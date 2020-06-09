import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iipe/pending_books.dart';
import 'package:intl/intl.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:easy_dialog/easy_dialog.dart';
import 'package:iipe/new_pending_book.dart';

class AddNewBook extends StatefulWidget {
  @override
  _AddNewBook createState() => _AddNewBook();
}

class _AddNewBook extends State<AddNewBook> {
  BookModel currentBook;
  List<BookModel> books = [];
  final bookHelper _bookhelper = bookHelper();
  @override
  void initState() {
    // TODO: implement initState
    final fbm = FirebaseMessaging();
    fbm.requestNotificationPermissions();
    fbm.configure(onMessage: (msg) {
      EasyDialog(
              title: Text(msg['notification']['title']),
              description: Text(msg['notification']['body']))
          .show(context);
      return;
    }, onLaunch: (msg) {
      return;
    }, onResume: (msg) {
      return;
    });
    fbm.subscribeToTopic('messages');
    super.initState();
  }

  final _formkey = GlobalKey();
  String bookName = "Core Java";

  DateTime _currentDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    String formattedDate = new DateFormat.yMMMd().format(_currentDate);
    Future<Null> _selectedDate(BuildContext context) async {
      final DateTime _selectDate = await showDatePicker(
          context: context,
          initialDate: _currentDate,
          firstDate: DateTime(2020),
          lastDate: DateTime(2025),
          builder: (context, child) {
            return SingleChildScrollView(
              child: child,
            );
          });
      if (_selectedDate != null) {
        setState(() {
          _currentDate = _selectDate;
        });
      }
    }

    return SingleChildScrollView(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Form(
        key: _formkey,
        child: Container(
          color: Color(0xff757575),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20.0),
                  topLeft: Radius.circular(20.0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    'ADD NEW ISSUED BOOK',
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                GestureDetector(
                  onTap: () {
                    _selectedDate(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 20.0),
                    child: ListTile(
                      leading: Icon(
                        Icons.book,
                      ),
                      title: TextFormField(
                        maxLength: 15,
                        onChanged: (value) {
                          setState(() {
                            bookName = value;
                          });
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          counterText: "",
                          hintText: 'Change Book Name',
                          hintStyle: TextStyle(
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      trailing: Text(
                        '$bookName',
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                GestureDetector(
                  onTap: () {
                    _selectedDate(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 20.0),
                    child: ListTile(
                      leading: Icon(
                        Icons.calendar_today,
                      ),
                      title: Text(
                        'Change Last Date',
                        style: TextStyle(
                          color: Colors.black87,
                        ),
                      ),
                      trailing: Text(
                        '$formattedDate',
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 30.0, right: 30.0),
                        child: RaisedButton(
                          color: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          onPressed: () async {
                            currentBook = BookModel(
                                bookName: bookName,
                                lastDate: _currentDate.toString());
                            await _bookhelper.insertTask(currentBook);
                            books = await _bookhelper.getAllBooks();
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: ((context) =>
                                        PendingBooks(books))));
                          },
                          child: Text(
                            'Add',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
