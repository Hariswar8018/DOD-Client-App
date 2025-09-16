import 'package:flutter/material.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';

import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

class Daily_Driver extends StatefulWidget {
  const Daily_Driver({super.key});

  @override
  State<Daily_Driver> createState() => _Daily_DriverState();
}

class _Daily_DriverState extends State<Daily_Driver> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        centerTitle: false,
        title: Text("Daily DOD Driver",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
      ),
      body:Container(
          width: w,
          height: h,
          child: SingleChildScrollView(
            child: Container(
              width: w,
              height: 700,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10,),
                  Center(
                    child: Container(
                      width: w-20,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4), // Rounded corners
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1), // Shadow color
                            spreadRadius: 1, // How much the shadow spreads
                            blurRadius: 6, // Softness of the shadow
                            offset: Offset(0, 3), // Shadow position (x, y)
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(width: 15,),
                          Icon(Icons.import_export,color: Colors.green,),
                          SizedBox(width: 10,),
                          Text("Select Pickup Location",),
                          SizedBox(width: 8,)
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Text("   Select Car Type",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 17),),
                  SizedBox(height: 5),
                  InkWell(
                    onTap: (){
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 10,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Text(
                                      "Select Transmission & Car Types",
                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Divider(),
                                  Text(
                                    "Transmission",
                                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                                  ),
                                  SizedBox(height: 4,),
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap:(){
                                          setState(() {
                                            trasmission="Manual";
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          decoration:BoxDecoration(
                                              color:trasmission=="Manual"?Colors.white:Colors.blue.shade50,
                                              borderRadius: BorderRadius.circular(10)
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 14.0,vertical: 5),
                                            child: Center(child: Text("Manual")),
                                          ),
                                        ),
                                      ),SizedBox(width: 9,),
                                      InkWell(
                                        onTap:(){
                                          setState(() {
                                            trasmission="Automatic";
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          decoration:BoxDecoration(
                                              color:trasmission=="Automatic"?Colors.white:Colors.blue.shade50,
                                              borderRadius: BorderRadius.circular(10)
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 14.0,vertical: 5),
                                            child: Center(child: Text("Automatic")),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10,),
                                  Text(
                                    "Car Type",
                                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                                  ),
                                  SizedBox(height: 4,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      con("Hatchbacks", w),
                                      con("Sedan", w),
                                      con("SUV", w),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Row(
                      children: [
                        SizedBox(width: 15,),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.grey.shade300,
                                  width: 0.8
                              ),
                              borderRadius: BorderRadius.circular(5)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 5),
                            child: Row(
                              children: [
                                Icon(Icons.car_crash,color: Colors.green,),
                                SizedBox(width: 9),
                                Text(type,style: TextStyle(fontWeight: FontWeight.w700),),
                                SizedBox(width: 7,),
                                Icon(Icons.keyboard_arrow_down_rounded,),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 8,),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.grey.shade300,
                                  width: 0.8
                              ),
                              borderRadius: BorderRadius.circular(5)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 5),
                            child: Row(
                              children: [
                                Icon(Icons.auto_awesome_mosaic,color: Colors.green,),
                                SizedBox(width: 9),
                                Text(trasmission,style: TextStyle(fontWeight: FontWeight.w700),),
                                SizedBox(width: 7,),
                                Icon(Icons.keyboard_arrow_down_rounded,),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                  Text("   Select Estimated per Day Usage",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 17),),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      SizedBox(width: 10,),
                      r(w, 4),r(w, 6),r(w, 8),
                      r(w, 10),r(w, 12)
                    ],
                  ),
                  SizedBox(height: 15,),
                  Row(
                    children: [
                      Text("   Trip is DOD Secured ",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 17),),
                      Spacer(),
                      Switch(
                        value: isSwitched,
                        onChanged: (value) {
                          setState(() {
                            isSwitched = value;
                            if(isSwitched){

                              price=price+40;
                            }else{
                              price=price-40;
                            }
                          });
                        },
                        activeColor: Colors.green.shade200,
                        inactiveThumbColor: Colors.grey,
                        inactiveTrackColor: Colors.grey[300],
                      ),
                      SizedBox(width: 10,)
                    ],
                  ),
                  SizedBox(height: 22),
                  Text("   Select PickUp Time ",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 17),),
                  SizedBox(height: 10,),
                  Center(
                    child: Container(
                      width: w - 20,
                      height: 45,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.shade200,
                        ),
                        borderRadius: BorderRadius.circular(5), // Optional rounded corners
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14.0),
                        child: DropdownButtonHideUnderline( // Removes underline
                          child: DropdownButton<String>(
                            isExpanded: true, // Makes dropdown fill the width
                            hint: Text("Select a Time"),
                            value: selectedValue,
                            items: items.map((String item) {
                              return DropdownMenuItem<String>(
                                value: item,
                                child: Text(item),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                selectedValue = newValue;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("   Select Driver Language ",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 17),),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Container(
                          width: w/2-15,
                          child: MultiSelectDialogField(
                            items: item.map((e) => MultiSelectItem<String>(e, e)).toList(),
                            title: Text("Select Language"),
                            selectedColor: Colors.blue,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                              border: Border.all(
                                color: Colors.grey.shade200,
                                width: 1,
                              ),
                            ),
                            buttonText: Text(
                              selectedValue1.isEmpty?"Select Lang":"${selectedValue1.length} Languages",
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                              ),
                            ),
                            chipDisplay: MultiSelectChipDisplay.none(),
                            onConfirm: (results) {
                              setState(() {
                                selectedValue1 = results;
                              });
                            },
                          ),
                        ),
                      )

                    ],
                  ),

                ],
              ),
            ),
          )
      ),
      persistentFooterButtons: [
        InkWell(
          child: Container(
              width: w-20,
              height: 45,
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Center(child: Text("Continue to Shedule Driver",style: TextStyle(color: Colors.white,),))
          ),
        )
      ],

    );
  }

  String? selectedValue; // Store the selected value

  // List of items for the dropdown
