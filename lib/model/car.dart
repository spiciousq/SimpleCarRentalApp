class Car {
  String manufacturer;
  String vehicleName;
  double rentalPrice;
  String image;

  Car(
      {required this.manufacturer,
      required this.vehicleName,
      required this.rentalPrice,
      required this.image});

  Map<String, dynamic> toJson() {
    return {
      'vehicleName': vehicleName,
     'manufacturer': manufacturer,
     'rentalPrice': rentalPrice,
     'image': image,
    };
  }

  // Create a Car instance from JSON data
  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      vehicleName: json['vehicleName'], manufacturer: json['manufacturer'],
      rentalPrice: json['rentalPrice'], image: json['image'],
    
    );
  }
}

List<Car> carList = [
  Car(
      manufacturer: 'Perodua',
      vehicleName: 'Alza 1.5 (A)',
      rentalPrice: 245,
      image: 'assets/image/Alza.jpg'),
  Car(
      manufacturer: 'Perodua',
      vehicleName: 'Axia 2023 1.0 (A)',
      rentalPrice: 140,
      image: 'assets/image/Axia.png'),
  Car(
      manufacturer: 'Proton',
      vehicleName: 'Ertiga 1.4 (A)',
      rentalPrice: 300,
      image: 'assets/image/Ertiga.png'),
  Car(
      manufacturer: 'Proton',
      vehicleName: 'Perdana 2.0 (A)',
      rentalPrice: 460,
      image: 'assets/image/Perdana.jpg'),
  Car(
      manufacturer: 'Mazda',
      vehicleName: 'CX-5 2.0 (A)',
      rentalPrice: 599,
      image: 'assets/image/mazda1.jpg'),
  Car(
      manufacturer: 'Mazda',
      vehicleName: 'CX-6 2.5 (A)',
      rentalPrice: 640,
      image: 'assets/image/mazda2.jpg'),
  Car(
      manufacturer: 'Toyota',
      vehicleName: 'Alphard 2.4 (A)',
      rentalPrice: 729,
      image: 'assets/image/alphard1.png'),
  Car(
      manufacturer: 'Toyota',
      vehicleName: 'C-HR 1.8 (A)',
      rentalPrice: 599,
      image: 'assets/image/toyota1.png'),
  Car(
      manufacturer: 'Honda',
      vehicleName: 'Accord 2.0 (A)',
      rentalPrice: 550,
      image: 'assets/image/honda1.png'),
  Car(
      manufacturer: 'Honda',
      vehicleName: 'City Hatchback 1.5 (A)',
      rentalPrice: 300,
      image: 'assets/image/honda2.png'),
];
