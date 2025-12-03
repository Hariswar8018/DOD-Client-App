import 'package:dio/dio.dart';
import 'package:dod/global.dart';
import 'package:dod/global/global_list.dart';
import 'package:dod/main/car/add_car.dart';
import 'package:dod/model/brandmodel.dart';
import 'package:flutter/material.dart';

import '../../login/bloc/login/view.dart';
import '../../model/car_model.dart';

class GetModeFuel extends StatefulWidget {
  BrandModel model; CarModel car;
  GetModeFuel({super.key,required this.model, required this.car});

  @override
  State<GetModeFuel> createState() => _GetModeFuelState();
}

class _GetModeFuelState extends State<GetModeFuel> {
  void initState(){
    GetModeModels();
  }
  Future<void> GetModeModels() async {
    final Dio dio = Dio(
      BaseOptions(
        validateStatus: (status) => status != null && status < 500,
      ),
    );
    GetTrans();
    try {
      doit(true);
      final response = await dio.post(
        'https://dod.brandeducer.host/api/getFuelTypes',
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${UserModel.token}",
          },
        ),
        data: {
          "search": "",
        },
      );
      print("Status: ${response.statusCode}");
      print("Response: ${response.data}");
      print("Status: ${response.statusCode}");
      print("Response: ${response.data}");

      // --- Parse JSON ---
      print("Response: ${response.data}");

      final parsed = GetCarModelsResponse.fromJson(response.data);

      carList = parsed.data;
      str1=carList.first.name;
      strr1=carList.first.id;
      print("Car Model Count: ${carList.length}");

      doit(false);
    } catch (e) {
      doit(false);
      print("Error during API call: $e");
    }
  }
  List<CarModel> carList = [];

  Future<void> GetTrans() async {
    final Dio dio = Dio(
      BaseOptions(
        validateStatus: (status) => status != null && status < 500,
      ),
    );

    try {
      doit(true);
      final response = await dio.post(
        'https://dod.brandeducer.host/api/getTransmissions',
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${UserModel.token}",
          },
        ),
        data: {
          "search": "",
        },
      );
      print("Status: ${response.statusCode}");
      print("Response: ${response.data}");
      print("Status: ${response.statusCode}");
      print("Response: ${response.data}");

      // --- Parse JSON ---
      print("Response: ${response.data}");

      final parsed = GetCarModelsResponse.fromJson(response.data);

      carList2 = parsed.data;
      str2 = carList2.first.name;
      strr2=carList2.first.id;
      print("Car Model Count: ${carList2.length}");

      doit(false);
    } catch (e) {
      doit(false);
      print("Error during API call: $e");
    }
  }
  List<CarModel> carList2 = [];

  bool isprogress = false;
  doit(bool on){
    setState(() {
      isprogress=on;
    });
  }
  String str1 = "", str2 = '';
  int strr1 = 1, strr2 =1 ;

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar:AppBar(
        backgroundColor: Color(0xff25252D),
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        title: Text("Select Fuel & Transmission",style: TextStyle(color: Colors.white),),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 18.0,bottom: 10),
              child: Center(
                child: Container(
                  width: w/2,height: 100,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: NetworkImage(widget.car.image))
                  ),
                ),
              ),
            ),
            Center(child: t1("${widget.car.name} "),),
            SizedBox(height: 20,),
            t2("${widget.car.name} Fuel Type"),
            Container(
              width: w,
              height: 150,
              child: carList.isEmpty
                  ? (isprogress?GlobalShimmer.shimmer(w):GlobalShimmer.empty(context, "Fuel Types"))
                  : Padding(
                padding: const EdgeInsets.all(12.0),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: carList.length,
                  itemBuilder: (context, index) {
                    final brand = carList[index];
                    return InkWell(
                      onTap: (){
                        setState(() {
                          str1= brand.name;
                          strr1=brand.id;
                        });
                      },
                      child: Container(
                        width: 130,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                          boxShadow: [
                            str1==brand.name?BoxShadow(
                              blurRadius: 5,
                              offset: Offset(0, 3),
                              color: Colors.blue,
                            ):BoxShadow(
                              blurRadius: 6,
                              offset: Offset(0, 3),
                              color: Colors.black12,
                            )
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Brand Image
                            SizedBox(
                              height: 70,
                              width: 70,
                              child: Image.network(
                                brand.image,
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              brand.name,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 10,),
            t2("${widget.car.name} Transmission Type"),
            Container(
              width: w,
              height: 150,
              child: carList2.isEmpty
                  ? (isprogress?GlobalShimmer.shimmer(w):GlobalShimmer.empty(context,"Transmission Types"))
                  : Padding(
                padding: const EdgeInsets.all(12.0),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: carList2.length,
                  itemBuilder: (context, index) {
                    final brand = carList2[index];
                    return InkWell(
                      onTap: (){
                        setState(() {
                          str2= brand.name;
                          strr2=brand.id;
                        });
                      },
                      child: Container(
                        width: 130,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                          boxShadow: [
                            str2==brand.name?BoxShadow(
                              blurRadius: 5,
                              offset: Offset(0, 3),
                              color: Colors.blue,
                            ):BoxShadow(
                              blurRadius: 6,
                              offset: Offset(0, 3),
                              color: Colors.black12,
                            )
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Brand Image
                            SizedBox(
                              height: 70,
                              width: 70,
                              child: Image.network(
                                brand.image,
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              brand.name,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      persistentFooterButtons: [
        InkWell(
          onTap: (){
            if(str1.isEmpty||str2.isEmpty){
              Send.message(context, "Please Select a Fuel Type", false);
            }else{
              Cars car = Cars(
                  brand: widget.car.name, model: widget.model.name,
                  transmission:str2, fuel: str1,
                brandInt: widget.car.id, modelInt: widget.model.id, transmissionInt:strr2,
                fuelInt: strr1
              );
              Navigator.pop(context, car);
            }
          },
          child: Container(
            width: w-20,
            height: 50,
            decoration: BoxDecoration(
              color: Color(0xff25252D),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Center(child: Text("Save Car",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800),)),
          ),
        )
      ],
    );
  }
  Widget t1(String str){
    return Text(str,style: TextStyle(color: Colors.black,fontWeight: FontWeight.w800,fontSize: 18),);
  }
  Widget t2(String str){
    return Padding(
      padding: const EdgeInsets.only(top: 15.0,bottom: 5),
      child: Text(str,style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 15),),
    );
  }
}

