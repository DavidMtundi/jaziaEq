import 'package:flutter/material.dart';

class InDevelopment extends StatelessWidget {
  const InDevelopment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Container(width: double.infinity, height: MediaQuery.of(context).size.width,child: Text('STILL IN DEVELOPMENT'),color: Colors.red,),));
  }
}
