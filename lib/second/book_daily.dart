import 'package:dod/second/shedule_book_confirm.dart';
import 'package:flutter/material.dart';

import 'one_way.dart';

class Daily extends StatelessWidget {
  const Daily({super.key});

  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        centerTitle: false,
        title: Text("DOD Daily Driver",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Image.asset("assets/reserve.jpg",width: w,),
          SizedBox(height: 15,),
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text("Get the same Driver Everyday with preferred Language",style: TextStyle(fontSize: 15),),
          ),
          ListTile(
            leading: Icon(Icons.timelapse_outlined),
            title: Text("0 Cancellation Charges ",style: TextStyle(fontSize: 15),),
          ),
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text("Book for as little as 3-4 days",style: TextStyle(fontSize: 15),),
          ),
        ],
      ),
      persistentFooterButtons: [
        InkWell(
          onTap: (){
            Navigator.push(context,MaterialPageRoute(builder: (_)=>One_Way(dateTime: DateTime.now(),i: 3,)));
            return ;

          },
          child: Container(
            width: w-20,
            height: 45,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10)
            ),
            child: Center(child: Text("Reserve Daily Driver",style: TextStyle(color: Colors.white,),))
          ),
        )
      ],
    );
  }
}
