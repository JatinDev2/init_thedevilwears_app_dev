import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:lookbook/screens/listing/FiltersScreen_Listing.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Details_Screen.dart';
import 'new_listing/List_Model.dart';

class ListingScreen extends StatefulWidget {
  @override
  State<ListingScreen> createState() => _ListingScreenState();
}

class _ListingScreenState extends State<ListingScreen> {
  List<String> selectedOptions = [];
  bool showListView = true;
  // late Future<List<ListModel>> _fetchListingsFuture;
  late final Stream<List<ListModel>>
      _listingsStream; // Replace with your Firestore stream

  List<String> filterOptions = [
    'Clothing',
    'Shoes',
    'Accessories',
    'Bags',
    'Jewelry',
    'Birthday',
    'Anniversary',
    'Graduation',
    'Holiday',
    'Prom',
    'Movie Promotions',
    'Shoots',
    'Events',
    'Concerts',
    'Weddings',
    'Public Appearances',
  ];
  List<ListModel> _listings = [];

  List<String> filterCopyOptions = [
    'Clothing',
    'Shoes',
    'Accessories',
    'Bags',
    'Jewelry',
    'Birthday',
    'Anniversary',
    'Graduation',
    'Holiday',
    'Prom',
    'Movie Promotions',
    'Shoots',
    'Events',
    'Concerts',
    'Weddings',
    'Public Appearances',
  ];


  Future<List<String>> fetchImagesForCustomID(String customID) async {
    List<String> imageUrls = [];

    try {
      FirebaseStorage storage = FirebaseStorage.instance;

      Reference storageRef = storage.ref().child('listings/$customID');

      ListResult result = await storageRef.listAll();

      for (var item in result.items) {
        String downloadURL = await item.getDownloadURL();
        imageUrls.add(downloadURL);
      }

      return imageUrls;
    } catch (e) {
      print('Error fetching images: $e');
      return [];
    }
  }

