import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker_dart/faker_dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'AlphaBetScrollJob.dart';
import 'AlphaBetScrollPeople.dart';

class JobOpening {
  String imageUrl;
  String brandName;
  String category;
  String subCategory;
  int numberOfJobOpenings;
  String location;

  JobOpening({
    required this.imageUrl,
    required this.brandName,
    required this.category,
    required this.subCategory,
    required this.numberOfJobOpenings,
    required this.location,
  });

  Map<String, dynamic> toJson() => {
        'imageUrl': imageUrl,
        'brandName': brandName,
        'category': category,
        'subCategory': subCategory,
        'numberOfJobOpenings': numberOfJobOpenings,
        'location': location,
      };

  factory JobOpening.fromFirestore(Map<String, dynamic> firestoreDoc) {
    return JobOpening(
      imageUrl: firestoreDoc['imageUrl'],
      brandName: firestoreDoc['brandName'],
      category: firestoreDoc['category'],
      subCategory: firestoreDoc['subCategory'],
      numberOfJobOpenings: firestoreDoc['numberOfJobOpenings'],
      location: firestoreDoc['location'],
    );
  }
}

class PeopleClass{
  String name;
  String role;
  String companiesWorkedIn;
  String imgUrl;

  PeopleClass({
required this.companiesWorkedIn,
    required this.imgUrl,
    required this.name,
    required this.role,
  });

  Map<String, dynamic> toJson() => {
  "name": name,
  "role": role,
  "companiesWorkedIn": companiesWorkedIn,
  "imgUrl": imgUrl,
  };

  factory PeopleClass.fromFirestore(Map<String, dynamic> firestoreDoc) {
    return PeopleClass(
    name: firestoreDoc['name'],
companiesWorkedIn: firestoreDoc['companiesWorkedIn'],
role: firestoreDoc['role'],
imgUrl: firestoreDoc['imgUrl'],
    );
  }
}

class JobAndPeopleData {
  final List<JobOpening> jobOpenings;
  final List<PeopleClass> people;

  JobAndPeopleData({required this.jobOpenings, required this.people});
}


class JobSearchScreen extends StatefulWidget {
  double height;

  JobSearchScreen({
    required this.height,
  });

  @override
  State<JobSearchScreen> createState() => _JobSearchScreenState();
}

class _JobSearchScreenState extends State<JobSearchScreen> with TickerProviderStateMixin{
  String query_check = "";

  late Future<JobAndPeopleData?> _data;
  List<JobOpening> filteredJobOpenings=[];
  List<JobOpening> realData=[];
  List<PeopleClass> realPeopleData=[];
  List<PeopleClass> filteredPeopleList=[];
  int _selectedTab = 0;
  final faker = Faker.instance;