// Existing fruits
  final List<String> items = [];

// Add time slots from 1:00 AM to 12:00 PM
  void addTimeSlots() {
    for (int i = 1; i <= 12; i++) {
      items.add("${i}:00 AM");
    }
    for (int i = 1; i <= 12; i++) {
      items.add("${i}:00 PM");
    }
  }

// Call this in initState or before using items
  @override
  void initState() {
    super.initState();
    addTimeSlots();

  }


  List selectedValue1 = []; // Store the selected value


  final List<String> item = [
    "English",
    "Assamese",
    "Bengali",
    "Bodo",
    "Dogri",
    "Gujarati",
    "Hindi",
    "Kannada",
    "Kashmiri",
    "Konkani",
    "Maithili",
    "Malayalam",
    "Manipuri",
    "Marathi",
    "Nepali",
    "Odia",
    "Punjabi",
    "Sanskrit",
    "Santali",
    "Sindhi",
    "Tamil",
    "Telugu",
    "Urdu"
  ];


  Widget con(String str,double w)=>Padding(
    padding: const EdgeInsets.all(2.0),
    child: InkWell(
      onTap: (){
        type=str;
        setState(() {

        });
        Navigator.pop(context);
      },
      child: Container(
        width: w/4-14,
        child: Column(
          children: [
            Container(
              width: w/4-14,
              height: w/4-14,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(image: AssetImage("assets/car.jpg")),
                  border: Border.all(
                      color: type==str?Colors.blue:Colors.grey.shade400,
                      width: type==str?2:1
                  )
              ),
            ),
            Text(str,style: TextStyle(fontWeight: FontWeight.w800,color: Colors.grey.shade600,fontSize: 11),)
          ],
        ),
      ),
    ),
  );
  String type="Hatchbacks";
  String trasmission="Manual";

  int price=369;
  bool classic=true;
  bool isSwitched = false;
  int i = 4;
  Widget r (double w, int y)=>InkWell(
    onTap: (){
      setState(() {
        i=y;
        if(isSwitched){
          price=(369*y).toInt()+40;
        }else{
          price=(369*y).toInt();
        }
      });
    },
    child: Padding(
      padding: const EdgeInsets.only(right: 4.0),
      child: Stack(
        children: [
          Container(
            width: w/6-7,
            height: 65,
            decoration: BoxDecoration(
                color: i==y?Colors.blue.shade50:Colors.white,
                border: Border.all(
                  color: Colors.grey.shade200,
                ),
                borderRadius: BorderRadius.circular(8)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                Text(y.toString(),style: TextStyle(color:i==y?Colors.black:Colors.grey,fontWeight: FontWeight.w800),),
                Text("Hr",style: TextStyle(color:i==y?Colors.black:Colors.grey,fontWeight: FontWeight.w800),)
                ,Spacer(),
              ],
            ),
          ),
          i==y?Container(
            width: w/6-7,
            height: 65,
            child: Column(
              children: [
                SizedBox(height: 3,),
                Row(
                  children: [
                    Spacer(),
                    Icon(Icons.verified,color: Colors.green,size: 20,),
                    SizedBox(width: 3,)
                  ],
                ),
                Spacer(),
              ],
            ),
          ):SizedBox(),
        ],
      ),
    ),
  );
}
