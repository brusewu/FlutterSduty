
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_api/api.dart';
import 'package:flutter_api/backdrop.dart';
import 'package:flutter_api/category.dart';
import 'package:flutter_api/category_tile.dart';
import 'package:flutter_api/unit.dart';
import 'package:flutter_api/unit_converter.dart';

class CategoryRoute extends StatefulWidget {
  const CategoryRoute();

  @override
  CategoryRouteState createState() {
    return CategoryRouteState();
  }

}

class CategoryRouteState extends State<CategoryRoute>{
  Category defaultCategory;
  Category currentCategory;
  final categories = <Category>[];
  static const baseColors = <ColorSwatch>[
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

  static const _icons = <String>[
    'assets/icons/length.png',
    'assets/icons/area.png',
    'assets/icons/volume.png',
    'assets/icons/mass.png',
    'assets/icons/time.png',
    'assets/icons/digital_storage.png',
    'assets/icons/power.png',
    'assets/icons/currency.png',
  ];

  @override
  Future<void> didChangeDependencies() async{
    super.didChangeDependencies();
    if(categories.isEmpty){
      await retrieveApiCategory();
      await retrieveLocalCategories();
    }
  }

  Future<void> retrieveLocalCategories() async{
    final json = DefaultAssetBundle
        .of(context)
        .loadString('assets/data/regular_units.json');
    final data = JsonDecoder().convert(await json);
    if(data is! Map){
      throw ('Data retrieved from API is not a Map');
    }
    var categoryIndex = 0;
    data.keys.forEach((key){
      final List<Unit> units =
        data[key].map<Unit>((dynamic data) => Unit.fromJson(data)).toList();

      var category = Category(
          name: key,
          units: units,
          color: baseColors[categoryIndex],
          iconLocation: _icons[categoryIndex],
          );

      setState(() {
        if(categoryIndex == 0){
          defaultCategory = category;
        }
        categories.add(category);
      });
      categoryIndex += 1;
    });
  }

  Future<void> retrieveApiCategory() async{
    setState(() {
      categories.add(Category(
        name: apiCategory['name'],
        units: [],
        color: baseColors.last,
        iconLocation: _icons.last,
      ));
    });
    final api = Api();
    final jsonUnits = await api.getUnits(apiCategory['route']);
    if(jsonUnits != null){
      final units = <Unit>[];
      for(var unit in jsonUnits){
        units.add(Unit.fromJson(unit));
      }
      setState(() {
        categories.removeLast();
        categories.add(Category(
            color: baseColors.last,
            name: apiCategory['name'],
            iconLocation: _icons.last,
            units: units
        ));
      });
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
          itemBuilder: (BuildContext context,int index) {
            return CategoryTile(
                category: categories[index],
                onTap: onCategoryTap);
          },
        itemCount: categories.length,
      );
    }else {
      return GridView.count(
          crossAxisCount: 2,
        childAspectRatio: 3.0,
        children:categories.map((Category c){
          return CategoryTile(category: c, onTap: onCategoryTap);
        }).toList(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if(categories.isEmpty){
      return Center(
        child: Container(
          height: 180.0,
          width: 180.0,
          child: CircularProgressIndicator(),
        ),
      );
    }
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
        currentCategory: currentCategory == null ? defaultCategory:currentCategory,
        frontTitle: Text('Unit Converter'),
        backTitle: Text('Select a Category'),
        frontPanel: currentCategory == null ? UnitConverter(category: defaultCategory,):UnitConverter(category: currentCategory,),
        backPanel: listView);

  }


}