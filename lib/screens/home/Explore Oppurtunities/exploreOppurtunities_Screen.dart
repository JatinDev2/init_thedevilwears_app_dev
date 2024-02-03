import 'package:flutter/material.dart';
import 'package:lookbook/screens/home/Explore%20Oppurtunities/shimmer_card.dart';
import '../../../Models/ProfileModels/brandModel.dart';
import '../../../profiles/ProfileViews/brandProfileView/brandProfileView.dart';
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

            return InkWell(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (_){
                  return BrandProfileView(brandProfile: profile,);
                }));
              },
              child: CustomCard(
                imageUrl:"https://cdn-academyblog.pressidium.com/wp-content/uploads/2020/01/fashion-abby-yang-spring-2020-collections-8.jpg",
                companyName: profile.brandName,
                companyType: profile.companyName,
                clothingType:profile.brandDescription.join(' • '),
                jobOpenings:profile.numberOfApplications,
                location:profile.location,
                brandId:profile.userId,
              ),
            );
          },
        );
      },
    );
  }
}
