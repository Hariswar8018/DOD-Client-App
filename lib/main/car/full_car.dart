


import 'package:dio/dio.dart';
import 'package:dod/global.dart';
import 'package:dod/global/global_list.dart';
import 'package:flutter/material.dart';

import '../../login/bloc/login/view.dart';
import '../../model/usercarmodel.dart';

class GetFullCAR extends StatefulWidget {
  String id;
   GetFullCAR({super.key,required this.id});

  @override
  State<GetFullCAR> createState() => _GetFullCARState();
}

class _GetFullCARState extends State<GetFullCAR> {
  bool isLoading = false;
  List<UserCarModel> carList = [];
  UserCarModel? car ;
  @override
  void initState() {
    super.initState();
    getCars();
  }

  Future<void> getCars() async {
    final Dio dio = Dio(
      BaseOptions(
        validateStatus: (status) => status != null && status < 500,
      ),
    );

    try {
      setState(() => isLoading = true);

      final response = await dio.get(
        'https://dod.brandeducer.host/api/user/cars/${widget.id}',
        options: Options(
          headers: {
            "Authorization": "Bearer ${UserModel.token}",
          },
        ),
      );

      print("Status: ${response.statusCode}");
      print("Response: ${response.data}");

      final parsed = SingleCarResponse.fromJson(response.data);

      setState(() {
        carList = [parsed.data];
        car = carList.first;
        isLoading = false;
      });

    } catch (e) {
      print("Error: $e");
      setState(() => isLoading = false);
    }
  }
  Future<bool> deleteCar(String carId) async {
    final Dio dio = Dio(
      BaseOptions(
        validateStatus: (status) => status != null && status < 500,
      ),
    );

    try {
      final response = await dio.delete(
        "https://dod.brandeducer.host/api/user/cars/$carId",
        options: Options(
          headers: {
            "Authorization": "Bearer ${UserModel.token}",
          },
        ),
      );

      print("Delete Status: ${response.statusCode}");
      print("Delete Response: ${response.data}");
      if(response.data["success"] == true){
        Navigator.pop(context);
        Send.message(context, "Car Deleted", true);
      }else{
        Send.message(context, "${response.statusMessage}", true);
      }
      return response.data["success"] == true;
    } catch (e) {
      print("Delete Car Error: $e");
      Send.message(context, "Delete Car Error: $e", true);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff25252D),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Car Info",
            style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(onPressed: (){
            showDialog(
              context: context,
              barrierDismissible: false, // User must tap Yes or No
              builder: (ctx) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6), // rectangle with slight curve
                  ),
                  title: Text(
                    "Delete this saved Car?",
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
                        Navigator.of(context).pop();
                        deleteCar(widget.id);
                      },
                      child: Text("Yes"),
                    ),
                  ],
                );
              },
            );
          }, icon:Icon(Icons.delete,color: Colors.white,))
        ],
      ),
      backgroundColor: Colors.white,
      body: isLoading
          ?  GlobalShimmer.shimmer(w)
          : carList.isEmpty
          ? GlobalShimmer.empty(context,"Car Details")
          : Column(
            children: [
              SizedBox(height: 30,),
              Padding(
                padding: const EdgeInsets.all(19.0),
                child: Center(
                  child: CircleAvatar(
                    radius: 65,
                    backgroundColor: Colors.yellow.shade50,
                    child: Icon(Icons.directions_car,size: 55,),
                  ),
                ),
              ),
              SizedBox(height: 30,),
              Text.rich(
                TextSpan(
                  text: "Booking Status : ",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                  children: [
                    TextSpan(
                      text: car!.bookingstatus.toString().toUpperCase(),
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30,),
              SizedBox(height: 10,),
              c("Nickname", car!.nickName.toString(), w),
              c("Car Number", car!.number.toString(), w),
              c("Brand Name", car!.brand.toString(), w),
              c("Model Name", car!.model.toString(), w),
              c("Transmission", car!.transmission.toString(), w),
              c("Fuel Type", car!.fueltype.toString(), w),
            ],
          ),
    );
  }
  int i = 0;
  Widget c(String str, String? str2,double w ){
    i++;
    return Container(
      width: w,
      color: i%2==0?Colors.grey.shade50:Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0,vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            t("$str"),
            t("$str2"),
          ],
        ),
      ),
    );
  }
  Widget t(str)=>Text(str,style: TextStyle(fontSize: 18),);
}

class SingleCarResponse {
  final bool success;
  final String message;
  final UserCarModel data;

  SingleCarResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory SingleCarResponse.fromJson(Map<String, dynamic> json) {
    return SingleCarResponse(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: UserCarModel.fromJson(json["data"]),
    );
  }
}
