import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:trashapp/page3.dart';
import 'package:trashapp/repository/dioUtil.dart';

class TrashDetailPage extends StatefulWidget {
  final String _keyword;

  TrashDetailPage(this._keyword);

  @override
  _TrashDetailPageState createState() => _TrashDetailPageState(_keyword);
}

class _TrashDetailPageState extends State<TrashDetailPage> {
  final String _keyword;

  List list = List();

  int _garbageType = 1;
  _TrashDetailPageState(this._keyword);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var result = await garbageSearch(_keyword);

      for (var item in result) {
        if(item["garbageType"]!=16){
          list.add(item);
        }
      }
      if (list.length > 0) {
        setState(() {});
      } else {
        Navigator.pop(context);

        Fluttertoast.showToast(
            msg: "暂未识别的垃圾",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = List();
    for (var item in list) {
      var row = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(item['name']),
          ),
          Item(trashTypeMap[item['garbageType']]),
        ],
      );

      widgets.add(Column(
        children: <Widget>[
          row,
          Divider(
            height: 1,
          ),
        ],
      ));
    }

    return Scaffold(
        appBar: AppBar(),
        // body: Column(children: <Widget>[
        //   Text(_keyword),
        //   Item(trashTypeMap[_garbageType]),
        // ],),
        body: SingleChildScrollView(
          child: Column(
            children: widgets,
          ),
        ));
  }
}

/// design/9暂无状态页面/index.html#artboard3
class StateLayout extends StatefulWidget {
  const StateLayout({Key key, @required this.type, this.hintText})
      : super(key: key);

  final StateType type;
  final String hintText;

  @override
  _StateLayoutState createState() => _StateLayoutState();
}

class _StateLayoutState extends State<StateLayout> {
  String _img;
  String _hintText;

  @override
  Widget build(BuildContext context) {
    switch (widget.type) {
      case StateType.order:
        _img = 'zwdd';
        _hintText = '暂无订单';
        break;
      case StateType.goods:
        _img = 'zwsp';
        _hintText = '暂无商品';
        break;
      case StateType.network:
        _img = 'zwwl';
        _hintText = '无网络连接';
        break;
      case StateType.message:
        _img = 'zwxx';
        _hintText = '暂无消息';
        break;
      case StateType.account:
        _img = 'zwzh';
        _hintText = '马上添加提现账号吧';
        break;
      case StateType.loading:
        _img = '';
        _hintText = '';
        break;
      case StateType.empty:
        _img = '';
        _hintText = '';
        break;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const SizedBox(
          width: double.infinity,
          height: 16,
        ),
        Text(
          widget.hintText ?? _hintText,
          style: Theme.of(context).textTheme.subtitle.copyWith(fontSize: 14),
        ),
        SizedBox(
          height: 50,
        ),
      ],
    );
  }
}

enum StateType {
  /// 订单
  order,

  /// 商品
  goods,

  /// 无网络
  network,

  /// 消息
  message,

  /// 无提现账号
  account,

  /// 加载中
  loading,

  /// 空
  empty
}
