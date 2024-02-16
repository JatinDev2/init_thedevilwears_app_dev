import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:lookbook/Models/ProfileModels/brandModel.dart';
import 'package:lookbook/Models/formModels/educationModel.dart';
import 'package:lookbook/screens/search/filterScreenJob.dart';
import '../../Models/ProfileModels/studentModel.dart';
import '../../Models/formModels/workModel.dart';
import 'AlphaBetScrollJob.dart';
import 'AlphaBetScrollPeople.dart';

class JobAndPeopleData {
  final List<BrandProfile> jobOpenings;
  final List<StudentProfile> people;

  JobAndPeopleData({required this.jobOpenings, required this.people});
}

class JobSearchScreen extends StatefulWidget {
  final double height;

  JobSearchScreen({
    required this.height,
  });

  @override
  State<JobSearchScreen> createState() => _JobSearchScreenState();
}

class _JobSearchScreenState extends State<JobSearchScreen> with TickerProviderStateMixin{
  String query_check = "";
  late Future<JobAndPeopleData?> _data;
  List<BrandProfile> filteredJobOpenings=[];
  List<BrandProfile> realData=[];
  List<StudentProfile> realPeopleData=[];
  List<StudentProfile> filteredPeopleList=[];
  int _selectedTab = 0;
   List selectedOptions=[];
   String tabSelectedInFilterScreen="";

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
    Set<BrandProfile> tempFiltered = {};

    // Filter by brand name if query_check is not empty
    if (query_check.isNotEmpty) {
      for (int i = 0; i < realData.length; i++) {
        if (realData[i].brandName.toLowerCase().contains(query_check.toLowerCase())) {
          tempFiltered.add(realData[i]);
        }
      }
    } else {
      tempFiltered.addAll(realData);
    }

    // Further filter by selected chip if applicable
    if (_selectedChipIndex != null &&
        _selectedChipIndex >= 0 &&
        filterList[_selectedChipIndex] != "All") {
      tempFiltered.retainWhere((profile) =>
          profile.brandDescription.join(",").contains(filterList[_selectedChipIndex]));
    }

    // Handle opening filters
    if (selectedOptions.isNotEmpty) {
      bool filterAllOpenings = selectedOptions.contains("All openings");
      bool filterNoOpenings = selectedOptions.contains("No openings");

      // Remove "All openings" and "No openings" from the options to handle other filters normally
      List<String> filterableOptions = List<String>.from(selectedOptions)
        ..remove("All openings")
        ..remove("No openings");

      tempFiltered.retainWhere((profile) {
        // Skip filtering by openings if "All openings" is selected
        List<String> profileCities = profile.location.split(',').map((s) => s.trim().toLowerCase()).toList();

        // Define a helper function to check if the profile location matches any part of the selected location
        bool locationMatches(String locationOption) {
          List<String> locationParts = locationOption.split(',').map((s) => s.trim().toLowerCase()).toList();
          return profileCities.any((city) => locationParts.contains(city));
        }


        if (filterAllOpenings) {
          return filterableOptions.every((option) =>
          profile.brandDescription.join(",").toLowerCase().contains(option.toLowerCase()) ||
              profile.location.toLowerCase().contains(option.toLowerCase())
          );
        }

        // If "No openings" is selected, profile should have empty openings
        if (filterNoOpenings) {
          return profile.openings.isEmpty &&
              filterableOptions.every((option) =>
              profile.brandDescription.join(",").toLowerCase().contains(option.toLowerCase()) ||
                  profile.location.toLowerCase().contains(option.toLowerCase())
              );
        }

        List<String> openingTypes = profile.openings.split(",").map((s) => s.trim().toLowerCase()).toList();

        return filterableOptions.every((option) =>
        profile.brandDescription.join(",").toLowerCase().contains(option.toLowerCase()) ||
            profile.location.toLowerCase().contains(option.toLowerCase()) ||
            openingTypes.contains(option.toLowerCase()) || locationMatches(option)
        );
      });
    }

