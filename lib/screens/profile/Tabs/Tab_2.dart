import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../listing/Details_Screen.dart';
import '../../listing/new_listing/List_Model.dart';
import '../applicationsListing.dart';

class tabTwo extends StatefulWidget {
  const tabTwo({super.key});

  @override
  State<tabTwo> createState() => _tabTwoState();
}

class _tabTwoState extends State<tabTwo> {
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
  late final Stream<List<ListModel>>_listingsStream;

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
      return collection.snapshots().asyncMap((querySnapshot) async {
        List<ListModel> listings = [];
        String? userPreferenceId = await getUserPreferenceId(); // Retrieve the user's ID from SharedPreferences

        for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
          Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;

          // Check if the userId matches the one from SharedPreferences
          if (userPreferenceId != null && data['userId'] == userPreferenceId) {
            // Fetch images asynchronously and wait for the result
            List<String> images = await fetchImagesForCustomID(docSnapshot.id);

            ListModel listModel = ListModel(
              images: images,
              listingType: data['listingType'] ?? '',
              location: data['location'] ?? '',
              eventCategory: data['eventCategory'] ?? '',
              eventDate: data['eventDate'] ?? '',
              instaHandle: data['toStyleInsta'] ?? '',
              productDate: data['productDate'] ?? '',
              requirement: data['requirements'] ?? '',
              createdBy: data['createdBy'] ?? '',
              toStyleName: data['toStyleName'] ?? '',
              userId: data['userId'] ?? null,
              timeStamp: data['timeStamp'] ?? null,
              selectedTags: data['preferences'],
            );
            if (listModel.selectedTags != null) {
              listModel.tags = listModel.selectedTags!.values.expand((tags) => tags).toList();
            }
            listings.add(listModel);
          }
        }
        return listings;
      });
    } catch (e) {
      // Handle any errors or exceptions here
      print('Error fetching data: $e');
      throw e; // You can choose to throw the error to handle it elsewhere
    }
  }

  Future<String?> getUserPreferenceId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    return userId;
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


  void initState() {
    // TODO: implement initState
    super.initState();
    _listingsStream = fetchListingsFromFirestoreStream();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffF0F0F0),
      child: Column(
        children: [
          GestureDetector(
            onTap: (){
              Navigator.pushNamed(context, "/newlistingOptionsScreen");
            },
            child: Container(
              height: 65,
              width: 396,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              margin: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Add a new listing",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff0f1015),
                      height: 24/16,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(width: 7,),
                  Icon(Icons.add, size: 24, color: Colors.black,),
                ],
              ),
            ),
          ),
          SizedBox(height: 7,),
          Expanded(
            child: StreamBuilder<List<ListModel>>(
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
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index){
                      final listing = data[index];
                      return _buildCustomCard(listing);
                    },
                  );
                }
              },
            ),
          ),

        ],
      ),
    );
  }
  Widget _buildCustomCard(ListModel listing){
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: 16,
      ),
      child: InkWell(
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (_){
            return applicationsListing();
          }));
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
              // height: 50,
              // width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage("https://images.squarespace-cdn.com/content/v1/5a99d01c5ffd206cdde00bec/7e125d62-e859-41ff-aa04-23e4e0040a33/image-asset.jpeg?format=500w",),
                  ),
                  const SizedBox(width: 6,),
                   Expanded(
                      child: Text(
                        "${listing.createdBy}",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff0f1015),
                          height: 20/18,
                        ),
                        textAlign: TextAlign.left,
                      )
                  ),
                  Container(
                    child: Column(
                      children: [
                        Text(
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
              // height: 71,
              // width: MediaQuery.of(context).size.width,
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
                         text: '${listing.requirement}',
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
                  Container(
                    // height: 25,
                    // width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                         Text(
                          "${getTimeAgo(listing.timeStamp!)}",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff8b8b8b),
                            height: 18/12,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        const Spacer(),
                        TextButton(onPressed: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (_){
                            return applicationsListing();
                          }));
                        }, child:
                        Text(
                          "112 Applications",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.primary,
                            height: 21/14,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 12,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoColumns(String heading_text, String info_text){
    return  Expanded(
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
                height: 18/12,
              ),
            ),
            Flexible(
              child: Container(
                margin: const EdgeInsets.all(4.0),
                child: Text(
                  info_text,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style:const TextStyle(
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

}


