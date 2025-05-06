import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurant_booking_app/review_page.dart';
import 'package:restaurant_booking_app/services/database_helper.dart';

class PaymentPage extends StatefulWidget {
  final String sessionId;
  const PaymentPage({super.key, required this.sessionId});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  Map<String, dynamic>? reservationData;

  @override
  void initState() {
    super.initState();
    _loadReservationData();
  }

  Future<void> _loadReservationData() async {
    final data = await DatabaseHelper.instance.fetchReservation(
      widget.sessionId,
    );
    setState(() {
      reservationData = data;
    });
  }

  final TextEditingController _discountCodeController = TextEditingController();
  bool _isValidDiscountCode = false;
  double finalPrice = 0.0;

  @override
  Widget build(BuildContext context) {
    if (reservationData == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final data = reservationData!;

    // extract data from reservationData
    final String packageName =
        data['selected_package_name'] ?? 'Unknown Package';
    final double packagePrice = data['selected_package_price'];
    final int numberOfGuests = data['guests'];
    final String customerName = data['name'];

    // extract additional items data (decode to json)
    final String? additionalItemsJson = data['selected_additional_items'];
    final Map<String, dynamic> additionalItems =
        additionalItemsJson != null && additionalItemsJson.trim().isNotEmpty
            ? Map<String, dynamic>.from(jsonDecode(additionalItemsJson))
            : {};

    // calculate total of selected package
    double packageTotal = packagePrice * numberOfGuests;

    // calculate total price for additional items
    double additionalItemsTotal = 0.0;
    additionalItems.forEach((key, value) {
      final price = value['price'] as double;
      final quantity = value['quantity'] as int;
      additionalItemsTotal += price * quantity;
    });

    // calculate total price (selected package + additional items)
    double totalPrice = packageTotal + additionalItemsTotal;

    // apply discount if code is valid
    finalPrice = _isValidDiscountCode ? totalPrice * 0.5 : totalPrice;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Payment Details',
          style: GoogleFonts.roboto(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // logo
            const SizedBox(height: 24),
            Center(child: Image.asset('assets/logo.png', height: 100)),
            const SizedBox(height: 32),
            // discount code input
            Text(
              'Discount Code',
              style: GoogleFonts.roboto(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _discountCodeController,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                labelText: 'Enter Code',
                labelStyle: GoogleFonts.roboto(color: Colors.black),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
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
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                suffixIcon: IconButton(
                  icon: Icon(Icons.check),
                  color: Colors.black,
                  onPressed: () {
                    setState(() {
                      // check if the discount code is valid
                      if (_discountCodeController.text == 'DISCOUNT50') {
                        _isValidDiscountCode = true;
                      } else {
                        _isValidDiscountCode = false;
                      }
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 30),
            // display selected package
            Text(
              'Selected Package:',
              style: GoogleFonts.roboto(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            ListTile(
              title: Text(
                '$packageName (x$numberOfGuests)',
                style: GoogleFonts.roboto(fontSize: 16),
              ),
              subtitle: Text(
                'RM${packagePrice.toStringAsFixed(2)} per person',
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              trailing: Text(
                'RM${packageTotal.toStringAsFixed(2)}',
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 30),
            // display additional items
            Text(
              'Additional Items:',
              style: GoogleFonts.roboto(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            if (additionalItems.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16.0,
                ),
                child: Text(
                  '-',
                  style: GoogleFonts.roboto(fontSize: 16, color: Colors.black),
                ),
              )
            else
              ...additionalItems.entries.map((entry) {
                final itemName = entry.key;
                final quantity = entry.value['quantity'] as int;
                final price = entry.value['price'] as double;
                final total = quantity * price;

                return ListTile(
                  title: Text(
                    '$itemName (x$quantity)',
                    style: GoogleFonts.roboto(fontSize: 16),
                  ),
                  subtitle: Text(
                    'RM${price.toStringAsFixed(2)} each',
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  trailing: Text(
                    'RM${total.toStringAsFixed(2)}',
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }),
            const SizedBox(height: 30),
            // total to pay
            Text(
              'Total to Pay:',
              style: GoogleFonts.roboto(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            if (_isValidDiscountCode) ...[
              ListTile(
                title: Text(
                  'Original Price',
                  style: GoogleFonts.roboto(fontSize: 16),
                ),
                trailing: Text(
                  'RM${totalPrice.toStringAsFixed(2)}',
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    decoration: TextDecoration.lineThrough,
                    color: Colors.redAccent,
                  ),
                ),
                subtitle: Text(
                  'Discount applied: 50% off!',
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    color: Colors.green[700],
                  ),
                ),
              ),
            ],
            ListTile(
              title: Text(
                'Total Price',
                style: GoogleFonts.roboto(fontSize: 16),
              ),
              trailing: Text(
                'RM${finalPrice.toStringAsFixed(2)}',
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
      // pay button
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  // handle payment logic or confirmation
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
                                'Payment Successful',
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
                                  'You have paid RM${finalPrice.toStringAsFixed(2)}.',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.roboto(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  'Thank you for your reservation!',
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
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder:
                                            (context) => ReviewPage(
                                              packageName: packageName,
                                              customerName: customerName,
                                              sessionId: widget.sessionId,
                                            ),
                                      ),
                                    );
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
                            contentPadding: const EdgeInsets.fromLTRB(
                              24,
                              16,
                              24,
                              16,
                            ),
                          ),
                        ),
                  );
                },
                child: Text(
                  'Pay RM${finalPrice.toStringAsFixed(2)}',
                  style: GoogleFonts.roboto(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
