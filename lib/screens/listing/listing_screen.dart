import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lookbook/screens/listing/FiltersScreen_Listing.dart';

import 'Details_Screen.dart';

class ListingScreen extends StatefulWidget {
  @override
  State<ListingScreen> createState() => _ListingScreenState();
}

class _ListingScreenState extends State<ListingScreen> {
  List<String> selectedOptions = [];
  bool showListView = true;
  List<String> filterOptions = [
    'Clothing',
    'Shoes',
    'Accessories',
    'Bags',
    'Jewelry',
    'Birthday',
    'Anniversary',
    'Graduation',
    'Holiday',
    'Prom',
    'Movie Promotions',
    'Shoots',
    'Events',
    'Concerts',
    'Weddings',
    'Public Appearances',
  ];

  List<String> filterCopyOptions = [
    'Clothing',
    'Shoes',
    'Accessories',
    'Bags',
    'Jewelry',
    'Birthday',
    'Anniversary',
    'Graduation',
    'Holiday',
    'Prom',
    'Movie Promotions',
    'Shoots',
    'Events',
    'Concerts',
    'Weddings',
    'Public Appearances',
  ];

  void toggleOption(String option) {
    setState(() {
      if (selectedOptions.contains(option)) {
        selectedOptions.remove(option);
      } else {
        selectedOptions.add(option);
      }
    });
  }
  @override

