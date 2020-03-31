import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stateful/Unit.dart';
import 'package:flutter_stateful/category.dart';

final backgroundColor = Colors.green[100];

class CategoryRoute extends StatefulWidget {
  const CategoryRoute();

  @override
  CategoryRouteState createState() => CategoryRouteState();


}

class CategoryRouteState extends State<CategoryRoute> {
  final categories = <Category>[];

  static const categoryNames = <String>[
    'Length',
    'Area',
    'Volume',
    'Mass',
    'Time',
    'Digital Storage',
    'Energy',
    'Currency',
  ];

  static const baseColors = <Color>[
    Colors.teal,
    Colors.orange,
    Colors.pinkAccent,
    Colors.blueAccent,
    Colors.yellow,
    Colors.greenAccent,
    Colors.purpleAccent,
    Colors.red,
  ];

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < categoryNames.length; i++) {
      categories.add(Category(
        name: categoryNames[i],
        color: baseColors[i],
        iconLocation: Icons.cake,
        units: retrieveUnitList(categoryNames[i]),
      ));
    }
  }

  Widget buildCategoryWidgets() {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) => categories[index],
      itemCount: categories.length,
    );
  }

  List<Unit> retrieveUnitList(String categoryName) {
    return List.generate(10, (int i) {
      i += 1;
      return Unit(
        name: '$categoryName Unit $i',
        conversion: i.toDouble(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final listView = Container(
      color: backgroundColor,
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: buildCategoryWidgets(),
    );

    final appBar = AppBar(
      elevation: 0.0,
      title: Text(
        'Unit Converter',
        style: TextStyle(
          color: Colors.black,
          fontSize: 30.0,
        ),
      ),
      centerTitle: true,
      backgroundColor: backgroundColor,
    );

    return Scaffold(
      appBar: appBar,
      body: listView,

    );
  }


}