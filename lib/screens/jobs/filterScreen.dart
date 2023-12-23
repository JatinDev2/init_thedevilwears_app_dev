import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import 'job_model.dart';

class FilterJobListings extends StatefulWidget {
  final List selectedOptions;
  const FilterJobListings({
    super.key,
    required this.selectedOptions,
  });

  @override
  _FilterJobListingsState createState() => _FilterJobListingsState();
}

class _FilterJobListingsState extends State<FilterJobListings> {
  String _selectedTab = 'Job Profile';
  bool isLoading = true;
  List catOptions = [];
  int count = 0;
  bool isQuery = false;
  TextEditingController searchController = TextEditingController();
  String jobDurValue = "Months";
  List filterSearchOptions=[];
  List locations=[];
  TextEditingController durationController = TextEditingController();
  DateTime testDate=DateTime.now();
  TextEditingController dateController = TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedOptions.addAll(widget.selectedOptions);
    fetchData().then((value) {
      fetchListingsFromFirestore();
      setState(() {
        isLoading = false;
      });
    });
  }

  final List<String> _filterTabs = [
    'Job Profile',
    'Job Type',
    'Duration',
    'Work Mode',
    'Location',
    'Stipend',
    'Start Date',
  ];

  void _clearAllFilters() {
    setState(() {
      _selectedOptions.clear();
      catOptions.clear();
      _selectedOptionMap = {
        "Job Profile": [],
        "Job Type": [],
        "Duration": [],
        "Work Mode": [],
        "Location": [],
        "Stipend": [],
        "Start Date": [],
      };
    });
  }

  Future<void> _selectDate(BuildContext context) async{

  }


  Map<String, dynamic> _selectedOptionMap = {
    "Job Profile": [],
    "Job Type": [],
    "Duration": [],
    "Work Mode": [],
    "Location": [],
    "Stipend": [],
    "Start Date": [],
  };



  Map<String, dynamic> filterData = {};

  Future<void> fetchData() async {
    try {

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('listing_jobs_Filters')
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
        filterData = documentSnapshot.data() as Map<String, dynamic>;
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

  Widget _buildFilterTabs() {
    return Container(
      height: _selectedOptions.isEmpty
          ? MediaQuery.of(context).size.height - 150.h
          : MediaQuery.of(context).size.height - 220.h,
      child: ListView.builder(
        itemCount: _filterTabs.length,
        itemBuilder: (context, index) {
          String tab = _filterTabs[index];
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

  Widget _buildFilterOptions() {
    var options = filterData[_selectedTab] ?? [];

    String getString() {
      if (_selectedTab == "Job Profile") {
        return "Search Job Profile";
      } else {
        return "Search location/pincode";
      }
    }

    if (_selectedTab == "Job Profile"){
      return SizedBox(
        height: _selectedOptions.isEmpty
            ? MediaQuery.of(context).size.height - 150.h
            : MediaQuery.of(context).size.height - 220.h,
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
                    hintText: getString(),
                    hintStyle: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 15.sp,
                      color: const Color(0xffaaaaaa),
                      height: (30 / 14).h,
                    ),
                    border: InputBorder.none),
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
                      filterSearchOptions.clear();
                    }

                  });
                },
              ),
            ),
            SizedBox(
              height: 11.h,
            ),
            filterSearchOptions.isEmpty && isQuery
                ? const Text("No reslts") :   SizedBox(
              height: _selectedOptions.isEmpty
                  ? MediaQuery.of(context).size.height - 232.h
                  : MediaQuery.of(context).size.height - 315.h,
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
                          option,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w300,
                            color: const Color(0xff3c3c3c),
                          ),
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

    if (_selectedTab == "Duration"){
      return SizedBox(
        height: _selectedOptions.isEmpty
            ? MediaQuery.of(context).size.height - 152.h
            : MediaQuery.of(context).size.height - 224.h,
        child: ListView.builder(
          itemCount: options.length,
          itemBuilder: (context, index) {
            String option = options[index];
            bool isSelected = _selectedOptions.contains(option);
            return Column(
              children: [
                ListTile(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        // _selectedOptions.remove(option);
                        // _selectedOptions.contains(option);
                        if (_selectedOptions.contains(option)){
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
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w300,
                          color: const Color(0xff3c3c3c),
                        ),
                      ),
                    ],
                  ),
                ),
                if (option == "Fixed" && isSelected)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 41.h,
                        width: 96.w,
                        decoration: BoxDecoration(
                            color: const Color(0xffF8F7F7),
                            borderRadius: BorderRadius.circular(8.0.r)),
                        child: TextField(
                          controller: durationController,
                          decoration: InputDecoration(
                              hintText: "Eg: 3",
                              hintStyle: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xff666666),
                                height: (21 / 14).h,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 27.w, vertical: 16.h)
                                  ),
                          keyboardType: TextInputType.number,
                          onChanged: (value){
                            bool isChanged=false;
                            if(value.isNotEmpty){
                              setState(() {
                                if(_selectedOptions.contains(option)){
                                  for(int i=0; i<_selectedOptions.length; i++){
                                    if(_selectedOptions[i].contains(jobDurValue)){
                                      _selectedOptions[i]="${durationController.text} $jobDurValue";
                                      isChanged=true;
                                    }
                                  }
                                  if(!isChanged){
                                    _selectedOptions.add("${durationController.text} $jobDurValue");
                                  }
                                }
                              });
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        width: 9.w,
                      ),
                      Container(
                        height: 41.h,
                        width: 112.w,
                        padding: EdgeInsets.symmetric(horizontal: 14.0.w),
                        decoration: BoxDecoration(
                            color: const Color(0xffF8F7F7),
                            borderRadius: BorderRadius.circular(8.0.r)),
                        child: DropdownButton<String>(
                          value: jobDurValue,
                          onChanged: (String? newValue) {
                            setState(() {
                              jobDurValue = newValue!;
                            });
                          },
                          icon: const Icon(IconlyLight.arrowDown2),
                          underline: Container(),
                          items: <String>['Days', 'Months', 'Years']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xff666666),
                                  height: (21 / 14).h,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
              ],
            );
          },
        ),
      );
    }

    if (_selectedTab == "Location") {
      options = locations;
      return SizedBox(
        height: _selectedOptions.isEmpty
            ? MediaQuery.of(context).size.height - 152.h
            : MediaQuery.of(context).size.height - 224.h,
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
                    hintText: getString(),
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
                      filterSearchOptions.clear();
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
                  ? MediaQuery.of(context).size.height - 232.h
                  : MediaQuery.of(context).size.height - 315.h,
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


    if(_selectedTab=="Start Date"){
      return SizedBox(
        height: _selectedOptions.isEmpty
            ? MediaQuery.of(context).size.height - 152.h
            : MediaQuery.of(context).size.height - 224.h,
        child: ListView.builder(
          itemCount: options.length,
          itemBuilder: (context, index) {
            String option = options[index];
            bool isSelected = _selectedOptions.contains(option);
            if(option=="DD/MM/YYYY"){
              return ListTile(
                onTap: ()async{
                  DateTime? picked;

                     picked = await showDatePicker(
                      context: context,
                      initialDate: testDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                  setState(() {
                    // if (isSelected) {

                      if (picked != null && picked != dateController.text) {
                        testDate=picked;
                        dateController.text = DateFormat('dd/MM/yyyy').format(picked);
                      }
                      filterData[_selectedTab][index]=dateController.text;
                      // option=dateController.text;
                    // }
                      // _selectedOptions.remove(option);
                      // _selectedOptions.contains(option);
                    //   if (_selectedOptions.contains(option)) {
                    //     _selectedOptions.remove(option);
                    //   }
                    // } else {
                    //   _selectedOptions.add(option);
                    // }
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
            }
            else{
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
            }


          },
        ),
      );
    }

else{
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

  }

  Widget _buildSelectedOptions() {
    _selectedOptionMap.forEach((key, value) {
      if (value is Map) {
        value.forEach((key, items) {
          if ((items is List) && (items.isNotEmpty)) {
            for (int i = 0; i < items.length; i++) {
              if (catOptions.contains(items[i])) {
                continue;
              } else {
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

    for (int i = 0; i < catOptions.length; i++) {
      if (_selectedOptions.contains(catOptions[i])) {
        continue;
      } else {
        _selectedOptions.add(catOptions[i]);
      }
    }
    print("Printing selecteddddd Optionsssssssssssssssssssssssss");
    print(_selectedOptions);
    return Container(
      height: 60.h,
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _selectedOptions.length,
        itemBuilder: (context, index) {
          String option = _selectedOptions[index];
          if(option=="Fixed"){
            return Container();
          } else{
            return Container(
              margin: EdgeInsets.only(right: 4.w),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    option,
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.clip,
                  ),
                  SizedBox(width: 6.w),
                  GestureDetector(
                    onTap: () {
                      print("TAAAAAAAAAAPPPPPPPPPPPPPEEEEEEEEEEEDDDDDDDDDDDDDDD");
                      setState(() {
                        _selectedOptionMap.forEach((key, value) {
                          if (value is Map) {
                            value.forEach((key, items) {
                              if ((items is List) && (items.contains(option))) {
                                items.remove(option);
                              }
                            });
                          }
                        });
                        _selectedOptions.remove(option);
                        if (catOptions.contains(option)) {
                          catOptions.remove(option);
                        }
                        print(
                            "Editttttttttttttttttt Printing selecteddddd Optionsssssssssssssssssssssssss");
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
          }

        },
      ),
    );
  }

  int _getSelectedOptionsCount(String tab) {
    var options = filterData[tab] ?? [];
    count = 0;
    for (var option in options) {
      if (_selectedOptions.contains(option)) {
        count++;
      }
    }
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
        title: Text(
          "Filters",
          style: TextStyle(
            fontFamily: "Poppins",
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xff0f1015),
            height: (22 / 16).h,
          ),
          textAlign: TextAlign.left,
        ),
        backgroundColor: Colors.white,
        // iconTheme: IconThemeData(color: Colors.black),
        actions: [
          Container(
            margin: EdgeInsets.only(
              right: 16.0.w,
            ),
            child: TextButton(
              onPressed: _clearAllFilters,
              child: Text(
                "Clear All",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff4a4a4a),
                  height: (20 / 16).h,
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
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: const Color(0xffDDDDDD),
                        width: 1.0.w,
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
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: const Color(0xffDDDDDD),
                          width: 1.0.w,
                        ),
                      ),
                    ),
                  ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(_selectedOptions);
                  },
                  child: Container(
                    height: 50.h,
                    margin: _selectedOptions.isNotEmpty
                        ? EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w)
                        : EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
                    child: Center(
                        child: Text(
                      "APPLY FILTERS",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff4a4a4a),
                        height: (20 / 16).h,
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
