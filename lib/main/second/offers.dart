import 'package:dio/dio.dart';
import 'package:dod/api.dart';
import 'package:flutter/material.dart';

import '../../global.dart' show Send;
import '../../login/bloc/login/view.dart';
import '../../model/booking_response.dart';
import '../../model/coupon.dart';
import '../../model/ordermodel.dart';

class Offers extends StatefulWidget {
   Offers({super.key});

  @override
  State<Offers> createState() => _OffersState();
}

class _OffersState extends State<Offers> {

  void initState(){
    gets();
  }
  Future<void> gets() async {
    final Dio dio = Dio(
      BaseOptions(validateStatus: (status) => status != null && status < 500),
    );

    try {
      final response = await dio.get(
        Api.apiurl + "coupon-offers",
        options: Options(
          headers: {"Authorization": "Bearer ${UserModel.token}"},
        ),
      );
      print(UserModel.token);
      if (response.statusCode == 200) {
        final couponResponse = CouponResponse.fromJson(response.data);
        setState(() {
          coupons = couponResponse.coupons;
        });
        print("✅ Total Coupons: ${coupons.length}");
      } else {
        print("❌ Error: ${response.statusMessage}");
      }
    } catch (e) {
      print("Error during API call: $e");
    }
  }
  List<CouponModel> coupons = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        centerTitle: true,
        title: Text("Offers & Coupons",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
      ),
      body: coupons.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: coupons.length,
        itemBuilder: (context, index) {
          final coupon = coupons[index];
          return OfferCard(coupon: coupon);
        },
      ),

    );
  }
}

class OfferCard extends StatelessWidget {
  CouponModel coupon ;
   OfferCard({super.key,required this.coupon});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final Dio dio = Dio(
          BaseOptions(validateStatus: (status) => status != null && status < 500),
        );
        try {
          final response = await dio.post(
            Api.apiurl + "user-apply-coupon",
            data: {
              "code":coupon.code,
              "order_amount":100,
            },
            options: Options(
              headers: {"Authorization": "Bearer ${UserModel.token}"},
            ),
          );
          print("Status: ${response.statusCode}");
          print("Response: ${response.data}");
          if (response.statusCode == 200 || response.statusCode == 201) {
            Navigator.pop(context,coupon.code);
            return;
          }
          Send.message(context, "Error ${response.statusMessage}", false);
        } catch (e) {
          Send.message(context, "Error $e", false);
          print("Error during API call: $e");
        }
      },
      child: Card(
        color: Colors.white,
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.local_offer,color: Colors.red,size: 35,),
              title: Text(coupon.name,style: TextStyle(fontWeight: FontWeight.w900),),
              subtitle: Text(coupon.type+" Discount"),
              trailing: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.red,
                    width: 2
                  )
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 4),
                  child: Text("APPLY",style: TextStyle(color: Colors.red,fontWeight: FontWeight.w800),),
                ),
              ),
            ),
            r("Coupon Code", coupon.code),
            SizedBox(height: 10,)
          ],
        ),
      ),
    );
  }
  Widget r(String str,String str2){
    return Row(
      children: [
        SizedBox(width: 15,),
        Text("$str : "),
        Text("$str2",style: TextStyle(fontWeight: FontWeight.w500),)
      ],
    );
  }
}

