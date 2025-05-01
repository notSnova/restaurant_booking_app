import 'package:flutter/material.dart';

class Reservation extends ChangeNotifier {
  String name = '';
  String address = '';
  String phone = '';
  String email = '';
  int numberOfGuests = 0;
  DateTime? reservationDate;
  TimeOfDay? reservationTime;
  String dineDuration = '3 hours';
  List<String> additionalRequests = [];

  // package related data
  String _selectedPackageName = '';
  double _selectedPackagePrice = 0.0;
  Map<String, Map<String, dynamic>> selectedAdditionalItems = {};

  // getters
  String get selectedPackageName => _selectedPackageName;
  double get selectedPackagePrice => _selectedPackagePrice;

  // set selected package and price
  void setSelectedPackage({required String name, required double price}) {
    _selectedPackageName = name;
    _selectedPackagePrice = price;
    notifyListeners();
  }

  // update reservation with optional parameters, allowing partial updates
  void updateReservation({
    String? name,
    String? address,
    String? phone,
    String? email,
    int? numberOfGuests,
    DateTime? reservationDate,
    TimeOfDay? reservationTime,
    String? dineDuration,
    List<String>? additionalRequests,
  }) {
    if (name != null) {
      this.name = name;
    }
    if (address != null) {
      this.address = address;
    }
    if (phone != null) {
      this.phone = phone;
    }
    if (email != null) {
      this.email = email;
    }
    if (numberOfGuests != null) {
      this.numberOfGuests = numberOfGuests;
    }
    if (reservationDate != null) {
      this.reservationDate = reservationDate;
    }
    if (reservationTime != null) {
      this.reservationTime = reservationTime;
    }
    if (dineDuration != null) {
      this.dineDuration = dineDuration;
    }
    if (additionalRequests != null) {
      this.additionalRequests = additionalRequests;
    }

    notifyListeners(); // notify listeners to update the UI
  }

  // update selected items
  void updateSelectedItems(Map<String, Map<String, dynamic>> items) {
    selectedAdditionalItems = Map.from(items);
    notifyListeners();
  }
}
