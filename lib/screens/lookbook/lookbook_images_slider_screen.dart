import 'dart:math';
import 'package:flutter/material.dart';
import 'package:faker_dart/faker_dart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Common Widgets/widgets/carousel_widget.dart';
import '../../Common Widgets/widgets/status_bar_app_bar.dart';

class LookbookImagesSliderScreen extends StatefulWidget {
  const LookbookImagesSliderScreen({Key? key}) : super(key: key);

  @override
  State<LookbookImagesSliderScreen> createState() => _LookbookImagesSliderScreenState();
}

class _LookbookImagesSliderScreenState extends State<LookbookImagesSliderScreen> {

  final faker = Faker.instance;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StatusBarAppBar(),
      body: Column(
        children: [
          SizedBox(
            height: 15.h,
          ),
          SizedBox(
            height: 40,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 10.w,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        size: 20.w,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        faker.name.fullName(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                  ],
                ),
                Text(
                  faker.company.companyName(),
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.8),
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30.h,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 50,
              itemBuilder: (context, index) {
                return CarouselWidget(
                  showTopInfo: true,
                  totalImagesInCollection: 50,
                  thisImageIndex: index + 1,
                  images: List.generate(Random().nextInt(4) + 1, (index) => '${faker.image.unsplash.image(keyword: 'model')},${Random().nextInt(100)}'),
                  onTap: () {
                    Navigator.pushNamed(context, '/lookbookImageDetailsScreen');
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
