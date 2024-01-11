import 'package:car_rental_app/car_page.dart';
import 'package:car_rental_app/model/car.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  final List<Car> upcomingCars;
  final String startDate;
  final String endDate;
  final double price;

  Profile({
    Key? key,
    required this.upcomingCars,
    required this.price,
    required this.startDate,
    required this.endDate,
  }) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController _name = TextEditingController(text: 'Jason Wang');
  TextEditingController _email =
      TextEditingController(text: 'wanghau@test.com');
  TextEditingController _phone = TextEditingController(text: '601145903800');
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (_selectedIndex) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CarList()),
        );
        break;
      case 1:
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
    }
  }

  Map<String, dynamic> bookingDetails = {};

  Future<Map<String, dynamic>> getBookingDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? manufacturer = prefs.getString('manufacturer');
    String? vehicleName = prefs.getString('vehicleName');
    String? startDate = prefs.getString('startDate');
    String? endDate = prefs.getString('endDate');
    int? totalDays = prefs.getInt('totalDays');
    double? price = prefs.getDouble('price');
    double? totalCost = prefs.getDouble('totalCost');

    return {
      'manufacturer': manufacturer,
      'vehicleName': vehicleName,
      'startDate': startDate,
      'endDate': endDate,
      'totalDays': totalDays,
      'price': price,
      'totalCost': totalCost,
    };
  }

  @override
  void initState() {
    super.initState();
    loadBookingDetails();
    loadProfileInfo();
  }

  Future<void> loadProfileInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _name.text = prefs.getString('name') ?? '';
      _email.text = prefs.getString('email') ?? '';
      _phone.text = prefs.getString('phone') ?? '';
    });
  }

  Future<void> loadBookingDetails() async {
    Map<String, dynamic> details = await getBookingDetails();
    setState(() {
      bookingDetails = details;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => CarList()));
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/image/customer.png'),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _name,
                  decoration: InputDecoration(labelText: 'Full Name'),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _email,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _phone,
                  decoration: InputDecoration(labelText: 'Phone Number'),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    _nameController.text = _name.text;
                    _emailController.text = _email.text;
                    _phoneController.text = _phone.text;
                    _showEditDialog();
                  },
                  child: Text('Edit Profile'),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'Your bookings',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.deepPurple),
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.all(16.0),
              child: Card(
                elevation: 4.0,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: bookingDetails.isEmpty
                      ? Text('No bookings')
                      : ListTile(
                          leading: Icon(CupertinoIcons.car_detailed),
                          title: Text(
                              '${bookingDetails['manufacturer']} ${bookingDetails['vehicleName']}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Start Date: ${bookingDetails['startDate']}'),
                              Text('End Date: ${bookingDetails['endDate']}'),
                              Text(
                                  'Total Days: ${bookingDetails['totalDays']}'),
                              Text(
                                  'Total Cost: ${bookingDetails['totalCost']}'),
                            ],
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
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

  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Profile'),
          content: Container(
            width: 300, // Set the width according to your needs
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(labelText: 'Phone'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString('name', _nameController.text);
                prefs.setString('email', _emailController.text);
                prefs.setString('phone', _phoneController.text);

                loadProfileInfo();
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
