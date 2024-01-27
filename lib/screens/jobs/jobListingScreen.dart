import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lookbook/Preferences/LoginData.dart';
import '../common_widgets.dart';
import 'createNewJobListing.dart';
import 'job_model.dart';

class JobListScreen extends StatefulWidget {
  const JobListScreen({super.key});

  @override
  State<JobListScreen> createState() => _JobListScreenState();
}

class _JobListScreenState extends State<JobListScreen> {
  late final Stream<List<jobModel>>_listingsStream;
  List<jobModel> _listings = [];
  List<jobModel> filteredListings = [];

  List selectedOptions=[];
  List<String> filterOptions = [
    'Fixed',
    'Project Based',
    'Accessories',
    'Video Editor',
    'Internship',
    'Later',
    'Unpaid',
    'Hybrid',
  ];

  Stream<List<jobModel>> fetchListingsFromFirestoreStream() {
    try {
      CollectionReference collection = FirebaseFirestore.instance.collection('jobListing');

      // Return a stream that listens to changes in the Firestore collection
      return collection.snapshots().asyncMap((querySnapshot) async {
        List<jobModel> listings = [];
        for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
          Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;

          jobModel listModel = jobModel(
           jobType : data["jobType"] ?? "",
           jobProfile : data["jobProfile"] ?? "",
           responsibilities : data["responsibilities"] ?? "",
           jobDuration : data["jobDuration"] ?? "",
           jobDurExact : data["jobDurationExact"] ?? "",
           workMode : data["workMode"] ?? "",
           officeLoc : data["officeLoc"] ?? "",
           tentativeStartDate : data["tentativeStartDate"] ?? "",
           stipend : data["stipend"] ?? "",
           stipendAmount : data["stipendAmount"] ?? "",
           numberOfOpenings : data["numberOfOpenings"] ?? "",
           perks : data["perks"] ?? [],
            createdBy : data["createdBy"] ?? "",
           createdAt : data["createdAt"] ?? "",
           userId : data["userId"] ?? "",
           jobDurVal : data["jobDurVal"] ?? "",
           stipendVal : data["stipendVal"] ?? "",
           tags : data["tags"] ?? [],
            applicationCount: data["applicationCount"] ?? 0,
            clicked: data["clicked"] ?? false,
            docId: data["docId"] ?? "",
            applicationsIDS: data["applicationsIDS"] ?? [],
            interests: data["interests"] ?? [],
              brandPfp:data["brandPfp"] ?? "",
              phoneNumber: data["phoneNumber"] ?? ""
          );
          listings.add(listModel);
        }
        return listings;
      });
    } catch (e) {
      // Handle any errors or exceptions here
      print('Error fetching data: $e');
      throw e; // You can choose to throw the error to handle it elsewhere
    }
  }

  List<jobModel> sortJobListings(List<jobModel> jobListings, List<String> studentInterests, List<String> studentJobProfiles) {
    // Scoring and sorting function
    jobListings.sort((a, b) {
      int scoreA = calculateMatchScore(a, studentInterests, studentJobProfiles);
      int scoreB = calculateMatchScore(b, studentInterests, studentJobProfiles);

      // If scores are equal, sort by time (most recent first)
      if (scoreA == scoreB) {
        // Assuming createdAt is a DateTime object. If it's a string, convert it to DateTime.
        return b.createdAt.compareTo(a.createdAt);
      }

      // Otherwise, sort by score (higher score first)
      return scoreB.compareTo(scoreA);
    });

    return jobListings;
  }

  int calculateMatchScore(jobModel job, List<String> studentInterests, List<String> studentJobProfiles) {
    // Count how many interests match
    int matchingInterestsCount = job.interests.where((interest) => studentInterests.contains(interest)).length;

    // Check if job profile matches
    bool matchesJobProfile = studentJobProfiles.contains(job.jobProfile);

    // Adjusted scoring logic
    if (matchesJobProfile && matchingInterestsCount > 0) {
      // Matches both job profile and interests
      return 1000 + matchingInterestsCount; // Highest score
    } else if (matchingInterestsCount > 0) {
      // Matches interests only
      return 500 + matchingInterestsCount; // Medium-high score
    } else if (matchesJobProfile) {
      // Matches job profile only
      return 100; // Medium score
    } else {
      // No match
      return 0; // Lowest score
    }
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    // _fetchListingsFuture = fetchListingsFromFirestore();
    _listingsStream = fetchListingsFromFirestoreStream();
    // fetchListingsFromFirestore();
  }

  // void filterListings(){
  //   filteredListings.clear();
  //   for (var listing in _listings){
  //     if (listing.tags.any((tag) => selectedOptions.contains(tag)) || selectedOptions.contains(listing.createdBy) || selectedOptions.contains(listing.stipendAmount) || selectedOptions.contains(listing.stipend) || selectedOptions.contains(listing.officeLoc) || selectedOptions.contains(listing.workMode) || selectedOptions.contains(listing.jobProfile) || selectedOptions.contains(listing.jobDuration) || selectedOptions.contains(listing.workMode) || selectedOptions.contains(listing.tentativeStartDate)){
  //       setState(() {
  //         filteredListings.add(listing);
  //       });
  //     }
  //   }
  // }

  void filterListings() {
    filteredListings.clear();
    for (var listing in _listings) {
      // Check if all selected options are contained in the listing
      var matchesAll = selectedOptions.every((option) =>
      listing.tags.contains(option) ||
          listing.createdBy == option ||
          listing.stipendAmount == option ||
          // listing.stipend == option ||
          listing.officeLoc == option ||
          listing.workMode == option ||
          listing.jobProfile == option ||
          listing.jobDuration == option ||
          listing.workMode == option ||
          listing.tentativeStartDate == option ||
          option =="${listing.stipendAmount}${listing.stipendVal}"
      );
      if (matchesAll) {
        setState(() {
          filteredListings.add(listing);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context){
    return Container(
      color: const Color(0xffF7F7F7),
      child: Stack(
            children: [
          StreamBuilder<List<jobModel>>(
            stream: _listingsStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error.toString()}'),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('No data available.'),
                );
              } else {
                final data = snapshot.data!;
                print("Interests");
                print(LoginData().getUserInterests());
                print("Job");
                print(LoginData().getUserJobProfile());

                List<jobModel>sortedListings=  sortJobListings(data,LoginData().getUserInterests(),LoginData().getUserJobProfile());

                _listings=sortedListings;
                return Column(
                  children: [
                    Container(
                      // margin: EdgeInsets.only(horizontal: 5.0.w, vertical: 5.0.h),
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      child: Row(
                        children: [
                          Container(
                            child: SizedBox(
                              // height: 24,
                              width: 45.w,
                              child: GestureDetector(
                                onTap: () async{
                                  Navigator.pushNamed(
                                    context,
                                    '/listingFilterJobScreen',
                                    arguments: selectedOptions,
                                  ).then((data) {
                                    if (data != null) {
                                      setState(() {
                                        selectedOptions = data as List;
                                        if(selectedOptions.contains("Fixed")){
                                          selectedOptions.remove("Fixed");
                                        }
                                        filterListings();
                                      });
                                    }
                                  });

                                },
                                child: Container(
                                  height: 30.h,
                                  padding:  EdgeInsets.symmetric(horizontal: 3.0.w, vertical: 3.0.h),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primary,
                                    borderRadius: BorderRadius.circular(20.0.r),
                                  ),
                                  child: SvgPicture.asset(
                                    'assets/Filter.svg',
                                    semanticsLabel: 'My SVG Image',
                                    height: 20.h,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // selectedOptions.isEmpty? // Use the showListView flag to conditionally show the ListView or Wrap
                          Expanded(
                            child: SizedBox(
                              height: 50,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: filterOptions.map((option) {
                                  return FilterOptionChip(
                                    title: option,
                                    selected: selectedOptions.contains(option),
                                    onTap: () {
                                      // toggleOption(option);
                                      setState(() {
                                        if (filterOptions.isNotEmpty) {
                                          filterOptions.remove(option);
                                          selectedOptions.add(option);
                                        }
                                        filterListings();
                                        // showListView = false;
                                      });
                                    },
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (selectedOptions.isNotEmpty)
                      SizedBox(
                        height: 50,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: selectedOptions.map((option) {
                            return FilterOptionChip(
                              title: option,
                              selected: true,
                              onTap: () {
                                setState(() {
                                  if (selectedOptions.contains(option)){
                                    selectedOptions.remove(option);
                                    // if(filteredListings.isNotEmpty){
                                    //   for(int i=0; i<filteredListings.length; i++){
                                    //     if(filteredListings[i].tags!.contains(option)){
                                    //       filteredListings.remove(filteredListings[i]);
                                    //     }
                                    //   }
                                    // }
                                    filterListings();
                                    if(!filterOptions.contains(option)){
                                      filterOptions.insert(0, option);
                                    }
                                    // filterOptions.add(option);
                                  }
                                  // else {
                                  //   selectedOptions.add(option);
                                  // }
                                });
                                // toggleOption(option);
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    SizedBox(height: 8,),
                    Expanded(
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: selectedOptions.isNotEmpty? filteredListings.length:  _listings.length,
                        itemBuilder: (context, index){
                          final listing = selectedOptions.isNotEmpty? filteredListings[index]: _listings[index];
                          return BuildCustomJobCard(listing: listing);
                        },
                      ),
                    ),
                  ],
                );
              }
            },
          ),

        LoginData().getUserType()=="Company"?  Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () async {
                await Navigator.of(context).push(MaterialPageRoute(builder: (_){
                  return const CreateNewJobListing();
                }));
              },
              child: Container(
                height: 50.h,
                width: 170.w,
                margin: EdgeInsets.symmetric(horizontal: 10.0.w, vertical: 10.0.h),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(10.0.r),
                ),
                child:  Center(
                  child: Text(
                    "Create a listing",
                    style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
          ) : Container(),
        ]),
    );
  }
}
