import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CupertinoSwitchWidget extends StatefulWidget {
  @override
  _CupertinoSwitchWidgetState createState() => _CupertinoSwitchWidgetState();
}

class _CupertinoSwitchWidgetState extends State<CupertinoSwitchWidget> {
  var _lights = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: MergeSemantics(
        child: ListTile(
          title: Text('Lights'),
          trailing: CupertinoSwitch(
            value: _lights,
            onChanged: (bool value) {
              setState(() {
                _lights = value;
              });
            },
          ),
          onTap: () {
            setState(() {
              _lights = !_lights;
            });
          },
        ),
      ),
    );
  }
}