import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lookbook/Models/ProfileModels/brandModel.dart';
import '../../Models/ProfileModels/studentModel.dart';
import 'Explore Oppurtunities/exploreOppurtunities_Screen.dart';
import 'Explore Talents/exploreTalents_screen.dart';

class NewHomeScreen extends StatefulWidget{
  const NewHomeScreen({super.key});

  @override
  State<NewHomeScreen> createState() => _NewHomeScreenState();
}

class _NewHomeScreenState extends State<NewHomeScreen> {
  late Future<List<StudentProfile>> futureList;
  late Future<List<BrandProfile>> brandList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureList= fetchStudentProfiles();
    brandList=fetchBrandProfiles();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Column(
            children: [
              SizedBox(height: 16,),
              Row(
                children: [
                  const SizedBox(width: 5,),
                  SvgPicture.asset("assets/devil.svg"),
                  const SizedBox(width: 9,),
                   Text(
                    "The Devil Wears",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff000000),
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ],
          ),
          bottom: TabBar(
            unselectedLabelColor: const Color(0xff9D9D9D),
            labelColor: const Color(0xff000000),
            indicatorColor: Colors.black,
            tabs: [
              Tab(child: Text(
                "Explore Talents",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  height: 24/16,
                ),
                textAlign: TextAlign.left,
              ),),
              Tab(child: Text(
                "Explore opportunities",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  height: 24/16,
                ),
                textAlign: TextAlign.left,
              ),),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            TalentGrid(futureList: futureList,),
            OpportunitiesGrid(futureList: brandList,),
          ],
        ),
      ),
    );
  }
}