import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../listing/response_screen.dart';

class tabOne extends StatefulWidget {
  const tabOne({super.key});

  @override
  State<tabOne> createState() => _tabOneState();
}

class _tabOneState extends State<tabOne> {
  List gridItems=[];
  @override
  void initState() {
    // TODO: implement initState
    gridItems = GridItemData.generateItems();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Color(0xffF8F8F8),
          child: GridView.builder(
            itemCount: gridItems.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              childAspectRatio: 100 / 150,
            ),
            itemBuilder: (context, index) => _gridItem(index),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/searchFilterScreen');
          },
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.only(bottom: 8.0),
              padding: const EdgeInsets.symmetric(
                  vertical: 15.0, horizontal: 24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Text(
                "Find what you're looking for",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),

      ],
    );
  }
  Widget _gridItem(int index) {
    GridItemData item = gridItems[index];
    if(index==0) {
      return Container(
        height: 250,
        width: 200,
        decoration: const BoxDecoration(
          color: Color(0xffF8F8F8),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle
                ),
               child: SvgPicture.asset("assets/Pluse.svg"),
              ),
              SizedBox(height: 16,),
              const Text(
                "Create a lookbook ",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff0f1015),
                  height: 18/12,
                ),
              )
            ],
          ),
        ),
      );
    }


    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/lookbookDetailsScreen');
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: item.isSelected ? 0.6 : 1.0,
              child: FadeInImage(
                placeholder: MemoryImage(kTransparentImage),
                image: NetworkImage(item.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 13.w,
                vertical: 13.h,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.center,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black,
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    item.companyName,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


}
