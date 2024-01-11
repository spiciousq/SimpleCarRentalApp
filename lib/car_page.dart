// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:car_rental_app/book_car.dart';
import 'package:car_rental_app/car_filter.dart';
import 'package:car_rental_app/model/car.dart';
import 'package:car_rental_app/profile.dart';
import 'package:flutter/material.dart';

class CarList extends StatefulWidget {
  const CarList({super.key});

  @override
  State<CarList> createState() => _CarListState();
}

class _CarListState extends State<CarList> {
  String searchKeyword = '';
  bool isFiltering = false;

  List<String> selectedManufacturers = [];
  List<String> selectedVehicleNames = [];
  RangeValues priceRange = RangeValues(0, 600);
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (_selectedIndex) {
      case 0:
        // Navigate to the CarList page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CarList()),
        );
        break;
      case 1:
        // Navigate to the ProfilePage page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Profile(
                    upcomingCars: [],
                    price: 0,
                    startDate: '',
                    endDate: '',
                  )),
        );
        break;
      // Add more cases if you have additional tabs
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 80,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25),
            child: Text(
              "Rent A Car",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Container(
                            height: 30,
                            child: Icon(
                              Icons.search,
                              size: 30,
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            onChanged: (value) {
                              setState(() {
                                searchKeyword = value.toLowerCase();

                                selectedManufacturers = [];
                                selectedVehicleNames = [];
                                priceRange = RangeValues(0, 600);
                              });
                            },
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Search available cars..'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CarFilter(onApplyFilters: applyFilters)));
                  },
                  child: Container(
                    height: 50,
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(12)),
                    child: Image.asset(
                      'assets/image/filter.png',
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: Container(
              child: ListView.builder(
                itemCount: carList.length,
                itemBuilder: (context, index) {
                  final car = carList[index];

                  if (
                      // Check for filter conditions
                      (selectedManufacturers.isEmpty ||
                              selectedManufacturers
                                  .contains(car.manufacturer)) &&
                          (selectedVehicleNames.isEmpty ||
                              selectedVehicleNames.any((selectedName) =>
                                  car.vehicleName.contains(selectedName))) &&
                          (car.rentalPrice >= priceRange.start &&
                              car.rentalPrice <= priceRange.end) &&

                          // Check for search condition
                          (searchKeyword.isEmpty ||
                              car.manufacturer
                                  .toLowerCase()
                                  .contains(searchKeyword) ||
                              car.vehicleName
                                  .toLowerCase()
                                  .contains(searchKeyword))) {
                    return CarListItem(index);
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.car_rental),
            label: 'Car',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  void applyFilters(
    List<String> manufacturers,
    List<String> vehicleNames,
    RangeValues priceRange,
  ) {
    setState(() {
      selectedManufacturers = manufacturers;
      selectedVehicleNames = vehicleNames;
      this.priceRange = priceRange;
    });
  }
}

class CarListItem extends StatelessWidget {
  const CarListItem(
    this.index, {
    super.key,
  });

  final int index;

  @override
  Widget build(BuildContext context) {
    Car car = carList[index];
    return Container(
        margin: EdgeInsets.only(
          bottom: 20,
        ),
        child: Stack(children: [
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(left: 24, right: 24),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${car.manufacturer}',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Image.asset(
                  '${car.image}',
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${car.vehicleName}',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'RM${car.rentalPrice.toStringAsFixed(2)}/day',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8))),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BookCar(
                                        car: car,
                                      )));
                        },
                        child: Text(
                          'Book Now',
                        )),
                  ],
                )
              ],
            ),
          ),
        ]));
  }
}
