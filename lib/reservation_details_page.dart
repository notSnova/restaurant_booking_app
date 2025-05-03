import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_booking_app/menu_page.dart';
import 'models/reservation.dart';

class ReservationDetailsPage extends StatelessWidget {
  const ReservationDetailsPage({super.key});

  String formatDate(DateTime? date) {
    if (date == null) return 'Not selected';
    return DateFormat('d MMMM yyyy').format(date);
  }

  String formatTime(TimeOfDay? time) {
    if (time == null) return 'Not selected';
    final now = DateTime(0, 0, 0, time.hour, time.minute);
    return DateFormat.jm().format(now);
  }

  @override
  Widget build(BuildContext context) {
    final reservation = Provider.of<Reservation>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Reservation Details',
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
            const SizedBox(height: 32),
            Text(
              'Confirm Your Details',
              style: GoogleFonts.roboto(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _buildInfoCard(
                    context,
                    title: 'Customer Info',
                    children: [
                      _buildSummaryRow('Name', reservation.name),
                      _buildSummaryRow('Address', reservation.address),
                      _buildSummaryRow('Phone', reservation.phone),
                      _buildSummaryRow('Email', reservation.email),
                      _buildSummaryRow(
                        'Guests',
                        reservation.numberOfGuests.toString(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildInfoCard(
                    context,
                    title: 'Reservation Info',
                    children: [
                      _buildSummaryRow(
                        'Date',
                        formatDate(reservation.reservationDate),
                      ),
                      _buildSummaryRow(
                        'Time',
                        formatTime(reservation.reservationTime),
                      ),
                      _buildSummaryRow('Duration', reservation.dineDuration),
                      _buildSummaryRow(
                        'Additional Requests',
                        reservation.additionalRequests.isNotEmpty
                            ? reservation.additionalRequests.join(', ')
                            : 'None',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
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
                    MaterialPageRoute(builder: (context) => MenuPage()),
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

  Widget _buildInfoCard(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Card(
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
            Text(
              title,
              style: GoogleFonts.roboto(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            ..._addDividersBetween(children),
          ],
        ),
      ),
    );
  }

  List<Widget> _addDividersBetween(List<Widget> widgets) {
    return List.generate(widgets.length * 2 - 1, (index) {
      if (index.isOdd) {
        return const Divider(thickness: 1, color: Colors.black45);
      } else {
        return widgets[index ~/ 2];
      }
    });
  }

  Widget _buildSummaryRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title: ',
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
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
}
