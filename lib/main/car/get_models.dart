import 'package:dio/dio.dart';
import 'package:dod/global/global_list.dart';
import 'package:dod/model/brandmodel.dart';
import 'package:flutter/material.dart';

import '../../login/bloc/login/view.dart';
import '../../model/car_model.dart';
import 'add_car.dart';
import 'fuel.dart';

class GetMode extends StatefulWidget {
  BrandModel model;
   GetMode({super.key,required this.model});

  @override
  State<GetMode> createState() => _GetModeState();
}

class _GetModeState extends State<GetMode> {
  void initState(){
    GetModeModels();
  }
  Future<void> GetModeModels() async {
    final Dio dio = Dio(
      BaseOptions(
        validateStatus: (status) => status != null && status < 500,
      ),
    );

    try {
      doit(true);
      final response = await dio.post(
        'https://dod.brandeducer.host/api/getCarModels',
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${UserModel.token}",
          },
        ),
        data: {
          "search": "",
          "brand_id":widget.model.id
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

      print("Car Model Count: ${carList.length}");

      doit(false);
    } catch (e) {
      doit(false);
      print("Error during API call: $e");
    }
  }
  bool isprogress = false;
  doit(bool on){
    setState(() {
      isprogress=on;
    });
  }
  List<CarModel> carList = [];

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
        title: Text("${widget.model.name} Models",style: TextStyle(color: Colors.white),),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            width: w,
            height: 80,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                width: w-30,
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.grey.shade100
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0,vertical: 5),
                  child: TextFormField(
                    decoration: InputDecoration(
                        suffixIcon: IconButton(onPressed: (){
                          GetModeModels();
                        }, icon: Icon(Icons.search)),
                        border: InputBorder.none,
                        hintText: "Search for ${widget.model.name} Models"
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: w,
            height: h-180,
            child: carList.isEmpty
                ? (isprogress?GlobalShimmer.shimmer(w):GlobalShimmer.empty(context, "Brands"))
                : Padding(
              padding: const EdgeInsets.all(12.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,         // 2 columns
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.85,    // adjust height
                ),
                itemCount: carList.length,
                itemBuilder: (context, index) {
                  final brand = carList[index];
                  return InkWell(
                    onTap: () async {
                      Cars car = await Navigator.push(context, MaterialPageRoute(builder: (_)=> GetModeFuel(
                        model: widget.model, car: brand,)));
                      Navigator.pop(context, car);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
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
    );
  }
}

