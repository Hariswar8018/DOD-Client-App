import 'package:dio/dio.dart' show Dio, BaseOptions, Options;
import 'package:dod/global.dart';
import 'package:dod/main/car/get_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../login/bloc/login/view.dart';

class AddCar extends StatefulWidget {
  const AddCar({super.key});

  @override
  State<AddCar> createState() => _AddCarState();
}

class _AddCarState extends State<AddCar> {

  void df(){

  }
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar:AppBar(
        backgroundColor: Color(0xff25252D),
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        title: Text("Add Car",style: TextStyle(color: Colors.white),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Add a New Car",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w800,fontSize: 18),),
            t1("Add your Vehicle to the garage. Get remainders for Service, Insurance, and etc"),
            t2("Car Nickname"),
            con(w, name,link: false),
            t2("Car Registration Number"),
            con(w, register,link: false,i: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: w/2-35,
                  height: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      t2("Car Model"),
                      con(w,make),
                      t2("Transmission Type"),
                      con(w, transport),
                    ],
                  ),
                ),
                Container(
                  width: w/2-35,
                  height: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      t2("Car Brand"),
                      con(w, model),
                      t2("Fuel Type"),
                      con(w, fuel),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      persistentFooterButtons: [
        progress? Center(child: CircularProgressIndicator()):InkWell(
          onTap: () async {
            if(cars==null){
              Send.message(context, "Error ! Please Select Car Info", false);
              return ;
            }
            if(name.text.isEmpty||register.text.isEmpty){
              Send.message(context, " Please Add Car Nickname or Registration Number", false);
              return ;
            }
              showDialog(
                context: context,
                barrierDismissible: false, // User must tap Yes or No
                builder: (ctx) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6), // rectangle with slight curve
                    ),
                    title: Text(
                      "Are you sure?",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    content: Text("Do you want to continue?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // close dialog
                        },
                        child: Text("No"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // close dialog
                          addCar();
                        },
                        child: Text("Yes"),
                      ),
                    ],
                  );
                },
              );

          },
          child: Container(
            width: w-20,
            height: 50,
            decoration: BoxDecoration(
              color: Color(0xff25252D),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Center(child: Text("Add Car",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800),)),
          ),
        )
      ],
    );
  }
  bool progress= false;
  void onn(on){
    setState(() {
      progress=on;
    });
  }
  Future<void> addCar() async {
    final dio = Dio(
      BaseOptions(
        validateStatus: (status) => status != null && status < 500,
      ),
    );
    onn(true);
    try {
      final response = await dio.post(
        "https://dod.brandeducer.host/api/user/cars",
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${UserModel.token}", // Use your token here
          },
        ),
        data: {
          "nick_name": name.text,
          "number": register.text,
          "brand": cars!.brandInt,
          "model":cars!.modelInt,
          "transmission":cars!.transmissionInt,
          "fueltype": cars!.fuelInt,
          "year": 2022
        },
      );
      onn(false);
      print("Status: ${response.statusCode}");
      print("Response: ${response.data}");
      Navigator.pop(context);
      Send.message(context, "Added Car Success", true);
    } catch (e) {
      Send.message(context, "Error adding car: $e", false);
      onn(false);
      print("Error adding car: $e");
    }
  }

  TextEditingController name = TextEditingController();
  TextEditingController register = TextEditingController();
  TextEditingController transport = TextEditingController();
  TextEditingController fuel = TextEditingController();
  TextEditingController make = TextEditingController();
  TextEditingController model = TextEditingController();

  Widget t1(String str){
    return Text(str,style: TextStyle(color: Colors.grey.shade600,fontWeight: FontWeight.w400,fontSize: 12),);
  }
  Widget t2(String str){
    return Padding(
      padding: const EdgeInsets.only(top: 15.0,bottom: 5),
      child: Text(str,style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 15),),
    );
  }
  Widget con(double w , TextEditingController controller,{bool link = true, int i = 0})=>Container(
    width: w-30,
    height: 45,
    decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(9)
    ),
    child:link?InkWell(
      onTap: () async {
          Cars car = await Navigator.push(context, MaterialPageRoute(builder: (_)=>Get()));
          if(car!=null){
            model.text = car.model;
            fuel.text = car.fuel;
            transport.text = car.transmission;
            make.text = car.brand;
            cars = car;
            setState(() {

            });
          }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0),
        child: TextFormField(
          controller: controller,
          onTap: () async {
            Cars car = await Navigator.push(context, MaterialPageRoute(builder: (_)=>Get()));
            if(car!=null){
              model.text = car.model;
              fuel.text = car.fuel;
              transport.text = car.transmission;
              make.text = car.brand;
              cars = car ;
              setState(() {

              });
            }
          },
          decoration: InputDecoration(
              border: InputBorder.none
          ),
          readOnly: true,
        ),
      ),
    ): Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0),
      child: i==1?TextFormField(
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none
        ),
        textCapitalization: TextCapitalization.characters,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')),
          UpperCaseTextFormatter(),
        ],
      ):TextFormField(
        controller: controller,
        decoration: InputDecoration(
            border: InputBorder.none
        ),
      ),
    ),
  );
  Cars? cars ;
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    return newValue.copyWith(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class Cars {
  String fuel;
  String transmission;
  String brand;
  String model;

  int fuelInt;
  int transmissionInt;
  int brandInt;
  int modelInt;

  Cars({
    required this.brand,
    required this.model,
    required this.transmission,
    required this.fuel,

    required this.brandInt,
    required this.modelInt,
    required this.transmissionInt,
    required this.fuelInt,
  });
}
