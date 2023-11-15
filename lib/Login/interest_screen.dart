import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'insta_verification_screen.dart';

class InterestSccreen extends StatefulWidget {
  @override
  State<InterestSccreen> createState() => _InterestSccreenState();
}

class _InterestSccreenState extends State<InterestSccreen> {
  List<String> selectedOptions = [];
  final List<String> _tabs = ["Availability", "Category", "Gender", "Genre"];
   String selectedTab="";

  Map<String, List<String>> optionsData = {};
  Map<String, List<String>> selectedOptionsMap ={
    "Gender":[],
    "Category":[],
    "Availability":[],
    "Genre":[],
  };
  bool isLoading = true;

  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');



  Future<Map<String, List<String>>> fetchFiltersData() async {
    final firestore = FirebaseFirestore.instance;

    try {
      final filtersCollectionRef = firestore.collection('listing_Filters');
      final querySnapshot = await filtersCollectionRef.get();

      if (querySnapshot.docs.isNotEmpty) {
        final filtersDocument = querySnapshot.docs.first;
        final data = filtersDocument.data() as Map<String, dynamic>;
        final result = data.map((key, value) {
          if (value is List) {
            return MapEntry(key, value.cast<String>());
          }
          return MapEntry(key, <String>[]);
        });

        return result;
      } else {
        print('No documents found in the "listing_Filters" collection.');
        return {};
      }
    } catch (error) {
      print('Error fetching filters data: $error');
      return {};
    }
  }

  Widget _buildSelectedOptions(){
    return Container(
      height:selectedOptions.isNotEmpty? 60 : 0,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: selectedOptions.length,
        itemBuilder: (context, index){
          String option = selectedOptions[index];
          return Container(
            margin: const EdgeInsets.only(right: 4),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  option,
                  style: const TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: (){
                    // print("TAAAAAAAAAAPPPPPPPPPPPPPEEEEEEEEEEEDDDDDDDDDDDDDDD");
                    setState((){
                      selectedOptionsMap.forEach((key, value) {
                        if(selectedOptionsMap[key]!.contains(option)){
                          selectedOptionsMap[key]!.remove(option);
                        }
                      });
                        selectedOptions.remove(option);
                    });
                  },
                  child: SvgPicture.asset(
                    'assets/cross.svg',
                    semanticsLabel: 'My SVG Image',
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildOption(String option, String tab){
    final isSelected = selectedOptions.contains(option);
    final backgroundColor = isSelected ? Theme.of(context).colorScheme.primary : Color(0xffF7F7F7);

    return GestureDetector(
      onTap: (){
        setState((){
          if (selectedOptions.contains(option)){
            if(selectedOptionsMap[tab]!.contains(option)){
              selectedOptionsMap[tab]!.remove(option);
            }
            selectedOptions.remove(option);
          }else{
            selectedOptionsMap[tab]!.add(option);
            selectedOptions.add(option);
          }
          print(selectedOptionsMap);
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(14.0),
        ),
        margin: EdgeInsets.all(5.0),
        padding: EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              option,
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: isSelected ? Colors.white : Color(0xff303030),
                height: 18 / 12,
              ),
              textAlign: TextAlign.left,
            ),
            if (isSelected)
              GestureDetector(
                // onTap: () => toggleOption(option),
                child: Icon(
                  Icons.close,
                  size: 16,
                  color: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchFiltersData().then((value) {
      setState(() {
        optionsData = value;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 60),
                  const Text(
                    "Choose what describes\n your brand the best",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff0f1015),
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: selectedOptions.isEmpty? MediaQuery.of(context).size.height-250: MediaQuery.of(context).size.height-280,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _tabs.length,
                      itemBuilder: (BuildContext context, index) {
                        var items = optionsData[_tabs[index]] ?? [];
                        selectedTab=_tabs[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.all(5.0),
                              child: Text(
                                _tabs[index],
                                style: const TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff2d2d2d),
                                  height: 24 / 16,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Wrap(
                              spacing: 5.0,
                              runSpacing: 5.0,
                              children: items.map((option) => buildOption(option,_tabs[index])).toList(),
                            ),
                            SizedBox(height: 24),
                          ],
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildSelectedOptions(),
                GestureDetector(
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setStringList('preferences', selectedOptions).then((value) {
                      // addUser();
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                        return InstaVerification(map: selectedOptionsMap,);
                      }));
                    });
                  },
                  child: Container(
                    height: 50,
                    width: 109,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: const Center(
                      child: Text(
                        "Next",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                          height: 20 / 16,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                const Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "4",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          height: 24 / 16,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        "/5",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          height: 24 / 16,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
