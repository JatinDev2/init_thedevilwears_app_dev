import 'package:flutter/material.dart';
import 'package:lookbook/App%20Constants/usedFunctions.dart';
import 'package:lookbook/Preferences/LoginData.dart';
import 'package:lookbook/screens/home/Explore%20Talents/shimmer_card.dart';
import 'package:lookbook/screens/home/Explore%20Talents/talent_card.dart';
import '../../../Models/ProfileModels/studentModel.dart';
import '../../../profiles/ProfileViews/studentProfileView/studentProfileView.dart';

class TalentGrid extends StatefulWidget {
  final Future<List<StudentProfile>> futureList;

  TalentGrid({Key? key, required this.futureList}) : super(key: key);
  @override
  State<TalentGrid> createState() => _TalentGridState();
}

class _TalentGridState extends State<TalentGrid> {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<StudentProfile>>(
      future: widget.futureList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting){
          return  GridView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              childAspectRatio: 3 / 3.2,
            ),
            itemCount: 8,
            itemBuilder: (context, index) {
              return ShimmerTalentCard();
            },
          );
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData) {
          return Center(child: Text("No talents found."));
        }

        List<StudentProfile> profiles = snapshot.data!;
        profiles=DisplayFunctions().sortStudentProfiles(profiles, LoginData().getUserJobProfile() ,LoginData().getUserInterests());
        return GridView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            childAspectRatio: 3 / 3.2,
          ),
          itemCount: profiles.length,
          itemBuilder: (context, index) {
            StudentProfile profile = profiles[index];
            String workString = DisplayFunctions().formatCompanyNames(profile.workExperience);

            return GestureDetector(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (_){
                  return StudentProfileView(studentProfile: profile,);
                }));
              },
              child: TalentCard(
                name: "${profile.firstName ?? 'Unknown'} ${profile.lastName ?? ''}",
                designation: profile.userDescription?.join(" • ") ?? 'No description',
                company: workString,
                imageUrl: profile.userProfilePicture!.isNotEmpty? profile.userProfilePicture : "",
                education: profile.education!=null && profile.education!.isNotEmpty ? DisplayFunctions().getLatestInstituteName(profile.education) : "No Education",
                uid: profile.userId!,
              ),
            );
          },
        );
      },
    );
  }
}
