
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_api/unit.dart';

class Category {
  final String name;
  final ColorSwatch color;
  final List<Unit> units;
  final String iconLocation;

  const Category({
    @required this.color,
    @required this.name,
    @required this.iconLocation,
    @required this.units,
})  : assert(name != null),
      assert(color != null),
      assert(units != null),
      assert(iconLocation != null);
}