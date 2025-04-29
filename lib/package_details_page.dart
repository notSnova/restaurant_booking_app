import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurant_booking_app/menu_package.dart';

class PackageDetailsPage extends StatelessWidget {
  final MenuPackage menuPackage;

  const PackageDetailsPage({super.key, required this.menuPackage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          menuPackage.name,
          style: GoogleFonts.roboto(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // display image
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                menuPackage.imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            //display menu name and description
            Text(
              menuPackage.name,
              style: GoogleFonts.roboto(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              menuPackage.description,
              style: GoogleFonts.roboto(fontSize: 16),
            ),
            const SizedBox(height: 16),
            // display menu items
            Text(
              'Main Menu:',
              style: GoogleFonts.roboto(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  menuPackage.menuItems.map((item) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        "- $item",
                        style: GoogleFonts.roboto(fontSize: 16),
                      ),
                    );
                  }).toList(),
            ),
            const SizedBox(height: 16),
            // display additional items
            Text(
              'Additional Items:',
              style: GoogleFonts.roboto(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  menuPackage.additionalItems.map((item) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        "- $item",
                        style: GoogleFonts.roboto(fontSize: 16),
                      ),
                    );
                  }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
