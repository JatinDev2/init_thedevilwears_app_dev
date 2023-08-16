import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

import '../../listing/Details_Screen.dart';
import '../applicationsListing.dart';

class tabTwo extends StatefulWidget {
  const tabTwo({super.key});

  @override
  State<tabTwo> createState() => _tabTwoState();
}

class _tabTwoState extends State<tabTwo> {
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
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Color(0xffF0F0F0),
        child: Column(
          children: [
            GestureDetector(
              onTap: (){
                Navigator.pushNamed(context, "/newlistingOptionsScreen");
              },
              child: Container(
                height: 65,
                width: 396,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                margin: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Add a new listing",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff0f1015),
                        height: 24/16,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(width: 7,),
                    Icon(Icons.add, size: 24, color: Colors.black,),
                  ],
                ),
              ),
            ),
            SizedBox(height: 7,),
            _buildCustomCard(),
          ],
        ),
      ),
    );
  }
  Widget _buildCustomCard(){
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: 16,
      ),
      child: InkWell(
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (_){
            return applicationsListing();
          }));
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
              // height: 50,
              // width: MediaQuery.of(context).size.width,
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
              // height: 71,
              // width: MediaQuery.of(context).size.width,
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
                  Container(
                    // height: 25,
                    // width: MediaQuery.of(context).size.width,
                    child: Row(
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
                        TextButton(onPressed: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (_){
                            return applicationsListing();
                          }));
                        }, child:
                        Text(
                          "112 Applications",
                          style: const TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.orange,
                            height: 21/14,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 12,),
                ],
              ),
            ),
          ],
        ),
      ),
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

}