  List<String> filterList=["All", "Brand", "Stylist"];
  List<String> roles=[
    'All',
    'Fashion Stylist',
    'Fashion Designer',
    'Communication Designer',
    'Social media intern',
    'Social media Manager',
    'Production Associate',
    'Fashion Consultant',
    'Video Editor',
    'Graphic Designers',
    'Textile Designer',
    'Shoot Manager',
    'Shoot Assistant',
    'Set designer',
    'Set design assistant',
    'Videographer',
    'Photographer',
  ];
  int _selectedChipIndex = 0;
  int _selectedIndexPeople=0;
  late TabController _tabController;



  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _data=fetchJobOpeningsAndPeopleData();
    _tabController.addListener(() {
      if (_tabController.index != _selectedTab) {
        setState(() {
          _selectedTab = _tabController.index;
        });
      }
    });
  }

  void _applyFilters() {
    Set<JobOpening> tempFiltered = {};
    if (query_check.isNotEmpty) {
      for (int i = 0; i < realData.length; i++) {
        if (realData[i].brandName.toLowerCase().contains(query_check.toLowerCase())) {
          tempFiltered.add(realData[i]);
        }
      }
    } else {
      tempFiltered.addAll(realData);
    }
    if (_selectedChipIndex != null &&
        _selectedChipIndex >= 0 &&
        filterList[_selectedChipIndex] != "All") {
      filteredJobOpenings = tempFiltered
          .where((job) => job.category.contains(filterList[_selectedChipIndex]))
          .toList();
    } else {
      filteredJobOpenings = tempFiltered.toList();
    }
  }

  void _applyFiltersPeoople() {
    Set<PeopleClass> tempFiltered = {};
    if (query_check.isNotEmpty) {
      for (int i = 0; i < realPeopleData.length; i++) {
        if (realPeopleData[i].name.toLowerCase().contains(query_check.toLowerCase())) {
          tempFiltered.add(realPeopleData[i]);
        }
      }
    } else {
      tempFiltered.addAll(realPeopleData);
    }
    if (_selectedIndexPeople != null &&
        _selectedIndexPeople >= 0 &&
        roles[_selectedIndexPeople] != "All") {
      filteredPeopleList = tempFiltered
          .where((job) => job.role.contains(roles[_selectedIndexPeople]))
          .toList();
    } else {
      filteredPeopleList = tempFiltered.toList();
    }
  }

  Future<List<JobOpening>?> fetchJobOpeningsData() async {
    final firestore = FirebaseFirestore.instance;
    final jobOpeningsCollectionRef = firestore.collection('jobOpenings');
    List<JobOpening> jobOpeningsList = [];

    try {
      final companiesDocSnapshot = await jobOpeningsCollectionRef.doc('companies').get();

      if (companiesDocSnapshot.exists) {
        List<dynamic> jobOpeningsMapList = companiesDocSnapshot.data()?['openings'];
        jobOpeningsList = jobOpeningsMapList.map((jobOpeningMap) => JobOpening.fromFirestore(jobOpeningMap as Map<String, dynamic>)).toList();
      } else {
        print('The "companies" document does not exist.');
      }
      return jobOpeningsList;
    } catch (error) {
      print('Error fetching job openings data: $error');
      return [];
    }
  }

  // Future<void> storeJobOpeningsData() async {
  //   final firestore = FirebaseFirestore.instance;
  //   List<PeopleClass> peopleList = generateJobOpeningsData();
  //   List<Map<String, dynamic>> jobOpeningsMapList = peopleList.map((job) => job.toJson()).toList();
  //
  //   try {
  //     // Create the "jobOpenings" collection reference
  //     final jobOpeningsCollectionRef = firestore.collection('jobOpenings');
  //
  //     // Create the "companies" document and insert the list of job openings maps
  //     await jobOpeningsCollectionRef.doc('people').set({
  //       'openings': jobOpeningsMapList,
  //     });
  //
  //     print('Job openings data stored successfully.');
  //   } catch (error) {
  //     print('Error storing job openings data: $error');
  //   }
  // }
  // //
  // List<PeopleClass> generateJobOpeningsData(){
  //   Random random = Random();
  //   List<String> items=[
  //     'Fashion Stylist',
  //     'Fashion Designer',
  //     'Communication Designer',
  //     'Social media intern',
  //     'Social media Manager',
  //     'Production Associate',
  //     'Fashion Consultant',
  //     'Video Editor',
  //     'Graphic Designers',
  //     'Textile Designer',
  //     'Shoot Manager',
  //     'Shoot Assistant',
  //     'Set designer',
  //     'Set design assistant',
  //     'Videographer',
  //     'Photographer',
  //   ];
  //   List<PeopleClass> peopleList = List.generate(260, (index) {
  //     return PeopleClass(
  //       imgUrl: '${faker.image.unsplash.image(keyword: 'fashion')},${Random().nextInt(100)}', // Replace with actual image URL logic
  //       name: faker.name.firstName(),
  //       role: items[random.nextInt(items.length)],
  //       companiesWorkedIn: faker.company.companyName(),
  //     );
  //   });
  //   return peopleList;
  // }

  Future<JobAndPeopleData?> fetchJobOpeningsAndPeopleData() async {
    final firestore = FirebaseFirestore.instance;
    final jobOpeningsCollectionRef = firestore.collection('jobOpenings');

    List<JobOpening> jobOpeningsList = [];
    List<PeopleClass> peopleList = [];

    try {
      // Fetch job openings
      final companiesDocSnapshot = await jobOpeningsCollectionRef.doc('companies').get();
      if (companiesDocSnapshot.exists) {
        List<dynamic> jobOpeningsMapList = companiesDocSnapshot.data()?['openings'];
        jobOpeningsList = jobOpeningsMapList.map((jobOpeningMap) => JobOpening.fromFirestore(jobOpeningMap as Map<String, dynamic>)).toList();
      } else {
        print('The "companies" document does not exist.');
      }

      // Fetch people
      final peopleDocSnapshot = await jobOpeningsCollectionRef.doc('people').get();
      if (peopleDocSnapshot.exists) {
        List<dynamic> peopleMapList = peopleDocSnapshot.data()?['openings'];
        peopleList = peopleMapList.map((peopleMap) => PeopleClass.fromFirestore(peopleMap as Map<String, dynamic>)).toList();
      } else {
        print('The "peopleData" document does not exist.');
      }

      return JobAndPeopleData(jobOpenings: jobOpeningsList, people: peopleList);
    } catch (error) {
      print('Error fetching data: $error');
      return JobAndPeopleData(jobOpenings: [], people: []); // Return empty lists in case of error
    }
  }

  // List<JobOpening> generateJobOpeningsData() {
  //   Random random = Random();
  //   List<String> locations = ['Delhi', 'Mumbai', 'Bangalore', 'New York', 'London'];
  //   List<String> categories = ['Luxury Clothing', 'Fast Fashion', 'Sports Apparel', 'Formal Wear'];
  //   List<String>roles=['Brand','Stylist'];
  //   List<JobOpening> jobOpenings = List.generate(260, (index) {
  //     return JobOpening(
  //       imageUrl: '${faker.image.unsplash.image(keyword: 'fashion')},${Random().nextInt(100)}', // Replace with actual image URL logic
  //       brandName: faker.company.companyName(),
  //       category: roles[random.nextInt(roles.length)],
  //       subCategory: categories[random.nextInt(categories.length)],
  //       numberOfJobOpenings: random.nextInt(10) + 1, // Generates a random number between 1 and 10
  //       location: locations[random.nextInt(locations.length)],
  //     );
  //   });
  //   return jobOpenings;
  // }
  //
  // Future<void> storeJobOpeningsData() async {
  //   final firestore = FirebaseFirestore.instance;
  //   List<JobOpening> peopleList = generateJobOpeningsData();
  //   List<Map<String, dynamic>> jobOpeningsMapList = peopleList.map((job) => job.toJson()).toList();
  //
  //   try {
  //     // Create the "jobOpenings" collection reference
  //     final jobOpeningsCollectionRef = firestore.collection('jobOpenings');
  //
  //     // Create the "companies" document and insert the list of job openings maps
  //     await jobOpeningsCollectionRef.doc('companies').set({
  //       'openings': jobOpeningsMapList,
  //     });
  //
  //     print('Job openings data stored successfully.');
  //   } catch (error) {
  //     print('Error storing job openings data: $error');
  //   }
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Material(
                  elevation: 1,
                  child: Container(
                    margin: const EdgeInsets.only(
                      top: 32,
                      bottom: 8,
                      left: 9,
                      right: 9,
                    ),
                    child: Container(
                      height: 44,
                      width: 396,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        color: Color(0xffF7F7F7),
                      ),
                      child: Container(
                        child: TextField(
                          textAlignVertical: TextAlignVertical.center,
                          onChanged: (value) {
                            setState(() {
                              query_check = value;

                                _applyFilters();

                                _applyFiltersPeoople();
                            });
                          },
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 14),
                            isDense: true,
                            hintText:
                            "Search a Brand, Product, Stylist or Season",
                            hintStyle: const TextStyle(
                              fontSize: 12,
                              color: Color(0xff9D9D9D),
                            ),
                            prefixIcon: Container(
                              margin: const EdgeInsets.only(
                                  left: 14, bottom: 14, top: 10),
                              child: const Icon(
                                IconlyLight.search,
                                size: 18,
                                color: Color(0xFF4B4B4B),
                              ),
                            ),
                            border: InputBorder.none,
                            suffixIcon: IconTheme(
                              data: const IconThemeData(color: Colors.black),
                              child: IconButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, '/searchFilterScreen');
                                },
                                icon: const Icon(
                                  IconlyLight.filter,
                                  color: Color(0xff0F1015),
                                ),
                              ),
                            ),
                          ),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child: DefaultTabController(
                      length: 2,
                      child: Column(
                        children: [
                          Material(
                            elevation: 1,
                            child: TabBar(
                                controller: _tabController,
                              tabs: [
                                Tab(
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: const Center(
                                        child: Text(
                                          "Companies",
                                          style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            height: 24 / 16,
                                          ),
                                          textAlign: TextAlign.left,
                                        )),
                                  ),
                                ),
                                Tab(
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: const Center(
                                        child: Text(
                                          "People",
                                          style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            height: 24 / 16,
                                          ),
                                          textAlign: TextAlign.left,
                                        )),
                                  ),
                                ),
                              ],
                              indicatorColor: const Color(0xff282828),
                              labelColor: const Color(0xff282828),
                              unselectedLabelColor: const Color(0xff9D9D9D),
                            ),
                          ),
                          FutureBuilder<JobAndPeopleData?>(
                              future: _data,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else if (!snapshot.hasData || snapshot.data == null) {
                                  return const Text('No data available');
                                }
                                else{
                                  List<JobOpening> data = snapshot.data!.jobOpenings;
                                  List<PeopleClass> dataPeople = snapshot.data!.people;
                                  realData=data;
                                  realPeopleData=dataPeople;
                                  return Expanded(
                                    child: TabBarView(
                                        controller: _tabController,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.all(8.0),
                                          child: query_check.isNotEmpty &&
                                              filteredJobOpenings.isEmpty
                                              ? Container(
                                            margin: const EdgeInsets.all(16.0),
                                            child: const Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "No search results found",
                                                  style: TextStyle(
                                                    fontFamily: "Poppins",
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                    color: Color(0xff9d9d9d),
                                                    height: 24 / 16,
                                                  ),
                                                  textAlign: TextAlign.left,
                                                )
                                              ],
                                            ),
                                          )
                                              : AlphaBetScrollPageJob(
                                            height: query_check.isEmpty
                                                ? (widget.height ==
                                                MediaQuery.of(context)
                                                    .size
                                                    .height
                                                ? 0
                                                : MediaQuery.of(context)
                                                .size
                                                .height)
                                                : filteredJobOpenings.isEmpty
                                                ? 0
                                                : (widget.height ==
                                                MediaQuery.of(context)
                                                    .size
                                                    .height
                                                ? 0
                                                : MediaQuery.of(context)
                                                .size
                                                .height),
                                            query_check: query_check,
                                            onClickedItem: (item) {},
                                            jobList:  filteredJobOpenings.isNotEmpty
                                                ? filteredJobOpenings
                                                : data,
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.all(8.0),
                                          child: query_check.isNotEmpty &&
                                              filteredPeopleList.isEmpty
                                              ? Container(
                                            margin: EdgeInsets.all(16.0),
                                            child: const Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "No search results found",
                                                  style: TextStyle(
                                                    fontFamily: "Poppins",
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                    color: Color(0xff9d9d9d),
                                                    height: 24 / 16,
                                                  ),
                                                  textAlign: TextAlign.left,
                                                )
                                              ],
                                            ),
                                          )
                                              : AlphaBetScrollPagePeople(
                                            height: query_check.isEmpty
                                                ? (widget.height ==
                                                MediaQuery.of(context)
                                                    .size
                                                    .height
                                                ? 0
                                                : MediaQuery.of(context)
                                                .size
                                                .height)
                                                : filteredPeopleList.isEmpty
                                                ? 0
                                                : (widget.height ==
                                                MediaQuery.of(context)
                                                    .size
                                                    .height
                                                ? 0
                                                : MediaQuery.of(context)
                                                .size
                                                .height),
                                            query_check: query_check,
                                            onClickedItem: (item) {},
                                             peopleList: filteredPeopleList.isNotEmpty? filteredPeopleList: dataPeople,
                                          ),
                                        ),

                                      ],
                                    ),
                                  );

                                }
                              }
                          ),
                        ],
                      ),
                    ))
              ],
            ),
