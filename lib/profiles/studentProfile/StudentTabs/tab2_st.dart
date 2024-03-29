import 'package:flutter/material.dart';
import 'package:lookbook/Preferences/LoginData.dart';
import 'package:lookbook/Services/profiles.dart';

import '../../../Common Widgets/common_widgets.dart';

class Tab2St extends StatefulWidget {
  const Tab2St({super.key});

  @override
  State<Tab2St> createState() => _Tab2StState();
}

class _Tab2StState extends State<Tab2St> {

  late final Stream<List<ApplicationJobPair>>_listingsStream;
  List<ApplicationJobPair> _listings = [];

  void initState() {
    // TODO: implement initState
    super.initState();
    _listingsStream = ProfileServices().streamJobListingsForStudent(LoginData().getUserId());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffF7F7F7),
      child: Stack(
          children: [
            StreamBuilder<List<ApplicationJobPair>>(
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
                  // data.sort((a, b) => b.createdAt.compareTo(a.createdAt));
                  _listings=data;

                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount:  _listings.length,
                          itemBuilder: (context, index){
                            final listing =_listings[index];
                            return BuildJobCardForStudent(listing: listing.job, applicationData: listing.application,);
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
