import 'package:dod/login/bloc/login/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyCoins extends StatelessWidget {
  const MyCoins({super.key});

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
        title: Text("Coins",style: TextStyle(color: Colors.white),),
      ),
      body: Column(
        children: [
          SizedBox(height: 10,),
          Image.asset("assets/co.jpg",width: w,),
          SizedBox(height: 20,),
          Center(
            child: Container(
              width: w-20,height: 130,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.shade300,
                ),borderRadius: BorderRadius.circular(6)
              ),
              child: Row(
                children: [
                  Container(
                    width: w/4+20,
                    height: w/4+20,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SvgPicture.asset("assets/wallet-svgrepo-com.svg"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: Container(
                      width: w-w/4-54,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Reward Summary",style: TextStyle(fontWeight: FontWeight.w800),),
                          Divider(),
                          SizedBox(height: 3,),
                          r("Wallet balance", "${UserModel.user.walletBalance}"),
                          r("Coins Earned", "${jy()}"),
                          r("Coins Used", "${ii()}"),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  num? jy(){
    return UserModel.user.coins!=null?UserModel.user.coins:0.0;
  }
  int ii(){
    double i = UserModel.user!.walletBalance;
    int? j = UserModel.user.coins;
    if(j!=null){
      return (i - j).toInt();
    }else{
      return UserModel.user!.walletBalance.toInt();
    }
  }
  Widget r(String str, String str2)=>Row(
    children: [
      Text(str,style: TextStyle(fontWeight: FontWeight.w400),),
      Spacer(),
      Text("₹ " +str2,style: TextStyle(fontWeight: FontWeight.w700),),
      SizedBox(width: 10,)
    ],
  );
}
