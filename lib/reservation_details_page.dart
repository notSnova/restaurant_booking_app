import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurant_booking_app/package_page.dart';
import 'package:restaurant_booking_app/services/database_helper.dart';

class ReservationDetailsPage extends StatefulWidget {
  final String sessionId;

  const ReservationDetailsPage({super.key, required this.sessionId});

  @override
  ReservationDetailsPageState createState() => ReservationDetailsPageState();
}

class ReservationDetailsPageState extends State<ReservationDetailsPage> {
  Map<String, dynamic>? reservationData;

  @override
  void initState() {
    super.initState();
    _loadReservationData();
  }

  // fetch data from database
  Future<void> _loadReservationData() async {
    final data = await DatabaseHelper.instance.fetchReservation(
      widget.sessionId,
    );
    setState(() {
      reservationData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (reservationData == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final reservation = reservationData!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Reservation Confirm',
          style: GoogleFonts.roboto(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
        child: Column(
          children: [
            const SizedBox(height: 24),
            Center(child: Image.asset('assets/logo.png', height: 100)),
            const SizedBox(height: 35),
            Expanded(
              child: ListView(
                children: [
                  Card(
                    elevation: 8,
                    color: Colors.white,
                    shadowColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey.shade400, width: 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Center(
                            child: Text(
                              'Customer Details',
                              style: GoogleFonts.roboto(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const Divider(thickness: 1, color: Colors.black45),
                          const SizedBox(height: 12),
                          _buildSummaryRow('Name', reservation['name']),
                          _buildSummaryRow('Address', reservation['address']),
                          _buildSummaryRow('Phone', reservation['phone']),
                          _buildSummaryRow('Email', reservation['email']),
                          _buildSummaryRow(
                            'Guests',
                            '${reservation['guests'].toString()} people(s)',
                          ),

                          const SizedBox(height: 30),

                          Center(
                            child: Text(
                              'Reservation Details',
                              style: GoogleFonts.roboto(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          const Divider(thickness: 1, color: Colors.black45),
                          const SizedBox(height: 12),
                          _buildSummaryRow(
                            'Date',
                            reservation['reservation_date'],
                          ),
                          _buildSummaryRow(
                            'Time',
                            _formatTimeRange(
                              reservation['reservation_time'],
                              reservation['duration'],
                            ),
                          ),
                          _buildSummaryRow('Duration', reservation['duration']),
                          _buildSummaryRow(
                            'Additional Requests',
                            reservation['additional_requests'] ?? 'None',
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.white,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      content: Row(
                        children: [
                          const Icon(
                            Icons.check_circle_outline,
                            color: Colors.black,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Information Saved!',
                            style: GoogleFonts.roboto(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );

                  Future.delayed(const Duration(seconds: 1));

                  // Navigate to the MenuPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => PackagePage(sessionId: widget.sessionId),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Confirm',
                  style: GoogleFonts.roboto(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$title:',
              textAlign: TextAlign.right,
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.roboto(fontSize: 16, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  // format time + duration
  String _formatTimeRange(String startTime, String durationText) {
    try {
      // clean and parse start time
      final cleanedTime = startTime.trim().toUpperCase().replaceAll('.', ':');
      final timeParts = cleanedTime.split(RegExp(r'[:\s]+'));
      int hour = int.parse(timeParts[0]);
      int minute = int.parse(timeParts[1]);
      String meridiem = timeParts[2];

      if (meridiem == 'PM' && hour != 12) {
        hour += 12;
      } else if (meridiem == 'AM' && hour == 12) {
        hour = 0;
      }

      final now = DateTime.now();
      final startDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      );

      // parse duration in hours
      final durationHours =
          int.tryParse(durationText.replaceAll(RegExp(r'\D'), '')) ?? 0;
      final endDateTime = startDateTime.add(Duration(hours: durationHours));

      final formattedStart = _formatTo12Hour(startDateTime);
      final formattedEnd = _formatTo12Hour(endDateTime);

      return '$formattedStart - $formattedEnd';
    } catch (e) {
      // if parsing fails, show fallback
      return '$startTime ($durationText)';
    }
  }

  String _formatTo12Hour(DateTime dt) {
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final suffix = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour.$minute $suffix';
  }
}
