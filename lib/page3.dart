import 'package:flutter/material.dart';
import 'package:trashapp/pages/trashList.dart';

class Page3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("垃圾大全"),
      ),
      body: Container(
        // color: Colors.green,
        height: 500,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Item(TrashClassEnum.hazardous),
                Item(TrashClassEnum.household),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Item(TrashClassEnum.recyclable),
                Item(TrashClassEnum.residual),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class Item extends StatelessWidget {
  final TrashClassEnum trashClassEnum;
  Item(this.trashClassEnum);
  @override
  Widget build(BuildContext context) {
    final String name = trashClassEnumMap[trashClassEnum];
    return InkWell(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Container(
          height: 120,
          width: 120,
          // color: Colors.black,
          child: Image.asset("assets/images/$name.png"),
        ),
      ),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context){

          return TrashList(trashClassEnumIntMap[trashClassEnum]);
        }));
      },
    );
  }
}

enum TrashClassEnum { hazardous, household, recyclable, residual }
final Map<TrashClassEnum, String> trashClassEnumMap = {
  TrashClassEnum.hazardous: "hazardous",
  TrashClassEnum.household: "household",
  TrashClassEnum.recyclable: "recyclable",
  TrashClassEnum.residual: "residual",
};

final Map<TrashClassEnum, int> trashClassEnumIntMap = {
  TrashClassEnum.hazardous: 2,
  TrashClassEnum.household: 4,
  TrashClassEnum.recyclable: 1,
  TrashClassEnum.residual: 8,
};


final Map<int, TrashClassEnum> trashTypeMap = {
  1: TrashClassEnum.recyclable,
  2: TrashClassEnum.hazardous,
  4: TrashClassEnum.household,
  8: TrashClassEnum.residual,
};