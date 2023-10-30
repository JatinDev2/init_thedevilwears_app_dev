// import 'package:flutter/material.dart';
//
// class TagScreen extends StatefulWidget {
//   const TagScreen({Key? key}) : super(key: key);
//
//   @override
//   State<TagScreen> createState() => _TagScreenState();
// }
//
// class _TagScreenState extends State<TagScreen> {
//   List<String> gender = ["Men's", "Women's", "Teen","Boys", "Footwear"];
//   List<String> occasion= ["Party Wear", "Wedding Wear", "Office Wear","Men's", "Women's", "Teen","Boys", "Footwear"];
//   List<String> selectedOptions = [];
//   Map<String, List<String>> _selectedOptions = {};
//
//   List<String>_selectedGender=[];
//   List<String>_selectedOccasion=[];
//
//   void toggleOption(String option) {
//     setState(() {
//       if (selectedOptions.contains(option)){
//         selectedOptions.remove(option);
//       } else {
//         selectedOptions.add(option);
//       }
//     });
//   }
//
//   String getCategory(String option){
//     if (gender.contains(option)) {
//       return "gender";
//     } else if (occasion.contains(option)){
//       return "occasion";
//     }
//     return "";
//   }
//
//   Widget buildOption(String option) {
//     final isSelected = selectedOptions.contains(option);
//     final backgroundColor = isSelected ? Color(0xffFF9431) : Color(0xffF7F7F7);
//
//     return GestureDetector(
//       onTap: () => toggleOption(option),
//       child: Container(
//         decoration: BoxDecoration(
//           color: backgroundColor,
//           borderRadius: BorderRadius.circular(14.0),
//         ),
//         margin: EdgeInsets.all(5.0),
//         padding: EdgeInsets.all(8.0),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               option,
//               style: TextStyle(
//                 fontFamily: "Poppins",
//                 fontSize: 12,
//                 fontWeight: FontWeight.w400,
//                 color: isSelected? Colors.white : Color(0xff303030),
//                 height: 18/12,
//               ),
//               textAlign: TextAlign.left,
//             ),
//             if (isSelected)
//               GestureDetector(
//                 onTap: () => toggleOption(option),
//                 child: Icon(
//                   Icons.close,
//                   size: 16,
//                   color: Colors.white,
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: ()async{
//         for(int i=0; i<selectedOptions.length; i++){
//           String cat= getCategory(selectedOptions[i]);
//           if(cat=="gender"){
//             _selectedGender.add(selectedOptions[i]);
//           }
//           else{
//             _selectedOccasion.add(selectedOptions[i]);
//           }
//         }
//         _selectedOptions.addAll({
//           "gender": _selectedGender,
//           "occasion": _selectedOccasion,
//         });
//         Map _data={
//           "selectedOptionsList": selectedOptions,
//           "selectedOptionsMap": _selectedOptions,
//         };
//         Navigator.of(context).pop(_data);
//         return false;
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.white,
//           leading: IconButton(
//           icon: Icon(Icons.arrow_back_ios_new_outlined,
//             color: Colors.black,
//             size: 26,),
//             onPressed: (){
//               for(int i=0; i<selectedOptions.length; i++){
//                 String cat= getCategory(selectedOptions[i]);
//                 if(cat=="gender"){
//                   _selectedGender.add(selectedOptions[i]);
//                 }
//                 else{
//                   _selectedOccasion.add(selectedOptions[i]);
//                 }
//               }
//               _selectedOptions.addAll({
//                 "gender": _selectedGender,
//                 "occasion": _selectedOccasion,
//               });
//               Map _data={
//                 "selectedOptionsList": selectedOptions,
//                 "selectedOptionsMap": _selectedOptions,
//               };
//             Navigator.of(context).pop(_data);
//             },
//           ),
//           title: Text(
//             "Add what you’re looking for",
//             style: const TextStyle(
//               fontFamily: "Poppins",
//               fontSize: 16,
//               fontWeight: FontWeight.w500,
//               color: Color(0xff0f1015),
//               height: 20 / 16,
//             ),
//             textAlign: TextAlign.left,
//           ),
//         ),
//         body: Container(
//           margin: EdgeInsets.all(10.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 margin: EdgeInsets.all(5.0),
//                 child: Text(
//                   "Gender",
//                   style: const TextStyle(
//                     fontFamily: "Poppins",
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     color: Color(0xff2d2d2d),
//                     height: 24 / 16,
//                   ),
//                   textAlign: TextAlign.left,
//                 ),
//               ),
//               Wrap(
//                 spacing: 5.0,
//                 runSpacing: 5.0,
//                 children: gender.map((option) => buildOption(option)).toList(),
//               ),
//               SizedBox(height: 30,),
//
//               Container(
//                 margin: EdgeInsets.all(5.0),
//                 child: Text(
//                   "Occasion",
//                   style: const TextStyle(
//                     fontFamily: "Poppins",
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     color: Color(0xff2d2d2d),
//                     height: 24 / 16,
//                   ),
//                   textAlign: TextAlign.left,
//                 ),
//               ),
//               Wrap(
//                 spacing: 5.0,
//                 runSpacing: 5.0,
//                 children: occasion.map((option) => buildOption(option)).toList(),
//               ),
//
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TagScreen extends StatefulWidget {
   List<String> listSelectedOptions;
  Map<String, List<String>> mapSelectedOptions;

  TagScreen({
    super.key,
   required this.listSelectedOptions,
   required this.mapSelectedOptions,
});

  @override
  State<TagScreen> createState() => _TagScreenState();
}

class _TagScreenState extends State<TagScreen> {
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
  void initState(){
    super.initState();
    if(widget.listSelectedOptions.isNotEmpty){
      selectedOptions.addAll(widget.listSelectedOptions);
    }
    if(widget.mapSelectedOptions.isNotEmpty){
        widget.mapSelectedOptions.forEach((key, value) {
          if(selectedOptionsMap.containsKey(key)){
            selectedOptionsMap[key]?.addAll(value);
          }
        });
    }
    fetchFiltersData().then((value) {
      setState(() {
        optionsData = value;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{

        Map _data={
          "selectedOptionsList": selectedOptions,
          "selectedOptionsMap": selectedOptionsMap,
        };
        Navigator.of(context).pop(_data);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_outlined,
              color: Colors.black,
              size: 26,),
            onPressed: (){
              Map _data={
                "selectedOptionsList": selectedOptions,
                "selectedOptionsMap": selectedOptionsMap,
              };
              Navigator.of(context).pop(_data);
            },
          ),
          title: Text(
            "Add what you’re looking for",
            style: const TextStyle(
              fontFamily: "Poppins",
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xff0f1015),
              height: 20 / 16,
            ),
            textAlign: TextAlign.left,
          ),
        ),

        body: Container(
          margin: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Expanded(
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
    );
  }
}
