import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_ui/pages/profile_page.dart';
import 'package:google_fonts/google_fonts.dart';

import '../new_reclamation.dart';
import '../widgets/widgets.dart';

class Watering extends StatefulWidget {
  const Watering({Key? key}): super(key:key);

  @override
  State<Watering> createState() => _WateringState();
}

class _WateringState extends State<Watering> {
  String selectedOption = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF5B8E55),
        elevation: 4,
        title: Text('Watering System', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white), // Change back arrow color to white

      ),
      body: Container(
        color: Colors.grey[200],
        padding: EdgeInsets.fromLTRB(20, 70, 20, 0),
        child: ListView(
          children: [
            settingTile(context, 'Resource Efficiency'),
            SizedBox(height: 15,),
            settingTile(context, 'Garden Cleanliness:'),
            SizedBox(height: 15,),
            settingTile(context, 'Organic Waste Management'),
            SizedBox(height: 15,),
            settingTile(context, 'Other'),
          ],
        ),
      ),
    );
  }

  Widget settingTile(BuildContext context, String title) {
    bool isSelected = selectedOption == title;
    return SizedBox(
      height: 120,
      child: Card(
        color: Colors.white,
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          // Centering the title and setting font style
          title: Center(
            child: Text(
              title,
              style: GoogleFonts.anekTelugu(
                fontSize: 20.0,
                fontWeight: FontWeight.normal,// Adjust the font size as needed
              ),
            ),
          ),
          trailing: GestureDetector(
            onTap: () {
              setState(() {
                if (isSelected) {
                  selectedOption = ''; // Deselect if already selected
                } else {
                  selectedOption = title; // Select this and deselect others
                }
              });
              if (!isSelected) { // Navigate only if new selection is made
                navigateToReclamationForm(title);
              }
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              height: 25,
              width: 25,
              decoration: BoxDecoration(
                color: isSelected ? Color(0xFF5B8E55) : Colors.white, // Fill circle with green when selected
                shape: BoxShape.circle,
                border: Border.all(
                    color: Color(0xFF5B8E55),
                    width: 2
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


  void navigateToReclamationForm(String type) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => NewReclamationForm(
            type: type,
            complaintTypes: getComplaintTypesForType(type),
          )
      ),
    );
  }


  List<String> getComplaintTypesForType(String type) {
    switch (type) {
      case 'Overwatering':
        return ['Overwatering', 'Underwatering','Irrigation Malfunction', 'Other'];
      case 'Underwatering:':
        return ['Overwatering', 'Underwatering','Irrigation Malfunction', 'Other'];
      case 'Irrigation Malfunction':
        return ['Overwatering', 'Underwatering','Irrigation Malfunction', 'Other'];
      case 'Other':
        return ['Overwatering', 'Underwatering','Irrigation Malfunction', 'Other'];
      default:
        return [];
    }
  }
}

