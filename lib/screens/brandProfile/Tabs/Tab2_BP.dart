import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common_widgets.dart';
import '../../jobs/job_model.dart';

class BrandListingsTab extends StatefulWidget {
  const BrandListingsTab({super.key});

  @override
  State<BrandListingsTab> createState() => _BrandListingsTabState();
}

class _BrandListingsTabState extends State<BrandListingsTab> {

  late final Stream<List<jobModel>>_listingsStream;
  List<jobModel> _listings = [];
  bool isLoading=true;

  Stream<List<jobModel>> fetchListingsFromFirestoreStream(String currentUserId) {
    try {
      CollectionReference collection = FirebaseFirestore.instance.collection('jobListing');
      return collection
          .where('userId', isEqualTo: currentUserId)
          .snapshots()
          .map((querySnapshot) {
        return querySnapshot.docs.map((docSnapshot) {
          Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;

          return jobModel(
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
          );
        }).toList();
      });
    } catch (e) {
      // Handle any errors or exceptions here
      print('Error fetching data: $e');
      return Stream.error(e); // Return an error stream
    }
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    // _fetchListingsFuture = fetchListingsFromFirestore();

    getId().then((value){
      _listingsStream = fetchListingsFromFirestoreStream(value);
      setState((){
        isLoading=false;
      });
    });
    // fetchListingsFromFirestore();
  }

  Future<String> getId()async{
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    return userId!;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffF7F7F7),
      child: isLoading? Center(child: CircularProgressIndicator(),) : Stack(
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
                      Expanded(
                        child: ListView.builder(
                          itemCount:  _listings.length,
                          itemBuilder: (context, index){
                            final listing =_listings[index];
                            return BuildCustomBrandJobListingCard(listing: listing);
                          },
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ]),
    );
  }
}
