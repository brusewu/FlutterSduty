import 'package:flutter/material.dart';
import 'package:flutter_category/category_task.dart';



const categoryName = 'Cake';
const categoryIcon = Icons.cake;
const categoryColor = Colors.green;

void main() => runApp(InitConverterApp());

class InitConverterApp extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Unit Converter',
      home:Scaffold(
        backgroundColor: Colors.green[100],
        body: Center(
          child: CategoryTask(),
//          child: Category(
//            name: categoryName,
//            color: categoryColor,
//            iconLocation: categoryIcon,
//          ),
        ),
      ),
    );
  }
}