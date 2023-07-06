import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:faker_dart/faker_dart.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:transparent_image/transparent_image.dart';

class CarouselWidget extends StatefulWidget {
  final List<String> images;
  final int totalImagesInCollection;
  final int thisImageIndex;
  final Function onTap;
  final bool showTopInfo;

  const CarouselWidget({
    Key? key,
    required this.images,
    this.totalImagesInCollection = 0,
    this.thisImageIndex = 0,
    required this.onTap,
    this.showTopInfo = true,
  }) : super(key: key);

  @override
  State<CarouselWidget> createState() => _CarouselWidgetState();
}

class _CarouselWidgetState extends State<CarouselWidget> {
  /// Fake data generator
  final faker = Faker.instance;

  int _currentImage = 0;
  String _singleImageUrl = '';
  bool _isSingleImage = true;

  @override
  void initState() {
    _isSingleImage = widget.images.length == 1;
    _singleImageUrl = widget.images[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onTap(),
      child: SizedBox(
        height: 600.h,
        child: Column(
          children: [
            if (widget.showTopInfo) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 10.w,
                  ),
                  Text(
                    widget.thisImageIndex.toString().padLeft(2, '0'),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text('/'),
                  Text(widget.totalImagesInCollection.toString()),
                ],
              ),
              SizedBox(
                height: 5.h,
              ),
            ],
            Expanded(
              child: _isSingleImage
                  ? FadeInImage(
                      placeholder: MemoryImage(kTransparentImage),
                      image: NetworkImage(
                        _singleImageUrl,
                      ),
                      fit: BoxFit.cover,
                    )
                  : CarouselSlider(
                      options: CarouselOptions(
                        aspectRatio: ScreenUtil().screenWidth / 530.h,
                        viewportFraction: 1,
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        autoPlay: true,
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: true,
                        scrollDirection: Axis.horizontal,
                        onPageChanged: (index, reason) => setState(() => _currentImage = index),
                      ),
                      items: List.generate(
                        widget.images.length,
                        (index) => FadeInImage(
                          placeholder: MemoryImage(kTransparentImage),
                          image: NetworkImage(widget.images[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
            ),
            SizedBox(
              height: 5.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                /// Show only when images are multiple
                if (!_isSingleImage) ...[
                  SizedBox(
                    width: 80.w,
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 10.h,
                          child: ListView.builder(
                            itemCount: widget.images.length,
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              if (_currentImage == index) {
                                return UnconstrainedBox(
                                  child: Container(
                                    width: 20.w,
                                    height: 5.h,
                                    margin: EdgeInsets.symmetric(horizontal: 2.w),
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(5.r),
                                    ),
                                  ),
                                );
                              }

                              return Container(
                                width: 5.w,
                                height: 5.w,
                                margin: EdgeInsets.symmetric(horizontal: 2.w),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey,
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ],
                Icon(
                  IconlyLight.bookmark,
                  size: 20,
                ),
                SizedBox(
                  width: 15.w,
                ),
                Icon(
                  IconlyLight.send,
                  size: 20,
                ),
                SizedBox(
                  width: 15.w,
                ),
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
          ],
        ),
      ),
    );
  }
}