  Stream<List<ListModel>> fetchListingsFromFirestoreStream() {
    try {
      CollectionReference collection = FirebaseFirestore.instance.collection('listings');

      // Return a stream that listens to changes in the Firestore collection
      return collection.snapshots().asyncMap((querySnapshot) async {
        List<ListModel> listings = [];
        for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
          Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;

          // Fetch images asynchronously and wait for the result
          List<String> images = await fetchImagesForCustomID(docSnapshot.id);

          ListModel listModel = ListModel(
            images: images, // Assign the fetched images to your ListModel
            listingType: data['listingType'] ?? '',
            location: data['location'] ?? '',
            eventCategory: data['eventCategory'] ?? '',
            eventDate: data['eventDate'] ?? '',
            instaHandle: data['toStyleInsta'] ?? '',
            productDate: data['productDate'] ?? '',
            requirement: data['requirements'] ?? '',
            toStyleName: data['toStyleName'] ?? '',
            createdBy: data['createdBy'] ?? '',
            userId: data['userId'] ?? null,
            timeStamp: data['timeStamp'] ?? null,
            selectedTags: data['preferences'],
          );
          if (listModel.selectedTags != null) {
            listModel.tags = listModel.selectedTags!.values.expand((tags) => tags).toList();
          }
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

  void toggleOption(String option) {
    setState(() {
      if (selectedOptions.contains(option)) {
        selectedOptions.remove(option);
      } else {
        selectedOptions.add(option);
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _fetchListingsFuture = fetchListingsFromFirestore();
    _listingsStream = fetchListingsFromFirestoreStream();
    // fetchListingsFromFirestore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(
                height: 13,
              ),
              Container(
                color: Colors.white,
                child: TabBar(
                  tabs: [
                    Tab(
                      child: Text(
                        "Sourcing",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          height: 24 / 16,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Tab(
                      child: Text(
                        "Collab",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          height: 24 / 16,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                  indicatorColor: Color(0xff282828),
                  labelColor: Color(0xff282828),
                  unselectedLabelColor: Color(0xff9D9D9D),
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: TabBarView(
                    children: [
                      _buildSourceTab(),
                      _buildCollabTab(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSourceTab(){
    return Stack(children: [
      StreamBuilder<List<ListModel>>(
        stream: _listingsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error.toString()}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('No data available.'),
            );
          } else {
            final data = snapshot.data!;
            data.sort((a, b) => b.timeStamp!.compareTo(a.timeStamp!));
            return Column(
              children: [
                Container(
                  margin: EdgeInsets.all(5.0),
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      Container(
                        child: SizedBox(
                          // height: 24,
                          width: 45,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/listingFilterScreen',
                                arguments: selectedOptions,
                              ).then((data) {
                                if (data != null) {
                                  setState(() {
                                    selectedOptions = data as List<String>;
                                  });
                                }
                              });
                            },
                            child: Container(
                              height: 30,
                              padding: const EdgeInsets.all(3.0),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: SvgPicture.asset(
                                'assets/Filter.svg',
                                semanticsLabel: 'My SVG Image',
                                height: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // selectedOptions.isEmpty? // Use the showListView flag to conditionally show the ListView or Wrap
                      Expanded(
                        child: Container(
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
                  Container(
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
                    itemCount: data.length,
                    itemBuilder: (context, index){
                      final listing = data[index];
                      return _buildCustomCard(listing);
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
            await Navigator.pushNamed(context, '/newlistingOptionsScreen');
          },
          child: Container(
            height: 50,
            width: 170,
            margin: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: const Center(
              child: Text(
                "Create a listing",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    ]);
  }

  Widget _buildCollabTab() {
    return const Center(
      child: Text("Collab Tab"),
    );
  }

  Widget _buildInfoColumns(String heading_text, String info_text) {
    return Expanded(
      child: Container(
        height: 40,
        child: Column(
          children: [
            Text(
              heading_text,
              style: const TextStyle(
                fontFamily: "Poppins",
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Color(0xff9a9a9a),
                height: 18 / 12,
              ),
            ),
            Flexible(
              child: Container(
                margin: const EdgeInsets.all(4.0),
                child: Text(
                  info_text,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff424242),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getTimeAgo(String timestampString) {
    // Convert the Firestore timestamp string to a DateTime
    DateTime timestamp = DateTime.parse(timestampString);

    // Get the current time
    DateTime now = DateTime.now();

    // Calculate the time difference
    Duration difference = now.difference(timestamp);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} seconds ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      // Format the timestamp in a custom way if it's more than a week ago
      String formattedDate = DateFormat('MMM d, yyyy').format(timestamp);
      return 'on $formattedDate';
    }
  }

  Widget _buildCustomCard(ListModel listing){
    return Card(
      elevation: 2,
      margin: EdgeInsets.all(16),
      child: InkWell(
        onTap: () {
       Navigator.of(context).push(MaterialPageRoute(builder: (_){
         return Details_Screen(listing: listing);
       }));
          // Navigator.pushNamed(context, 'listingDetailsScreen');
        },
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(2.0),
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Expanded(
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: listing.tags!.map((option) {
                        return OptionChipDisplay(
                          title: option,
                        );
                      }).toList(),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                      "https://images.squarespace-cdn.com/content/v1/5a99d01c5ffd206cdde00bec/7e125d62-e859-41ff-aa04-23e4e0040a33/image-asset.jpeg?format=500w",
                    ),
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                   Expanded(
                      child: Text(
                    "${listing.createdBy}",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff0f1015),
                      height: 20 / 18,
                    ),
                    textAlign: TextAlign.left,
                  )),
                  Container(
                    child: Column(
                      children: [
                        const Text(
                          "Required on ",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff0f1015),
                          ),
                        ),
                        Text(
                          "${listing.productDate}",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff0f1015),
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.all(8.0),
              color: const Color(0xffF9F9F9),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildInfoColumns("For", "${listing.toStyleName}"),
                  Container(
                    margin: const EdgeInsets.all(2.0),
                    height: 50,
                    width: 2,
                    color: const Color(0xffB7B7B9),
                  ),
                  _buildInfoColumns("Location", "${listing.location}"),
                  Container(
                    margin: const EdgeInsets.all(2.0),
                    height: 50,
                    width: 2,
                    color: const Color(0xffB7B7B9),
                  ),
                  _buildInfoColumns("Event", "${listing.eventCategory}"),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'Requirements ',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff2F2F2F),
                      ),
                      children: [
                        TextSpan(
                          // text: ' A mustard yellow traditional outfit is required for Alia Bhatt for her new movie promotions. The fabric...',
                          // text: "}"
                          text: "${listing.requirement}",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            color: Color(0xff424242),
                          ),
                        ),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        "${getTimeAgo(listing.timeStamp!)}",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff8b8b8b),
                          height: 18 / 12,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      const Spacer(),
                      IconButton(
                          onPressed: () {
                            // // Create a shareable link to the Details_Screen for the specific listing
                            // String listingId = listing.userId!; // Replace with the actual ID of the listing
                            // String shareableLink = 'https://in.lookbook.lookbook/details/$listingId';
                            // // Use the url_launcher package to open the share dialog
                            // launch(shareableLink);

                            // Create a deep link to the next page in your app
                            String deepLink = 'myapp://next_page'; // Replace with your actual deep link structure

                            // Share the deep link using the share package
                            Share.share('Check out this listing: $deepLink', subject: 'Listing Details');

                          }, icon: const Icon(IconlyLight.send)),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(IconlyLight.bookmark)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FilterOptionChip extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const FilterOptionChip({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(
            top: 9.0,
            left: selected ? 3.0 : 6.0,
            right: selected ? 3.0 : 6.0,
            bottom: 9.0),
        padding: selected
            ? const EdgeInsets.symmetric(
                horizontal: 10,
                // vertical: 1,
              )
            : const EdgeInsets.symmetric(
                horizontal: 10,
              ),
        decoration: BoxDecoration(
          color: selected
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 12,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                color: selected ? Colors.white : Color(0xff303030),
                height: 18 / 12,
              ),
            ),
            if (selected)
              GestureDetector(
                onTap: onTap,
                child: const Icon(
                  Icons.clear,
                  size: 16,
                  color: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class OptionChipDisplay extends StatelessWidget {
  final String title;

  OptionChipDisplay({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      margin:
          const EdgeInsets.only(top: 9.0, left: 6.0, right: 6.0, bottom: 9.0),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xffF7F7F7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: "Poppins",
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xff303030),
              height: 18 / 12,
            ),
          ),
        ],
      ),
    );
  }
}
