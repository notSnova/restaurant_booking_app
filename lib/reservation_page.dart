import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_booking_app/reservation_details_page.dart';
import 'models/reservation.dart';

class ReservationPage extends StatelessWidget {
  const ReservationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Reservation Details',
          style: GoogleFonts.roboto(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: ReservationForm(),
      ),
    );
  }
}

class ReservationForm extends StatefulWidget {
  const ReservationForm({super.key});

  @override
  State<ReservationForm> createState() => _ReservationFormState();
}

class _ReservationFormState extends State<ReservationForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _guestController = TextEditingController();
  DateTime? _reservationDate;
  TimeOfDay? _reservationTime;
  String? _dateError;
  String? _timeError;

  String _formatTime(TimeOfDay timeOfDay) {
    final now = DateTime(0, 0, 0, timeOfDay.hour, timeOfDay.minute);
    return DateFormat.jm().format(now);
  }

  String _dineDuration = 'Select';

  final List<String> _additionalRequests = [];
  final List<String> _requestOptions = ['Birthday Celebration', 'Decoration'];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            primaryColor: Colors.white,
            textTheme: TextTheme(
              bodyLarge: GoogleFonts.roboto(color: Colors.white),
            ),
            colorScheme: const ColorScheme.dark(
              primary: Colors.white,
              onSurface: Colors.white,
              secondary: Colors.white,
            ),
            dialogTheme: const DialogTheme(backgroundColor: Colors.black),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _reservationDate = picked;
        _dateError = null;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            primaryColor: Colors.white,
            textTheme: TextTheme(
              bodyLarge: GoogleFonts.roboto(color: Colors.white),
            ),
            colorScheme: const ColorScheme.dark(
              primary: Colors.white,
              onSurface: Colors.white,
              secondary: Colors.white,
            ),
            dialogTheme: const DialogTheme(backgroundColor: Colors.black),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _reservationTime = picked;
        _timeError = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Center(child: Image.asset('assets/logo.png', height: 100)),
            const SizedBox(height: 32),
            Text(
              'Customer Details',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.black),
            ),
            const SizedBox(height: 4),
            _buildTextField(_nameController, 'Name'),
            _buildTextField(_addressController, 'Address', isMultiline: true),
            _buildTextField(_phoneController, 'Phone No', isNumber: true),
            _buildTextField(_emailController, 'Email'),
            _buildTextField(
              _guestController,
              'Number of Guests',
              isNumber: true,
            ),
            const SizedBox(height: 16),
            _buildDatePicker(),
            const SizedBox(height: 8),
            _buildTimePicker(),
            const SizedBox(height: 16),
            _buildDineDurationDropdown(),
            const SizedBox(height: 16),
            _buildAdditionalRequests(),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _dateError =
                        _reservationDate == null
                            ? 'Please select a reservation date'
                            : null;
                    _timeError =
                        _reservationTime == null
                            ? 'Please select a reservation time'
                            : null;
                  });

                  if (_formKey.currentState!.validate() &&
                      _dateError == null &&
                      _timeError == null) {
                    final reservation = Provider.of<Reservation>(
                      context,
                      listen: false,
                    );
                    reservation.updateReservation(
                      name: _nameController.text,
                      address: _addressController.text,
                      phone: _phoneController.text,
                      email: _emailController.text,
                      numberOfGuests: int.parse(_guestController.text),
                      reservationDate: _reservationDate!,
                      reservationTime: _reservationTime!,
                      dineDuration: _dineDuration,
                      additionalRequests: _additionalRequests,
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ReservationDetailsPage(),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 14.0,
                    horizontal: 50.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text('Proceed', style: GoogleFonts.roboto(fontSize: 18)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // textfield build
  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    bool isNumber = false,
    bool isMultiline = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType:
            isNumber
                ? TextInputType.number
                : isMultiline
                ? TextInputType.multiline
                : TextInputType.text,
        maxLines: isMultiline ? 3 : 1,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return '$label is required';
          }
          if (label == 'Email' && !RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
            return 'Enter a valid email';
          }
          if (isNumber && int.tryParse(value) == null) {
            return 'Enter a valid number';
          }
          if (label == 'Number of Guests') {
            final guests = int.tryParse(value);
            if (guests == null || guests <= 0) {
              return 'Number of Guests must be greater than 0';
            }
          }
          return null;
        },
      ),
    );
  }

  // date picker
  Widget _buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reservation Date',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(color: Colors.black),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: _dateError != null ? Colors.white : Colors.white,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextButton(
            onPressed: () => _selectDate(context),
            child: Text(
              _reservationDate == null
                  ? 'Select Date'
                  : DateFormat('d MMMM yyyy').format(_reservationDate!),
              style: GoogleFonts.roboto(color: Colors.black, fontSize: 16),
            ),
          ),
        ),
        if (_dateError != null)
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 0),
            child: Text(
              _dateError!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  // time picker
  Widget _buildTimePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reservation Time',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(color: Colors.black),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: _timeError != null ? Colors.white : Colors.white,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextButton(
            onPressed: () => _selectTime(context),
            child: Text(
              _reservationTime == null
                  ? 'Select Time'
                  : _formatTime(_reservationTime!),
              style: GoogleFonts.roboto(color: Colors.black, fontSize: 16),
            ),
          ),
        ),
        if (_timeError != null)
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 0),
            child: Text(
              _timeError!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _buildDineDurationDropdown() {
    return DropdownButtonFormField<String>(
      value: _dineDuration,
      items:
          ['Select', '3 hours', '4 hours', '5 hours']
              .map(
                (duration) => DropdownMenuItem(
                  value: duration,
                  child: Text(
                    duration,
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              )
              .toList(),
      onChanged: (value) {
        setState(() {
          _dineDuration = value!;
        });
      },
      validator: (value) {
        if (value == 'Select') {
          return 'Please select a dine-in duration';
        }
        return null;
      },
      decoration: const InputDecoration(labelText: 'Dine-in Duration'),
      dropdownColor: Colors.white,
      iconEnabledColor: Colors.black,
    );
  }

  Widget _buildAdditionalRequests() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Additional Requests',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        ..._requestOptions.map((request) {
          return CheckboxListTile(
            title: Text(request),
            value: _additionalRequests.contains(request),
            onChanged: (bool? selected) {
              setState(() {
                if (selected == true) {
                  _additionalRequests.add(request);
                } else {
                  _additionalRequests.remove(request);
                }
              });
            },
            activeColor: Colors.black,
            checkColor: Colors.white,
          );
        }),
      ],
    );
  }
}
