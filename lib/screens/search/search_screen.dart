import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'AlphaBetScroll.dart';
import 'FiltersScreen.dart';

class SearchScreen extends StatefulWidget {
  double height;

  SearchScreen({
    required this.height,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>{
  String query_check="";
  List<String> items_brands = [];
  List<String> items_stylists = [];
  List<String> items_seasons=[];

  List<String> filteredBrands=[];
  List<String> filteredStylists=[];
  List<String> filteredSeasons = [];


  @override
  void initState() {
    super.initState();
    setState(() {
      items_brands = generateBrandData();
      items_stylists=generateStylistsData();
      items_seasons=generateSeasons();
    });
  }

  List<String> generateBrandData() {
    List<String> brands = List.generate(260, (_) => faker.company.name());
    brands.sort();
    return brands;
  }

  List<String> generateStylistsData(){
    List<String> stylists = List.generate(260, (_) => faker.person.name());
    stylists.sort();
    return stylists;
  }

  List<String> generateSeasons() {
    List<String> seasons = [
      'Spring 2022',
      'Summer 2022',
      'Autumn 2022',
      'Winter 2022',
      'Spring 2023',
      'Summer 2023',
      'Autumn 2023',
      'Winter 2023',
      'Spring 2024',
      'Summer 2024',
      'Autumn 2024',
      'Winter 2024',
    ];
    return seasons;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        body: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top: 32,
                    bottom: 8,
                    left: 9,
                    right: 9,
                  ),
                  child: Container(
                    height: 44,
                    width: 396,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      color: Color(0xffF7F7F7),
                    ),
                    child:Container(
                      margin: EdgeInsets.only(),
                      child: TextField(
                        textAlignVertical: TextAlignVertical.center,
                        onChanged: (value) {
                          setState(() {
                            query_check = value;
                            filteredBrands = items_brands
                                .where((brand) => brand.toLowerCase().contains(value.toLowerCase()))
                                .toList();

                            filteredStylists = items_stylists
                                .where((stylist) => stylist.toLowerCase().contains(value.toLowerCase()))
                                .toList();
                          });
                        },
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 14),
                          isDense: true,
                          hintText: "Search a Brand, Product, Stylist or Season",
                          hintStyle: TextStyle(
                            fontSize: 12,
                            color: Color(0xff9D9D9D),
                          ),
                          prefixIcon: Container(
                            margin: EdgeInsets.only(left: 14, bottom: 14, top: 10),
                            child: Icon(
                              IconlyLight.search,
                              size: 18,
                              color: Color(0xFF4B4B4B),
                            ),
                          ),
                          border: InputBorder.none,
                          suffixIcon: IconTheme(
                            data: IconThemeData(color: Colors.black),
                            child: IconButton(
                              onPressed: () {
                                Navigator.pushNamed(context,'/searchFilterScreen');
                              },
                              icon: Icon(IconlyLight.filter),
                            ),
                          ),
                        ),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: DefaultTabController(
                    length: 3,
                    child: Column(
                        children: [
                    TabBar(
                    tabs: [
                    Tab(
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Text(
                        "Brands",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Text(
                        'Stylists',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Text(
                        'Seasons',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
              indicatorColor: Color(0xff282828),
              labelColor: Color(0xff282828),
              unselectedLabelColor: Color(0xff9D9D9D),
            ),
            Expanded(
              child: TabBarView(
                  children: [
              Container(
              margin: EdgeInsets.all(8.0),
              child: query_check.isNotEmpty && filteredBrands.isEmpty
                  ? Container(
                margin: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "No Search Results Found",
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xff9D9D9D),
                      ),
                    ),
                  ],
                ),
              )
                  : AlphaBetScrollPage(
                height: query_check.isEmpty
                    ? (widget.height == MediaQuery.of(context).size.height ? 0 : MediaQuery.of(context).size.height)
                    : filteredBrands.isEmpty
                    ? 0
                    : (widget.height == MediaQuery.of(context).size.height ? 0 : MediaQuery.of(context).size.height),
                query_check: query_check,
                onClickedItem: (item) {},
                items: query_check.isNotEmpty ? filteredBrands : items_brands,
              ),
            ),
            Container(
              margin: EdgeInsets.all(8.0),
              child: query_check.isNotEmpty && filteredStylists.isEmpty
                  ? Container(
                margin: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "No Search Results Found",
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xff9D9D9D),
                      ),
                    ),
                  ],
                ),
              )
                  : AlphaBetScrollPage(
                height: query_check.isEmpty
                    ? (widget.height == MediaQuery.of(context).size.height ? 0 : MediaQuery.of(context).size.height)
                    : filteredStylists.isEmpty
                    ? 0
                    : (widget.height == MediaQuery.of(context).size.height ? 0 : MediaQuery.of(context).size.height),
                query_check: query_check,
                onClickedItem: (item) {},
                items: query_check.isNotEmpty ? filteredStylists : items_stylists,
              ),
            ),
            Container(
              margin: EdgeInsets.all(8.0),
              child: _buildSeasonSearchResults(items_seasons),
            ),
    ],),),],),))],),
            GestureDetector(
              onTap: (){
                Navigator.pushNamed(context,'/searchFilterScreen');
              },
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.only(bottom: 8.0),
                  padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 24),
                  decoration: BoxDecoration(
                    color: Color(0xffFF9431),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text("Find what you're looking for", style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),),
                ),
              ),
            ),

          ],
        ));
  }


  Widget _buildSeasonSearchResults(List<String> seasons) {
    return Builder(
      builder: (BuildContext context) {
        String? prevYear;
        List<String> filteredSeasons = seasons;

        if (query_check.isNotEmpty) {
          filteredSeasons = seasons
              .where((season) =>
              season.toLowerCase().contains(query_check.toLowerCase()))
              .toList();
        }

        // Get the unique years from the filtered seasons
        List<String> uniqueYears = filteredSeasons
            .map((season) => season.substring(season.length - 4))
            .toSet()
            .toList();

        // Sort the years in descending order
        uniqueYears.sort((a, b) => b.compareTo(a));

        return query_check.isNotEmpty && filteredSeasons.isEmpty
            ? Container(
          margin: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "No Search Results Found",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xff9D9D9D),
                ),
              ),
            ],
          ),
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.all(8.0),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: uniqueYears.map((year) {
                      List<String> seasonsOfYear = filteredSeasons
                          .where((season) => season.endsWith(year))
                          .toList();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8),
                          Text(
                            year,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ...seasonsOfYear.map((season) => Container(
                            margin: EdgeInsets.symmetric(
                              vertical: 11.0,
                            ),
                            child: Text(
                              season,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          )),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}