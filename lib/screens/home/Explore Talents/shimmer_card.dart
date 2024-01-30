import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';


class ShimmerTalentCard extends StatelessWidget {
  final double avatarRadius = 48;
  final double avatarBorderWidth = 4;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: avatarRadius + avatarBorderWidth),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: <Widget>[
          // Shimmer effect for the card background
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: double.infinity,
                height: 200, // Adjust the height as needed
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // Shimmer effect for the avatar image
          Positioned(
            top: -(avatarRadius + avatarBorderWidth - 8),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: CircleAvatar(
                radius: avatarRadius,
                backgroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
