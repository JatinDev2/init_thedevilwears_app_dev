import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lookbook/Common%20Widgets/widgets/showDialog.dart';
import 'package:lookbook/Preferences/LoginData.dart';
import 'package:lookbook/Services/profiles.dart';
import 'package:rxdart/rxdart.dart';
import '../../../App Constants/pfpClass.dart';
import '../../../Models/ProfileModels/studentModel.dart';
import '../../../Models/RequestModel/requestModel.dart';

class RequestWithUserProfile {
  final RequestModel request;
  final String userProfilePicture;
  final String userName;

  RequestWithUserProfile({required this.request, required this.userProfilePicture, required this.userName});
}


class RequestsTab extends StatefulWidget {
  final String companyName;
  const RequestsTab({super.key, required this.companyName});

  @override
  State<RequestsTab> createState() => _RequestsTabState();
}

class _RequestsTabState extends State<RequestsTab> {
  late Stream<List<RequestWithUserProfile>> streamForRequests;
  // Stream<List<RequestModel>> streamRequestsForBrand(String documentId) {
  //   FirebaseFirestore firestore = FirebaseFirestore.instance;
  //
  //   return firestore
  //       .collection('brandProfiles')
  //       .doc(documentId)
  //       .snapshots()
  //       .map((snapshot) {
  //     if (snapshot.exists && snapshot.data() != null) {
  //       var data = snapshot.data()!;
  //       if (data['Requests'] != null) {
  //         List<dynamic> requests = data['Requests'];
  //         return requests.map((request) {
  //           if (request is Map<String, dynamic>) {
  //             return RequestModel.fromMap(request);
  //           } else {
  //             return RequestModel(
  //                 userId: '', status: 'pending', requesterName: 'Unknown' , jobProfile: '');
  //           }
  //         }).toList();
  //       }
  //     }
  //     return <RequestModel>[];
  //   });
  // }

  Stream<List<RequestWithUserProfile>> streamRequestsForBrand() {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String currentUserId = LoginData().getUserId();

    // Stream of brand requests with status "pending"
    Stream<List<RequestModel>> brandRequestsStream = firestore
        .collection('brandProfiles')
        .doc(currentUserId)
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists || snapshot.data() == null || snapshot.data()!['Requests'] == null) {
        return <RequestModel>[];
      }
      List<dynamic> requests = snapshot.data()!['Requests'];
      // Filter for requests with status "pending"
      return requests.map<RequestModel>((request) {
        if (request is Map<String, dynamic> && request['status'] == 'pending') {
          return RequestModel.fromMap(request);
        }
        return  RequestModel(
            userId: '', status: 'pending', requesterName: 'Unknown' , jobProfile: '');;
      }).where((request) => request != null).cast<RequestModel>().toList();
    });

    // Stream of user profiles
    Stream<Map<String, StudentProfile>> studentProfilesStream = brandRequestsStream
        .asyncMap((requests) {
      // Fetch user profiles in parallel for requests with non-empty userId
      var futures = requests
          .where((request) => request.userId.isNotEmpty)
          .map((request) => firestore.collection('studentProfiles').doc(request.userId).get())
          .toList();
      return Future.wait(futures);
    })
        .map((snapshots) {
      // Convert snapshots to a Map of userId to StudentProfile
      Map<String, StudentProfile> userProfiles = {};
      for (var snapshot in snapshots) {
        if (snapshot.exists) {
          StudentProfile profile = StudentProfile.fromDocument(snapshot);
          userProfiles[snapshot.id] = profile;
        }
      }
      return userProfiles;
    });

    // Combining the streams
    return Rx.combineLatest2(brandRequestsStream, studentProfilesStream,
            (List<RequestModel> requests, Map<String, StudentProfile> userProfiles) {
          return requests.map<RequestWithUserProfile>((request) {
            String userProfilePicture = '';
            String userName = '';
            if (request.userId.isNotEmpty && userProfiles.containsKey(request.userId)) {
              StudentProfile profile = userProfiles[request.userId]!;
              userProfilePicture = profile.userProfilePicture ?? '';
              userName = "${profile.firstName} ${profile.lastName}";
            }
            return RequestWithUserProfile(
              request: request,
              userProfilePicture: userProfilePicture,
              userName: userName,
            );
          }).toList();
        });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    streamForRequests=streamRequestsForBrand();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,

      child: StreamBuilder<List<RequestWithUserProfile>>(
        stream: streamForRequests,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No requests found'));
          }

          List<RequestWithUserProfile> requests = snapshot.data!;

          return ListView.separated(
            padding: const EdgeInsets.all(8.0),
            itemCount: requests.length,
            separatorBuilder: (_, __) => Divider(height: 1.0),
            itemBuilder: (context, index) {
              RequestWithUserProfile request = requests[index];

              return request.request.jobProfile.isEmpty?Center(child: Text('No requests found'))  : Card(
                elevation: 0.0,
                color: Colors.white,
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      StudentProfilePicClassRadiusClass(imgUrl: request.userProfilePicture, radius: 24,),
                      // CircleAvatar(
                      //   radius: 16,
                      // ),
                      SizedBox(width: 10), // Adjust spacing to match your design
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: request.userName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: ' wants to be approved as a ${request.request.jobProfile}',
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14.0,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      ElevatedButton(
                        onPressed: () {
                          ShowDialog().dialogWithButtons(context, "Are you sure you want to verify ${request.userName} as ${request.request.jobProfile} in ${widget.companyName}", () {
                            ProfileServices().updateWorkExperienceStatus(widget.companyName, request.request.jobProfile, "verified",request.request.userId);
                            ProfileServices().updateRequestStatus(LoginData().getUserId(), request.request.userId, request.request.jobProfile, "verified");
                            Navigator.of(context).pop();
                          });
                        },
                        child: Text('Verify'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        ),
                      ),
                      const SizedBox(width: 2),
                      TextButton(
                        onPressed: () {
                          // Decline action
                        },
                        child: Text('Decline'),
                        style: TextButton.styleFrom(
                          primary: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );

            },
          );
        },
      ),
    );
  }
}
