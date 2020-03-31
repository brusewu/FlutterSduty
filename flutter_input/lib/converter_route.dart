import 'package:flutter/material.dart';
import 'package:flutter_input/unit.dart';


const padding = EdgeInsets.all(16.0);

class CoverterRoute extends StatefulWidget {
  final Color color;
  final List<Unit> units;

  const CoverterRoute({
    @required this.color,
    @required this.units,
  })
      : assert(color != null),
        assert(units != null);

  @override
  CoverterRouteState createState() => CoverterRouteState();


}

class CoverterRouteState extends State<CoverterRoute> {
  Unit fromValue;
  Unit toValue;
  double inputValue;
  String convertedValue = '';
  List<DropdownMenuItem> unitMenuItems;
  bool showValidationError = false;

  @override
  void initState() {
    super.initState();
    createDropdownMenuItems();
    setDefaults();
  }

  void createDropdownMenuItems() {
    var newItems = <DropdownMenuItem>[];
    for (var unit in widget.units) {
      newItems.add(DropdownMenuItem(
          value: unit.name,
          child: Container(
            child: Text(
              unit.name,
              softWrap: true,
            ),
          )
      ));
    }
    setState(() {
      unitMenuItems = newItems;
    });
  }

  void setDefaults() {
    setState(() {
      fromValue = widget.units[0];
      toValue = widget.units[0];
    });
  }

  String format(double conversion) {
    var outputNum = conversion.toStringAsPrecision(7);
    if (outputNum.contains('.') && outputNum.endsWith('0')) {
      var i = outputNum.length - 1;
      while (outputNum[i] == '0') {
        i -= 1;
      }
      outputNum = outputNum.substring(0, i + 1);
    }
    if (outputNum.endsWith('.')) {
      return outputNum.substring(0, outputNum.length - 1);
    }
    return outputNum;
  }

  void updateConversion() {
    setState(() {
      convertedValue =
          format(inputValue * (toValue.conversion / fromValue.conversion));
    });
  }

  void updateInputValue(String input) {
    setState(() {
      if (input == null || input.isEmpty) {
        convertedValue = '';
      } else {
        try {
          final inputDouble = double.parse(input);
          showValidationError = false;
          inputValue = inputDouble;
          updateConversion();
        } on Exception catch (e) {
          print('Error:$e');
          showValidationError = true;
        }
      }
    });
  }

  Unit getUnit(String unitName) {
    return widget.units.firstWhere(
          (Unit unit) {
        return unit.name == unitName;
      },
      orElse: null,
    );
  }

  void updateFromConversion(dynamic unitName) {
    setState(() {
      fromValue = getUnit(unitName);
    });
    if (inputValue != null) {
      updateConversion();
    }
  }

  void updateToConversion(dynamic unitName) {
    setState(() {
      toValue = getUnit(unitName);
    });
    if (inputValue != null) {
      updateConversion();
    }
  }

  Widget createDropdown(String currentValue, ValueChanged<dynamic> onChanged) {
    return Container(
      margin: EdgeInsets.only(top: 16.0),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border.all(
            color: Colors.grey[400],
            width: 1.0
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Colors.grey[50],
          ),
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton(
                value: currentValue,
                items: unitMenuItems,
                onChanged: onChanged,
                style: Theme
                    .of(context)
                    .textTheme
                    .title,
              ),
            ),
          )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final input = Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextField(
            style: Theme
                .of(context)
                .textTheme
                .display1,
            decoration: InputDecoration(
              labelStyle: Theme
                  .of(context)
                  .textTheme
                  .display1,
              errorText: showValidationError ? 'Invalid number entered' : null,
              labelText: 'Input',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(0.0),
              ),
            ),
            keyboardType: TextInputType.number,
            onChanged: updateInputValue,
          ),
          createDropdown(fromValue.name, updateFromConversion),
        ],
      ),
    );

    final arrows = RotatedBox(
      quarterTurns: 1,
      child: Icon(
        Icons.compare_arrows,
        size: 40.0,
      ),
    );
    final output = Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          InputDecorator(
            child: Text(
              convertedValue,
              style: Theme
                  .of(context)
                  .textTheme
                  .display1,
            ),
            decoration: InputDecoration(
              labelText: 'Output',
              labelStyle: Theme
                  .of(context)
                  .textTheme
                  .display1,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(0.0),

              ),
            ),
          ),
          createDropdown(toValue.name, updateToConversion)
        ],
      ),
    );

    final converter = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        input,
        arrows,
        output,
      ],
    );

    return Padding(
      padding: padding,
      child: converter,
    );
  }


}