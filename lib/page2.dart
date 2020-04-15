import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/delivery_header.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';

class Page2 extends StatefulWidget {
  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  EasyRefreshController _controller = EasyRefreshController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("2"),
      ),
      body: Center(
          child: Padding(
        padding: EdgeInsets.only(bottom: 200),
        child: EasyRefresh.custom(
            enableControlFinishRefresh: true,
            enableControlFinishLoad: true,
            controller: _controller,
            header: DeliveryHeader(),
            footer: MaterialFooter(),
            onRefresh: () async {
              await Future.delayed(Duration(seconds: 2), () {});
              _controller.finishRefresh(success: true);
            },
            onLoad: () async {
              await Future.delayed(Duration(seconds: 2), () {});
              _controller.finishLoad(success: true, noMore: false);
            },
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Container(
                      width: 60.0,
                      height: 60.0,
                      child: Center(
                        child: Text('$index'),
                      ),
                      color: index % 2 == 0
                          ? Colors.grey[300]
                          : Colors.transparent,
                    );
                  },
                  childCount: 10,
                ),
              ),
            ]),
      )),
    );
  }
}
