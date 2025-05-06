import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:restaurant_booking_app/services/database_helper.dart';
import 'package:restaurant_booking_app/services/session_helper.dart';
import 'welcome_page.dart';

class ReviewPage extends StatefulWidget {
  final String packageName;
  final String customerName;
  final String sessionId;

  const ReviewPage({
    super.key,
    required this.packageName,
    required this.customerName,
    required this.sessionId,
  });

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  double _currentRating = 0.0;
  final TextEditingController _reviewController = TextEditingController();

  // list to store submitted reviews locally
  List<Map<String, dynamic>> _reviews = [];

  @override
  void initState() {
    super.initState();
    _fetchReviews();
  }

  // fetch review from database
  void _fetchReviews() async {
    final reviews = await DatabaseHelper.instance.fetchReviews(
      widget.packageName,
    );
    setState(() {
      _reviews = reviews;
    });
  }

  // submit review to database
  void _submitReview() async {
    if (_currentRating > 0 && _reviewController.text.isNotEmpty) {
      final newReview = {
        'customer_name': widget.customerName, // customer name from parameter
        'package_name': widget.packageName,
        'rating': _currentRating,
        'review': _reviewController.text.trim(),
      };

      // insert review into database
      await DatabaseHelper.instance.insertReview(newReview);

      // refresh reviews list
      _fetchReviews();

      // clear input fields
      setState(() {
        _currentRating = 0.0;
        _reviewController.clear();
      });

      // show thankyou message
      showDialog(
        context: context,
        builder:
            (_) => Center(
              child: AlertDialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                title: Center(
                  child: Text(
                    'Thank You!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Your review has been submitted successfully.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.grey[350],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        await SessionManager.resetSession();
                        Navigator.of(context).pop(); // close dialog
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const WelcomePage(),
                          ),
                        ); // back to WelcomePage
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: Text(
                          'OK',
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
              ),
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
                        '${review['customer_name']} - ${review['rating']} ⭐',
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
