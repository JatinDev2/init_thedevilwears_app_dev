// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
//
// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({Key? key}) : super(key: key);
//
//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }
//
// class _ProfileScreenState extends State<ProfileScreen> {
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: const Center(
//           child: Text('Profile Screen')
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
// }


import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class ImageItem {
  final String imageUrl;
  bool isSelected;
  String caption;

  ImageItem({
    required this.imageUrl,
    this.isSelected = false,
    this.caption = '',
  });
}

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<ImageItem> imageList = [
    ImageItem(imageUrl: 'https://img-cf.xvideos-cdn.com/videos/thumbs169lll/ff/c9/71/ffc9714b7fe8db32e9042e323a34082f/ffc9714b7fe8db32e9042e323a34082f.17.jpg'),
    ImageItem(imageUrl: 'https://static-ca-cdn.eporner.com/gallery/o3/0y/5ARYR110yo3/8472119-upskirt-upskirt-girls-5c845f86b4d7e-7-1600x1200_880x660.jpg'),
    ImageItem(imageUrl: "https://upskirt.pantiesless.com/nopanties/-000//1/5a2a000681195_.jpg"),
    // Add more images here
  ];

  void selectItem(int index) {
    setState(() {
      for (int i = 0; i < imageList.length; i++) {
        if (i == index) {
          imageList[i].isSelected = true;
        } else {
          imageList[i].isSelected = false;
        }
      }
    });
  }

  void updateCaption(int index, String text) {
    setState(() {
      imageList[index].caption = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Gallery'),
      ),
      body: Column(
        children: [
          Container(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: imageList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    selectItem(index);
                  },
                  child: Container(
                    margin: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: imageList[index].isSelected
                            ? Colors.black
                            : Colors.transparent,
                        width: 2.0,
                      ),
                    ),
                    child: Image.network(
                      imageList[index].imageUrl,
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (text){
                updateCaption(
                  imageList.indexWhere((item) => item.isSelected),
                  text,
                );
              },
              decoration: InputDecoration(
                hintText: 'Enter your caption',
                labelText: 'Caption',
              ),
              controller: TextEditingController(
                text: imageList.firstWhere((item) => item.isSelected,
                    orElse: () => ImageItem(
                      imageUrl: ""
                    ))
                    .caption,
              ),
            ),
          ),
          Text('Selected Caption: ${imageList.firstWhere((item) => item.isSelected, orElse: () => ImageItem(
            imageUrl: ""
          )).caption}'),
        ],
      ),
    );
  }
}
