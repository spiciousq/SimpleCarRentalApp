import 'package:car_rental_app/model/car.dart';
import 'package:car_rental_app/profile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookCar extends StatefulWidget {
  final Car car;
  BookCar({Key? key, required this.car}) : super(key: key);

  @override
  State<BookCar> createState() => _BookCarState();
}

class _BookCarState extends State<BookCar> {
  DateTimeRange selectedDates =
      DateTimeRange(start: DateTime.now(), end: DateTime.now());
  late int day = 0;
  late double total = 0.0;

  @override
  Widget build(BuildContext context) {
    final int day =
        selectedDates.end.difference(selectedDates.start).inDays + 1;
    final double total = widget.car.rentalPrice * day;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Book A Car'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('${widget.car.image}'),
                  fit: BoxFit
                      .cover, // You can adjust the BoxFit as per your design
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                  color: Colors.deepPurple,
                ),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              final DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(3000),
                              );

                              if (pickedDate != null) {
                                setState(() {
                                  selectedDates = DateTimeRange(
                                    start: pickedDate,
                                    end: pickedDate,
                                  );
                                });
                              }
                            },
                            child: Text('Rent for one day'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              final DateTimeRange? dateTimeRange =
                                  await showDateRangePicker(
                                context: context,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(3000),
                              );
                              if (dateTimeRange != null) {
                                setState(() {
                                  selectedDates = dateTimeRange;
                                });
                              }
                            },
                            child: Text(
                              'Rent for multiple days',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Start Date: ',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${selectedDates.start.day}-${selectedDates.start.month}-${selectedDates.start.year}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'End Date: ',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${selectedDates.end.day}-${selectedDates.end.month}-${selectedDates.end.year}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Days',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${day}',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 1,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Price',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'RM ${widget.car.rentalPrice.toStringAsFixed(2)}',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 1,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Cost',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'RM ${total.toStringAsFixed(2)}',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          await _saveBookingDetails();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Booking Successful"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Profile(
                                              upcomingCars: [widget.car],
                                              price: total,
                                              startDate:
                                                  '${selectedDates.start.day}-${selectedDates.start.month}-${selectedDates.start.year},',
                                              endDate:
                                                  '${selectedDates.end.day}-${selectedDates.end.month}-${selectedDates.end.year}'),
                                        ),
                                      );
                                    },
                                    child: Text("OK"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Text('Proceed'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveBookingDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Save booking details to shared preferences
    await prefs.setString('manufacturer', widget.car.manufacturer);
    await prefs.setString('vehicleName', widget.car.vehicleName);
    await prefs.setString('startDate',
        '${selectedDates.start.day}-${selectedDates.start.month}-${selectedDates.start.year}');
    await prefs.setString('endDate',
        '${selectedDates.end.day}-${selectedDates.end.month}-${selectedDates.end.year}');
    await prefs.setInt('totalDays',
        selectedDates.end.difference(selectedDates.start).inDays + 1);
    await prefs.setDouble('price', widget.car.rentalPrice);
    await prefs.setDouble(
        'totalCost',
        widget.car.rentalPrice *
            (selectedDates.end.difference(selectedDates.start).inDays + 1));
  }
}
