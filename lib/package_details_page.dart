import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurant_booking_app/models/menu_package.dart';
import 'package:restaurant_booking_app/services/database_helper.dart';
import 'package:restaurant_booking_app/payment_page.dart';

class PackageDetailsPage extends StatefulWidget {
  final MenuPackage menuPackage;
  final String sessionId;

  const PackageDetailsPage({
    super.key,
    required this.menuPackage,
    required this.sessionId,
  });

  @override
  State<PackageDetailsPage> createState() => _PackageDetailsPageState();
}

class _PackageDetailsPageState extends State<PackageDetailsPage> {
  final Map<String, int> _itemQuantities =
      {}; // track quantity of selected items

  // methods to calculate the price
  double getBasePrice() => widget.menuPackage.price;

  double getExtraGuestPrice(int numberOfGuests) {
    return numberOfGuests > 1 ? (numberOfGuests - 1) * getBasePrice() : 0.0;
  }

  double getAdditionalItemsPrice() {
    return widget.menuPackage.additionalItems.entries.fold(0.0, (sum, entry) {
      final item = entry.key;
      final unitPrice = entry.value;
      final qty = _itemQuantities[item] ?? 0;
      return sum + (qty * unitPrice);
    });
  }

  double getFinalTotal(int numberOfGuests) {
    return getBasePrice() +
        getExtraGuestPrice(numberOfGuests) +
        getAdditionalItemsPrice();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.menuPackage.name,
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
            // image with shadows
            Card(
              elevation: 8,
              shadowColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade400, width: 1),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  widget.menuPackage.imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // package name
            Text(
              widget.menuPackage.name,
              style: GoogleFonts.roboto(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            // package description
            Text(
              widget.menuPackage.description,
              style: GoogleFonts.roboto(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 42),
            // menu section
            Center(
              child: Text(
                'Main Menu',
                style: GoogleFonts.roboto(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const Divider(thickness: 1, color: Colors.black45),
            const SizedBox(height: 14),
            Center(
              child: Wrap(
                spacing: 16,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  ...widget.menuPackage.menuItems.map((item) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 2,
                            ), // icon placement
                            child: const Icon(Icons.restaurant_menu, size: 18),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              item,
                              style: GoogleFonts.roboto(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  // add invisible box if item count is odd to balance layout
                  if (widget.menuPackage.menuItems.length.isOdd)
                    SizedBox(width: MediaQuery.of(context).size.width * 0.4),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // additional items section
            Center(
              child: Text(
                'Additional Items',
                style: GoogleFonts.roboto(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const Divider(thickness: 1, color: Colors.black45),
            // list additional items one by one
            Column(
              children:
                  widget.menuPackage.additionalItems.entries.map((entry) {
                    final item = entry.key;
                    final itemPrice = entry.value;

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 2.0,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(Icons.restaurant_menu, size: 18),
                          const SizedBox(width: 8),
                          // item name and price
                          Expanded(
                            child: Text(
                              '$item (RM${itemPrice.toStringAsFixed(2)})',
                              style: GoogleFonts.roboto(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          // quantity controls
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline),
                                color: Colors.grey.shade900,
                                onPressed: () {
                                  setState(() {
                                    if ((_itemQuantities[item] ?? 0) > 0) {
                                      _itemQuantities[item] =
                                          _itemQuantities[item]! - 1;
                                    }
                                  });
                                },
                              ),
                              Text(
                                (_itemQuantities[item] ?? 0).toString(),
                                style: GoogleFonts.roboto(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline),
                                color: Colors.grey.shade900,
                                onPressed: () {
                                  setState(() {
                                    _itemQuantities[item] =
                                        (_itemQuantities[item] ?? 0) + 1;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),
            ),
            const SizedBox(height: 30),
            // price section
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Price',
                    style: GoogleFonts.roboto(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const Divider(thickness: 1, color: Colors.black45),
                  const SizedBox(height: 8),
                  Text(
                    'RM${getBasePrice().toStringAsFixed(2)} per person',
                    style: GoogleFonts.roboto(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.green[800],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
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
                onPressed: () async {
                  // handle booking logic
                  final selectedPackageName = widget.menuPackage.name;
                  final selectedPackagePrice = widget.menuPackage.price;

                  // prepare selected additional items (json format)
                  final detailedItems = <String, Map<String, dynamic>>{};

                  // update selected additional items
                  _itemQuantities.forEach((itemName, quantity) {
                    if (quantity > 0) {
                      final unitPrice =
                          widget.menuPackage.additionalItems[itemName]!;
                      detailedItems[itemName] = {
                        'quantity': quantity,
                        'price': unitPrice,
                      };
                    }
                  });

                  // convert detailedItems to a string
                  String additionalItemsJson =
                      detailedItems.isNotEmpty ? detailedItems.toString() : '';

                  // update to database
                  final update = await DatabaseHelper.instance
                      .updateReservationPackage(
                        widget.sessionId,
                        selectedPackageName,
                        selectedPackagePrice,
                        additionalItemsJson,
                      );

                  if (update) {
                    print('Package Updated!');
                  }

                  // set selected package
                  // reservation.setSelectedPackage(
                  //   name: widget.menuPackage.name,
                  //   price: widget.menuPackage.price,
                  // );

                  // // store additional items selection
                  // reservation.updateSelectedItems(detailedItems);

                  // navigate to payment page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PaymentPage()),
                  );
                },
                child: Text(
                  'Choose Package',
                  style: GoogleFonts.roboto(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 10), // additional space at the bottom
          ],
        ),
      ),
    );
  }
}
