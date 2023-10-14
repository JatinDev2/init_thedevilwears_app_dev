import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_svg/svg.dart';

class FiltersScreen extends StatefulWidget {
  @override
  _FiltersScreenState createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  String _selectedTab = 'Gender';
  bool isLoading = true;
  List catOptions=[];
  int count = 0;
  bool isQuery = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData().then((value) {
      setState(() {
        isLoading = false;
      });
    });
  }

  final List<String> _filterTabs = [
    'Gender',
    'Size',
    'Colour',
    'Availability',
    'Category',
    'Crafts',
    'Genre',
    'Type',
  ];

  void _clearAllFilters() {
    setState(() {
      _selectedOptions.clear();
      catOptions.clear();
      _selectedOptionMap = {
        "Gender":[],
        "Size":[],
        "Colour":[],
        "Availability":[],
        "Category":{
          "Clothing":[],
          "Jewellery":[],
          "Footwear":[],
          "Accessories":[],
          "Bags":[],
        },
        "Crafts":{
          "Print":[],
          "Tie & Dye":[],
          "Embroidery":[],
          "Weave":[],
        },
        "Genre":{
          "Clothing":[],
          "Jewellery":[],
          "Footwear":[],
          "Accessories":[],
          "Bags":[],
        },
        "Type":{
          "Clothing":[],
          "Jewellery":[],
          "Footwear":[],
          "Bags":[],
        },
      };
    });
  }

   Map<String, dynamic> _selectedOptionMap = {
    "Gender":[],
    "Size":[],
    "Colour":[],
    "Availability":[],
    "Category":{
      "Clothing":[],
      "Jewellery":[],
      "Footwear":[],
      "Accessories":[],
      "Bags":[],
    },
    "Crafts":{
      "Print":[],
      "Tie & Dye":[],
      "Embroidery":[],
      "Weave":[],
    },
    "Genre":{
      "Clothing":[],
      "Jewellery":[],
      "Footwear":[],
      "Accessories":[],
      "Bags":[],
    },
    "Type":{
      "Clothing":[],
      "Jewellery":[],
      "Footwear":[],
      "Bags":[],
    },
  };

  Map<String, dynamic> filterData = {};

  Future<void> fetchData() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('Filters').get();
      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
        filterData = documentSnapshot.data() as Map<String, dynamic>;
      } else {
        print('No documents found in the "Filters" collection');
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  bool isClothing = true;
  bool isJewellery = false;
  bool isFootwear = false;
  bool isAccessories = false;
  bool isBags = false;

  final List _selectedOptions = [];
  Map filteredItems = {};

  Widget _buildFilterTabs(){
    return Container(
      height: _selectedOptions.isEmpty
          ? MediaQuery.of(context).size.height - 150
          : MediaQuery.of(context).size.height - 220,
      child: ListView.builder(
        itemCount: _filterTabs.length,
        itemBuilder: (context, index){
          String tab = _filterTabs[index];
          // int selectedOptionsCount = _getSelectedOptionsCount(tab);
          int selectedOptionsCount = _getSelectedOptionsCount(tab);
          return Container(
            decoration: BoxDecoration(
              color:
                  _selectedTab == tab ? Colors.white : const Color(0xffEFEFEF),
              border: const Border(
                bottom: BorderSide(
                  color: Color(0xFFDDDDDD),
                  width: 1.0,
                ),
              ),
            ),
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    tab,
                    style: const TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff4a4a4a),
                      height: 20 / 16,
                    ),
                  ),
                  // SizedBox(width: 5),
                  if (selectedOptionsCount > 0)
                    Container(
                      padding: const EdgeInsets.all(4),
                      child: Text(
                        selectedOptionsCount.toString(),
                        style: const TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff4a4a4a),
                          height: 28 / 14,
                        ),
                      ),
                    ),
                ],
              ),
              onTap: () {
                setState(() {
                  _selectedTab = tab;
                });
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterOptions(){
    var options = filterData[_selectedTab] ?? [];
    if (_selectedTab == "Availability" ||
        _selectedTab == "Gender" ||
        _selectedTab == "Size"){
      return Container(
        height: _selectedOptions.isEmpty
            ? MediaQuery.of(context).size.height - 150
            : MediaQuery.of(context).size.height - 220,
        child: ListView.builder(
          itemCount: options.length,
          itemBuilder: (context, index) {
            String option = options[index];
            bool isSelected = _selectedOptions.contains(option);
            return ListTile(
              onTap: () {
                setState(() {
                  if (isSelected){
                    // _selectedOptions.remove(option);
                    // _selectedOptions.contains(option);
                    if(_selectedOptions.contains(option)){
                      _selectedOptions.remove(option);
                    }
                  }
                  else {
                    _selectedOptions.add(option);
                  }
                });
              },
              title: Row(
                children: [
                  const SizedBox(
                    width: 8,
                  ),
                  Icon(
                    isSelected ? Icons.check : null,
                    color: Colors.black,
                    size: 17,
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Text(
                    option,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w300,
                      color: const Color(0xff3c3c3c),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    }

    else if (_selectedTab == "Category" ||
        _selectedTab == "Genre" ||
        _selectedTab == "Type") {
      var data;
      void _updateFilteredData(String searchText) {
        setState(() {
          filteredItems.clear();
          data.forEach((category, items) {
            if (category.toLowerCase().contains(searchText.toLowerCase())) {
              filteredItems[category] = items;
            }
            if (items.isNotEmpty) {
              List filteredItemsList = items
                  .where((item) => item
                      .toLowerCase()
                      .contains(searchText.toLowerCase()) as bool)
                  .toList();
              if (filteredItemsList.isNotEmpty) {
                filteredItems[category] = filteredItemsList;
              }
            }
          });
        });
      }

      if (isAccessories && _selectedTab != "Type") {
        setState(() {
          data = options["Accessories"];
          _updateFilteredData(searchController.text);
        });
      }
      else if (isClothing) {
        setState(() {
          data = options["Clothing"];
          _updateFilteredData(searchController.text);
        });
      }
      else if (isJewellery) {
        setState(() {
          data = options["Jewellery"];
          _updateFilteredData(searchController.text);
        });
      }
      else if (isFootwear) {
        setState(() {
          data = options["Footwear"];
          _updateFilteredData(searchController.text);
          // print(data);
        });
      }
      else {
        setState(() {
          data = options["Bags"];
          _updateFilteredData(searchController.text);
        });
      }

      String check() {
        if (isAccessories) {
          return "Search Accessories";
        } else if (isJewellery) {
          return "Search Jewellery";
        } else if (isFootwear) {
          return "Search Footwear";
        } else if (isClothing) {
          return "Search Clothing";
        } else if (isBags) {
          return "Search Bags";
        } else {
          return "Search";
        }
      }

      String getStr() {
        if (isAccessories) {
          return "Accessories";
        } else if (isJewellery) {
          return "Jewellery";
        } else if (isFootwear) {
          return "Footwear";
        } else if (isClothing) {
          return "Clothing";
        } else if (isBags) {
          return "Bags";
        } else {
          return "Search";
        }
      }
      return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isClothing = true;
                      isJewellery = false;
                      isFootwear = false;
                      isAccessories = false;
                      isBags = false;
                    });
                  },
                  child: Container(
                    child: isClothing
                        ? SvgPicture.asset("assets/clothingC.svg")
                        : SvgPicture.asset("assets/clothing.svg"),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isClothing = false;
                      isJewellery = true;
                      isFootwear = false;
                      isAccessories = false;
                      isBags = false;
                    });
                  },
                  child: Container(
                    child: isJewellery
                        ? SvgPicture.asset("assets/jewelleryC.svg")
                        : SvgPicture.asset("assets/jewellery.svg"),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isClothing = false;
                      isJewellery = false;
                      isFootwear = true;
                      isAccessories = false;
                      isBags = false;
                    });
                  },
                  child: Container(
                    child: isFootwear
                        ? SvgPicture.asset("assets/footwearC.svg")
                        : SvgPicture.asset("assets/footwear.svg"),
                  ),
                ),
                if (_selectedTab != "Type")
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isClothing = false;
                        isJewellery = false;
                        isFootwear = false;
                        isAccessories = true;
                        isBags = false;
                      });
                    },
                    child: Container(
                      child: isAccessories
                          ? SvgPicture.asset("assets/accessoriesC.svg")
                          : SvgPicture.asset("assets/accessories.svg"),
                    ),
                  ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isClothing = false;
                      isJewellery = false;
                      isFootwear = false;
                      isAccessories = false;
                      isBags = true;
                    });
                  },
                  child: Container(
                    child: isBags
                        ? SvgPicture.asset("assets/bagsC.svg")
                        : SvgPicture.asset("assets/bags.svg"),
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(
                left: 10.0,
                right: 10.0,
                top: 10.0,
                bottom: 5.0,
              ),
              height: 50,
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    IconlyLight.search,
                    size: 18,
                    color: Color(0xFF4B4B4B),
                  ),
                  hintText: check(),
                  hintStyle: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 14,
                    color: Color(0xffaaaaaa),
                  ),
                ),
                controller: searchController,
                onChanged: (searchIn){
                  setState((){
                    if (searchIn.isNotEmpty) {
                      isQuery = true;
                    } else {
                      isQuery = false;
                    }
                    _updateFilteredData(searchIn);
                  });
                },
              ),
            ),
            Container(
              height: catOptions.isEmpty || _selectedOptions.isEmpty
                  ? MediaQuery.of(context).size.height - 250
                  : MediaQuery.of(context).size.height - 315,
              child: filteredItems.isEmpty && isQuery
                  ? Container(
                      child: Text("No reslts"),
                    )
                  : ListView(
                      children: filteredItems.isNotEmpty && isQuery
                          ? filteredItems.entries.map<Widget>((entry){
                              String category = entry.key;
                              // print(category);
                              List<String> items = List<String>.from(entry.value);
                              // print(items);
                              if (category != "data" && items.isNotEmpty) {
                                return ExpansionTile(
                                  title: Row(
                                    children: [
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Icon(
                                        items.any((item) =>
                                                _selectedOptionMap[_selectedTab][getStr()].contains(item))
                                            ? Icons.check
                                            : null,
                                        size: 17,
                                      ),
                                      const SizedBox(
                                        width: 13,
                                      ),
                                      Expanded(
                                        child: Text(
                                          category,
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight:   items.any((item) =>
                                                _selectedOptionMap[_selectedTab][getStr()].contains(item))
                                                ? FontWeight.w600
                                                : FontWeight.w300,
                                            color: Color(0xff3c3c3c),
                                          ),
                                          softWrap: true,
                                          maxLines: null,
                                        ),
                                      ),
                                    ],
                                  ),
                                  trailing: Icon(
                                    Icons.chevron_right_rounded,
                                    color: Colors.black,
                                  ),
                                  children: [
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: items.length,
                                      itemBuilder: (context, index){
                                        String option = items[index];
                                        bool isSelected =
                                        items.any((item) =>
                                            _selectedOptionMap[_selectedTab][getStr()].contains(option));
                                        return ListTile(
                                          onTap: () {
                                            setState(() {
                                              if (isSelected){
                                                _selectedOptionMap[_selectedTab][getStr()].remove(option);
                                                if(catOptions.contains(option)){
                                                  catOptions.remove(option);
                                                }
                                                if(_selectedOptions.contains(option)){
                                                  _selectedOptions.remove(option);
                                                }
                                                // _selectedOptions.remove(option);
                                              }
                                              else {
                                                _selectedOptionMap[_selectedTab][getStr()].add(option);
                                                if(!_selectedOptions.contains(option)){
                                                  _selectedOptions.add(option);
                                                }
                                                // _selectedOptions.add(option);
                                              }
                                            });
                                          },
                                          title: Row(
                                            children: [
                                              const SizedBox(
                                                width: 15,
                                              ),
                                              Icon(
                                                isSelected ? Icons.check : null,
                                                color: Colors.black,
                                                size: 17,
                                              ),
                                              SizedBox(
                                                width: 16,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  option,
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: isSelected
                                                        ? FontWeight.w600
                                                        : FontWeight.w300,
                                                    color:
                                                        const Color(0xff3c3c3c),
                                                  ),
                                                  maxLines: null,
                                                  softWrap: true,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                );
                              } else {
                                return ListTile(
                                  onTap: () {
                                    setState(() {
                                      if (_selectedOptionMap[_selectedTab][getStr()].contains(category)){
                                        _selectedOptionMap[_selectedTab][getStr()].remove(category);
                                        if(catOptions.contains(category)){
                                          catOptions.remove(category);
                                        }
                                        if(_selectedOptions.contains(category)){
                                          _selectedOptions.remove(category);
                                        }
                                        // _selectedOptions.remove(option);
                                      }
                                      else {
                                        _selectedOptionMap[_selectedTab][getStr()].add(category);
                                        if(!_selectedOptions.contains(category)){
                                          _selectedOptions.add(category);
                                        }
                                      }
                                    });
                                  },
                                  title: Row(
                                    children: [
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Icon(
                                        _selectedOptionMap[_selectedTab][getStr()].contains(category)
                                            ? Icons.check
                                            : null,
                                        color: Colors.black,
                                        size: 17,
                                      ),
                                      SizedBox(
                                        width: 16,
                                      ),
                                      Expanded(
                                        child: Text(
                                          category,
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight:  _selectedOptionMap[_selectedTab][getStr()].contains(category)
                                                ? FontWeight.w600
                                                : FontWeight.w300,
                                            color: const Color(0xff3c3c3c),
                                          ),
                                          maxLines: null,
                                          softWrap: true,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            }).toList()
                          : data.entries.map<Widget>((entry) {
                              String category = entry.key;
                              // print(category);
                              List<String> items = List<String>.from(entry.value);
                              // print(items);
                              if (category != "data" && items.isNotEmpty) {
                                return ExpansionTile(
                                  title: Row(
                                    children: [
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Icon(
                                        items.any((item) =>
                                            _selectedOptionMap[_selectedTab][getStr()].contains(item))
                                            ? Icons.check
                                            : null,
                                        size: 17,
                                      ),
                                      const SizedBox(
                                        width: 13,
                                      ),
                                      Expanded(
                                        child: Text(
                                          category,
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: items.any((item) =>
                                                _selectedOptionMap[_selectedTab][getStr()].contains(item))
                                                ? FontWeight.w600
                                                : FontWeight.w300,
                                            color: Color(0xff3c3c3c),
                                          ),
                                          softWrap: true,
                                          maxLines: null,
                                        ),
                                      ),
                                    ],
                                  ),
                                  trailing: Icon(
                                    Icons.chevron_right_rounded,
                                    color: Colors.black,
                                  ),
                                  children: [
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: items.length,
                                      itemBuilder: (context, index) {
                                        String option = items[index];
                                        bool isSelected =
                                        items.any((item) =>
                                            _selectedOptionMap[_selectedTab][getStr()].contains(option));
                                        return ListTile(
                                          onTap: () {
                                            setState(() {
                                              if (isSelected){
                                                _selectedOptionMap[_selectedTab][getStr()].remove(option);
                                                if(catOptions.contains(option)){
                                                  catOptions.remove(option);
                                                }
                                                if(_selectedOptions.contains(option)){
                                                  _selectedOptions.remove(option);
                                                }
                                                // _selectedOptions.remove(option);
                                              }
                                              else {
                                                _selectedOptionMap[_selectedTab][getStr()].add(option);
                                                if(!_selectedOptions.contains(category)){
                                                  _selectedOptions.add(category);
                                                }
                                              }
                                            });
                                          },
                                          title: Row(
                                            children: [
                                              const SizedBox(
                                                width: 15,
                                              ),
                                              Icon(
                                                isSelected ? Icons.check : null,
                                                color: Colors.black,
                                                size: 17,
                                              ),
                                              SizedBox(
                                                width: 16,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  option,
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: isSelected
                                                        ? FontWeight.w600
                                                        : FontWeight.w300,
                                                    color:
                                                        const Color(0xff3c3c3c),
                                                  ),
                                                  maxLines: null,
                                                  softWrap: true,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                );
                              } else {
                                return ListTile(
                                  onTap: () {
                                    setState(() {
                                      if (_selectedOptionMap[_selectedTab][getStr()].contains(category)){
                                        _selectedOptionMap[_selectedTab][getStr()].remove(category);
                                        if(catOptions.contains(category)){
                                          catOptions.remove(category);
                                        }
                                        if(_selectedOptions.contains(category)){
                                          _selectedOptions.remove(category);
                                        }
                                        // _selectedOptions.remove(option);
                                      }
                                      else {
                                        _selectedOptionMap[_selectedTab][getStr()].add(category);
                                        if(!_selectedOptions.contains(category)){
                                          _selectedOptions.add(category);
                                        }
                                      }
                                    });
                                  },
                                  title: Row(
                                    children: [
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Icon(
                                        _selectedOptionMap[_selectedTab][getStr()].contains(category)
                                            ? Icons.check
                                            : null,
                                        color: Colors.black,
                                        size: 17,
                                      ),
                                      SizedBox(
                                        width: 16,
                                      ),
                                      Expanded(
                                        child: Text(
                                          category,
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight:_selectedOptionMap[_selectedTab][getStr()].contains(category)
                                                ? FontWeight.w600
                                                : FontWeight.w300,
                                            color: const Color(0xff3c3c3c),
                                          ),
                                          maxLines: null,
                                          softWrap: true,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            }).toList(),
                    ),
            ),
          ],
        ),
      );
    }
    else if (_selectedTab == "Crafts"){
      return Container(
        height: _selectedOptions.isEmpty
            ? MediaQuery.of(context).size.height - 150
            : MediaQuery.of(context).size.height - 220,
        child: ListView(
          children: options.entries.map<Widget>((entry) {
            String category = entry.key;
            // print(category);
            List<String> items = List<String>.from(entry.value);
            // print(items);
            if (category != "data" && items.isNotEmpty) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.only(
                        top: 20.0,
                      ),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 40,
                          ),
                          Text(
                            category,
                            style: const TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xffaaaaaa),
                            ),
                            softWrap: true,
                            maxLines: null,
                          ),
                        ],
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      String option = items[index];
                      bool isSelected = _selectedOptions.contains(option);
                      return ListTile(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              _selectedOptions.remove(option);
                              if(catOptions.contains(option)){
                                catOptions.remove(option);
                              }
                            } else {
                              if(!_selectedOptions.contains(option)){
                                _selectedOptions.add(option);
                              }
                            }
                          });
                        },
                        title: Row(
                          children: [
                            Icon(
                              isSelected ? Icons.check : null,
                              color: Colors.black,
                              size: 17,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: Text(
                                option,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w300,
                                  color: const Color(0xff3c3c3c),
                                ),
                                maxLines: null,
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              );
            } else {
              return ListTile(
                onTap: () {
                  setState(() {
                    if (_selectedOptions.contains(category)) {
                      _selectedOptions.remove(category);
                      if(catOptions.contains(category)){
                        catOptions.remove(category);
                      }
                    } else {
                      if(!_selectedOptions.contains(category)){
                        _selectedOptions.add(category);
                      }
                    }
                  });
                },
                title: Row(
                  children: [
                    const SizedBox(
                      width: 8,
                    ),
                    Icon(
                      _selectedOptions.contains(category) ? Icons.check : null,
                      color: Colors.black,
                      size: 17,
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: Text(
                        category,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: _selectedOptions.contains(category)
                              ? FontWeight.w600
                              : FontWeight.w300,
                          color: const Color(0xff3c3c3c),
                        ),
                        maxLines: null,
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
              );
            }
          }).toList(),
        ),
      );
    }
    else if (_selectedTab == "Colour") {
      return Container(
        height: _selectedOptions.isEmpty
            ? MediaQuery.of(context).size.height - 150
            : MediaQuery.of(context).size.height - 220,
        child: ListView.builder(
          itemCount: options.length,
          itemBuilder: (context, index) {
            final colorName = options.keys.elementAt(index);
            final hexValue = options[colorName];
            bool isSelected = _selectedOptions.contains(colorName);
            return ListTile(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedOptions.remove(colorName);
                    if(catOptions.contains(colorName)){
                      catOptions.remove(colorName);
                    }
                  } else {
                    _selectedOptions.add(colorName);
                  }
                });
              },
              title: Row(
                children: [
                  const SizedBox(
                    width: 8,
                  ),
                  Icon(
                    isSelected ? Icons.check : null,
                    color: Colors.black,
                    size: 17,
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Container(
                    width: 20, // Adjust the size of the circle as needed
                    height: 20, // Adjust the size of the circle as needed
                    decoration: BoxDecoration(
                      color: Color(
                          int.parse(hexValue.substring(1, 7), radix: 16) +
                              0xFF000000),
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: hexValue == "#ffffff" || hexValue == "#FFFFFF"
                              ? Colors.black
                              : Colors.transparent),
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    colorName,
                    style: const TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff000000),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    }
    return Container();
  }

  Widget _buildSelectedOptions(){
      _selectedOptionMap.forEach((key,value){
        if(value is Map){
          value.forEach((key,items){
              if( (items is List) && (items.isNotEmpty)){
                for(int i=0; i<items.length;i++){
                  if(catOptions.contains(items[i])){
                    continue;
                  }
                  else{
                    catOptions.add(items[i]);
                  }
                }
              }
          });
        }
      });
      print("PRINTINGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG");
      print(catOptions);
      if (_selectedOptions.isEmpty) {
        return const SizedBox(
          height: 0,
        );
      }

      for(int i=0; i<catOptions.length ; i++){
        if(_selectedOptions.contains(catOptions[i])){
          continue;
        }
        else{
          _selectedOptions.add(catOptions[i]);
        }
      }
      print("Printing selecteddddd Optionsssssssssssssssssssssssss");
      print(_selectedOptions);
      return Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _selectedOptions.length,
          itemBuilder: (context, index){
            String option = _selectedOptions[index];
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
                      print("TAAAAAAAAAAPPPPPPPPPPPPPEEEEEEEEEEEDDDDDDDDDDDDDDD");
                      setState((){
                        _selectedOptionMap.forEach((key,value){
                          if(value is Map){
                            value.forEach((key,items){
                              if((items is List) && (items.contains(option))){
                                items.remove(option);
                              }
                            });
                          }
                        });
                        _selectedOptions.remove(option);
                        if(catOptions.contains(option)){
                          catOptions.remove(option);
                        }
                        print("Editttttttttttttttttt Printing selecteddddd Optionsssssssssssssssssssssssss");
                        print(_selectedOptions);
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

  int _getSelectedOptionsCount(String tab){
    var options = filterData[tab] ?? [];
    if (tab != "Category") {
      count = 0;
    }

    if (tab == "Gender" || tab == "Size" || tab == "Availability") {
      count = 0;
      for (var option in options) {
        if (_selectedOptions.contains(option)) {
          count++;
        }
      }
    }

    else if (tab == "Colour") {
      options.forEach((key, value) {
        if (_selectedOptions.contains(key)) {
          count++;
        }
      });
    }

    else if (tab == "Category" || tab == "Genre" || tab == "Type") {
      _selectedOptionMap[tab].forEach((key,items){
        if((items is List) && (items.isNotEmpty)){
          for(int i=0; i<items.length; i++){
            count++;
          }
        }
      });
    }
    else if (tab == "Crafts") {
      options.forEach((key, items) {
        for (int i = 0; i < items.length; i++) {
          if (_selectedOptions.contains(items[i])) {
            count++;
          }
        }
      });
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    // fetchData();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.black,
            )),
        title: const Text(
          "Filters",
          style: TextStyle(
            fontFamily: "Poppins",
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xff0f1015),
            height: 22 / 16,
          ),
          textAlign: TextAlign.left,
        ),
        backgroundColor: Colors.white,
        // iconTheme: IconThemeData(color: Colors.black),
        actions: [
          Container(
            margin: const EdgeInsets.only(
              right: 16.0,
            ),
            child: TextButton(
              onPressed: _clearAllFilters,
              child: const Text(
                "Clear All",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff4a4a4a),
                  height: 20 / 16,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Color(0xffDDDDDD),
                        width: 1.0,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: Container(
                          child: _buildFilterTabs(),
                        ),
                      ),
                      Flexible(
                        flex: 4,
                        child: Container(
                          color: Colors.white,
                          child: _buildFilterOptions(),
                        ),
                      ),
                    ],
                  ),
                ),
                // SizedBox(height: 4,),
                _buildSelectedOptions(),
                // SizedBox(height: 4,),
                if (_selectedOptions.isNotEmpty)
                  Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0xffDDDDDD),
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    height: 50,
                    margin: _selectedOptions.isNotEmpty
                        ? const EdgeInsets.all(10.0)
                        : const EdgeInsets.all(5.0),
                    child: const Center(
                        child: Text(
                      "APPLY FILTERS",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff4a4a4a),
                        height: 20 / 16,
                      ),
                      textAlign: TextAlign.left,
                    )),
                  ),
                ),
              ],
            ),
    );
  }
}