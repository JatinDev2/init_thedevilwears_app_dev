import 'package:country_state_city/utils/city_utils.dart';
import 'package:country_state_city/utils/country_utils.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lookbook/Services/profiles.dart';



class EditBrandProfilePage extends StatefulWidget {

   String foundedIn;
   String companySize;
   String companyLocationSel;
   String industrySel;

  EditBrandProfilePage({
   required this.companySize,
   required this.companyLocationSel,
   required this.industrySel,
   required this.foundedIn,
});

  @override
  State<EditBrandProfilePage> createState() => _EditBrandProfilePageState();
}

class _EditBrandProfilePageState extends State<EditBrandProfilePage> {
  TextEditingController yearController=TextEditingController();
  TextEditingController companySizeController=TextEditingController();
  TextEditingController additionalInfoBrandController=TextEditingController();



  String stipendValue="January";
  String industryValue="Fashion Designer";
  String selectedSize="0-20";
  String? selectedCityValueDrop;
  bool isLoading=false;
  bool isLoadingData=true;
  // String cityValue = "";
  List countryCitis=[];
  List<String> countryCitisStringList=[];
  TextEditingController textEditingController=TextEditingController();

  String cityValue="";
  String selectedCity = 'Select City';
  bool isDataLoaded = false;
  bool isOpen=false;

  late FocusNode myFocusNode;
  late FocusNode myFocusNode2;
  late FocusNode myFocusNode3;



  List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  List<String> listOfEmployees=[
    "0-20",
    "20-40",
        "40-60",
        "greater than 60",

  ];

  List<String> items=[
    'Fashion Stylist',
    'Fashion Designer',
    'Communication Designer',
    'Social media intern',
    'Social media Manager',
    'Production Associate',
    'Fashion Consultant',
    'Video Editor',
    'Graphic Designers',
    'Textile Designer',
    'Shoot Manager',
    'Shoot Assistant',
    'Set designer',
    'Set design assistant',
    'Videographer',
    'Photographer',
    'Other'
  ];


  void initState() {
    // TODO: implement initState
    super.initState();
    myFocusNode = FocusNode();
    myFocusNode2 = FocusNode();
    myFocusNode3 = FocusNode();

    // Listen to focus change events
    void updateIsOpen() {
      if (mounted) {
        setState(() {
          isOpen = myFocusNode.hasFocus || myFocusNode2.hasFocus || myFocusNode3.hasFocus;
        });
      }
    }

    myFocusNode.addListener(updateIsOpen);
    myFocusNode2.addListener(updateIsOpen);
    myFocusNode3.addListener(updateIsOpen);

    getData()
        .then((value) {
          if(widget.companyLocationSel.isNotEmpty){
            List<String> parts = widget.companyLocationSel.split(', ');
            String city = parts[0];
            print("HLOo");
            print(city);
            String country = parts[1];
            selectedCity=city;
            selectedCityValueDrop=city;
          }
          if(widget.foundedIn.isNotEmpty){
            List<String> founded = widget.foundedIn.split(', ');
            String month = founded[0];
            String year = founded[1];
            stipendValue=month;
            yearController.text=year;
          }
          if(widget.companySize.isNotEmpty){
            selectedSize=widget.companySize;
          }
          if(widget.industrySel.isNotEmpty){
            industryValue=widget.industrySel;
          }
    });
  }

