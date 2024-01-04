import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class FiltersTabJobScreen extends StatefulWidget {
  final String tabString;
  final List selectedFilterOption;
  final Map<String,dynamic> selectedOptionMap;

  FiltersTabJobScreen({
    required this.tabString,
    required this.selectedFilterOption,
    required this.selectedOptionMap,
});

  @override
  _FiltersTabJobScreenState createState() => _FiltersTabJobScreenState();
}

class _FiltersTabJobScreenState extends State<FiltersTabJobScreen> {
  String _selectedTab = 'Type';
  bool isLoading = true;
  List catOptions=[];
  int count = 0;
  bool isQuery = false;
  TextEditingController searchController = TextEditingController();
  List locations=[];
  List filterSearchOptions=[];
  String _selectedOption="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedOptions.addAll(widget.selectedFilterOption);
    _selectedOptionMap.addAll(widget.selectedOptionMap);
    fetchData().then((value) {
      fetchListingsFromFirestore();
      setState(() {
        isLoading = false;
        _selectedOption=widget.tabString;
      });
    });
  }

  final List<String> _filterTabs = [
    'Type',
    'Category',
    'Opening',
    'Location',
  ];

  final List<String> _filterTabsPeople=[
    'Type',
    'Profile',
    'Status',
    'Location',
  ];

  void _clearAllFilters() {
    setState(() {
      _selectedOptions.clear();
      catOptions.clear();
      _selectedOptionMap = {
        "Type":[],
        "Category":{
          "Brands":[],
          "Export houses":[],
          "Stylists":[],
          "Social Media agency":[],
          "PR agency":[],
          "AD agency":[],
        },
        "Opening":[],
        "Location":[],
        "Profile":[],
        "Status":[],
      };
    });
  }

  Map<String, dynamic> _selectedOptionMap = {
    "Type":[],
    "Category":{
      "Brands":[],
      "Export houses":[],
      "Stylists":[],
      "Social Media agency":[],
      "PR agency":[],
      "AD agency":[],
    },
    "Opening":[],
    "Location":[],
  };

  Map<String, dynamic> filterData = {};

  Future<void> fetchData() async {
    try {
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('jobsFilters').get();
      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
        filterData = documentSnapshot.data() as Map<String, dynamic>;
        print(filterData);
      } else {
        print('No documents found in the "Filters" collection');
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  Future<void> fetchListingsFromFirestore() async {
    try {
      print("Hello from function");
      CollectionReference collection = FirebaseFirestore.instance.collection('jobListing');
      QuerySnapshot querySnapshot = await collection.get();
      for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
        print(data["officeLoc"]);
        if (!locations.contains(data["officeLoc"])) {
          locations.add(data["officeLoc"]);
        }
      }
    } catch (e) {
      // Handle any errors or exceptions here
      print('Error fetching data: $e');
      rethrow; // You can choose to throw the error to handle it elsewhere
    }
  }

  final List _selectedOptions = [];
  Map filteredItems = {};

  Widget _buildFilterTabs(){
    return Container(
      height: _selectedOptions.isEmpty
          ? MediaQuery.of(context).size.height - 150.h
          : MediaQuery.of(context).size.height - 220.h,
      child: ListView.builder(
        itemCount: _selectedOption=="Companies"? _filterTabs.length : _filterTabsPeople.length,
        itemBuilder: (context, index) {
          String tab = _selectedOption=="Companies"? _filterTabs[index] : _filterTabsPeople[index];
          // int selectedOptionsCount = _getSelectedOptionsCount(tab);
          int selectedOptionsCount = _getSelectedOptionsCount(tab);
          return Container(
            decoration: BoxDecoration(
              color:
              _selectedTab == tab ? Colors.white : const Color(0xffEFEFEF),
              border: Border(
                bottom: BorderSide(
                  color: Color(0xFFDDDDDD),
                  width: 1.0.w,
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
                      fontFamily: "Poppins",
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xff4a4a4a),
                      height: (20 / 16).h,
                    ),
                  ),
                  // SizedBox(width: 5),
                  if (selectedOptionsCount > 0)
                    Container(
                      padding: const EdgeInsets.all(4),
                      child: Text(
                        selectedOptionsCount.toString(),
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xff4a4a4a),
                          height: (28 / 14).h,
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

  String truncateWithEllipsis(String text, int maxLength) {
    return (text.length <= maxLength) ? text : '${text.substring(0, maxLength)}...';
  }

  Widget _buildFilterOptions(){
    var options;
    if(_selectedTab == "Location"){
      options=locations ??[];
    }
    else{
      options= filterData[_selectedTab] ?? [];
    }
    if (_selectedTab == "Opening" || _selectedTab == "Status"){
      return SizedBox(
        height: _selectedOptions.isEmpty
            ? MediaQuery.of(context).size.height - 152.h
            : MediaQuery.of(context).size.height - 224.h,
        child: ListView.builder(
          itemCount: options.length,
          itemBuilder: (context, index) {
            String option = options[index];
            bool isSelected = _selectedOptions.contains(option);
            return ListTile(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    // _selectedOptions.remove(option);
                    // _selectedOptions.contains(option);
                    if (_selectedOptions.contains(option)) {
                      _selectedOptions.remove(option);
                    }
                  } else {
                    _selectedOptions.add(option);
                  }
                });
              },
              title: Row(
                children: [
                  SizedBox(
                    width: 8.w,
                  ),
                  Icon(
                    isSelected ? Icons.check : null,
                    color: Colors.black,
                    size: 17.h,
                  ),
                  SizedBox(
                    width: 16.w,
                  ),
                  Text(
                    option,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w300,
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
    else if(_selectedTab == "Type"){
      return SizedBox(
        height: _selectedOptions.isEmpty
            ? MediaQuery.of(context).size.height - 152.h
            : MediaQuery.of(context).size.height - 224.h,
        child: ListView.builder(
          itemCount: options.length,
          itemBuilder: (context, index) {
            String option = options[index];
            bool isSelected = _selectedOption == option; // Use a single variable for the selected option
            return ListTile(
              onTap: () {
                setState(() {
                  _selectedOption = option;
                  _selectedOptions.clear();
                  catOptions.clear();
                  _selectedOptionMap = {
                    "Type":[],
                    "Category":{
                      "Brands":[],
                      "Export houses":[],
                      "Stylists":[],
                      "Social Media agency":[],
                      "PR agency":[],
                      "AD agency":[],
                    },
                    "Opening":[],
                    "Location":[],
                    "Profile":[],
                    "Status":[],
                  };
                });
              },
              title: Row(
                children: [
                  SizedBox(
                    width: 8.w,
                  ),
                  // Configure Radio button
                  Radio(
                    value: option,
                    groupValue: _selectedOption, // Use the single selected option variable
                    onChanged: (String? value){
                      setState(() {
                        _selectedOption = value!; // Update the selected option
                        _selectedOptions.clear();
                        catOptions.clear();
                        _selectedOptionMap = {
                          "Type":[],
                          "Category":{
                            "Brands":[],
                            "Export houses":[],
                            "Stylists":[],
                            "Social Media agency":[],
                            "PR agency":[],
                            "AD agency":[],
                          },
                          "Opening":[],
                          "Location":[],
                          "Profile":[],
                          "Status":[],
                        };
                      });
                    },
                    activeColor: Colors.black, // Set the color of the smaller circle
                  ),
                  SizedBox(
                    width: 16.w,
                  ),
                  Text(
                    option,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w300,
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

    if (_selectedTab == "Location"){
      options = locations;
      return SizedBox(
        height: _selectedOptions.isEmpty
            ? MediaQuery.of(context).size.height - 120
            : MediaQuery.of(context).size.height - 190,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(
                left: 18.0.w,
                right: 10.0.w,
                top: 10.0.h,
                bottom: 5.0.h,
              ),
              height: 50.h,
              child: TextField(
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      IconlyLight.search,
                      size: 16.sp,
                      color: const Color(0xFF4B4B4B),
                    ),
                    hintText: "Search Location",
                    hintStyle: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 15.sp,
                      color: const Color(0xffaaaaaa),
                      height: (30 / 14).h,
                    ),
                    border: InputBorder.none
                ),
                controller: searchController,
                onChanged: (searchIn) {
                  setState((){
                    if (searchIn.isNotEmpty) {
                      isQuery = true;
                      filterSearchOptions = options
                          .where((option) =>
                      option.toLowerCase().contains(searchIn.toLowerCase()) as bool)
                          .toList();

                    } else {
                      isQuery = false;
                      // filterSearchOptions.clear();
                    }

                  });
                },
              ),
            ),
            SizedBox(
              height: 11.h,
            ),
            filterSearchOptions.isEmpty && isQuery
                ? const Text("No results") :   SizedBox(
              height: _selectedOptions.isEmpty
                  ? MediaQuery.of(context).size.height - 215
                  : MediaQuery.of(context).size.height - 300,
              child: ListView.builder(
                itemCount: filterSearchOptions.isNotEmpty? filterSearchOptions.length: locations.length,
                itemBuilder: (context, index) {
                  String option = filterSearchOptions.isNotEmpty?filterSearchOptions[index] : locations[index];
                  bool isSelected = _selectedOptions.contains(option);
                  return ListTile(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          // _selectedOptions.remove(option);
                          // _selectedOptions.contains(option);
                          if (_selectedOptions.contains(option)) {
                            _selectedOptions.remove(option);
                          }
                        } else {
                          _selectedOptions.add(option);
                        }
                      });
                    },
                    title: Row(
                      children: [
                        SizedBox(
                          width: 8.w,
                        ),
                        Icon(
                          isSelected ? Icons.check : null,
                          color: Colors.black,
                          size: 17.h,
                        ),
                        SizedBox(
                          width: 16.w,
                        ),
                        Text(
                          truncateWithEllipsis(option, 20),
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w300,
                            color: const Color(0xff3c3c3c),
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    }

    if (_selectedTab == "Profile"){
      return SizedBox(
        height: _selectedOptions.isEmpty
            ? MediaQuery.of(context).size.height - 120
            : MediaQuery.of(context).size.height - 190,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(
                left: 18.0.w,
                right: 10.0.w,
                top: 10.0.h,
                bottom: 5.0.h,
              ),
              height: 50.h,
              child: TextField(
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      IconlyLight.search,
                      size: 16.sp,
                      color: const Color(0xFF4B4B4B),
                    ),
                    hintText: "Search Location",
                    hintStyle: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 15.sp,
                      color: const Color(0xffaaaaaa),
                      height: (30 / 14).h,
                    ),
                    border: InputBorder.none
                ),
                controller: searchController,
                onChanged: (searchIn) {
                  setState((){
                    if (searchIn.isNotEmpty) {
                      isQuery = true;
                      filterSearchOptions = options
                          .where((option) =>
                      option.toLowerCase().contains(searchIn.toLowerCase()) as bool)
                          .toList();
                    } else {
                      isQuery = false;
                      // filterSearchOptions.clear();
                    }

                  });
                },
              ),
            ),
            SizedBox(
              height: 11.h,
            ),
            filterSearchOptions.isEmpty && isQuery
                ? const Text("No results") :   SizedBox(
              height: _selectedOptions.isEmpty
                  ? MediaQuery.of(context).size.height - 215
                  : MediaQuery.of(context).size.height - 300,
              child: ListView.builder(
                itemCount: filterSearchOptions.isNotEmpty? filterSearchOptions.length: options.length,
                itemBuilder: (context, index) {
                  String option = filterSearchOptions.isNotEmpty?filterSearchOptions[index] : options[index];
                  bool isSelected = _selectedOptions.contains(option);
                  return ListTile(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          // _selectedOptions.remove(option);
                          // _selectedOptions.contains(option);
                          if (_selectedOptions.contains(option)) {
                            _selectedOptions.remove(option);
                          }
                        } else {
                          _selectedOptions.add(option);
                        }
                      });
                    },
                    title: Row(
                      children: [
                        SizedBox(
                          width: 8.w,
                        ),
                        Icon(
                          isSelected ? Icons.check : null,
                          color: Colors.black,
                          size: 17.h,
                        ),
                        SizedBox(
                          width: 16.w,
                        ),
                        Text(
                          truncateWithEllipsis(option, 20),
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w300,
                            color: const Color(0xff3c3c3c),
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    }


    else if (_selectedTab == "Category"){
      var data=filterData[_selectedTab];

      void _updateFilteredData(String searchText) {
        setState(() {
          filteredItems.clear();
          data.forEach((category, items) {
            if (category.toLowerCase().contains(searchText.toLowerCase())) {
              filteredItems[category] = items;
            }
            if (items.isNotEmpty) {
              List filteredItemsList = items
                  .where((item) => item
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) as bool)
                  .toList();
              if (filteredItemsList.isNotEmpty) {
                filteredItems[category] = filteredItemsList;
              }
            }
          });
        });
      }

      return ListView(
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(
              left: 10.0,
              right: 10.0,
              top: 10.0,
              bottom: 5.0,
            ),
            height: 50,
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(
                  IconlyLight.search,
                  size: 18,
                  color: Color(0xFF4B4B4B),
                ),
                hintText: "Search Category",
                hintStyle: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 14,
                  color: Color(0xffaaaaaa),
                ),
                  border: InputBorder.none,
              ),
              controller: searchController,
              onChanged: (searchIn){
                setState((){
                  if (searchIn.isNotEmpty) {
                    isQuery = true;
                  } else {
                    isQuery = false;
                  }
                  _updateFilteredData(searchIn);
                });
              },
            ),
          ),
          Container(
            height: catOptions.isEmpty || _selectedOptions.isEmpty
                ? MediaQuery.of(context).size.height - 250
                : MediaQuery.of(context).size.height - 315,
            child: filteredItems.isEmpty && isQuery
                ? const Center(child: Text("No results"))
                : ListView(
              children: filteredItems.isNotEmpty && isQuery
                  ? filteredItems.entries.map<Widget>((entry){
                String category = entry.key;
                // print(category);
                List<String> items = List<String>.from(entry.value);
                // print(items);
                if (category != "data" && items.isNotEmpty) {
                  return ExpansionTile(
                    title: Row(
                      children: [
                        const SizedBox(
                          width: 8,
                        ),
                        Icon(
                          items.any((item) =>
                              _selectedOptionMap[_selectedTab][category].contains(item))
                              ? Icons.check
                              : null,
                          size: 17,
                        ),
                        const SizedBox(
                          width: 13,
                        ),
                        Expanded(
                          child: Text(
                            category,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight:   items.any((item) =>
                                  _selectedOptionMap[_selectedTab][category].contains(item))
                                  ? FontWeight.w600
                                  : FontWeight.w300,
                              color: Color(0xff3c3c3c),
                            ),
                            softWrap: true,
                            maxLines: null,
                          ),
                        ),
                      ],
                    ),
                    trailing: const Icon(
                      Icons.chevron_right_rounded,
                      color: Colors.black,
                    ),
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: items.length,
                        itemBuilder: (context, index){
                          String option = items[index];
                          bool isSelected =
                          items.any((item) =>
                              _selectedOptionMap[_selectedTab][category].contains(option));
                          return ListTile(
                            onTap: () {
                              setState(() {
                                if (isSelected){
                                  _selectedOptionMap[_selectedTab][category].remove(option);
                                  if(catOptions.contains(option)){
                                    catOptions.remove(option);
                                  }
                                  if(_selectedOptions.contains(option)){
                                    _selectedOptions.remove(option);
                                  }
                                  // _selectedOptions.remove(option);
                                }
                                else {
                                  _selectedOptionMap[_selectedTab][category].add(option);
                                  if(!_selectedOptions.contains(option)){
                                    _selectedOptions.add(option);
                                  }
                                  // _selectedOptions.add(option);
                                }
                              });
                            },
                            title: Row(
                              children: [
                                const SizedBox(
                                  width: 15,
                                ),
                                Icon(
                                  isSelected ? Icons.check : null,
                                  color: Colors.black,
                                  size: 17,
                                ),
                                SizedBox(
                                  width: 16,
                                ),
                                Expanded(
                                  child: Text(
                                    option,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.w300,
                                      color:
                                      const Color(0xff3c3c3c),
                                    ),
                                    maxLines: null,
                                    softWrap: true,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  );
                } else {
                  return ListTile(
                    onTap: () {
                      setState(() {
                        if (_selectedOptionMap[_selectedTab][category].contains(category)){
                          _selectedOptionMap[_selectedTab][category].remove(category);
                          if(catOptions.contains(category)){
                            catOptions.remove(category);
                          }
                          if(_selectedOptions.contains(category)){
                            _selectedOptions.remove(category);
                          }
                          // _selectedOptions.remove(option);
                        }
                        else {
                          _selectedOptionMap[_selectedTab][category].add(category);
                          if(!_selectedOptions.contains(category)){
                            _selectedOptions.add(category);
                          }
                        }
                      });
                    },
                    title: Row(
                      children: [
                        const SizedBox(
                          width: 8,
                        ),
                        Icon(
                          _selectedOptionMap[_selectedTab][category].contains(category)
                              ? Icons.check
                              : null,
                          color: Colors.black,
                          size: 17,
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: Text(
                            category,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight:  _selectedOptionMap[_selectedTab][category].contains(category)
                                  ? FontWeight.w600
                                  : FontWeight.w300,
                              color: const Color(0xff3c3c3c),
                            ),
                            maxLines: null,
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                  );
                }
              }).toList()
                  : data.entries.map<Widget>((entry) {
                String category = entry.key;
                // print(category);
                List<String> items = List<String>.from(entry.value);
                // print(items);
                if (category != "data" && items.isNotEmpty) {
                  return ExpansionTile(
                    title: Row(
                      children: [
                        const SizedBox(
                          width: 8,
                        ),
                        Icon(
                          items.any((item) =>
                              _selectedOptionMap[_selectedTab][category].contains(item))
                              ?
                          Icons.check
                              : null,
                          size: 17,
                        ),
                        const SizedBox(
                          width: 13,
                        ),
                        Expanded(
                          child: Text(
                            category,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: items.any((item) =>
                                  _selectedOptionMap[_selectedTab][category].contains(item))
                                  ? FontWeight.w600
                                  : FontWeight.w300,
                              color: Color(0xff3c3c3c),
                            ),
                            softWrap: true,
                            maxLines: null,
                          ),
                        ),
                      ],
                    ),
                    trailing: Icon(
                      Icons.chevron_right_rounded,
                      color: Colors.black,
                    ),
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          String option = items[index];
                          bool isSelected =
                          items.any((item) =>
                              _selectedOptionMap[_selectedTab][category].contains(option));
                          return ListTile(
                            onTap: () {
                              setState(() {
                                if (isSelected){
                                  _selectedOptionMap[_selectedTab][category].remove(option);
                                  if(catOptions.contains(option)){
                                    catOptions.remove(option);
                                  }
                                  if(_selectedOptions.contains(option)){
                                    _selectedOptions.remove(option);
                                  }
                                  // _selectedOptions.remove(option);
                                }
                                else {
                                  _selectedOptionMap[_selectedTab][category].add(option);
                                  // if(!_selectedOptions.contains(category)){
                                  //   _selectedOptions.add(category);
                                  // }
                                  if(!_selectedOptions.contains(option)){
                                    _selectedOptions.add(option);
                                  }
                                }
                              });
                            },
                            title: Row(
                              children: [
                                const SizedBox(
                                  width: 15,
                                ),
                                Icon(
                                  isSelected ? Icons.check : null,
                                  color: Colors.black,
                                  size: 17,
                                ),
                                SizedBox(
                                  width: 16,
                                ),
                                Expanded(
                                  child: Text(
                                    option,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.w300,
                                      color:
                                      const Color(0xff3c3c3c),
                                    ),
                                    maxLines: null,
                                    softWrap: true,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  );
                } else {
                  return ListTile(
                    onTap: () {
                      setState((){
                        if (_selectedOptionMap[_selectedTab][category].contains(category)){
                          _selectedOptionMap[_selectedTab][category].remove(category);
                          if(catOptions.contains(category)){
                            catOptions.remove(category);
                          }
                          if(_selectedOptions.contains(category)){
                            _selectedOptions.remove(category);
                          }
                          // _selectedOptions.remove(option);
                        }
                        else {
                          _selectedOptionMap[_selectedTab][category].add(category);
                          if(!_selectedOptions.contains(category)){
                            _selectedOptions.add(category);
                          }
                        }
                      });
                    },
                    title: Row(
                      children: [
                        const SizedBox(
                          width: 8,
                        ),
                        Icon(
                          _selectedOptionMap[_selectedTab][category].contains(category)
                              ? Icons.check
                              : null,
                          color: Colors.black,
                          size: 17,
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: Text(
                            category,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight:_selectedOptionMap[_selectedTab][category].contains(category)
                                  ? FontWeight.w600
                                  : FontWeight.w300,
                              color: const Color(0xff3c3c3c),
                            ),
                            maxLines: null,
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                  );
                }
              }).toList(),
            ),
          ),
        ],
      );
    }

    return Container();
  }

  Widget _buildSelectedOptions(){
    _selectedOptionMap.forEach((key,value){
      if(value is Map){
        value.forEach((key,items){
          if( (items is List) && (items.isNotEmpty)){
            for(int i=0; i<items.length;i++){
              if(catOptions.contains(items[i])){
                continue;
              }
              else{
                catOptions.add(items[i]);
              }
            }
          }
        });
      }
    });
    print("PRINTINGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG");
    print(catOptions);
    if (_selectedOptions.isEmpty) {
      return const SizedBox(
        height: 0,
      );
    }

    for(int i=0; i<catOptions.length ; i++){
      if(_selectedOptions.contains(catOptions[i])){
        continue;
      }
      else{
        _selectedOptions.add(catOptions[i]);
      }
    }
    print("Printing selecteddddd Optionsssssssssssssssssssssssss");
    print(_selectedOptions);
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _selectedOptions.length,
        itemBuilder: (context, index){
          String option = _selectedOptions[index];
          return Container(
            margin: const EdgeInsets.only(right: 4),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  option,
                  style: const TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: (){
                    print("TAAAAAAAAAAPPPPPPPPPPPPPEEEEEEEEEEEDDDDDDDDDDDDDDD");
                    setState((){
                      _selectedOptionMap.forEach((key,value){
                        if(value is Map){
                          value.forEach((key,items){
                            if((items is List) && (items.contains(option))){
                              items.remove(option);
                            }
                          });
                        }
                      });
                      _selectedOptions.remove(option);
                      if(catOptions.contains(option)){
                        catOptions.remove(option);
                      }
                      print("Editttttttttttttttttt Printing selecteddddd Optionsssssssssssssssssssssssss");
                      print(_selectedOptions);
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

  int _getSelectedOptionsCount(String tab){
    var options = filterData[tab] ?? [];
    if(tab=="Location"){
      options=locations;
    }
    if (tab != "Category") {
      count = 0;
    }

    if (tab == "Opening" || tab == "Location" || tab=="Profile" || tab=="Status"){
      count = 0;
      for (var option in options) {
        if (_selectedOptions.contains(option)) {
          count++;
        }
      }
    }

    // else if (tab == "Colour") {
    //   options.forEach((key, value) {
    //     if (_selectedOptions.contains(key)) {
    //       count++;
    //     }
    //   });
    // }
    //
    else if (tab == "Category"){
      _selectedOptionMap[tab].forEach((key,items){
        if((items is List) && (items.isNotEmpty)){
          for(int i=0; i<items.length; i++){
            count++;
          }
        }
      });
    }
    // else if (tab == "Crafts") {
    //   options.forEach((key, items) {
    //     for (int i = 0; i < items.length; i++) {
    //       if (_selectedOptions.contains(items[i])) {
    //         count++;
    //       }
    //     }
    //   });
    // }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    // fetchData();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.black,
            )),
        title: const Text(
          "Filters",
          style: TextStyle(
            fontFamily: "Poppins",
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xff0f1015),
            height: 22 / 16,
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
                  height: 20 / 16,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
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
          Expanded(
            child: Row(
              children: [
                Flexible(
                  flex: 2,
                  child: Container(
                    child: _buildFilterTabs(),
                  ),
                ),
                Flexible(
                  flex: 4,
                  child: Container(
                    color: Colors.white,
                    child: _buildFilterOptions(),
                  ),
                ),
              ],
            ),
          ),
          // SizedBox(height: 4,),
          _buildSelectedOptions(),
          // SizedBox(height: 4,),
          if (_selectedOptions.isNotEmpty)
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
            onTap: () {
              var result = {
                'tab': _selectedOption,
                'selectedOptionListFromFilterScreen': _selectedOptions,
                'selectedOptionMapFromFilterScreen': _selectedOptionMap,
              };
              Navigator.of(context).pop(result);
            },
            child: Container(
              height: 50,
              margin: _selectedOptions.isNotEmpty
                  ? const EdgeInsets.all(10.0)
                  : const EdgeInsets.all(5.0),
              child: const Center(
                  child: Text(
                    "APPLY FILTERS",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff4a4a4a),
                      height: 20 / 16,
                    ),
                    textAlign: TextAlign.left,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}