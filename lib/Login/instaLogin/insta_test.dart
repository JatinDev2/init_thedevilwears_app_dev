// import 'package:flutter/material.dart';
// import 'instagram_model.dart'; // Make sure this is the correct path to your InstagramModel
//
// class InstagramMediaWidget extends StatefulWidget {
//   @override
//   _InstagramMediaWidgetState createState() => _InstagramMediaWidgetState();
// }
//
// class _InstagramMediaWidgetState extends State<InstagramMediaWidget> {
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Test screen"),
//       ),
//       body: FutureBuilder<List<InstagramMedia>>(
//         future: InstagramModel.fetchMedia(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text('No media found'));
//           } else {
//             List<InstagramMedia> mediaList = snapshot.data!;
//             return ListView.builder(
//               itemCount: mediaList.length,
//               itemBuilder: (context, index) {
//                 InstagramMedia media = mediaList[index];
//                 return Card(
//                   child: Column(
//                     children: <Widget>[
//                       Image.network(media.mediaUrl),
//                       Text(media.username),
//                       Text(media.timestamp),
//                     ],
//                   ),
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }
//
class InstagramMedia {
  final String id;
  final String mediaType;
  final String mediaUrl;
  final String username;
  final String timestamp;

  InstagramMedia({
    required this.id,
    required this.mediaType,
    required this.mediaUrl,
    required this.username,
    required this.timestamp,
  });

  factory InstagramMedia.fromJson(Map<String, dynamic> json) {
    return InstagramMedia(
      id: json['id'],
      mediaType: json['media_type'],
      mediaUrl: json['media_url'],
      username: json['username'],
      timestamp: json['timestamp'],
    );
  }
}
