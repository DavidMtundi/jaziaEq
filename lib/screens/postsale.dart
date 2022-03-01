import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:jazia/custom_widgets/imagewidget.dart';
import 'package:jazia/funcs/imagefunc.dart';
import 'package:jazia/trydart/uploadonly.dart';

class PostSale extends StatefulWidget {
  const PostSale({Key? key}) : super(key: key);

  @override
  _PostSaleState createState() => _PostSaleState();
}

class _PostSaleState extends State<PostSale> {
  FirebaseFirestore firestore  = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jazia'),
      ),
      body:  SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              Slider(
                value: 0.5,
                activeColor: Colors.red,
                inactiveColor: Theme.of(context).disabledColor,
                onChanged: (value){},
              ),
              Container(
                height: MediaQuery.of(context).size.height/3,
                  width: MediaQuery.of(context).size.width,
                  //color: Colors.yellowAccent,
                  child: BodyWidget(),
              ),
              ElevatedButton.icon(
                  onPressed: (){
                    //GetValue(firestore, storage).uploadItems();
                    print('Post has been pressed!');
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const UploadDialogBox();
                        });
                  },
                  icon: Icon(Icons.arrow_forward),
                  label: Text('post'),
                style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
        ),),
              )
            ],
          ),
        ),
      ),
    );
  }
}
