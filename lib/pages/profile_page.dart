
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login_ui/pages/notification.dart';
import 'package:flutter_login_ui/pages/pdf_page.dart';
import 'package:flutter_login_ui/pages/relamtion%20page/SoilQuality.dart';
import 'package:flutter_login_ui/pages/relamtion%20page/watering.dart';
import 'package:flutter_login_ui/pages/relamtion%20page/GardenAppearance.dart';
import 'package:flutter_login_ui/pages/relamtion%20page/PlantHealth.dart';
import 'package:flutter_login_ui/pages/relamtion%20page/UserSatisfaction.dart';
import 'package:flutter_login_ui/pages/relamtion%20page/WasteManagement.dart';
import 'package:flutter_login_ui/pages/widgets/enTendence.dart';
import 'package:flutter_login_ui/pages/widgets/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

import 'ComplaintList.dart';
import 'new_reclamation.dart';
import 'widgets/sidebar.dart';



class ProfilePage extends StatefulWidget {
  final String token;
  const ProfilePage({required this.token, Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  List<Map<String, dynamic>> categories = [
    {"image": "assets/images/planthealth.png", "title": "Plant Health", "subtitle": "Issues with plant well-being and vitality of the plants within the smart garden"},
    {"image": "assets/images/watering.png", "title": "Watering System", "subtitle": "Concerns related to the management and functionality of the garden's watering system"},
    {"image": "assets/user_satisfaction.png", "title": "User Satisfaction", "subtitle": "Overall satisfaction and user experience with the smart garden system."},
    {"image": "assets/garden_appearance.png", "title": "Garden Appearance", "subtitle": "Feedback on the aesthetic appeal and visual aspects of the garden"},
    {"image": "assets/waste_management.png", "title": "Waste Management", "subtitle": "Management and disposal of waste generated within the garden environment."},
    {"image": "assets/soil_quality.png", "title": "Soil Quality", "subtitle": "Complaints regarding the condition and composition of the soil supporting plant growth."},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF5B8E55) ,
        title: Text("My Garden", style: TextStyle(fontFamily: 'Poppins', color: Colors.white, fontWeight: FontWeight.bold)),
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.white), // Change back arrow color to white
      ),
      drawer: DrawerWidget (),
      body: Container(
        color: Colors.grey[200] ,// Set the background color to light green
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: <Widget>[
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
                child: Text(" Most Popular Complaints",
                  style: GoogleFonts.anekTelugu(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              // Example horizontal list widget for popular complaints
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: 100,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        enTendence(),
                      ],
                    ),
                  )
              ) ,

              SizedBox(height: 30),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("Categories of Complaints",
                  style: GoogleFonts.anekTelugu(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,

                  ),
                ),
              ),
              ...categories.map((category) => GestureDetector(
                onTap: () => navigateToScreen(context, category["title"]),
                child: Card(
                  color: Colors.white,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(5.0, 10, 2, 10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: Image.asset(category["image"], height: 100, fit: BoxFit.cover),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(category["title"], style: GoogleFonts.anekTelugu(
                                fontSize: 17.0,
                                fontWeight: FontWeight.w500
                              ),),
                              Text(category["subtitle"], style: GoogleFonts.anekTelugu(
                                fontSize: 16.0,
                                color: Colors.grey,
                              ),),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )).toList(),
            ],
          ),
        ),
      ),
    );
  }
}

void navigateToScreen(BuildContext context, String title) {
  Widget page = Container(); // Default empty widget for unrecognized categories
  switch (title) {
    case "Plant Health":
      page = PlantHealth();
      break;
    case "Watering System":
      page = Watering();
      break;
    case "User Satisfaction":
      page = UserSatisfaction();
      break;
    case "Garden Appearance":
      page = GardenAppearance();
      break;
    case "Waste Management":
      page = WasteManagement();
      break;
    case "Soil Quality":
      page = SoilQuality();
      break;
  }
  if (page is! Container) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
  }
}