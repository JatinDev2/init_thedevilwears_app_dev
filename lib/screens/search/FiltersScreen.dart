import 'package:flutter/material.dart';

class FiltersScreen extends StatefulWidget {
  @override
  _FiltersScreenState createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  String _selectedTab = 'Gender';

  List<String> _filterTabs = [
    'Gender',
    'Category',
    'Occasion',
    'Date',
    'Event',
    'Listing',
    'Color',
    'Size',
    'Brand',
    'Location',
    'Price',
    'Condition',
    'Rating',
  ];

  Map<String, List<String>> _filterData = {
    'Gender': [
      'Male',
      'Female',
      'Other',
      'Prefer not to say',
    ],
    'Category': [
      'Clothing',
      'Shoes',
      'Accessories',
      'Bags',
      'Jewelry',
      'Any',
    ],
    'Occasion': [
      'Casual',
      'Formal',
      'Party',
      'Sports',
      'Wedding',
    ],
    'Date': [
      'Last 24 hours',
      'Last 7 days',
      'Last 30 days',
      'Custom date range',
    ],
    'Event': [
      'Birthday',
      'Anniversary',
      'Graduation',
      'Holiday',
      'Prom',
      'Movie Promotions',
      'Movies',
      'Shoots',
      'Events',
      'Concerts',
      'Weddings',
      'Public Appearances',
    ],
    'Listing': [
      'For Sale',
      'For Rent',
      'Auction',
      'Free',
      'Collab',
    ],
    'Color': [
      'Red',
      'Blue',
      'Green',
      'Yellow',
      'Black',
      'White',
    ],
    'Size': [
      'XS',
      'S',
      'M',
      'L',
      'XL',
      'XXL',
    ],
    'Brand': [
      'Nike',
      'Adidas',
      'Puma',
      'Reebok',
      'Under Armour',
      'Vans',
    ],
    'Location': [
      'New York',
      'Los Angeles',
      'London',
      'Paris',
      'Tokyo',
      'Sydney',
    ],
    'Price': [
      '\$0 - \$10',
      '\$10 - \$50',
      '\$50 - \$100',
      '\$100 - \$200',
      'Above \$200',
    ],
    'Condition': [
      'New',
      'Used',
      'Refurbished',
    ],
    'Rating': [
      '1 Star',
      '2 Stars',
      '3 Stars',
      '4 Stars',
      '5 Stars',
    ],
  };

  void _clearAllFilters() {
    setState(() {
      _selectedOptions.clear();
    });
  }

  List<String> _selectedOptions = [];

  Widget _buildFilterTabs() {
    return Container(
      height: MediaQuery.of(context).size.height - 220,
      child: ListView.builder(
        itemCount: _filterTabs.length,
        itemBuilder: (context, index) {
          String tab = _filterTabs[index];
          int selectedOptionsCount = _getSelectedOptionsCount(tab);
          return Container(
            decoration: BoxDecoration(
              color:  _selectedTab == tab ? Colors.white : Color(0xFFEFEFEF),
              border: Border(
                bottom: BorderSide(
                  color: Color(0xFFDDDDDD),
                  width: 1.0,
                ),
              ),
            ),
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    tab,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  // SizedBox(width: 5),
                  if (selectedOptionsCount > 0)
                    Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        // color: Colors.orange,
                        // borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        selectedOptionsCount.toString(),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                ],
              ),
              onTap: () {
                setState(() {
                  _selectedTab = tab;
                });
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterOptions() {
    List<String> options = _filterData[_selectedTab] ?? [];
    return Container(
      height: MediaQuery.of(context).size.height - 220,
      child: ListView.builder(
        itemCount: options.length,
        itemBuilder: (context, index) {
          String option = options[index];
          bool isSelected = _selectedOptions.contains(option);
          return  ListTile(
            onTap: (){
              setState(() {
                if (isSelected) {
                  _selectedOptions.remove(option);
                } else {
                  _selectedOptions.add(option);
                }
              });
            },
            title: Row(
            children: [
              SizedBox(
                width: 8,
              ),
              Icon(
                isSelected ? Icons.check : null,
                color: Colors.black,
                size: 17,
              ),
              SizedBox(
                width: 16,
              ),
              Text(
                option,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight:isSelected ? FontWeight.bold: FontWeight.normal,
                  color: isSelected ? Colors.black : Colors.black87,
                ),
              ),
            ],
            ),
          );
      },
      ),
    );
  }

  Widget _buildSelectedOptions() {
    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _selectedOptions.length,
        itemBuilder: (context, index) {
          String option = _selectedOptions[index];

          return Container(
            margin: EdgeInsets.only(right: 4),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    option,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedOptions.remove(option);
                      });
                    },
                    child: Icon(
                      Icons.clear,
                      color: Colors.white,
                      size: 16,
                      weight: 16.0,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  int _getSelectedOptionsCount(String tab) {
    List<String> options = _filterData[tab] ?? [];
    int count = 0;

    for (String option in options) {
      if (_selectedOptions.contains(option)) {
        count++;
      }
    }

    return count;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Filters',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        // iconTheme: IconThemeData(color: Colors.black),
        actions: [
          Container(
            margin: EdgeInsets.only(
              right: 16.0,
            ),
            child: TextButton(
              child: Text(
                'Clear All',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
              onPressed: _clearAllFilters,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.black12,
                  width: 1.0,
                ),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  color: Colors.grey[200],
                  child: _buildFilterTabs(),
                ),
              ),
              Expanded(
                flex: 4,
                child: Container(
                  color: Colors.white,
                  child: _buildFilterOptions(),
                ),
              ),
            ],
          ),
          // SizedBox(height: 4,),
          _buildSelectedOptions(),
          // SizedBox(height: 4,),
          Divider(),
          GestureDetector(
            onTap: (){
              Navigator.of(context).pop();
            },
            child: Container(
              height: 50,
              child: Center(
                child: Text("Apply Filters", style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                ),),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

