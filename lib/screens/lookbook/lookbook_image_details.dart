import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:lookbook/widgets/carousel_widget.dart';
import 'package:lookbook/widgets/status_bar_app_bar.dart';
import 'package:lookbook/widgets/mini_expandable_text.dart';

import 'package:faker_dart/faker_dart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:transparent_image/transparent_image.dart';


class LookbookImageDetailsScreen extends StatefulWidget {
  const LookbookImageDetailsScreen({Key? key}) : super(key: key);

  @override
  State<LookbookImageDetailsScreen> createState() => _LookbookImageDetailsScreenState();
}

class _LookbookImageDetailsScreenState extends State<LookbookImageDetailsScreen> {

  final faker = Faker.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StatusBarAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CarouselWidget(
                    showTopInfo: false,
                    images: List.generate(Random().nextInt(4) + 1, (index) => '${faker.image.unsplash.image(keyword: 'model')},${Random().nextInt(100)}'),
                    onTap: () {
                      //Navigator.pushNamed(context, 'collection_info');
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Text(
                      'Black Formal Blazer'.toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Text(
                      faker.lorem.text(),
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  MiniExpandableText(
                    header: 'Material, Care And Origin'.toUpperCase(),
                    content: faker.lorem.text(),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  MiniExpandableText(
                    header: 'shipping and return'.toUpperCase(),
                    content: faker.lorem.text(),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  MiniExpandableText(
                    header: 'chat'.toUpperCase(),
                    content: faker.lorem.text(),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Text(
                      'You May Also Like'.toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  SizedBox(
                    height: 200.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 134.w,
                          margin: EdgeInsets.only(left: 10.w, right: index == 4 ? 10.w : 0.w),
                          child: FadeInImage(
                            placeholder: MemoryImage(kTransparentImage),
                            image: NetworkImage(
                              '${faker.image.unsplash.image(keyword: 'model')},${Random().nextInt(100)}',
                            ),
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                ],
              ),
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
