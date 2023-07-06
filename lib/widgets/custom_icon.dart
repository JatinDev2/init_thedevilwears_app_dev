import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CustomIcon extends StatelessWidget {
  final IconData selectedIcon;

  const CustomIcon({
    Key? key,
    required this.selectedIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Icon(selectedIcon),
        ),
        SizedBox(
          height: 5,
        ),
        CircleAvatar(
          radius: 2,
          backgroundColor: Colors.black,
        ),
      ],
    );
  }
}