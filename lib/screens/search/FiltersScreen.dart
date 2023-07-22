import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class FiltersScreen extends StatefulWidget {
  @override
  _FiltersScreenState createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  String _selectedTab = 'Gender';

  final List<String> _filterTabs = [
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

  final Map<String, List<String>> _filterData = {
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

  final List<String> _selectedOptions = [];

  Widget _buildFilterTabs() {
    return Container(
      height: _selectedOptions.isEmpty?MediaQuery.of(context).size.height - 150  : MediaQuery.of(context).size.height - 220,
      child: ListView.builder(
        itemCount: _filterTabs.length,
        itemBuilder: (context, index) {
          String tab = _filterTabs[index];
          int selectedOptionsCount = _getSelectedOptionsCount(tab);
          return Container(
            decoration: BoxDecoration(
              color:  _selectedTab == tab ? Colors.white : const Color(0xffEFEFEF),
              border: const Border(
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
                    style: const TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff4a4a4a),
                      height: 20/16,
                    ),
                  ),
                  // SizedBox(width: 5),
                  if (selectedOptionsCount > 0)
                    Container(
                      padding: const EdgeInsets.all(4),
                      child: Text(
                        selectedOptionsCount.toString(),
                        style: const TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff4a4a4a),
                          height: 28/14,
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
      height: _selectedOptions.isEmpty?MediaQuery.of(context).size.height - 150  : MediaQuery.of(context).size.height - 220,
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
              const SizedBox(
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
                  fontWeight:isSelected ? FontWeight.w600: FontWeight.w300,
                  color: const Color(0xff3c3c3c),
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
    if(_selectedOptions.isEmpty){
      return const SizedBox(
        height: 0,
      );
    }
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _selectedOptions.length,
        itemBuilder: (context, index) {
          String option = _selectedOptions[index];

          return Container(
            margin: const EdgeInsets.only(right: 4),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  option,
                  style:const TextStyle(
              fontFamily: "Poppins",
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
                ),
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedOptions.remove(option);
                    });
                  },
                  child: SvgPicture.asset(
                    'assets/cross.svg',
                    semanticsLabel: 'My SVG Image',
                  ),
                ),
              ],
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
        leading: IconButton(onPressed: (){
          Navigator.of(context).pop();
        }, icon: const Icon(Icons.arrow_back_rounded, color: Colors.black,)),
        title: const Text(
          "Filters",
          style: TextStyle(
            fontFamily: "Poppins",
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xff0f1015),
            height: 22/16,
          ),
          textAlign: TextAlign.left,
        ),
        backgroundColor: Colors.white,
        // iconTheme: IconThemeData(color: Colors.black),
        actions: [
          Container(
            margin: const EdgeInsets.only(
              right: 16.0,
            ),
            child: TextButton(
              onPressed: _clearAllFilters,
              child: const Text(
                "Clear All",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff4a4a4a),
                  height: 20/16,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color(0xffDDDDDD),
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
          if(_selectedOptions.isNotEmpty)
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xffDDDDDD),
                    width: 1.0,
                  ),
                ),
              ),
            ),
          GestureDetector(
            onTap: (){
              Navigator.of(context).pop();
            },
            child: Container(
              height: 50,
              margin: _selectedOptions.isNotEmpty? const EdgeInsets.all(10.0) : const EdgeInsets.all(5.0),
              child: const Center(
                child: Text(
                  "APPLY FILTERS",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff4a4a4a),
                    height: 20/16,
                  ),
                  textAlign: TextAlign.left,
                )
              ),
            ),
          ),
        ],
      ),
    );
  }
}

