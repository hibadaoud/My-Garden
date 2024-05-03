import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login_ui/pages/mypost.dart';
import 'package:flutter_login_ui/pages/new_reclamation.dart';
import '../ComplaintListt.dart';
import '../ComplaintStatusPieChart.dart';
import '../globals.dart' as globals;

import '../ComplaintList.dart';
import '../profile_page.dart';


class DrawerWidget extends StatelessWidget {
  DrawerWidget({Key? key}) : super(key: key);
  String get token => globals.authToken;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.grey[200],
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color:  Color(0xFF5B8E55),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(70,50,60,40),
                child: Text(
                  'My Garden',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily:'Poppins',
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(
                Icons.home,
                color:  Color(0xFF5B8E55),
                size: 25,

              ),
              title: Text(
                'Home',
                style: TextStyle(fontSize: 18, color: Colors.black,fontFamily:'Poppins',),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage(token: token)),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.list_alt_rounded,
                color:  Color(0xFF5B8E55),
                size: 25,

              ),
              title: Text(
                'My Posts',
                style: TextStyle(fontSize: 18, color: Colors.black,fontFamily:'Poppins',),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ComplaintList(),)
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.list_alt_rounded,
                color: Color(0xFF5B8E55),
                size: 25,

              ),
              title: Text(
                'All Posts',
                style: TextStyle(fontSize: 18, color: Colors.black,fontFamily:'Poppins',),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => toutlespost(),)
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.logout_rounded,
                color:  Color(0xFF5B8E55),
                size: 25,
              ),
              title: Text(
                'Log Out',
                style: TextStyle(fontSize: 18, color: Colors.black,fontFamily:'Poppins',),
              ),
              onTap: () {
                SystemNavigator.pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}