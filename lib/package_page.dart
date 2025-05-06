import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurant_booking_app/models/menu_package.dart';
import 'package:restaurant_booking_app/package_details_page.dart';

class PackagePage extends StatelessWidget {
  final String sessionId;
  const PackagePage({super.key, required this.sessionId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Menu Packages',
          style: GoogleFonts.roboto(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          const SizedBox(height: 32),
          Image.asset('assets/logo.png', height: 100),
          const SizedBox(height: 32),
          Text(
            'We offered the best menu choices here:',
            style: GoogleFonts.roboto(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                mainAxisExtent: 220, // height of card
              ),
              itemCount: menuPackages.length,
              itemBuilder: (context, index) {
                final menuPackage = menuPackages[index];
                return GestureDetector(
                  onTap: () {
                    // navigate to package details page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => PackageDetailsPage(
                              menuPackage: menuPackage,
                              sessionId: sessionId,
                            ),
                      ),
                    );
                  },
                  child: Card(
                    color: Colors.white,
                    elevation: 8,
                    shadowColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey.shade400, width: 1),
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                          child: Image.asset(
                            menuPackage.imageUrl,
                            height: 160,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              menuPackage.name,
                              style: GoogleFonts.roboto(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
