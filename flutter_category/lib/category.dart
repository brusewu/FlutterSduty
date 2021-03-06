
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final rowHeight = 100.0;
final borderRadius = BorderRadius.circular(rowHeight/2);


class Category extends StatelessWidget{
  final String name;
  final ColorSwatch color;
  final IconData iconLocation;
  
  const Category({
    Key key,
    @required this.name,
    @required this.color,
    @required this.iconLocation,
}) : assert(name != null),
  assert(color != null),
  assert(iconLocation != null),
  super(key:key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        height: rowHeight,
        child: InkWell(
          borderRadius: borderRadius,
          highlightColor: color,
          splashColor: color,
          onTap: (){
            print('I was tapped!');
            
          },
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.all(16.0),
                  child: Icon(
                    iconLocation,
                    size: 45.0,
                  ),
                ),
                Center(
                  child: Text(
                    name,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline,
                  ),
                )

              ],
            ),
          ),
        ),
      ),
    );
  }

}