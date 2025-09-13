import 'package:dod/global.dart';
import 'package:dod/second/book.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import '../return_functions/position.dart';

class One_Way extends StatefulWidget {
  const One_Way({super.key});

  @override
  State<One_Way> createState() => _One_WayState();
}

class _One_WayState extends State<One_Way> {
  bool on=false;
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          automaticallyImplyLeading: true,
          iconTheme: IconThemeData(
              color: Colors.white
          ),
          centerTitle: true,
          title: Text("One Way",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
        ),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          on?LinearProgressIndicator():SizedBox(),
          SizedBox(height: 10,),
          Center(
            child: Card(
              color: Colors.white,
              child: Container(
                width: w-20,
                height: 150,
                child: Row(
                  children: [
                    SizedBox(width: 20,),
                    Container(
                      width: 10,
                      height: 110,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.green,
                            radius: 6,
                          ),
                          Container(
                            width: 2,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(5)
                            ),
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.red,
                            radius: 6,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 15,),
                    Container(
                      width: w-15-20-20-20,
                      height: 200,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("  $str",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 14),),
                          SizedBox(height: 14,),
                          Container(
                            width: w-15-20-20-20-15,
                            height: 2,
                            decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(15)
                            ),
                          ),
                          SizedBox(height: 2,),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: TextFormField(
                              controller: controller,
                              style: TextStyle(fontWeight: FontWeight.w700,fontSize: 14),
                              decoration: InputDecoration(
                                hintText: "Type atleast 4 letter to Search",
                                border: InputBorder.none,   // Removes the border
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                contentPadding: EdgeInsets.zero, // Optional: removes extra padding
                              ),
                            ),
                          )

                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 10,),
          Expanded(
            child: ListView.builder(
              itemCount: filteredPlaces.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredPlaces[index]),
                  onTap: () async {
                    setState(() {
                      on=true;
                    });
                    try {
                      controller.text = filteredPlaces[index];
                      double lat1 = await latitute(str);
                      double lom1 = await longitude(str);
                      double lat2 = await latitute(controller.text);
                      double lon2 = await longitude(controller.text);
                      Navigator.push(context, MaterialPageRoute(builder: (_) =>
                          Book_OneWay(str: str,
                            str2: controller.text,
                            lat1: lat1,
                            lon1: lom1,
                            lat2: lat2,
                            lon2: lon2,
                          )));
                      setState(() {
                        on=false;
                      });
                    }catch(e){
                      setState(() {
                        on=false;
                      });
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
      persistentFooterButtons: [
        InkWell(
          onTap: (){
            Navigator.push(context,MaterialPageRoute(builder: (_)=>Position()));
          },
          child: Container(
            width: w-10,
            height: 50,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_location,color: Colors.green,),
                SizedBox(width: 7,),
                Text("Locate on the Map",style: TextStyle(fontWeight: FontWeight.w800),)
              ],
            ),
          ),
        )
      ],
    );
  }

  Future<double> latitute(String str) async {
    List<Location> locations = await locationFromAddress(str);
    return locations.first.latitude;
  }
  Future<double> longitude(String str) async {
    List<Location> locations = await locationFromAddress(str);
    return locations.first.longitude;
  }

  String str = "MAS Railway Station, Chennai, India, 600001";

  List<String> filteredPlaces = [];

  @override
  void initState() {
    super.initState();
    controller.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    String query = controller.text.toLowerCase();
    if (query.length >= 1) {
      setState(() {
        filteredPlaces = Global.places
            .where((place) => place.toLowerCase().contains(query))
            .toList();
      });
    } else {
      setState(() {
        filteredPlaces.clear();
      });
    }
  }
  TextEditingController controller=TextEditingController();
}
