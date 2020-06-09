import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iipe/add_new_book.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:easy_dialog/easy_dialog.dart';
import 'package:iipe/new_pending_book.dart';
import 'package:iipe/pending_books.dart';
import 'package:iipe/user_profile.dart';

class PendingBooks extends StatefulWidget {
  List<BookModel> list = [];
  PendingBooks(this.list);

  @override
  _PendingBooksState createState() => _PendingBooksState(list);
}

class _PendingBooksState extends State<PendingBooks> {
  _PendingBooksState(this.books);
  List<BookModel> books = [];

  BookModel currentBook;
  final bookHelper _bookhelper = bookHelper();
  @override
  void initState() async {
    // TODO: implement initState
    books = await _bookhelper.getAllBooks();
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => AddNewBook());
          },
          backgroundColor: Colors.blueAccent,
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 40.0,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(12.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => UserProfile()));
                },
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CircleAvatar(
                    radius: 40.0,
                    backgroundColor: Colors.white,
                    child: Image(
                      image: AssetImage('images/books.png'),
                      width: 100.0,
                      height: 100.0,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    'MY PENDING BOOKS',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 20.0,
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                child: ListView.separated(
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Text("${books[index].id}"),
                        title: Text("${books[index].bookName}"),
                        trailing: Text('${books[index].lastDate}'),
                      );
                    },
                    separatorBuilder: (context, index) => Divider(),
                    itemCount: books == null ? 0 : books.length),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
