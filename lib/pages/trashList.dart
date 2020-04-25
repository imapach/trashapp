import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:loading_dialog/loading_dialog.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:trashapp/page4.dart';
import 'package:trashapp/repository/dioUtil.dart';

class TrashList extends StatefulWidget {
  final int garbageType;

  TrashList(this.garbageType);

  @override
  _TrashListState createState() => _TrashListState(garbageType);
}

class _TrashListState extends State<TrashList> {
  EasyRefreshController _controller = EasyRefreshController();

  int _suspensionHeight = 40;
  int _itemHeight = 50;
  String _suspensionTag = "";

  final int garbageType;

  List<TrashName> list = List();

  _TrashListState(this.garbageType);

  void _onSusTagChanged(String tag) {
    setState(() {
      _suspensionTag = tag;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      LoadingDialog loading = LoadingDialog(buildContext: context,loadingMessage: "");
      loading.show();
      var data = await allGarbages(garbageType);
      for (var item in data) {
        list.add(TrashName(item["name"]));
      }
      handleList(list);
      loading.hide();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        backgroundColor: Colors.white,
        // body: Container(
        //   child: EasyRefresh.custom(
        //           enableControlFinishRefresh: true,
        //           enableControlFinishLoad: true,
        //           controller: _controller,
        //           header: DeliveryHeader(),
        //           footer: MaterialFooter(),
        //           onRefresh: () async {
        //             await Future.delayed(Duration(seconds: 2), () {});
        //             _controller.finishRefresh(success: true);
        //           },
        //           onLoad: () async {
        //             await Future.delayed(Duration(seconds: 2), () {});
        //             _controller.finishLoad(success: true, noMore: false);
        //           },
        //           slivers: <Widget>[
        //             SliverList(
        //               delegate: SliverChildBuilderDelegate(
        //                 (context, index) {
        //                   return Item("asd");
        //                 },
        //                 childCount: 10,
        //               ),
        //             ),
        //           ]),
        // ),
        body: AzListView(
          data: list,
          itemBuilder: (context, model) {
            return Item(model);
          },
          suspensionWidget: _buildSusWidget(_suspensionTag),
          isUseRealIndex: false,

          onSusTagChanged: _onSusTagChanged,
          //showCenterTip: false,
        ));
  }

  Widget _buildSusWidget(String susTag) {
    susTag = (susTag == "★" ? "热门" : susTag);
    return Container(
      height: _suspensionHeight.toDouble(),
      padding: const EdgeInsets.only(left: 15.0),
      color: Color(0xfff3f4f5),
      alignment: Alignment.centerLeft,
      child: Text(
        '$susTag',
        softWrap: false,
        style: TextStyle(
          fontSize: 14.0,
          color: Color(0xff999999),
        ),
      ),
    );
  }
}

class Item extends StatelessWidget {
  final TrashName name;
  Item(this.name);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: ClickItem(title: name._name),
    );
  }
}

class TrashName extends ISuspensionBean {
  String _name;
  String namepingyin;
  String tag;
  TrashName(this._name);
  @override
  String getSuspensionTag() {
    return tag;
  }
}

void handleList(List<TrashName> list) {
  if (list == null || list.isEmpty) return;
  for (int i = 0, length = list.length; i < length; i++) {
    String pinyin = PinyinHelper.getPinyinE(list[i]._name);
    String tag = pinyin.substring(0, 1).toUpperCase();
    list[i].namepingyin = pinyin;
    if (RegExp("[A-Z]").hasMatch(tag)) {
      list[i].tag = tag;
    } else {
      list[i].tag = "#";
    }
  }
  //根据A-Z排序
  SuspensionUtil.sortListBySuspensionTag(list);
}
