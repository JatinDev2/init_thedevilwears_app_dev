import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/requestModel.dart';

// class RequestsTab extends StatefulWidget {
//   const RequestsTab({super.key});
//
//   @override
//   State<RequestsTab> createState() => _RequestsTabState();
// }
//
// class _RequestsTabState extends State<RequestsTab> {
//
//
//   // Future<List<RequestModel>> fetchRequestsForBrand(String documentId) async {
//   //   FirebaseFirestore firestore = FirebaseFirestore.instance;
//   //   List<RequestModel> requestList = [];
//   //
//   //   try {
//   //     DocumentSnapshot documentSnapshot = await firestore.collection('brandProfiles').doc(documentId).get();
//   //
//   //     if (documentSnapshot.exists) {
//   //       Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
//   //       List<dynamic> requests = data['Requests'] ?? [];
//   //
//   //       for (var request in requests) {
//   //         if (request is Map<String, dynamic>) {
//   //           RequestModel requestModel = RequestModel.fromMap(request);
//   //           requestList.add(requestModel);
//   //         }
//   //       }
//   //     } else {
//   //       print('Document with ID $documentId not found');
//   //     }
//   //   } catch (e) {
//   //     print('Error fetching document: $e');
//   //   }
//   //
//   //   return requestList;
//   // }
//
//   Stream<List<RequestModel>> streamRequestsForBrand(String documentId) {
//     FirebaseFirestore firestore = FirebaseFirestore.instance;
//
//     return firestore.collection('brandProfiles').doc(documentId).snapshots().map((snapshot) {
//       if (snapshot.exists) {
//         List<dynamic> requests = snapshot.data()?['Requests'] ?? [];
//         return requests.map((request) {
//           if (request is Map<String, dynamic>) {
//             return RequestModel.fromMap(request);
//           } else {
//             return RequestModel(userId: '', status: '', requesterName: ''); // return a default or empty model
//           }
//         }).toList();
//       } else {
//         return <RequestModel>[]; // return an empty list if the document doesn't exist
//       }
//     });
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<List<RequestModel>>(
//       stream: streamRequestsForBrand("5owbHr4JniYiRFTBzKRU"),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         }
//
//         if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         }
//
//         if (!snapshot.hasData || snapshot.data!.isEmpty) {
//           return Center(child: Text('No requests found'));
//         }
//
//         List<RequestModel> requests = snapshot.data!;
//
//         return ListView.builder(
//           itemCount: requests.length,
//           itemBuilder: (context, index) {
//             RequestModel request = requests[index];
//             return Card(
//               margin: EdgeInsets.all(8.0),
//               child: ListTile(
//                 leading: CircleAvatar(
//                   // backgroundImage: AssetImage('assets/placeholder.png'), // Placeholder image
//                 ),
//                 title: Text(request.requesterName),
//                 subtitle: Text('wants to be approved as a ${request.status}'),
//                 trailing: Wrap(
//                   spacing: 8, // space between two icons
//                   children: <Widget>[
//                     ElevatedButton(
//                       onPressed: () {
//                         // Verify action
//                       },
//                       child: Text('Verify'),
//                       style: ElevatedButton.styleFrom(primary: Colors.green),
//                     ),
//                     ElevatedButton(
//                       onPressed: () {
//                         // Decline action
//                       },
//                       child: Text('Decline'),
//                       style: ElevatedButton.styleFrom(primary: Colors.red),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//
//   }
// }
class RequestsTab extends StatefulWidget {
  const RequestsTab({super.key});

  @override
  State<RequestsTab> createState() => _RequestsTabState();
}

class _RequestsTabState extends State<RequestsTab> {
  Stream<List<RequestModel>> streamRequestsForBrand(String documentId) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    return firestore
        .collection('brandProfiles')
        .doc(documentId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        var data = snapshot.data()!;
        if (data['Requests'] != null) {
          List<dynamic> requests = data['Requests'];
          return requests.map((request) {
            if (request is Map<String, dynamic>) {
              return RequestModel.fromMap(request);
            } else {
              return RequestModel(
                  userId: '', status: 'pending', requesterName: 'Unknown');
            }
          }).toList();
        }
      }
      return <RequestModel>[];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,

      child: StreamBuilder<List<RequestModel>>(
        stream: streamRequestsForBrand("5owbHr4JniYiRFTBzKRU"),
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

          List<RequestModel> requests = snapshot.data!;

          return ListView.separated(
            padding: const EdgeInsets.all(8.0),
            itemCount: requests.length,
            separatorBuilder: (_, __) => Divider(height: 1.0),
            itemBuilder: (context, index) {
              RequestModel request = requests[index];
              return Card(
                elevation: 0.0,
                color: Colors.white,
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        // Replace with NetworkImage if you have the image URL
                        // backgroundImage: AssetImage('assets/placeholder.png'),
                        radius: 16, // Adjust radius to match your design
                      ),
                      SizedBox(width: 10), // Adjust spacing to match your design
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: request.requesterName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                  color: Colors.black, // You need to specify the color for TextSpan
                                ),
                              ),
                              TextSpan(
                                text: ' wants to be approved as a ${request.status}',
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
                          // Verify action
                        },
                        child: Text('Verify'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        ),
                      ),
                      SizedBox(width: 2),
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
