
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stateful/Unit.dart';

class ConverterRoute extends StatefulWidget{
  final Color color;

  final List<Unit> units;

  const ConverterRoute({
    @required this.color,
    @required this.units,
}) : assert(color != null),
     assert(units != null);

  @override
  ConverterRoteState createState() => ConverterRoteState();
}

class ConverterRoteState extends State<ConverterRoute>{


  @override
  Widget build(BuildContext context) {
    final unitWidgets = widget.units.map((Unit unit){
      return Container(
        color: widget.color,
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
            ),
          ],
        ),
      );
    }).toList();

    return ListView(
      children: unitWidgets,
    );
  }
}