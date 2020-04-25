import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:trashapp/repository/dioUtil.dart';

class NewsDetailPage extends StatefulWidget {
  final int _id;
  NewsDetailPage(this._id);
  @override
  _NewsDetailPageState createState() => _NewsDetailPageState(_id);
}

class _NewsDetailPageState extends State<NewsDetailPage> {
  final int _id;
  _NewsDetailPageState(this._id);

  String newsTitle = '';
  String newsContent = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var data = await newsDetail(_id);
      newsTitle = data['newsTitle'];
      newsContent = data['newsContent'];
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(newsTitle),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          child: Html(
        data: newsContent,
      )),
    );
  }
}
