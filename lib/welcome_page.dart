import 'package:flutter/material.dart';
import 'package:restaurant_booking_app/services/session_helper.dart';
import 'package:restaurant_booking_app/services/database_helper.dart';
import 'reservation_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  String? sessionId;

  @override
  void initState() {
    super.initState();
    _initSessionAndDatabase();
  }

  Future<void> _initSessionAndDatabase() async {
    // initialize database
    await DatabaseHelper.instance.database;

    // delete database for test
    // await DatabaseHelper.instance.deleteDatabaseFile();

    // print all existing reservations
    final allReservations = await DatabaseHelper.instance.getAllReservations();
    if (allReservations.isNotEmpty) {
      for (var row in allReservations) {
        print(row);
      }
    } else {
      print('No table has been created');
    }

    // generate new session
    final newSessionId = await SessionManager.generateSession();
    //set state
    setState(() {
      sessionId = newSessionId;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (sessionId == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // logo
              Image.asset('assets/logo.png', height: 150),
              const SizedBox(height: 30),

              // welcome message
              Text(
                'Welcome to our Restaurant!',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Experience the finest dining experience with us.',
                style: TextStyle(fontSize: 16, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // book now button
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    // animation
                    PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 500),
                      pageBuilder:
                          (context, animation, secondaryAnimation) =>
                              ReservationPage(sessionId: sessionId!),
                      transitionsBuilder: (
                        context,
                        animation,
                        secondaryAnimation,
                        child,
                      ) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Book Now', style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 10),
              Text('ID: ${sessionId!.substring(0, 6)}...'),
            ],
          ),
        ),
      ),
    );
  }
}
