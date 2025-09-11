import 'package:dod/global.dart';
import 'package:dod/login/login.dart';
import 'package:flutter/material.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Global.bg,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 60,),
            Spacer(),
            Image.asset("assets/flat_logo.jpg",width: 120,),
            SizedBox(height: 10,),
            Text("Hire Drivers",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 29),),
            SizedBox(height: 3,),
            Text("Book Professional & Trained Drivers on Hourly Basis. Explore Best Offers",
              style: TextStyle(color: Colors.white),),
            SizedBox(height: 20,),
            Image.asset("assets/first.jpg",),
            Spacer(),
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (_)=>Login()));
              },
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width-60,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Center(child: Text("Get Started",
                    style: TextStyle(color: Colors.black,fontWeight: FontWeight.w700),)),
                ),
              ),
            ),
            SizedBox(height: 40,),
          ],
        ),
      ),
    );
  }
}
