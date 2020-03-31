
import 'package:flutter/material.dart';
import 'package:task_navigation/task.dart';
import 'package:task_navigation/unit.dart';

final backgroundColor = Colors.green[100];

class TaskRoute extends StatelessWidget{
  const TaskRoute();
  static const taskNames = <String>[
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
    Colors.red
    
  ];

  Widget buildTaskWidgets(List<Widget> tasks){
    return ListView.builder(
        itemBuilder: (BuildContext context,int index)=>tasks[index],
        itemCount: tasks.length,
    );
  }

  List<Unit> retrieveUnitList(String taskName){
    return List.generate(10, (int i){
      i += 1;
      return Unit(name: '$taskName Unit $i', conversion: i.toDouble());
    });
  }

  @override
  Widget build(BuildContext context) {
    final tasks = <Task>[];

    for(var i = 0;i < taskNames.length;i++){
      tasks.add(Task(
          name: taskNames[i],
          color: baseColors[i],
          iconLocation: Icons.cake,
          units: retrieveUnitList(taskNames[i]),
      ));
    }

    final listView = Container(
      color: backgroundColor,
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: buildTaskWidgets(tasks),
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