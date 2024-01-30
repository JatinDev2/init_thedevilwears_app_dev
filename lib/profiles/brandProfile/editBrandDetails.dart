import 'package:country_state_city/utils/city_utils.dart';
import 'package:country_state_city/utils/country_utils.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lookbook/Services/profiles.dart';



class EditBrandProfilePage extends StatefulWidget {

  @override
  State<EditBrandProfilePage> createState() => _EditBrandProfilePageState();
}

class _EditBrandProfilePageState extends State<EditBrandProfilePage> {
  TextEditingController yearController=TextEditingController();
  TextEditingController companySizeController=TextEditingController();
  TextEditingController additionalInfoBrandController=TextEditingController();

  String stipendValue="January";
  String industryValue="Fashion Designer";
  String? selectedCityValueDrop;
  bool isLoading=false;
  bool isLoadingData=true;
  String cityValue = "";
  List countryCitis=[];
  List<String> countryCitisStringList=[];
  TextEditingController textEditingController=TextEditingController();


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

    getData().then((value) {
      setState(() {
        isLoadingData=false;
      });
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
          "Add Work Experience",
          style:  TextStyle(
            fontFamily: "Poppins",
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
          children: <Widget>[
            SizedBox(height: 25.h,),
            const Text(
              "Founded in*",
              style: TextStyle(
                fontFamily: "Poppins",
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
                          fontFamily: "Poppins",
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
                    controller: yearController,
                    decoration:const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Year",
                      hintStyle: TextStyle(
                        fontFamily: "Poppins",
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
                fontFamily: "Poppins",
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xff2d2d2d),
                height: (24/16),
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 12,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              height: 50.h,
              width: 163.w,
              decoration: BoxDecoration(
                  color: const Color(0xffF8F7F7),
                  borderRadius: BorderRadius.circular(8.0.r)
              ),
              child: TextFormField(
                controller: companySizeController,
                decoration:const InputDecoration(
                  border: InputBorder.none,
                  hintText: "0 to 20 Employees",
                  hintStyle: TextStyle(
                    fontFamily: "Poppins",
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

            SizedBox(height: 24),

            const Text(
              "Industry*",
              style: TextStyle(
                fontFamily: "Poppins",
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
                      fontFamily: "Poppins",
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
                fontFamily: "Poppins",
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
                  'Select City',
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
                fontFamily: "Poppins",
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xff2d2d2d),
                height: (24/16),
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 12,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              height: 50.h,
              width: 163.w,
              decoration: BoxDecoration(
                  color: const Color(0xffF8F7F7),
                  borderRadius: BorderRadius.circular(8.0.r)
              ),
              child: TextFormField(
                controller: additionalInfoBrandController,
                decoration:const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Additional Info",
                  hintStyle: TextStyle(
                    fontFamily: "Poppins",
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

            Spacer(),
            SizedBox(height: 50.h,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: ()async{
                    if(stipendValue.isNotEmpty && yearController.text.isNotEmpty && companySizeController.text.isNotEmpty && selectedCityValueDrop!.isNotEmpty){
                      setState(() {
                        isLoading=true;
                      });
                      ProfileServices().updateBrandProfileDetails(
                          month: stipendValue,
                          year: yearController.text,
                          companySize: companySizeController.text,
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
                            fontFamily: "Poppins",
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
