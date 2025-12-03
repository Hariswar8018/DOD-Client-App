


import 'package:dio/dio.dart';
import 'package:dod/global/global_list.dart';
import 'package:dod/main/car/add_car.dart';
import 'package:dod/main/car/full_car.dart';
import 'package:flutter/material.dart';

import '../../login/bloc/login/view.dart';
import '../../model/usercarmodel.dart';

class GetMYCAR extends StatefulWidget {
  final bool select;
  const GetMYCAR({super.key, this.select=false});

  @override
  State<GetMYCAR> createState() => _GetMYCARState();
}

class _GetMYCARState extends State<GetMYCAR> {
  bool isLoading = false;
  List<UserCarModel> carList = [];

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
        'https://dod.brandeducer.host/api/user/cars',
        options: Options(
          headers: {
            "Authorization": "Bearer ${UserModel.token}",
          },
        ),
      );

      print("Status: ${response.statusCode}");
      print("Response: ${response.data}");

      final parsed = UserCarResponse.fromJson(response.data);

      setState(() {
        carList = parsed.data;
        isLoading = false;
      });

    } catch (e) {
      print("Error: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff25252D),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("My Saved Cars",
            style: TextStyle(color: Colors.white)),
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff25252D),
        onPressed: () async {
        await Navigator.push(context, MaterialPageRoute(builder: (_)=>AddCar()));
        getCars();
      },child: Icon(Icons.add,color: Colors.white,),),
      body: isLoading
          ? GlobalShimmer.shimmer(w)
          : carList.isEmpty
          ? GlobalShimmer.empty(context, "Car")
          : Padding(
        padding: const EdgeInsets.all(12),
        child: ListView.builder(
          itemCount: carList.length,
          itemBuilder: (context, index) {
            final car = carList[index];
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 6,
                    offset: Offset(0, 3),
                    color: Colors.black12,
                  )
                ],
              ),
              child: Column(
                children: [
                  ListTile(
                    onTap: (){
                      if(widget.select){
                        Navigator.pop(context,car);
                        return ;
                      }
                      Navigator.push(context, MaterialPageRoute(builder: (_)=>GetFullCAR(id: car.id.toString())));
                    },
                    leading: CircleAvatar(
                      backgroundColor: Colors.orange.shade50,
                      child: Icon(Icons.directions_car_rounded),
                    ),
                    title: Text(car.nickName,style: TextStyle(fontWeight: FontWeight.w800),),
                    subtitle: Text(car.number),
                    trailing: Icon(Icons.arrow_forward,color: Colors.green,),
                  )
                ],
              )
            );
          },
        ),
      ),
    );
  }
}
