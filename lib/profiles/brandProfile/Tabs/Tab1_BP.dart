import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lookbook/Preferences/LoginData.dart';
import 'package:shimmer/shimmer.dart';
import '../../../App Constants/colorManager.dart';
import '../../../Login/instaLogin/insta_test.dart';
import '../../../Login/instaLogin/instagram_model.dart';
import '../../../Login/instaLogin/instagram_view.dart';
import '../../../screens/jobs/createNewJobListing.dart';
import '../editBrandDetails.dart';

class Tab1_BP extends StatefulWidget {
  final VoidCallback callBackFunc;
  const Tab1_BP({super.key, required this.callBackFunc});

  @override
  State<Tab1_BP> createState() => _Tab1_BPState();
}

class _Tab1_BPState extends State<Tab1_BP> {
  late Stream<DocumentSnapshot> brandProfileStream;
  String uid = LoginData().getUserId();
  late Future<List<InstagramMedia>> instaPosts;
  String companyFoundedIn =  "";
  String companySize = "";
  String companyLocation =
      "";
  String industry = "";
  String additionalInfo =  "";


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    brandProfileStream = FirebaseFirestore.instance
        .collection('brandProfiles')
        .doc(uid)
        .snapshots();
    instaPosts = InstagramModel.fetchMedia(
        LoginData().getUserAccessToken(), LoginData().getUserInstaId());
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var cellSize = screenWidth / 3;

