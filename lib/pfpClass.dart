import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';

class StudentProfilePicClass extends StatelessWidget {
  final String imgUrl;
  const StudentProfilePicClass({super.key, required this.imgUrl});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      shape: const CircleBorder(),
      clipBehavior: Clip.none,
      child: CircleAvatar(
        radius: 25,
        backgroundColor: imgUrl.isNotEmpty? Colors.white : Colors.transparent,
        child: imgUrl != null && imgUrl.isNotEmpty
            ? CachedNetworkImage(
          imageUrl: imgUrl!, // Actual image URL
          placeholder: (context, url) => Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.white,
            ),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
          imageBuilder: (context, imageProvider) => CircleAvatar(
            radius: 25,
            backgroundImage: imageProvider,
          ),
        )
            : CircleAvatar( // Fallback to asset image
          radius: 25,
          backgroundColor: Colors.transparent,
          child: SvgPicture.asset("assets/devil.svg", fit: BoxFit.cover, height: 80, width: 80,), // Provide the path to your asset image
        ),
      ),
    );
  }
}


class BrandProfilePicClass extends StatelessWidget {
  final String imgUrl;
  const BrandProfilePicClass({super.key, required this.imgUrl});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      shape: const CircleBorder(),
      clipBehavior: Clip.none,
      child: CircleAvatar(
        radius: 20,
        backgroundColor: imgUrl.isNotEmpty? Colors.white : Colors.transparent,
        child: imgUrl != null && imgUrl.isNotEmpty
            ? CachedNetworkImage(
          imageUrl: imgUrl!, // Actual image URL
          placeholder: (context, url) => Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
            ),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
          imageBuilder: (context, imageProvider) => CircleAvatar(
            radius: 20,
            backgroundImage: imageProvider,
          ),
        )
            : CircleAvatar( // Fallback to asset image
          radius: 20,
          backgroundColor: Colors.transparent,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset("assets/brand.png", fit: BoxFit.cover, height: 80, width: 80,)), // Provide the path to your asset image
        ),
      ),
    );
  }
}