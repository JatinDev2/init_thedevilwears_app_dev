import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
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
                     child: TabBar(
                        tabs: [
                          Tab(
                            child: Text(
                              "Sourcing",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Tab(
                            child: Text(
                              "Collab",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.all(5.0),
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              Container(
                child: selectedOptions.isEmpty?
                SizedBox(
                  // height: 24,
                  width: 50,
                  child: ElevatedButton(
                    onPressed: () {
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
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24), // Adjust the radius as needed
                      ),
                    ),
                    child: Icon(
                      IconlyBold.filter,
                      size: 20,
                    ),
                  ),
                ) : Container(),
              ),
              selectedOptions.isEmpty? // Use the showListView flag to conditionally show the ListView or Wrap
              Expanded(
                child: Container(
                  height: 50,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: filterOptions.map((option) {
                      return FilterOptionChip(
                        title: option,
                        selected: selectedOptions.contains(option),
                        onTap: () {
                          toggleOption(option);
                          setState(() {
                            showListView = false;
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
              )
                  : Expanded(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ...selectedOptions.map((option) {
                      return FilterOptionChip(
                        title: option,
                        selected: true,
                        onTap: () {
                          toggleOption(option);
                        },
                      );
                    }).toList(),
                    if (selectedOptions.isNotEmpty)
                      TextButton(
                        onPressed: () {

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
                        child: Text(
                          "Modify Filters",
                          style: TextStyle(
                            color: Colors.orange,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        _buildCustomCard(),
      ],
    );
  }

  Widget _buildCollabTab(){
    return Center(
      child: Text("Collab Tab"),
    );
  }

  Widget _buildInfoColumns(String heading_text, String info_text){
    return  Expanded(
      child: Container(
        height: 50,
        child: Column(
          children: [
            Text(
              "${heading_text}",
              style: TextStyle(
                fontSize: 12,
                color: Color(0xff9A9A9A),
                fontWeight: FontWeight.bold,
              ),
            ),
            Flexible(
              child: Container(
                margin: EdgeInsets.all(4.0),
                child: Text(
                  "${info_text}",
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
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
      elevation: 2, // Adjust the elevation as per your requirement
      margin: EdgeInsets.all(16),
      child: InkWell(
        onTap: (){
          Navigator.pushNamed(context, 'listingDetailsScreen');
        },
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(13.0),
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Expanded(
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: filterOptions.map((option) {
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
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage("https://images.squarespace-cdn.com/content/v1/5a99d01c5ffd206cdde00bec/7e125d62-e859-41ff-aa04-23e4e0040a33/image-asset.jpeg?format=500w",),
                  ),
                  SizedBox(width: 6,),
                  Expanded(
                      child: Text("Tanya Ghavri", style: TextStyle(
                        color: Color(0xff0F1015),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),)
                  ),
                  Container(
                    child: Column(
                      children: [
                        Text(
                          "Required on", style: TextStyle(
                          color: Color(0xff9D9D9D),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        ),
                        Text("18 OCT",style: TextStyle(
                          color: Color(0xff0F1015),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              margin: EdgeInsets.all(8.0),
              color: Color(0xffF9F9F9),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildInfoColumns("For", "Alia Bhatt"),
                  Container(
                    margin: EdgeInsets.all(2.0),
                    height: 50,
                    width: 2,
                    color: Color(0xffB7B7B9),
                  ),
                  _buildInfoColumns("Location", "Mumbai"),
                  Container(
                    margin: EdgeInsets.all(2.0),
                    height: 50,
                    width: 2,
                    color: Color(0xffB7B7B9),
                  ),
                  _buildInfoColumns("Event", "Movie Promo"),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
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
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Text("37 mins ago", style: TextStyle(
                          fontSize: 12,
                          color: Color(0xff8B8B8B)
                      ),),
                      Spacer(),
                      IconButton(onPressed: (){}, icon: Icon(IconlyLight.send)),
                      IconButton(onPressed: (){}, icon: Icon(IconlyLight.bookmark)),
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
        margin: EdgeInsets.only(
          top: 4.0,
          left: 4.0,
          right: 4.0,
          bottom: 4.0
        ),
        padding: selected? EdgeInsets.all(0): EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: selected? Colors.transparent : Color(0xffF7F7F7),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 13,
              ),
            ),
            if (selected)
              GestureDetector(
                onTap: onTap,
                child: Icon(
                  Icons.clear,
                  size: 16,
                  color: Colors.black,
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
      margin: EdgeInsets.only(
          top: 4.0,
          left: 4.0,
          right: 4.0,
          bottom: 4.0
      ),
      padding:EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color:Color(0xffF9F9F9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
