import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomFilterChip extends StatefulWidget {
  final String text;
  final bool isSelected;
  final Function onTap;
  const CustomFilterChip({Key? key, required this.text, required this.isSelected, required this.onTap}) : super(key: key);

  @override
  State<CustomFilterChip> createState() => _CustomFilterChipState();
}

class _CustomFilterChipState extends State<CustomFilterChip> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onTap(),
      child: Container(
        height: 35.h,
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.w),
        margin: EdgeInsets.only(right: 10.w),
        decoration: BoxDecoration(
          color: widget.isSelected ? Colors.black : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(25.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.text,
              style: TextStyle(
                color: widget.isSelected ? Colors.white : Colors.black,
              ),
            ),
            if (widget.isSelected) ...[
              SizedBox(
                width: 10.w,
              ),
              const Icon(
                Icons.close,
                color: Colors.white,
                size: 15,
              )
            ]
          ],
        ),
      ),
    );
  }
}
