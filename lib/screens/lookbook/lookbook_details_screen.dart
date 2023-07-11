import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'package:lookbook/widgets/status_bar_app_bar.dart';

import 'package:faker_dart/faker_dart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:transparent_image/transparent_image.dart';

class LookbookDetailsScreen extends StatefulWidget {
  const LookbookDetailsScreen({Key? key}) : super(key: key);

  @override
  State<LookbookDetailsScreen> createState() => _LookbookDetailsState();
}

class _LookbookDetailsState extends State<LookbookDetailsScreen> with SingleTickerProviderStateMixin {

  final faker = Faker.instance;
  late TabController _tabController;

  bool isLoading = true;
  int _selected = 0;

  _select(int index) {
    setState(() {
      _selected = index;
      _tabController.animateTo(index);
    });
  }

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => _select(_tabController.index));

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
          TabBar(
            controller: _tabController,
            indicatorColor: Colors.black,
            dividerColor: Colors.transparent,
            indicatorSize: TabBarIndicatorSize.label,
            labelPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            // indicatorPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            labelStyle: TextStyle(
              fontSize: 14.sp
            ),
            isScrollable: true,
            tabs: const [
              Text(
                "Collection",
              ),
              Text(
                "About",
              ),
            ],
          ),
          Expanded(
            child: Column(
              children: [
                SizedBox(
                  height: 20.h,
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 4),
                        child: GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 4,
                              crossAxisSpacing: 4,
                              childAspectRatio: 100 / 150,
                            ),
                            itemBuilder: (context, index) => isLoading
                                ? _shimmerItem()
                                : _gridItem()
                        ),
                      ),
                      const Center(
                        child: Text(
                          'About Collection',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      )
    );
  }

  /// Grid Item
  _gridItem() {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/lookbookImagesSliderScreen');
      },
      child: FadeInImage(
        placeholder: MemoryImage(kTransparentImage),
        image: NetworkImage(
          '${faker.image.unsplash.image(keyword: 'fashion')},${Random().nextInt(100)}',
        ),
        fit: BoxFit.cover,
      ),
    );
  }

  /// Shimmer
  _shimmerItem() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withOpacity(0.2),
      highlightColor: Colors.white,
      child: Container(
        color: Colors.grey,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
