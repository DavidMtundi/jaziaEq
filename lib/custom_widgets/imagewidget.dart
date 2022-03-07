// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:jazia/funcs/detailFunc.dart';
import 'package:jazia/funcs/imagefunc.dart';
import 'package:jazia/funcs/pricefunc.dart';
import 'package:jazia/funcs/textfunc.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BodyWidget extends StatelessWidget {
  String? wig_name, wig_url, wig_des, wig_contact;
  int? wig_price;

  BodyWidget(
      {Key? key, this.wig_des, this.wig_name, this.wig_price, this.wig_url, this.wig_contact})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TextEditingController? nameController;
    //TextEditingController? priceController;
    //TextEditingController? detailController;



    return SizedBox(
      height: MediaQuery.of(context).size.height/4,
      width: MediaQuery.of(context).size.width,
      /* decoration:  BoxDecoration(
        border: Border.all(
          color: Colors.black26,
          width: 3,// red as border color
        ),
        borderRadius: BorderRadius.circular(10.0),
      )*/
      child: Card(
        elevation: 11,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Row(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.transparent,
                        width: 6, // red as border color
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          flex: 4,
                          child: GestureDetector(
                            child: Container(
                              color: Colors.blue,
                              child: (wig_url == null)
                                  ? const Center(
                                      child: Icon(
                                      Icons.camera_alt_outlined,
                                      size: 50,
                                    ))
                                  : CachedNetworkImage(
                                      imageUrl: '$wig_url',
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
//                                                colorFilter:
//                                                ColorFilter.mode(Colors.red, BlendMode.colorBurn)
                                          ),
                                        ),
                                      ),
                                      //placeholder: (context, url) => CircularProgressIndicator(),
                                      progressIndicatorBuilder: (context, url,
                                              downloadProgress) =>
                                          Center(
                                            child: CircularProgressIndicator(
                                                value: downloadProgress.progress),
                                          ),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                            ),
                            onTap: () {
                              showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (context) => GetImage(
                                      wig_url: wig_url!,
                                    ));
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                          child: Divider(
                            thickness: 2,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            child: Container(
                              //color: Colors.green,
                              child: Center(child: Text('$wig_name')),
                              decoration: BoxDecoration(
                                  // color: Colors.green
                                  ),
                            ),
                            onTap: () {
                              showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (context) {
                                  return GetName(
                                      wig_name: wig_name!, wig_contact: wig_contact!,
                                    );
                                });
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.transparent,
                    width: 6, // red as border color
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          child: Center(child: Text('Price: KSH $wig_price')),
                          onTap: ()=> showDialog(context: context, barrierDismissible: true, builder: (context)=> GetPrice(wig_price: wig_price!, wig_name: wig_name!, wig_url: wig_url!, wig_contact: wig_contact!, wig_des: wig_des!,)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: Divider(
                          thickness: 2,
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: GestureDetector(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Center(child: Text('$wig_des')),
                          ),
                          onTap: ()=> showDialog(context: context, barrierDismissible: true, builder: (context)=> GetDetail(wig_detail:wig_des!,wig_name: wig_name!,wig_contact: wig_contact!,)),

                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