    return StreamBuilder<DocumentSnapshot>(
        stream: brandProfileStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text("No data found"));
          }
          var data = snapshot.data!.data() as Map<String, dynamic>;
           companyFoundedIn = data["foundedIn"] ?? "";
           companySize = data["companySize"] ?? "";
           companyLocation =
              "${data["companyLocation"] != null ? "${data["companyLocation"]}, India" : ""}";
           industry = data["industry"] ?? "";
           additionalInfo = data["additionalInfo"] ?? "";

          return SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              // color: Colors.white,
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Text(
                        "About ",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff1a1a1a),
                          height: 19 / 16,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      const Spacer(),
                      InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (_) {
                              return EditBrandProfilePage(
                                companySize: companySize,
                                companyLocationSel: companyLocation,
                                industrySel: industry,
                                foundedIn: companyFoundedIn,
                              );
                            }));
                          },
                          child: Icon(
                            Icons.edit,
                            size: 18,
                            color: Colors.black,
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  buildProfileContainer(
                      "Founded in",
                      "Company Size",
                      companyFoundedIn,
                      "${companySize.isNotEmpty ? "${companySize} employees" : ""}"),
                  SizedBox(
                    height: 8.h,
                  ),
                  buildProfileContainer(
                      "Location", "Industry", companyLocation, industry),
                  SizedBox(
                    height: 30.h,
                  ),
                  // Row(
                  //   children: [
                  //
                  //     // Text(
                  //     //   "Job Openings",
                  //     //   style: TextStyle(
                  //     //     fontFamily: "Poppins",
                  //     //     fontSize: 16,
                  //     //     fontWeight: FontWeight.w600,
                  //     //     color: Color(0xff1a1a1a),
                  //     //     height: 19/16,
                  //     //   ),
                  //     //   textAlign: TextAlign.left,
                  //     // ),
                  //     // Spacer(),
                  //     // GestureDetector(
                  //     //   onTap: (){
                  //     //     widget.callBackFunc();
                  //     //   },
                  //     //   child: const Text(
                  //     //     "View all",
                  //     //     style: TextStyle(
                  //     //       fontFamily: "Poppins",
                  //     //       fontSize: 13,
                  //     //       fontWeight: FontWeight.w400,
                  //     //       color: Color(0xfff54e44),
                  //     //       height: 19/13,
                  //     //     ),
                  //     //     textAlign: TextAlign.left,
                  //     //   ),
                  //     // ),
                  //   ],
                  // ),
                  Header(
                    label: "Job Openings",
                    number: data["numberOfApplications"],
                  ),

                  if (data["numberOfApplications"] == 1)
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (_) {
                          return CreateNewJobListing();
                        }));
                      },
                      child: Center(
                          child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: ColorsManager.lightPink,
                              ),
                              child: SvgPicture.asset("assets/work.svg"),
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          const Text(
                            "Create a new Listing",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff000000),
                              height: 19 / 14,
                            ),
                            textAlign: TextAlign.left,
                          )
                        ],
                      )),
                    ),
                  SizedBox(
                    height: 23.h,
                  ),
                  Header(label: "Additional Information"),
                  if (additionalInfo.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _buildAddChip(context,"info"),
                          const Text(
                            "Add additional information about your brand",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff9e9e9e),
                              height: 19 / 14,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                  if (additionalInfo.isNotEmpty)
                    SizedBox(
                      height: 11.h,
                    ),
                  if (additionalInfo.isNotEmpty)
                    Text(
                      additionalInfo,
                      style: const TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff5a5a5a),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  if (additionalInfo.isNotEmpty)
                    SizedBox(
                      height: 21.h,
                    ),
                  Header(label: "Social Media"),

                  // SizedBox(height: 14.h,),
                  FutureBuilder<List<InstagramMedia>>(
                    future: instaPosts,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // Display a loading indicator or shimmer effect
                        return _buildShimmerEffect(cellSize);
                      } else if (snapshot.hasError) {
                        // Handle errors
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              _buildAddChip(context,"insta"),
                              const Text(
                                "Add social media handles",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff9e9e9e),
                                  height: 19 / 14,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        // Handle no data
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              _buildAddChip(context,"insta"),
                              const Text(
                                "Add social Media handles",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff9e9e9e),
                                  height: 19 / 14,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        );

                        // Center(child: Column(
                        //   children: [
                        //     Text('Session has Expired - Please Login again'),
                        //     ElevatedButton(onPressed: (){
                        //       Navigator.of(context)
                        //           .push(MaterialPageRoute(builder: (_) {
                        //         return  InstagramView(map: {}, label: "Login",);
                        //       }));
                        //     }, child: Text("Login"))
                        //   ],
                        // ));
                      } else {
                        // Build the grid view
                        // List<String> imageUrls = snapshot.data!;
                        List<InstagramMedia> mediaList = snapshot.data!;
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, // Adjust the number of columns
                            childAspectRatio: 1, // Aspect ratio for each cell
                            crossAxisSpacing: 4.w, // Spacing between cells
                            mainAxisSpacing: 4.h, // Spacing between rows
                          ),
                          itemCount: mediaList.length,
                          itemBuilder: (context, index) {
                            return CachedNetworkImage(
                              imageUrl: mediaList[index].mediaUrl,
                              placeholder: (context, url) =>
                                  _buildShimmerEffect(cellSize),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                              fit: BoxFit.cover,
                              width: 127.w,
                              height: 127.h,
                            );
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _buildAddChip(BuildContext context, String label) {
    return Container(
      margin: const EdgeInsets.only(top: 2.0, right: 7.0, bottom: 7.0),
      child: GestureDetector(
        onTap: () {
          if(label=="info"){
            Navigator.of(context).push(MaterialPageRoute(builder: (_){
              return EditBrandProfilePage(
                companySize: companySize,
                companyLocationSel: companyLocation,
                industrySel: industry,
                foundedIn: companyFoundedIn
              );
            }));
          }
          else if(label=="insta"){
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) {
              return  InstagramView(map: {}, label: "Login",);
            }));

          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(20.0), // Stadium shape
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(
                Icons.add,
                size: 18.0,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProfileContainer(
      String head1, String head2, String data1, String data2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 75.h,
          width: 184.w,
          decoration: BoxDecoration(
            color: Color(0xffF9F9F9)
            // color: Colors.blue
            ,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                head1,
                style: const TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff171717),
                  height: 19 / 14,
                ),
                textAlign: TextAlign.left,
              ),
              Text(
                data1.isNotEmpty ? data1 : "+ Add",
                style: const TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff000000),
                  height: 19 / 12,
                ),
                textAlign: TextAlign.left,
              )
            ],
          ),
        ),
        SizedBox(
          width: 9.w,
        ),
        Container(
          height: 75.h,
          width: 184.w,
          decoration: BoxDecoration(
            color: Color(0xffF9F9F9),
            // color: Colors.orange,

            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                head2,
                style: const TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff171717),
                  height: 19 / 14,
                ),
                textAlign: TextAlign.left,
              ),
              Text(
                data2.isNotEmpty ? data2 : "+ Add",
                style: const TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff000000),
                  height: 19 / 12,
                ),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildShimmerEffect(double size) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: size,
        height: size,
        color: Colors.white,
      ),
    );
  }
}

class Header extends StatelessWidget {
  final String label;
  int? number = 0;

  Header({
    required this.label,
    this.number,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            label,
            style: const TextStyle(
              fontFamily: "Poppins",
              fontSize:
                  // (label == "Hard skills" || label == "Soft skills" ) ? 14 :
                  24,
              fontWeight:
                  // (label == "Hard skills" || label == "Soft skills")
                  //     ? FontWeight.w500
                  //     :
                  FontWeight.bold,
              color: Color(0xff1a1a1a),
              height: 19 / 16,
            ),
            textAlign: TextAlign.left,
          ),
          // IconButton(
          //   icon:
          Spacer(),
          if (label != "Additional Information" && label != "Social Media")
            IconButton(
                onPressed: () {
                  if (label == "Job Openings") {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                      return CreateNewJobListing();
                    }));
                  }
                },
                icon: const Icon(Icons.add, size: 20.0)),
        ],
      ),
    );
  }
}