if(_selectedTab==0)
      Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          height: 50,
          color: Colors.white,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: filterList.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: OptionChip(
                  label: filterList[index],
                  isSelected: _selectedChipIndex == index,
                  onSelected: (bool isSelected){
                    setState((){
                      _selectedChipIndex = (isSelected ? index : null)!;
                      _applyFilters();
                    });
                  },
                  selectedColor: Theme.of(context).colorScheme.primary,
                ),
              );
            },
          ),
        ),
      ),
            if(_selectedTab==1)
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  height: 50,
                  color: Colors.white,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: roles.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: OptionChip(
                          label: roles[index],
                          isSelected: _selectedIndexPeople == index,
                          onSelected: (bool isSelected){
                            setState((){
                              _selectedIndexPeople = (isSelected ? index : null)!;
                              _applyFiltersPeoople();
                            });
                          },
                          selectedColor: Theme.of(context).colorScheme.primary,
                        ),
                      );
                    },
                  ),
                ),
              ),
      ],
        )
    );
  }

}

class OptionChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Function(bool) onSelected;
  final Color selectedColor;
  final Color textColor;
  final Color borderColor;

  OptionChip({
    required this.label,
    required this.isSelected,
    required this.onSelected,
    required this.selectedColor,
    this.textColor = Colors.black,
    this.borderColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: selectedColor,
      onSelected: onSelected,
      backgroundColor: Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : textColor,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: BorderSide(color: isSelected ? selectedColor : borderColor),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }
}