    Widget build(BuildContext context) {
      return Scaffold(
        body: DefaultTabController(
          length: 2,
          child:Container(
            color: Colors.white,
            child: Column(
                 children: [
                   SizedBox(height: 13,),
                   Container(
                     color: Colors.white,
                     child: const TabBar(
                        tabs: [
                          Tab(
                            child: Text(
                              "Sourcing",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                height: 24/16,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Tab(
                            child: Text(
                              "Collab",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                height: 24/16,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      indicatorColor: Color(0xff282828),
                      labelColor: Color(0xff282828),
                      unselectedLabelColor: Color(0xff9D9D9D),
                      ),
                   ),
               Expanded(
                 child: Container(
                   color: Colors.white,
                   child: TabBarView(
                    children: [
                      _buildSourceTab(),
                      _buildCollabTab(),
                    ],
              ),
                 ),
               ),
    ],),
          ),

        ),
      );
    }

  Widget _buildSourceTab(){
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.all(5.0),
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Container(
                    child: SizedBox(
                      // height: 24,
                      width: 45,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/listingFilterScreen',
                            arguments: selectedOptions,
                          ).then((data){
                            if(data !=null){
                              setState(() {
                                selectedOptions=data as List<String>;
                              });
                            }
                          });
                        },
                        child:  Container(
                          height: 30,
                          padding: const EdgeInsets.all(3.0),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                           borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: SvgPicture.asset(
                            'assets/Filter.svg',
                            semanticsLabel: 'My SVG Image',
                            height: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // selectedOptions.isEmpty? // Use the showListView flag to conditionally show the ListView or Wrap
                  Expanded(
                    child: Container(
                      height: 50,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: filterOptions.map((option){
                          return FilterOptionChip(
                            title: option,
                            selected: selectedOptions.contains(option),
                            onTap: () {
                              // toggleOption(option);
                              setState(() {
                                if(filterOptions.isNotEmpty){
                                  filterOptions.remove(option);
                                  selectedOptions.add(option);
                                }
                                // showListView = false;
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if(selectedOptions.isNotEmpty)
            Container(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: selectedOptions.map((option){
                  return FilterOptionChip(
                    title: option,
                    selected: true,
                    onTap: () {
                      setState(() {
                        if (selectedOptions.contains(option)) {
                          selectedOptions.remove(option);
                          filterOptions.insert(0, option);
                          // filterOptions.add(option);
                        }
                        // else {
                        //   selectedOptions.add(option);
                        // }
                      });
                      // toggleOption(option);
                    },
                  );
                }).toList(),
              ),
            ),

            // Wrap(
            //   spacing: 8,
            //   runSpacing: 8,
            //   children: [
            //     ...selectedOptions.map((option){
            //       return FilterOptionChip(
            //         title: option,
            //         selected: true,
            //         onTap: () {
            //           setState(() {
            //             if (selectedOptions.contains(option)) {
            //               selectedOptions.remove(option);
            //               filterOptions.insert(0, option);
            //               // filterOptions.add(option);
            //             }
            //             // else {
            //             //   selectedOptions.add(option);
            //             // }
            //           });
            //           // toggleOption(option);
            //         },
            //       );
            //     }).toList(),
            //   ],
            // ),

            _buildCustomCard(),
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: (){
              Navigator.pushNamed(context, '/newlistingOptionsScreen');
            },
            child: Container(
              height: 50,
              width: 170,
              margin: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: const Center(
                child: Text("Create a listing", style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                  ),),
              ),

            ),
          ),
        ),

      ],
    );
  }

  Widget _buildCollabTab(){
    return const Center(
      child: Text("Collab Tab"),
    );
  }

  Widget _buildInfoColumns(String heading_text, String info_text){
    return  Expanded(
      child: Container(
        height: 40,
        child: Column(
          children: [
            Text(
              heading_text,
                style: const TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff9a9a9a),
                  height: 18/12,
                ),
            ),
            Flexible(
              child: Container(
                margin: const EdgeInsets.all(4.0),
                child: Text(
                  info_text,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style:const TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff424242),
                ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomCard(){
    return Card(
      elevation: 2,
      margin: EdgeInsets.all(16),
      child: InkWell(
        onTap: (){
          Navigator.pushNamed(context, 'listingDetailsScreen');
        },
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(2.0),
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Expanded(
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: filterCopyOptions.map((option) {
                        return OptionChipDisplay(
                          title: option,
                        );
                      }).toList(),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage("https://images.squarespace-cdn.com/content/v1/5a99d01c5ffd206cdde00bec/7e125d62-e859-41ff-aa04-23e4e0040a33/image-asset.jpeg?format=500w",),
                  ),
                  const SizedBox(width: 6,),
                  const Expanded(
                      child: Text(
                        "Tanya Ghavri",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff0f1015),
                          height: 20/18,
                        ),
                        textAlign: TextAlign.left,
                      )
                  ),
                  Container(
                    child: Column(
                      children: const [
                        Text(
                          "Required on ",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff0f1015),
                          ),
                        ),
                        Text(
                          "18 Oct",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff0f1015),
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.all(8.0),
              color: const Color(0xffF9F9F9),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildInfoColumns("For", "Alia Bhatt"),
                  Container(
                    margin: const EdgeInsets.all(2.0),
                    height: 50,
                    width: 2,
                    color: const Color(0xffB7B7B9),
                  ),
                  _buildInfoColumns("Location", "Mumbai"),
                  Container(
                    margin: const EdgeInsets.all(2.0),
                    height: 50,
                    width: 2,
                    color: const Color(0xffB7B7B9),
                  ),
                  _buildInfoColumns("Event", "Movie Promo"),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: const TextSpan(
                      text: 'Requirements',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff2F2F2F),
                      ),
                      children: [
                        TextSpan(
                          text: ' A mustard yellow traditional outfit is required for Alia Bhatt for her new movie promotions. The fabric...',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            color: Color(0xff424242),
                          ),
                        ),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text(
                        "37 mins ago ",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff8b8b8b),
                          height: 18/12,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      const Spacer(),
                      IconButton(onPressed: (){}, icon: const Icon(IconlyLight.send)),
                      IconButton(onPressed: (){}, icon: const Icon(IconlyLight.bookmark)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }



}

class FilterOptionChip extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const FilterOptionChip({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin:  EdgeInsets.only(
          top: 9.0,
          left: selected? 3.0 : 6.0,
          right: selected? 3.0 : 6.0,
          bottom: 9.0
        ),
        padding: selected?const EdgeInsets.symmetric(horizontal: 10,
        // vertical: 1,
        ): const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        decoration: BoxDecoration(
          color: selected?  Colors.orange: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 12,
                fontWeight:selected? FontWeight.w700 : FontWeight.w400,
                color: selected? Colors.white : Color(0xff303030),
                height: 18/12,
              ),
            ),
            if (selected)
              GestureDetector(
                onTap: onTap,
                child: const Icon(
                  Icons.clear,
                  size: 16,
                  color: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }
}


class OptionChipDisplay extends StatelessWidget {
  final String title;

  OptionChipDisplay({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      margin: const EdgeInsets.only(
          top: 9.0,
          left: 6.0,
          right: 6.0,
          bottom: 9.0
      ),
      padding:const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color:const Color(0xffF7F7F7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: "Poppins",
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xff303030),
              height: 18/12,
            ),
          ),
        ],
      ),
    );
  }
}
