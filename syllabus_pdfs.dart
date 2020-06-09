import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:easy_dialog/easy_dialog.dart';

class SyllabusPDF extends StatefulWidget {
  final String pdf;
  final String appBarTitle;
  SyllabusPDF(this.pdf, this.appBarTitle);
  @override
  _SyllabusPDFState createState() => _SyllabusPDFState();
}

class _SyllabusPDFState extends State<SyllabusPDF> {
  PDFDocument _doc;
  bool _loading;

  _initPdf() async {
    setState(() {
      _loading = true;
    });
    final _doc = await PDFDocument.fromAsset(widget.pdf);
    setState(() {
      this._doc = _doc;
      _loading = false;
    });
  }

  @override
  void initState() {
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
    _initPdf();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appBarTitle),
      ),
      body: Center(
          child: _loading
              ? Center(child: CircularProgressIndicator())
              : PDFViewer(document: _doc)),
    );
  }
}
