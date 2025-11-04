import 'package:dio/dio.dart';
import 'package:dod/api.dart';
import 'package:flutter/material.dart';

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
          return Card(
            margin: EdgeInsets.all(8),
            child: ListTile(
              title: Text(coupon.name),
              subtitle: Text(
                "${coupon.code} • ${coupon.discountType == 'percentage' ? '${coupon.amount}%' : '₹${coupon.amount}'} off",
              ),
              trailing: Text(
                "${coupon.startDate} → ${coupon.endDate}",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          );
        },
      ),

    );
  }
}
