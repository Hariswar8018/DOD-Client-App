import 'package:dod/main/drivers.dart';
import 'package:dod/main/home.dart';
import 'package:dod/main/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {

  int currentTab=0;
  final Set screens ={
    Home(),
    Profile(),
  };
  final PageStorageBucket bucket = PageStorageBucket();

  dynamic selected ;

  var heart = false;
  PageController controller = PageController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  Widget currentScreen = Home();
  @override
  Widget build(BuildContext context){
    return WillPopScope(
        onWillPop: () async {
          // Show the alert dialog and wait for a result
          bool exit = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Exit App'),
                content: Text('Are you sure you want to exit?'),
                actions: [
                  ElevatedButton(
                    child: Text('No'),
                    onPressed: () {
                      // Return false to prevent the app from exiting
                      Navigator.of(context).pop(false);
                    },
                  ),
                  ElevatedButton(
                    child: Text('Yes'),
                    onPressed: () async {
                      // Return true to allow the app to exit
                      Navigator.of(context).pop(true);
                    },
                  ),
                ],
              );
            },
          );

          // Return the result to handle the back button press
          return exit ?? false;
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: PageStorage(
            child: currentScreen,
            bucket: bucket,
          ),
          bottomNavigationBar: BottomAppBar(
            shape: CircularNotchedRectangle(),
            notchMargin: 4, color: Colors.white, surfaceTintColor: Colors.white,
            shadowColor:  Colors.white,
            child: Container(
              height: 20, color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MaterialButton(
                      minWidth: 25, onPressed: (){
                    setState(() {
                      currentScreen = Home();
                      currentTab = 0;
                    });
                  },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            CupertinoIcons.home,
                            color: currentTab == 0? Colors.black : Colors.grey, size: 23,
                          ),
                          Text("Home", style: TextStyle(color: currentTab == 0?  Colors.black :Colors.grey, fontSize: 12))
                        ],
                      )
                  ),
                  MaterialButton(
                      minWidth: 25, onPressed: (){
                    setState(() {
                      currentScreen = Drivers();
                      currentTab = 3;
                    });
                  },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.two_wheeler,
                            color: currentTab == 3? Colors.black:Colors.grey, size: 23,
                          ),
                          Text("Drivers", style: TextStyle(color: currentTab == 3? Colors.black:Colors.grey, fontSize: 12))
                        ],
                      )
                  ),
                  MaterialButton(
                      minWidth: 25, onPressed: (){
                    setState(() {
                      currentScreen = Profile();
                      currentTab = 4;
                    });
                  },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            CupertinoIcons.person,
                            color: currentTab == 4? Colors.black:Colors.grey, size: 23,
                          ),
                          Text("User", style: TextStyle(color: currentTab == 4? Colors.black:Colors.grey, fontSize: 12))
                        ],
                      )
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
