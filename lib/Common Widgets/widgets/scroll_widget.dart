import 'dart:math';

import 'package:alphabet_list_view/alphabet_list_view.dart';
import 'package:faker_dart/faker_dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScrollWidget extends StatefulWidget {
  final List<String> data;

  const ScrollWidget({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<ScrollWidget> createState() => _ScrollWidgetState();
}

class _ScrollWidgetState extends State<ScrollWidget> {
  final _chars = [];
  List<AlphabetListViewItemGroup> _items = [];
  Faker faker = Faker.instance;

  @override
  Widget build(BuildContext context) {
    for (var element in widget.data) {
      if (!_chars.contains(element[0])) {
        _chars.add(element[0]);
      }
    }

    _items = _chars
        .map(
          (e) => AlphabetListViewItemGroup(
            tag: e,
            children: List.generate(
              widget.data.where((element) => element.startsWith(e)).length,
              (index) => Container(
                padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 15.w),
                child: Text(
                  widget.data.where((element) => element.startsWith(e)).toList()[index],
                  style: TextStyle(
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),
          ),
        )
        .toList();

    return AlphabetListView(
      items: _items,
      options: AlphabetListViewOptions(
        listOptions: ListOptions(
          physics: const BouncingScrollPhysics(),
          listHeaderBuilder: (context, symbol) {
            return Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
              child: Text(
                symbol,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.sp,
                ),
              ),
            );
          },
        ),
        scrollbarOptions: ScrollbarOptions(
          padding: const EdgeInsets.all(0),
          symbolBuilder: (context, data, state) {
            /// Show when state is Active
            if (state == AlphabetScrollbarItemState.active) {
              return Text(
                data,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              );
            }

            return Text(
              data,
              style: TextStyle(fontSize: 12.sp),
              textAlign: TextAlign.center,
            );
          },
        ),
        overlayOptions: const OverlayOptions(
          showOverlay: false,
        ),
      ),
    );
  }
}
