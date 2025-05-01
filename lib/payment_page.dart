import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'models/reservation.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final TextEditingController _discountCodeController = TextEditingController();
  bool _isValidDiscountCode = false;
  double finalPrice = 0.0;

  @override
  Widget build(BuildContext context) {
    final reservation = Provider.of<Reservation>(context);

    // get the total price from provider
    double totalPrice = reservation.totalPrice;

    // apply discount if code is valid
    if (_isValidDiscountCode) {
      finalPrice = totalPrice * 0.5;
    } else {
      finalPrice = totalPrice;
    }

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
    );
  }
}
