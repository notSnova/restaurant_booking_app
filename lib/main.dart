import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurant_booking_app/services/session_helper.dart';
import 'package:restaurant_booking_app/welcome_page.dart';
import 'package:restaurant_booking_app/services/database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await DatabaseHelper.instance.deleteDatabaseFile();
  await DatabaseHelper.instance.database; // make sure db is initialized
  final allReservations = await DatabaseHelper.instance.getAllReservations();

  for (var row in allReservations) {
    print(row);
  }
  String sessionId = await SessionManager.getOrCreateSession();
  print('Session ID: $sessionId');

  runApp(RestaurantBookingApp(sessionId: sessionId));
}

class RestaurantBookingApp extends StatelessWidget {
  final String sessionId;

  const RestaurantBookingApp({super.key, required this.sessionId});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Restaurant Booking App',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.white,
        brightness: Brightness.light,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
          titleTextStyle: GoogleFonts.roboto(
            color: Colors.white,
            fontSize: 24,
          ), // apply roboto to appBar title
        ),
        textTheme: TextTheme(
          titleLarge: GoogleFonts.roboto(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
          titleMedium: GoogleFonts.roboto(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
          bodyLarge: GoogleFonts.roboto(color: Colors.black, fontSize: 16),
          bodyMedium: GoogleFonts.roboto(
            color: Colors.black.withValues(alpha: 0.7),
            fontSize: 14,
          ),
          labelLarge: GoogleFonts.roboto(color: Colors.black),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          labelStyle: GoogleFonts.roboto(
            color: Colors.black.withValues(alpha: 0.7),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.2)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
          ),
        ),
      ),
      home: WelcomePage(sessionId: sessionId), // navigate to welcome page
    );
  }
}
