import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MiniExpandableText extends StatefulWidget {
  final String header;
  final String content;

  const MiniExpandableText({
    Key? key,
    required this.header,
    required this.content,
  }) : super(key: key);

  @override
  State<MiniExpandableText> createState() => _MiniExpandableTextState();
}

class _MiniExpandableTextState extends State<MiniExpandableText> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: GestureDetector(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.header,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Icon(
                  _isExpanded ? Icons.minimize : Icons.add,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 8.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: _isExpanded
              ? Text(
                  widget.content,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey,
                  ),
                )
              : Container(),
        ),
      ],
    );
  }
}
