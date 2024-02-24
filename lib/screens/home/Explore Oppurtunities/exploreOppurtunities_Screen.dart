import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lookbook/screens/home/Explore%20Oppurtunities/shimmer_card.dart';
import '../../../Models/ProfileModels/brandModel.dart';
import 'oppurtunities_card.dart';


class OpportunitiesGrid extends StatelessWidget {
  final Future<List<BrandProfile>> futureList;
  OpportunitiesGrid({
    required this.futureList,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BrandProfile>>(
      future: futureList,
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
              return const ShimmerCustomCard();
            },
          );
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData) {
          return const Center(child: Text("No talents found."));
        }

        List<BrandProfile> profiles = snapshot.data!;

        profiles = profiles.where((profile) => profile.userId != "FiNHu4B0uqXbRTPuZpSJjC3VvMP2").toList();

        // profiles=sortStudentProfiles(profiles, LoginData().getUserJobProfile() ,LoginData().getUserInterests());
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
            // Get the data for this index
            BrandProfile profile = profiles[index];
            // String workString = formatCompanyNames(profile.workExperience);

            return Container(
              margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 4.h),
              // padding: ,
              child: CustomCard(
                imageUrl:profile.brandProfilePicture,
                companyName: profile.brandName,
                companyType: profile.companyName,
                clothingType:profile.brandDescription.join(' • '),
                jobOpenings:profile.numberOfApplications,
                location:profile.location,
                brandId:profile.userId,
                brandProfile: profile,
              ),
            );
          },
        );
      },
    );
  }
}
