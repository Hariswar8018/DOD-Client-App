import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class GlobalShimmer{

  static Widget shimmer(double w)=>ListView.builder(
    itemCount: 10,
    itemBuilder: (context,index){
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Shimmer.fromColors(
            child: Container(
              width: w-20,
              height: 150,
              color: Colors.grey.shade200,
            ),
            baseColor: Colors.grey.shade200,
            highlightColor: Colors.white),
      );
    },
  );

  static Widget empty(BuildContext context, String str){
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height-85;
    return Container(
      width: w,
      height: h,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(child: Image.asset("assets/yM0GpVTYBr.gif",width: w/2,)),
          Center(child: Text("Opps ! No $str exist in our Data",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 18),))
        ],
      ),
    );
  }
}