  Future<void> getData()async{
    final country = await getCountryFromCode('IN');
    if (country != null) {
      countryCitis = await getCountryCities(country.isoCode);
      for(int i=0; i<countryCitis.length;i++){
        countryCitisStringList.add(countryCitis[i].name);
      }
    }
    setState(() {
      isLoadingData=false;
    });
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    myFocusNode2.dispose();
    myFocusNode3.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar:  AppBar(
        leading: IconButton(icon: const Icon(Icons.close, color: Colors.black,), onPressed: (){
          Navigator.of(context).pop();
        },),
        backgroundColor: Colors.white,
        title: const Text(
          "Edit details of Company",
          style:  TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xff0f1015),
            height: 20/16,
          ),
          textAlign: TextAlign.left,
        ),
      ),
      body: isLoadingData? Center(child: CircularProgressIndicator(),) :Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            SizedBox(height: 25.h,),
            const Text(
              "Founded in*",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xff2d2d2d),
                height: (24/16),
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 9),
            Row(
              children: [
                Container(
                  height: 50.h,
                  width: 194.w,
                  padding: EdgeInsets.symmetric(horizontal: 10.0.w),
                  decoration: BoxDecoration(
                      color: const Color(0xffF8F7F7),
                      borderRadius: BorderRadius.circular(8.0.r)
                  ),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: stipendValue,
                    onChanged: (String? newValue) {
                      setState(() {
                        stipendValue = newValue!;
                      });
                    },
                    icon:const Icon(IconlyLight.arrowDown2),
                    underline: Container(),
                    items: months
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value,style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff020202),
                          height: 22/14,
                        ),),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(width: 9.w,),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  height: 50.h,
                  width: 163.w,
                  decoration: BoxDecoration(
                      color: const Color(0xffF8F7F7),
                      borderRadius: BorderRadius.circular(8.0.r)
                  ),
                  child: TextFormField(
                    focusNode: myFocusNode,
                    controller: yearController,
                    decoration:const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Year",
                      hintStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff919191),
                        height: 21/14,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value){
                      if (value == null || value.isEmpty) {
                        return 'Please enter the year.';
                      }
                      return null;
                    },
                  ),
                ),

              ],
            ),
            SizedBox(height: 24),

            const Text(
              "Company Size*",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xff2d2d2d),
                height: (24/16),
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 12,),
            Container(
              height: 50.h,
              width: 194.w,
              padding: EdgeInsets.symmetric(horizontal: 10.0.w),
              decoration: BoxDecoration(
                  color: const Color(0xffF8F7F7),
                  borderRadius: BorderRadius.circular(8.0.r)
              ),
              child: DropdownButton<String>(
                isExpanded: true,
                value: selectedSize,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedSize = newValue!;
                  });
                },
                icon:const Icon(IconlyLight.arrowDown2),
                underline: Container(),
                items: listOfEmployees
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text("${value} employees",style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff020202),
                      height: 22/14,
                    ),),
                  );
                }).toList(),
              ),
            ),

            SizedBox(height: 24),

            const Text(
              "Industry*",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xff2d2d2d),
                height: (24/16),
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 12,),
            Container(
              height: 50.h,
              width: 194.w,
              padding: EdgeInsets.symmetric(horizontal: 10.0.w),
              decoration: BoxDecoration(
                  color: const Color(0xffF8F7F7),
                  borderRadius: BorderRadius.circular(8.0.r)
              ),
              child: DropdownButton<String>(
                isExpanded: true,
                value: industryValue,
                onChanged: (String? newValue) {
                  setState(() {
                    industryValue = newValue!;
                  });
                },
                icon:const Icon(IconlyLight.arrowDown2),
                underline: Container(),
                items: items
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value,style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff020202),
                      height: 22/14,
                    ),),
                  );
                }).toList(),
              ),
            ),


            SizedBox(height: 24),

            const Text(
              "Location*",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xff2d2d2d),
                height: (24/16),
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 12,),
            DropdownButtonHideUnderline(
              child: DropdownButton2<String>(
                isExpanded: true,
                hint: Text(
                  selectedCity,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                items: countryCitisStringList
                    .map((item) => DropdownMenuItem(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ))
                    .toList(),
                value: selectedCityValueDrop,
                onChanged: (value){
                  setState((){
                    selectedCityValueDrop = value;
                    cityValue=value!;
                  });
                },
                buttonStyleData: const ButtonStyleData(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  height: 40,
                  width: 150,
                ),
                dropdownStyleData: const DropdownStyleData(
                  maxHeight: 200,
                ),
                menuItemStyleData: const MenuItemStyleData(
                  height: 40,
                ),
                dropdownSearchData: DropdownSearchData(
                  searchController: textEditingController,
                  searchInnerWidgetHeight: 50,
                  searchInnerWidget: Container(
                    height: 50,
                    padding: const EdgeInsets.only(
                      top: 8,
                      bottom: 4,
                      right: 8,
                      left: 8,
                    ),
                    child: TextFormField(
                      focusNode: myFocusNode2,
                      expands: true,
                      maxLines: null,
                      controller: textEditingController,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        hintText: 'Search for an item...',
                        hintStyle: const TextStyle(fontSize: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  searchMatchFn: (item, searchValue){
                    return item.value.toString().toLowerCase().contains(searchValue);
                  },
                ),
                //This to clear the search value when you close the menu
                onMenuStateChange: (isOpen) {
                  if (!isOpen) {
                    textEditingController.clear();
                  }
                },
              ),
            ),


            SizedBox(height: 24),

            const Text(
              "Additional Information",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xff2d2d2d),
                height: (24/16),
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 12,),
            Container(
              padding: EdgeInsets.only(left: 20.w, right: 20.w , bottom: MediaQuery.of(context).viewInsets.bottom),
              height: 150.h,
              decoration: BoxDecoration(
                  color: const Color(0xffF8F7F7),
                  borderRadius: BorderRadius.circular(14.0.r)
              ),
              child: TextFormField(
                focusNode: myFocusNode3,
                controller: additionalInfoBrandController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Additional Information",
                  hintStyle:  TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade400,
                  ),
                ),
                // onChanged: (value){
                //   setState(() {
                //     isOpen=true;
                //   });
                // },
                maxLines: 8,

              ),
            ),

            // Spacer(),
            SizedBox(height: 50.h,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: ()async{
                    if(stipendValue.isNotEmpty && yearController.text.isNotEmpty  && selectedCityValueDrop!.isNotEmpty){
                      setState(() {
                        isLoading=true;
                      });
                      ProfileServices().updateBrandProfileDetails(
                          month: stipendValue,
                          year: yearController.text,
                          companySize: selectedSize,
                          industry: industryValue.toString(),
                          location: selectedCityValueDrop!,
                          additionalInfo: additionalInfoBrandController.text
                      ).then((value) {
                      setState(() {
                      isLoading=true;
                      });
                        Navigator.of(context).pop();
                      });
                    }
                    },
                  child: Container(
                    height: 56.h,
                    width: 176.w,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(5.0.r),
                    ),
                    child: Center(
                        child:isLoading?
                        const CircularProgressIndicator(
                          color: Colors.white,
                        ) :  Text(
                          "Publish",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xff010100),
                            height: (24/16).h,
                          ),
                          textAlign: TextAlign.left,
                        )
                    ),
                  ),
                ),
              ],
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 0),
              height: (myFocusNode.hasFocus || myFocusNode2.hasFocus || myFocusNode3.hasFocus) ? 238.0 : 0,
              // You can also add curve for the animation
              curve: Curves.bounceInOut,
              child: Container(
                // Content of the container, if any
              ),
            ),
          ],

        ),
      ),
    );
  }
}

class InputDropdown extends StatelessWidget {
  const InputDropdown({
    Key? key,
    required this.labelText,
    required this.valueText,
    required this.onPressed,
  }) : super(key: key);

  final String labelText;
  final String valueText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(),
        ),
        baseStyle: TextStyle(fontSize: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(valueText, style: TextStyle(fontSize: 16.0)),
            Icon(Icons.arrow_drop_down,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey.shade700
                    : Colors.white70)
          ],
        ),
      ),
    );
  }
}
