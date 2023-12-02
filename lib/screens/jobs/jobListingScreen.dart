import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../common_widgets.dart';
import '../listing/listing_screen.dart';
import 'createNewJobListing.dart';
import 'filterScreen.dart';
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

  void initState() {
    // TODO: implement initState
    super.initState();
    // _fetchListingsFuture = fetchListingsFromFirestore();
    _listingsStream = fetchListingsFromFirestoreStream();
    // fetchListingsFromFirestore();
  }

  void filterListings(){
    filteredListings.clear();
    for (var listing in _listings){
      if (listing.tags.any((tag) => selectedOptions.contains(tag)) || selectedOptions.contains(listing.createdBy) || selectedOptions.contains(listing.stipendAmount) || selectedOptions.contains(listing.stipend) || selectedOptions.contains(listing.officeLoc) || selectedOptions.contains(listing.workMode) || selectedOptions.contains(listing.jobProfile) || selectedOptions.contains(listing.jobDuration) || selectedOptions.contains(listing.workMode) || selectedOptions.contains(listing.tentativeStartDate)){
        setState(() {
          filteredListings.add(listing);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                data.sort((a, b) => b.createdAt.compareTo(a.createdAt));
                _listings=data;
                return Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5.0.w, vertical: 5.0.h),
                      width: MediaQuery.of(context).size.width,
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
                              height: 50.h,
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
                        height: 50.h,
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
                    Expanded(
                      child: ListView.builder(
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

          Align(
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
          ),
        ]),
    );
  }
}
