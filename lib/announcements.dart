import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class Announcements extends StatefulWidget {
  @override
  _AnnouncementsState createState() => _AnnouncementsState();
}

class _AnnouncementsState extends State<Announcements> {
  final _targetUrl =
      'https://api.rss2json.com/v1/api.json?rss_url=https://medium.com/feed/flutter';
  var jsonData;
  List items = List();

  @override
  void initState() {
    super.initState();
    http.read(_targetUrl).then((jsonResponse) {
      setState(() {
        jsonData = jsonDecode(jsonResponse);
        items = jsonData['items'] as List;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Announcements',
          style: GoogleFonts.josefinSans(),
        ),
      ),
      body: Container(
        child: jsonData == null
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                padding: EdgeInsets.all(50),
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    hoverColor: Colors.amberAccent,
                    contentPadding: EdgeInsets.all(20.0),
                    title: new Text(
                      items[index]['title'],
                      style: GoogleFonts.josefinSans(),
                    ),
                    subtitle: Text(items[index]['categories'].join(', ')),
                    leading: new Image.network(
                      items[index]['thumbnail'],
                      fit: BoxFit.cover,
                      height: 400.0,
                      width: 50.0,
                    ),
                    onTap: () => launch(items[index]['link']),
                  );
                },
              ),
      ),
    );
  }
}