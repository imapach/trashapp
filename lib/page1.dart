import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nice_button/nice_button.dart';
import 'package:trashapp/fluroRouter.dart';
import 'package:trashapp/repository/dioUtil.dart';

class Page1 extends StatefulWidget {
  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("垃圾分类")),
      ),
      body: Center(
          child: Column(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.only(left: 8, right: 8),
            child: TextField(
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white),
              controller: _controller,
            ),
          ),
          SizedBox(
            height: 30,
          ),
          NiceButton(
            radius: 15,
            icon: Icons.search,
            background: Colors.black,
            text: "search",
            onPressed: () {
                      router.navigateTo(context, "/trashDetail/${_controller.text}");
            },
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "OR",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
          ),
          SizedBox(
            height: 20,
          ),
          NiceButton(
            radius: 15,
            icon: Icons.photo,
            text: "camera",
            background: Colors.black,
            onPressed: () {
              showImageSelectBottomSheet();
            },
          ),
        ],
      )),
    );
  }

  void showImageSelectBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              FlatButton(
                child: Center(child: Text("从相册选择")),
                onPressed: () {
                  getAndShowImge(ImageSource.gallery);
                },
              ),
              Divider(
                color: Colors.black,
              ),
              FlatButton(
                child: Center(child: Text("拍摄一张照片")),
                onPressed: () {
                  getAndShowImge(ImageSource.camera);
                },
              ),
            ],
          );
        });
  }

  Future<void> getAndShowImge(ImageSource imageSource) async {
    File pickImage = await ImagePicker.pickImage(source: imageSource);
    if (pickImage != null) {
      Navigator.of(context).pop();
      showDialog(
          context: context,
          builder: (_) {
            return ImageAlertDialog(pickImage);
          });
    }
  }
}

class ImageAlertDialog extends StatelessWidget {
  final File _imageFile;
  ImageAlertDialog(this._imageFile);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("pic"),
      content: Image.file(
        _imageFile,
        height: 50,
        width: 50,
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("cancel"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text("ok"),
          onPressed: () async {
            List<String> keywords = await patternRecognition(_imageFile);
            Navigator.of(context).pop();
            showKeyWordsSelectBottomSheet(context, keywords);
          },
        )
      ],
    );
  }
}

void showKeyWordsSelectBottomSheet(
    BuildContext context, List<String> keywords) {
  List<KeyWordItem> widgets = List();
  keywords.forEach((keyword) {
    widgets.add(KeyWordItem(keyword));
  });

  showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: widgets,
        );
      });
}

class KeyWordItem extends StatelessWidget {
  final String _keyword;
  KeyWordItem(this._keyword);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(child: Center(child: Text(_keyword)),width: double.infinity,),
      onTap: () {
        router.navigateTo(context, "/trashDetail/$_keyword");
      },
    );
  }
}
