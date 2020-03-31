
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_navigation/converter_route.dart';
import 'package:task_navigation/unit.dart';

final rowHeight = 100.0;
final borderRadius = BorderRadius.circular(rowHeight/2);

class Task extends StatelessWidget{
  final String name;
  final ColorSwatch color;
  final IconData iconLocation;
  final List<Unit> units;

  const Task({
    Key key,
    @required this.name,
    @required this.color,
    @required this.iconLocation,
    @required this.units,
}) : assert(name != null),
     assert(color != null),
     assert(iconLocation != null),
     assert(units != null),
     super(key:key);
  
  void navigateToConverter(BuildContext context){
    Navigator.of(context).push(MaterialPageRoute<Null>(
      builder: (BuildContext context){
        return Scaffold(
          appBar: AppBar(
            elevation: 1.0,
            title: Text(
              name,
              style: Theme.of(context).textTheme.display1,
            ),
            centerTitle: true,
            backgroundColor: color,
          ),
          body: ConverterRoute(
            color: color,
            units: units,
          ),
        );
      }
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Material(

      color: Colors.transparent,
      child:Container(
        height: rowHeight,
        child: InkWell(
          borderRadius: borderRadius,
          highlightColor: color,
          splashColor: color,
          onTap: () => navigateToConverter(context),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Icon(
                    iconLocation,
                    size: 60.0,
                  ),
                ),
                Center(
                  child: Text(
                    name,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline,
                  ),
                ),
              ],
            ),
          ),
        ),
      )

    );
  }


}