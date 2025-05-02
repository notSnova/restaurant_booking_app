import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'models/reservation.dart';

class ReviewPage extends StatefulWidget {
  final String packageName;

  const ReviewPage({super.key, required this.packageName});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  double _currentRating = 0.0;
  final TextEditingController _reviewController = TextEditingController();

  // list to store submitted reviews locally
  final List<Map<String, dynamic>> _reviews = [];

  void _submitReview() {
    final reservation = Provider.of<Reservation>(context, listen: false);
    final customerName = reservation.name;

    if (_currentRating > 0 && _reviewController.text.isNotEmpty) {
      setState(() {
        _reviews.add({
          'name': customerName, // customer name from provider
          'rating': _currentRating,
          'review': _reviewController.text.trim(),
        });
        _currentRating = 0.0;
        _reviewController.clear();
      });

      // snackbar to show message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.white,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Row(
            children: [
              const Icon(Icons.check_circle_outline, color: Colors.black),
              const SizedBox(width: 12),
              Text(
                'Review submitted!',
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Reviews for ${widget.packageName}',
          style: GoogleFonts.roboto(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              Center(child: Image.asset('assets/logo.png', height: 100)),
              const SizedBox(height: 40),

              // rating bar
              Text(
                'Rate this package:',
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              RatingBar.builder(
                initialRating: _currentRating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 32,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder:
                    (context, _) => const Icon(Icons.star, color: Colors.amber),
                onRatingUpdate: (rating) {
                  setState(() {
                    _currentRating = rating;
                  });
                },
              ),
              const SizedBox(height: 30),

              // review input
              SizedBox(
                width: 400,
                child: TextField(
                  controller: _reviewController,
                  decoration: const InputDecoration(
                    labelText: 'Write your review',
                    border: OutlineInputBorder(),
                  ),
                  cursorColor: Colors.black,
                  maxLines: 3,
                ),
              ),
              const SizedBox(height: 22),

              // submit review button
              ElevatedButton(
                onPressed: _submitReview,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 40.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Submit Review',
                  style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(height: 24),
              const Divider(thickness: 1, color: Colors.black45),
              const SizedBox(height: 24),

              // section title
              Text(
                'User Reviews',
                style: GoogleFonts.roboto(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),

              // display reviews
              ..._reviews.map((review) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: Card(
                    color: Colors.grey[300],
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.star, color: Colors.amber),
                      title: Text(
                        '${review['name']} - ${review['rating']} ⭐',
                        style: GoogleFonts.roboto(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '“${review['review']}”',
                        style: GoogleFonts.roboto(color: Colors.black),
                      ),
                    ),
                  ),
                );
              }),

              if (_reviews.isEmpty) const Text('No reviews yet.'),
            ],
          ),
        ),
      ),
    );
  }
}
