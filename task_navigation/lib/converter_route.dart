
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_navigation/unit.dart';

class ConverterRoute extends StatelessWidget{
  final List<Unit> units;
  final Color color;

  const ConverterRoute({
    @required this.units,
    @required this.color,
}):assert(units != null),
   assert(color != null);

  @override
  Widget build(BuildContext context) {
    final unitWidgets = units.map((Unit unit){
        return Container(
          color: color,
          margin: EdgeInsets.all(8.0),
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Text(
                unit.name,
                style: Theme.of(context).textTheme.headline,
              ),
              Text(
                'Conversion:${unit.conversion}',
                style: Theme.of(context).textTheme.subhead,
              )
            ],
          ),
        );
    }).toList();

    return ListView(
      children: unitWidgets,
    );
  }


}