    filteredJobOpenings = tempFiltered.toList();

    // Debug print
    print("Length is:");
    print(filteredJobOpenings.length);
  }

  void _applyFiltersPeople() {
    Set<StudentProfile> tempFiltered = {};
    // Filter by name if query_check is not empty
    if (query_check.isNotEmpty) {
      for (int i = 0; i < realPeopleData.length; i++) {
        String fullName = "${realPeopleData[i].firstName} ${realPeopleData[i].lastName}".toLowerCase();
        if (fullName.contains(query_check.toLowerCase())) {
          tempFiltered.add(realPeopleData[i]);
        }
      }
    } else {
      tempFiltered.addAll(realPeopleData);
    }

    if (_selectedIndexPeople != null &&
        _selectedIndexPeople >= 0 &&
        roles[_selectedIndexPeople] != "All") {
      tempFiltered.retainWhere((profile) =>
          profile.userDescription!.join(",").contains(filterList[_selectedChipIndex]));
    }

    if(selectedOptions.isNotEmpty){
      List<String> filterableOptions = List<String>.from(selectedOptions);

      tempFiltered.retainWhere((student) {
        bool _matchesEducationFilter(List<EducationModel>? education, String selectedFilter) {
          return education?.any((edu) {
            if (selectedFilter == "Graduate") {
              return edu.degreeName.toLowerCase().contains("bachelor");
            } else if (selectedFilter == "Post Graduate") {
              return edu.degreeName.toLowerCase().contains("master") || edu.degreeName.toLowerCase().contains("phd");
            }
            return false;
          }) ?? false;
        }

        bool _matchesExperienceFilter(List<WorkModel>? workExperience, String selectedFilter) {
          // If workExperience is empty and the selected filter is "Fresher", return true
          if (workExperience == null || workExperience.isEmpty) {
            return selectedFilter == "Fresher";
          }

          // If there are work experiences, calculate the total years of experience
          for (var work in workExperience) {
            int experienceYears = _calculateExperienceYears(work.timePeriod);
            switch (selectedFilter.toLowerCase()) {
              case "fresher":
              // Since there's work experience, the person is not a fresher
                return false;
              case "2+ years experience":
                if (experienceYears >= 2) return true;
                break;
              case "5+ years experience":
                if (experienceYears >= 5) return true;
                break;
              case "10+ years experience":
                if (experienceYears >= 10) return true;
                break;
            }
          }
          // If no condition matches, return false
          return false;
        }

        return filterableOptions.every((option) =>
        student.userDescription!.join(",").toLowerCase().contains(option.toLowerCase()) ||
            _matchesEducationFilter(student.education,option) || _matchesExperienceFilter(student.workExperience,option)
        );
      });
    }
    filteredPeopleList = tempFiltered.toList();
    // Debug print
    print("Length of people list is:");
    print(filteredPeopleList.length);
  }

  int _calculateExperienceYears(String timePeriod) {
    // Split the time period into start and end parts
    List<String> parts = timePeriod.split(' - ');
    if (parts.length != 2) {
      return 0; // Return 0 if the format is unexpected
    }

    DateTime startDate = _parseDate(parts[0]);
    DateTime endDate = parts[1].toLowerCase() == 'present' ? DateTime.now() : _parseDate(parts[1]);

    // Calculate the difference in years
    int years = endDate.year - startDate.year;
    // If the current month is before the start month, or it's the same month but the day is earlier, subtract a year
    if (endDate.month < startDate.month || (endDate.month == startDate.month && endDate.day < startDate.day)) {
      years--;
    }

    return years;
  }

  DateTime _parseDate(String dateStr) {
    // Expecting dateStr in the format DD/MM/YYYY
    List<String> dateParts = dateStr.split('/');
    if (dateParts.length != 3) {
      return DateTime.now(); // Return current date if the format is unexpected
    }

    int day = int.parse(dateParts[0]);
    int month = int.parse(dateParts[1]);
    int year = int.parse(dateParts[2]);

    return DateTime(year, month, day);
  }




  Future<JobAndPeopleData?> fetchJobOpeningsAndPeopleData() async {
    final firestore = FirebaseFirestore.instance;
    final jobOpeningsCollectionRef = firestore.collection('jobOpenings');

    List<BrandProfile> jobOpeningsList = [];
    List<StudentProfile> peopleList = [];

    try {
        jobOpeningsList= await fetchBrandProfiles();
        peopleList = await fetchStudentProfiles();
      return JobAndPeopleData(jobOpenings: jobOpeningsList, people: peopleList);
    } catch (error) {
      print('Error fetching data: $error');
      return JobAndPeopleData(jobOpenings: [], people: []);
    }
  }

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
                  color: Color(0xFFFFFFFF),
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
                                _applyFiltersPeople();
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
                                 Navigator.of(context).push(MaterialPageRoute(builder: (_){
                                   return FiltersTabJobScreen(
                                     tabString: _tabController.index==0? "Companies" : "People",
                                     selectedFilterOption: selectedOptions,
                                     selectedOptionMap: _selectedOptionMap,
                                   );
                                 })).then((value) {
                                   setState(() {
                                     // _tabController.index=value=="Companies"?0 : 1;
                                     if(value is Map){
                                       _selectedOptionMap=value["selectedOptionMapFromFilterScreen"];
                                       selectedOptions=value["selectedOptionListFromFilterScreen"];
                                       tabSelectedInFilterScreen=value["tab"];
                                       value["tab"]=="Companies"? _tabController.index=0 : _tabController.index=1;
                                     }
                                     if(_tabController.index==0){
                                       print("INDEX : ${_tabController.index}");
                                       _applyFilters();
                                     }
                                     else{
                                       _applyFiltersPeople();
                                     }
                                   });
                                 });
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
                            color: Color(0xFFFFFFFF),
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
                                            //
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
                                            //
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
                                  return const CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else if (!snapshot.hasData || snapshot.data == null) {
                                  return const Text('No data available');
                                }
                                else{
                                  List<BrandProfile> data = snapshot.data!.jobOpenings;
                                  List<StudentProfile> dataPeople = snapshot.data!.people;
                                  realData=data;
                                  realPeopleData=dataPeople;
                                  _applyFilters();
                                  _applyFiltersPeople();
                                  return Expanded(
                                    child: TabBarView(
                                        controller: _tabController,
                                      children: [
                                        ListView(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.all(8.0),
                                              child: (query_check.isNotEmpty &&
                                                  filteredJobOpenings.isEmpty) || (filteredJobOpenings.isEmpty && filterList[_selectedChipIndex]!="All")
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
                                                        //
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
                                                selectedItems: tabSelectedInFilterScreen=="Companies"? selectedOptions : [],
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
                                                jobList:
                                                // filteredJobOpenings.isNotEmpty
                                                //     ?
                                                filteredJobOpenings
                                                    // : data
                                                ,
                                                selectedOptionsMap: tabSelectedInFilterScreen=="Companies"? _selectedOptionMap : {},
                                                onListUpdated: (){
                                                  setState(() {
                                                    _applyFilters();
                                                  });
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          margin: EdgeInsets.all(8.0),
                                          child: (query_check.isNotEmpty &&
                                filteredPeopleList.isEmpty) || (filteredPeopleList.isEmpty && roles[_selectedIndexPeople]!="All")
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
                                                    //
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
                                selectedOptionsMap: tabSelectedInFilterScreen=="People"? _selectedOptionMap : {},
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
                                             peopleList:
                                             // roles[_selectedIndexPeople]!="All" ||
                                             //     filteredPeopleList.isNotEmpty ?
                                             filteredPeopleList
                                                 // : dataPeople
                                            ,
                                            selectedItems: tabSelectedInFilterScreen=="People"? selectedOptions : [],
                                            onListUpdated: (){
                                  setState(() {
                                    _applyFiltersPeople();
                                  });
                                            },
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
                              _applyFiltersPeople();
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }
}
