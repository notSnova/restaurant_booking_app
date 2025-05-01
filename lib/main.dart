import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_booking_app/welcome_page.dart';
import 'package:restaurant_booking_app/models/reservation.dart';

void main() {
  runApp(const RestaurantBookingApp());
}

class RestaurantBookingApp extends StatelessWidget {
  const RestaurantBookingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Reservation(), // initialize Reservation provider
      child: MaterialApp(
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
              borderSide: BorderSide(
                color: Colors.black.withValues(alpha: 0.2),
              ),
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
        home: const WelcomePage(), // navigate to welcome page
      ),
    );
  }
}
