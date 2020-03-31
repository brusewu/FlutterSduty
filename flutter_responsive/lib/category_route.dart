
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_responsive/backdrop.dart';
import 'package:flutter_responsive/category.dart';
import 'package:flutter_responsive/category_tile.dart';
import 'package:flutter_responsive/unit.dart';
import 'package:flutter_responsive/unit_converter.dart';

class CategoryRoute extends StatefulWidget{
  const CategoryRoute();

  @override
  CategoryRoteState createState() {
    return CategoryRoteState();
  }


}

class CategoryRoteState extends State<CategoryRoute>{
  Category defaultCategory;
  Category currentCategory;

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

  static const _baseColors = <ColorSwatch>[
    ColorSwatch(0xFF6AB7A8, {
      'highlight': Color(0xFF6AB7A8),
      'splash': Color(0xFF0ABC9B),
    }),
    ColorSwatch(0xFFFFD28E, {
      'highlight': Color(0xFFFFD28E),
      'splash': Color(0xFFFFA41C),
    }),
    ColorSwatch(0xFFFFB7DE, {
      'highlight': Color(0xFFFFB7DE),
      'splash': Color(0xFFF94CBF),
    }),
    ColorSwatch(0xFF8899A8, {
      'highlight': Color(0xFF8899A8),
      'splash': Color(0xFFA9CAE8),
    }),
    ColorSwatch(0xFFEAD37E, {
      'highlight': Color(0xFFEAD37E),
      'splash': Color(0xFFFFE070),
    }),
    ColorSwatch(0xFF81A56F, {
      'highlight': Color(0xFF81A56F),
      'splash': Color(0xFF7CC159),
    }),
    ColorSwatch(0xFFD7C0E2, {
      'highlight': Color(0xFFD7C0E2),
      'splash': Color(0xFFCA90E5),
    }),
    ColorSwatch(0xFFCE9A9A, {
      'highlight': Color(0xFFCE9A9A),
      'splash': Color(0xFFF94D56),
      'error': Color(0xFF912D2D),
    }),
  ];

  @override
  void initState() {
    super.initState();
    for(var i = 0;i < categoryNames.length;i++){
      var category = Category(
        name: categoryNames[i],
        color: _baseColors[i],
        iconLocation: Icons.cake,
        units:retrieveUnitList(categoryNames[i]),
      );
      if( i == 0){
        defaultCategory = category;
      }
      categories.add(category);
    }
  }

  void onCategoryTap(Category category){
    setState(() {
      currentCategory = category;
    });
  }

  Widget buildCategoryWidgets(Orientation deviceOrientation){
    if(deviceOrientation == Orientation.portrait){
      return ListView.builder(
          itemBuilder: (BuildContext context,int index){
           return CategoryTile(
             category: categories[index],
             onTap: onCategoryTap,
           ) ;
          },
        itemCount: categories.length,
      );
    } else {
      return GridView.count(
          crossAxisCount: 2,
        childAspectRatio: 3.0,
        children:categories.map((Category c){
          return CategoryTile(
            category: c,
            onTap: onCategoryTap,
          );
        }).toList(),
      );
    }
  }

  List<Unit> retrieveUnitList(String categoryName){
    return List.generate(10, (int i){
      i += 1;
      return Unit(
        name: '$categoryName Unit $i',
        conversion: i.toDouble(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMediaQuery(context));
    final listView = Padding(
        padding: EdgeInsets.only(
          left: 8.0,
          right: 8.0,
          bottom: 48.0,
        ),
      child: buildCategoryWidgets(MediaQuery.of(context).orientation),
    );

    return Backdrop(
      currentCategory:
      currentCategory == null ? defaultCategory : currentCategory,
      frontPanel: currentCategory == null
          ? UnitConverter(category: defaultCategory)
          : UnitConverter(category: currentCategory),
      backPanel: listView,
      frontTitle: Text('Unit Converter'),
      backTitle: Text('Select a Category'),
    );
  }


}