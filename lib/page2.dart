import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/delivery_header.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:trashapp/pages/newsDetailPage.dart';
import 'package:trashapp/repository/dioUtil.dart';

class Page2 extends StatefulWidget {
  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  EasyRefreshController _controller = EasyRefreshController();

  List<dynamic> _datas = List();
  int _page = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _page = 1;
      _datas = await newsList(_page);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("垃圾资讯"),
      ),
      body: Padding(
        padding: EdgeInsets.only(bottom: 100, left: 5, right: 5, top: 5),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Container(
            child: EasyRefresh.custom(
                enableControlFinishRefresh: true,
                enableControlFinishLoad: true,
                controller: _controller,
                header: DeliveryHeader(),
                footer: MaterialFooter(),
                onRefresh: () async {
                  _page = 1;
                  _datas = await newsList(_page);
                  _controller.finishRefresh(success: true);
                  setState(() {});
                },
                onLoad: () async {
                  _page++;
                  _datas.addAll(await newsList(_page));
                  _controller.finishLoad(success: true, noMore: false);
                  setState(() {});
                },
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return Column(
                          children: <Widget>[
                            ListItem(
                                _datas[index]["newsTitle"],
                                _datas[index]["formatTime"],
                                _datas[index]['detailsId']),
                            SizedBox(
                              height: 5,
                            )
                          ],
                        );
                      },
                      childCount: _datas.length,
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  final TextStyle subtitleStyle =
      TextStyle(color: const Color(0xFFB5BDC0), fontSize: 12.0);
  final TextStyle titleTextStyle = TextStyle(fontSize: 15.0);

  final String _title;
  final String _timeStr;
  final int _newsId;

  ListItem(this._title, this._timeStr, this._newsId);

  @override
  Widget build(BuildContext context) {
    var timeRow = Row(
      children: <Widget>[
        Container(
          width: 20.0,
          height: 20.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFECECEC),
            image: DecorationImage(
                image: NetworkImage(
                    "https://dss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=1342143246,3577957495&fm=111&gp=0.jpg"),
                fit: BoxFit.cover),
            border: Border.all(
              color: const Color(0xFFECECEC),
              width: 2.0,
            ),
          ),
        ),
        SizedBox(
          width: 5,
        ),
        Text(
          _timeStr,
          style: subtitleStyle,
        ),
        Expanded(
          child: SizedBox(),
        ),
        Text(Random().nextInt(10).toString(), style: subtitleStyle),
        SizedBox(
          width: 5,
        ),
        Image.asset(
          "assets/images/pinglun.png",
          width: 16,
          height: 16,
        )
      ],
    );

    var row = Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(_title, style: titleTextStyle),
                SizedBox(
                  height: 10,
                ),
                timeRow
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(6.0),
          child: Container(
            width: 100.0,
            height: 80.0,
            color: const Color(0xFFECECEC),
            child: Image.network(imgurls[Random().nextInt(4)]),
          ),
        )
      ],
    );
    return InkWell(
      child: Container(color: Colors.white, child: row),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return NewsDetailPage(_newsId);
        }));
      },
    );
  }
}

List<String> imgurls = [
  'https://dss0.baidu.com/6ONWsjip0QIZ8tyhnq/it/u=2661681885,4081162711&fm=173&app=49&size=f242,162&n=0&g=0n&f=JPEG?s=95606BA24C4234DA48301D1F0300C0D0&sec=1587872958&t=a5478c8d65db83c700ae2cb40ac79951',
  'https://dss2.baidu.com/6ONYsjip0QIZ8tyhnq/it/u=1807878929,2459355926&fm=173&app=49&size=f242,162&n=0&g=0n&f=JPEG?s=C64ABC0BAED263E7D2B119030100E0E1&sec=1587872958&t=af7c8aa3d1c27a57f07f05a5f8cfcde5',
  'https://dss1.baidu.com/6ONXsjip0QIZ8tyhnq/it/u=485903605,4097899561&fm=173&app=49&size=f242,162&n=0&g=0n&f=JPEG?s=0FBB61859C020AD05C14A19603006091&sec=1587872958&t=20867cc43d29225a109a07be43ac1074',
  'https://dss0.bdstatic.com/6Ox1bjeh1BF3odCf/it/u=3033850304,2284880931&fm=190&app=2&size=f242,162&n=0&g=0n&f=PNG?s=F181F71740027EFBD08DD08E0300F061&sec=1587872958&t=1967b2a7627936b7ded9a94d6f5a93ff',
  'https://dss0.baidu.com/6ONWsjip0QIZ8tyhnq/it/u=3968642058,859358605&fm=173&app=49&size=f242,162&n=0&g=0n&f=JPEG?s=65D432D50814CECA009930570300C0E2&sec=1587872958&t=c3fb0c918334be28a00a7417cce896ee',
];
