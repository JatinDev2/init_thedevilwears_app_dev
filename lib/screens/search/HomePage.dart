import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'AlphaBetScroll.dart';
import 'FiltersScreen.dart';

class SearchScreen extends StatefulWidget {
  // const SearchScreen({Key? key}) : super(key: key);
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

  List<String> yearOptions = ['All', '2022', '2023', '2024'];
  String selectedYear = 'All';

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
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 8,),
          Container(
            padding: EdgeInsets.all(16),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: Colors.black12,
              ),
              child:TextField(
                onChanged: (value) {
                  setState(() {
                    query_check = value;
                    filteredBrands = items_brands
                        .where((brand) =>
                        brand.toLowerCase().contains(value.toLowerCase()))
                        .toList();

                    filteredStylists =items_stylists
                        .where((stylist) =>
                        stylist.toLowerCase().contains(value.toLowerCase()))
                        .toList();
                  },);
                },
                decoration: InputDecoration(
                  hintText: "Search a Brand, Product, Stylist or Season",
                  hintStyle: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600
                  ),
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 1), // Adjust the value as needed
                  suffixIcon: IconButton(
                    onPressed: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (_){
                        return FiltersScreen();
                      }));
                    },
                    icon: Icon(Icons.filter_list),
                  ),
                ),

              ),
            ),
          ),
          Expanded(
            child: DefaultTabController(
              length: 3,
              child: Scaffold(
                  appBar: TabBar(
                    tabs: [
                      Tab(child: Text("Brands", style: TextStyle(
                        fontSize: 15,
                      ),),),
                      Tab(child: Text(
                        'Stylists',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),),
                      Tab(child:  Text(
                        'Seasons',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),),
                    ],
                    indicatorColor: Colors.black,
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                  ),
                body: TabBarView(
                  children: [
                    Container(
                      margin: EdgeInsets.all(8.0),
                      child: AlphaBetScrollPage(
                        height:  query_check.isEmpty
                            ?(
                            widget.height==MediaQuery.of(context).size.height
                            ? 0 : MediaQuery.of(context).size.height
                        )
                            :
                      filteredBrands.isEmpty? 0 : (
                          widget.height==MediaQuery.of(context).size.height
                              ? 0
                            : MediaQuery.of(context).size.height
                        ) ,
                        query_check: query_check,
                        onClickedItem: (item) {},
                        items: query_check.isNotEmpty?filteredBrands:items_brands,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(8.0),
                      child: AlphaBetScrollPage(
                        height:   query_check.isEmpty
                            ?(MediaQuery.of(context).viewInsets.bottom > 0
                            ? 0
                            : MediaQuery.of(context).size.height) :
                           filteredStylists.isEmpty?0 : (MediaQuery.of(context).viewInsets.bottom > 0
                            ? 0
                            : MediaQuery.of(context).size.height),
                        query_check: query_check,
                        onClickedItem: (item) {},
                        items: query_check.isNotEmpty?filteredStylists:items_stylists,
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.all(8.0),
                        child: _buildSeasonSearchResults(items_seasons)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeasonSearchResults(List<String> seasons) {
    return Builder(
      builder: (BuildContext context) {
        String? prevYear;
        List<String> filteredSeasons = seasons;

        if (query_check.isNotEmpty) {
          filteredSeasons = seasons
              .where((season) => season.toLowerCase().contains(query_check.toLowerCase()))
              .toList();
        }

        // Get the unique years from the filtered seasons
        List<String> uniqueYears = filteredSeasons
            .map((season) => season.substring(season.length - 4))
            .toSet()
            .toList();

        // Sort the years in ascending order
        uniqueYears.sort();

        // Filter seasons based on the selected year
        if (selectedYear != 'All') {
          filteredSeasons = filteredSeasons
              .where((season) => season.endsWith(selectedYear))
              .toList();
        }

        return filteredSeasons.isEmpty? Container() : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton<String>(
              value: selectedYear,
              items: yearOptions.map((String year) {
                return DropdownMenuItem<String>(
                  value: year,
                  child: Text(year),
                );
              }).toList(),
              onChanged: (String? year) {
                setState(() {
                  selectedYear = year!;
                });
              },
            ),
            SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: filteredSeasons.map((season) {
                    String year = season.substring(season.length - 4);
                    String currentYear = prevYear ?? '';

                    prevYear = year;

                    if (currentYear != year) {
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
                          Container(
                            margin: EdgeInsets.symmetric(
                              vertical: 11.0,
                              horizontal: 11.0,
                            ),
                            child: Text(
                              season,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Container(
                        margin: EdgeInsets.symmetric(
                          vertical: 11.0,
                          horizontal: 11.0,
                        ),
                        child: Text(
                          season,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      );
                    }
                  }).toList(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}