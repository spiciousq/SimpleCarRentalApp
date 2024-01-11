import 'package:flutter/material.dart';

class CarFilter extends StatefulWidget {
  final Function(List<String>, List<String>, RangeValues) onApplyFilters;

  CarFilter({Key? key, required this.onApplyFilters});
  @override
  _CarFilterState createState() => _CarFilterState();
}

class _CarFilterState extends State<CarFilter> {
  Map<String, List<String>> manufacturerAndModels = {
    'Perodua': ['Alza', 'Aruz', 'Ativa', 'Axia', 'Bezza'],
    'Proton': ['Ertiga', 'Perdana', 'X50', 'X70', 'X90'],
    'Mazda': ['CX-5', 'CX-6', 'CX3'],
    'Toyota': ['Alphard', 'C-HR', 'Camry', 'Corolla Altis'],
    'Honda': ['Accord', 'City Hatchback', 'Civic'],
  };

  List<String> selectedManufacturer = [];
  List<String> selectedVehicleNames = [];
  RangeValues priceRange = RangeValues(0, 600);

  List<String> allVehicleNames = [
    'Alza',
    'Aruz',
    'Ativa',
    'Axia',
    'Bezza',
    'Ertiga',
    'Perdana',
    'X50',
    'X70',
    'X90',
    'CX-5',
    'CX-6',
    'CX3',
    'Alphard',
    'C-HR',
    'Camry',
    'Corolla Altis',
    'Accord',
    'City Hatchback',
    'Civic'
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(title: Text('Car Filter')),
      body: Column(
        children: [
          Expanded(
            child: Container(
              height: 50,
              width: double.infinity,
              color: Colors.white,
              child: Column(
                children: [
                  Text('Manufacturer'),
                  Container(
                    child: Wrap(
                      children: manufacturerAndModels.keys
                          .map((manufacturer) => FilterChip(
                                label: Text(manufacturer),
                                selected:
                                    selectedManufacturer.contains(manufacturer),
                                onSelected: (selected) {
                                  setState(() {
                                    if (selected) {
                                      selectedManufacturer.add(manufacturer);
                                    } else {
                                      selectedManufacturer.remove(manufacturer);
                                    }
                                  });
                                },
                              ))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              height: 50,
              width: double.infinity,
              color: Colors.white,
              child: Column(
                children: [
                  Text('Vehicle Name'),
                  Container(
                    child: Wrap(
                      children: allVehicleNames
                          .where((vehicleName) =>
                              selectedManufacturer.isEmpty ||
                              selectedManufacturer.any((manufacturer) =>
                                  manufacturerAndModels[manufacturer]!
                                      .contains(vehicleName)))
                          .map((vehicleName) => Padding(
                                padding: const EdgeInsets.all(2),
                                child: FilterChip(
                                  label: Text(vehicleName),
                                  selected: selectedVehicleNames
                                      .contains(vehicleName),
                                  onSelected: (selected) {
                                    setState(() {
                                      if (selected) {
                                        selectedVehicleNames.add(vehicleName);
                                      } else {
                                        selectedVehicleNames
                                            .remove(vehicleName);
                                      }
                                    });
                                  },
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 50,
              width: double.infinity,
              color: Colors.white,
              child: Column(
                children: [
                  Text('Rental Price Range'),
                  RangeSlider(
                    values: priceRange,
                    min: 0,
                    max: 600,
                    onChanged: (values) {
                      setState(() {
                        priceRange = values;
                      });
                    },
                    divisions: 6,
                    labels: RangeLabels('${priceRange.start.toInt()}',
                        '${priceRange.end.toInt()}'),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Call the callback function with the selected data
                  widget.onApplyFilters(
                    selectedManufacturer,
                    selectedVehicleNames,
                    priceRange,
                  );
                  Navigator.pop(context);
                },
                child: Text('Apply'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Call the callback function with the selected data
                  widget.onApplyFilters(
                    [],
                    [],
                    RangeValues(0, 600),
                  );
                  Navigator.pop(context);
                },
                child: Text('Reset'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
