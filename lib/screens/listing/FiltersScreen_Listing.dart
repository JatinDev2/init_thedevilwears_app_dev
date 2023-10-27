import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class FiltersScreen_Listing extends StatefulWidget {
  List<String> selectedOptionsSourcing;

  FiltersScreen_Listing({
   required this.selectedOptionsSourcing,
});

  @override
  _FiltersScreen_ListingState createState() => _FiltersScreen_ListingState();
}

class _FiltersScreen_ListingState extends State<FiltersScreen_Listing> {
  String _selectedTab = 'Gender';
  bool isLoading=true;

  void initState() {
    super.initState();
    _selectedOptions.addAll(widget.selectedOptionsSourcing);
    fetchFiltersData().then((value) {
      setState((){
        _filterData=value;
        isLoading=false;
      });
    });
  }

 final List<String> _filterTabs = [
    'Gender',
     'Availability',
    'Genre',
    'Category',
  ];

  Map _filterData = {};

  Future<Map> fetchFiltersData() async {
    final firestore = FirebaseFirestore.instance;

    try {
      final filtersCollectionRef = firestore.collection('listing_Filters');

      final querySnapshot = await filtersCollectionRef.get();

      if (querySnapshot.docs.isNotEmpty) {
        final filtersDocument = querySnapshot.docs.first;
        return filtersDocument.data();
      } else {
        print('No documents found in the "listing_Filters" collection.');
        return {};
      }
    } catch (error) {
      print('Error fetching filters data: $error');
      return {};
    }
  }

  void _clearAllFilters() {
    setState(() {
      _selectedOptions.clear();
    });
  }

  List<String> _selectedOptions = [];



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
    var options = _filterData[_selectedTab] ?? [];
    return Container(
      height: _selectedOptions.isEmpty ?MediaQuery.of(context).size.height - 150  : MediaQuery.of(context).size.height - 220,
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
    if(_selectedOptions.isEmpty){
      return SizedBox(
        height: 0,
      );
    }
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
              color: Theme.of(context).colorScheme.primary,
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
    var options = _filterData[tab] ?? [];
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
        }, icon: Icon(Icons.arrow_back_rounded, color: Colors.black,)),
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
      body: isLoading? const Center(
        child: CircularProgressIndicator(),
      ) : Column(
        children: [
          Container(
            decoration: const BoxDecoration(
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
          if(!_selectedOptions.isEmpty)
          Divider(),
          GestureDetector(
            onTap: (){
              Navigator.of(context).pop(
                _selectedOptions
              );
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

