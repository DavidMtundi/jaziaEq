import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jazia/widgets/downloadbutton.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:progress_state_button/progress_button.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

class Mt940Screen extends StatefulWidget {
  Mt940Screen({Key? key}) : super(key: key);

  @override
  State<Mt940Screen> createState() => _Mt940ScreenState();
}

class _Mt940ScreenState extends State<Mt940Screen> {
  ButtonState stateOnlyText = ButtonState.idle;

  String selectedValue = "Excell";
  List<String> items = [
    'Excell',
    'Pdf',
    'Word',
  ];
  late String _data;

  // This function is triggered when the user presses the floating button
  Future<void> _loadData() async {
    final _loadedData = await rootBundle.loadString('assets/data.TXT');
    setState(() {
      _data = _loadedData;
    });
    print("the loaded Data is $_data");
  }

  Widget buildCustomButton() {
    var progressTextButton = ProgressButton(
      stateWidgets: {
        ButtonState.idle: Text(
          "Convert To ${selectedValue.toString()}",
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        ButtonState.loading: const Text(
          "Please Wait",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        ButtonState.fail: const Text(
          "Fail",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        ButtonState.success: const Text(
          "Conversion Success",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        )
      },
      stateColors: {
        ButtonState.idle: Colors.redAccent,
        ButtonState.loading: Colors.blue.shade300,
        ButtonState.fail: Colors.red.shade300,
        ButtonState.success: Colors.green.shade400,
      },
      onPressed: onPressedCustomButton,
      state: stateOnlyText,
      padding: const EdgeInsets.all(8.0),
    );
    return progressTextButton;
  }

  void onPressedCustomButton() {
    setState(() {
      switch (stateOnlyText) {
        case ButtonState.idle:
          stateOnlyText = ButtonState.loading;
          _loadData();
          stateOnlyText = ButtonState.success;

          break;
        case ButtonState.loading:
          stateOnlyText = ButtonState.idle;
          break;
        case ButtonState.success:
          stateOnlyText = ButtonState.idle;
          break;
        case ButtonState.fail:
          stateOnlyText = ButtonState.loading;
          _loadData();
          stateOnlyText = ButtonState.success;

          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("MT940 Screen"),
      // ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 50),
          child: Container(
            child: Column(
              children: [
                //add
                const Center(
                  child: Image(
                    image: AssetImage('assets/transactions.png'),
                    width: 200,
                    height: 150,
                    fit: BoxFit.fill,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Center(
                  child: Flexible(
                      child: Padding(
                    padding: EdgeInsets.only(left: 16.0, right: 3),
                    child: Text(
                      "Convert your MT940 File to any format of choice",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  )),
                ),
                const SizedBox(
                  height: 30,
                ),
                ButtonAnimation(const Color.fromARGB(255, 236, 141, 141),
                    const Color.fromARGB(255, 233, 44, 54)),
                const SizedBox(
                  height: 30,
                ),
                const Center(
                    child: Text(
                  "Convert To:",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      isExpanded: true,
                      hint: Row(
                        children: const [
                          Icon(
                            Icons.list,
                            size: 16,
                            color: Colors.blue,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Expanded(
                            child: Text(
                              'Select Format',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      items: items
                          .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ))
                          .toList(),
                      value: selectedValue,
                      onChanged: (value) {
                        setState(() {
                          selectedValue = value as String;
                        });
                      },
                      icon: const Icon(
                        Icons.arrow_forward_ios_outlined,
                      ),
                      iconSize: 14,
                      iconEnabledColor: Colors.yellow,
                      iconDisabledColor: Colors.grey,
                      buttonHeight: 50,
                      buttonWidth: 160,
                      buttonPadding: const EdgeInsets.only(left: 14, right: 14),
                      buttonDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.black26,
                        ),
                        color: Colors.redAccent,
                      ),
                      buttonElevation: 2,
                      itemHeight: 40,
                      itemPadding: const EdgeInsets.only(left: 14, right: 14),
                      dropdownMaxHeight: 200,
                      dropdownWidth: 200,
                      dropdownPadding: null,
                      dropdownDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: Colors.redAccent,
                      ),
                      dropdownElevation: 8,
                      scrollbarRadius: const Radius.circular(40),
                      scrollbarThickness: 6,
                      scrollbarAlwaysShow: true,
                      offset: const Offset(-20, 0),
                    ),
                  ),
                ),
                Container(
                  height: 70,
                ),
                buildCustomButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
//!Todo, make sure that i've created the json files and also make sure that i've create the excell, word and pdf files respectively with charts and graphs
///