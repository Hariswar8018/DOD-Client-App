import 'package:flutter/material.dart';

class Navigation extends StatelessWidget {
  const Navigation({super.key});

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            width: w,
            height: 90,
            color: Colors.black,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("Hire Drivers",style: TextStyle(fontSize: 19,fontWeight: FontWeight.w800,color: Colors.white),),
                  Spacer(),
                  Text("41 MINS AWAY",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w800,color: Colors.white),)
                ],
              ),
            ),
          ),
          Container(
            width: w,
            height: 430,
            color: Colors.grey.shade100,
            child: Stack(
              children: [
                Container(
                  width: w,
                  height: 220,
                  color: Colors.greenAccent,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 200.0),
                  child: Column(
                    children: [
                      Center(
                        child: Container(
                          width: w-20,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(3)
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      Center(
                        child: Container(
                          width: w-20,
                          height: 130,
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(3)
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),

        ],
      ),
    );
  }
}
