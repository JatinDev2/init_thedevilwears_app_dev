import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_state_city/utils/city_utils.dart';
import 'package:country_state_city/utils/country_utils.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lookbook/Preferences/LoginData.dart';
import 'package:lookbook/Services/profiles.dart';

import '../../../Models/formModels/workModel.dart';

class AddNewWorkExperience extends StatefulWidget {
  const AddNewWorkExperience({super.key});

  @override
  State<AddNewWorkExperience> createState() => _AddNewWorkExperienceState();
}

class _AddNewWorkExperienceState extends State<AddNewWorkExperience> {

  String jobType = 'Internship';
  String startDate="Present";
  String dropdownValue='Fashion Stylist';
  bool isLoading=false;
  bool isOpen=false;
  final _formKey = GlobalKey<FormState>();
  String cityValue = "";
  List countryCitis=[];
  List<String> countryCitisStringList=[];

  String? selectedCityValueDrop;


  bool isLoadingData=true;
  TextEditingController textEditingController=TextEditingController();

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

  TextEditingController companyName=TextEditingController();
  TextEditingController dateController=TextEditingController();
  TextEditingController descriptionText=TextEditingController();
  TextEditingController projectLink=TextEditingController();
  bool isChecked=false;

  String? selectedStateValueDrop;
  late FocusNode myFocusNode;

  void updateJobType(String type) {
    setState(() {
      jobType = type;
    });
  }

  void updateStartDate(String type) {
    setState(() {
      startDate = type;
    });
  }


  Future<bool> addWorkToUserProfile(
      String userId, WorkModel workExp) async {
    if (userId.isEmpty) {
      print('User ID is null or empty');
      return false;
    }
    setState(() {
      isLoading=true;
    });
    Map<String, dynamic> workData = workExp.toJson();
    DocumentReference userDoc =
    FirebaseFirestore.instance.collection('studentProfiles').doc(userId);
    try {
      await userDoc.set({
        'Work Experience': FieldValue.arrayUnion([workData])
      }, SetOptions(merge: true));
      if(isChecked==true){
       await ProfileServices().sendRequestForVerification(companyName.text,dropdownValue);
      }
      print('Work added successfully');
      return true;
    } catch (error) {
      print('Error adding Work: $error');
      return false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myFocusNode = FocusNode();
    // Listen to focus change events
    myFocusNode.addListener(() {
      if (mounted) {
        setState(() {
          isOpen = myFocusNode.hasFocus;
        });
      }
    });

    getData().then((value) {
      setState(() {
        isLoadingData=false;
      });
    });
  }

  Future<void> _selectDate(BuildContext context) async{
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != dateController.text) {
      setState((){
        dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
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
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
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
        body: isLoadingData? Center(child: CircularProgressIndicator(),) : SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding:  const EdgeInsets.only(
              left: 22,
              right: 22,
              bottom: 40
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(height: 25.h,),
                const Text(
                  "Job Type",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff2d2d2d),
                    height: (24/16),
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 8,),
                CustomRadioGroup(
                  selectedValue: jobType,
                  option1: "Internship",
                  option2: "Full time",
                  option3: "Freelance",
                  option4: 'Self-lead',
                  label: "Job Type",
                  onChanged: (value) {
                    updateJobType(value);
                  },
                ),
                SizedBox(height: 15.h,),
                const Divider(height: 1,thickness: 1,color: Color(0xffE7E7E7),),
                const SizedBox(height: 14,),
                const Text(
                  "Job Title",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff2d2d2d),
                    height: (24/16),
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: DropdownButton<String>(
                    value: dropdownValue,
                    isExpanded: true, // Set this property to true
                    borderRadius: BorderRadius.circular(15),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                      });
                    },
                    icon: const Icon(IconlyLight.arrowDown2),
                    underline: Container(),
                    items: items.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff020202),
                            height: 22 / 14,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 15.h,),
                const Divider(height: 1,thickness: 1,color: Color(0xffE7E7E7),),
                const SizedBox(height: 14,),
                const Text(
                  "Company/stylist name",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff2d2d2d),
                  ),
                  textAlign: TextAlign.left,
                ),
                TextFormField(
                  controller: companyName,
                  decoration:const InputDecoration(
                      border: InputBorder.none,
                      hintText: "eg: Gucci|",
                    hintStyle:  TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xffb2b2b2),
                  ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Company/Stylist name.';
                    }
                    return null;
                  },
                ),

            Row(
              children: <Widget>[
                Checkbox(
                  value: isChecked ?? false,
                  onChanged: (bool? value) {
                    setState(() {
                      isChecked = value!;
                    });
                  },
                  checkColor: Colors.white,
                  activeColor: Theme.of(context).colorScheme.primary,
                ),
                const Text(
                  "Send a request for verifying your experience",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff404040),
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),

            const Divider(height: 1,thickness: 1,color: Color(0xffE7E7E7),),
                const SizedBox(height: 13,),
                const Text(
                  "Location",
                  style:  TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff2d2d2d),
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 4,),
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
                SizedBox(height: 15.h,),
                const Divider(height: 1,thickness: 1,color: Color(0xffE7E7E7),),
                const SizedBox(height: 14,),
                const Text(
                  "Start Date",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff2d2d2d),
                    height: (24/16),
                  ),
                  textAlign: TextAlign.left,
                ),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: dateController,
                      decoration: InputDecoration(
                        hintText: "DD/MM/YYYY",
                        hintStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xffb2b2b2),
                          height: 21 / 14,
                        ),
                        border: InputBorder.none,
                      ),
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a date.';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const Divider(height: 1,thickness: 1,color: Color(0xffE7E7E7),),
                const SizedBox(height: 14,),
                const Text(
                  "End Date",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff2d2d2d),
                    height: (24/16),
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 14,),
                CustomRadioGroup(
                  selectedValue: startDate,
                  option1: "DD/MM/YYYY",
                  option2: "Present",
                  option3: "",
                  option4: "",
                  label: "End Date",
                  onChanged: (value) {
                    updateStartDate(value);
                  },
                ),
                SizedBox(height: 15.h,),
                const Divider(height: 1,thickness: 1,color: Color(0xffE7E7E7),),
                const SizedBox(height: 14,),
                const Text(
                  "Project Link",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff2d2d2d),
                  ),
                  textAlign: TextAlign.left,
                ),
                TextFormField(
                  controller: projectLink,
                  decoration:const InputDecoration(
                    border: InputBorder.none,
                    hintText: "This link will be displayed next to this experience|",
                    hintStyle:  TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xffb2b2b2),
                    ),
                  ),
                ),
                SizedBox(height: 15.h,),
                const Divider(height: 1,thickness: 1,color: Color(0xffE7E7E7),),
                const SizedBox(height: 14,),
                const Text(
                  "Description",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff2d2d2d),
                    height: (24/16),
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 10,),
                Container(
                  padding: EdgeInsets.only(left: 20.w, right: 20.w , bottom: MediaQuery.of(context).viewInsets.bottom),
                  height: 238.h,
                  decoration: BoxDecoration(
                      color: const Color(0xffF8F7F7),
                      borderRadius: BorderRadius.circular(14.0.r)
                  ),
                  child: TextFormField(
                    focusNode: myFocusNode,
                    controller: descriptionText,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Mention your key roles, responsibilities or learnings from the job",
                      hintStyle:  TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    onChanged: (value){
                      setState(() {
                        isOpen=true;
                      });
                    },
                    maxLines: 8,
                  ),
                ),
                SizedBox(height: 50.h,),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        GestureDetector(
                          onTap: ()async{

                            WorkModel newRokModel=WorkModel(
                                roleInCompany: dropdownValue,
                                workType: jobType,
                                companyName: companyName.text,
                                timePeriod: "${dateController.text} - ${startDate}",
                                description: descriptionText.text,
                                projectLink: projectLink.text,
                                location: cityValue,
                              status: "pending"
                            );
                            if (_formKey.currentState!.validate()) {
                              await addWorkToUserProfile(LoginData().getUserId(), newRokModel)
                                  .then((value) {
                                if (value == true) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  Navigator.of(context).pop();
                                }
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
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 0),
                  height: isOpen ? 238.0 : 0,
                  // You can also add curve for the animation
                  curve: Curves.bounceInOut,
                  child: Container(
                    // Content of the container, if any
                  ),
                ),
              ],
            ),
          ),
        ),

      ),
    );
  }
}


class CustomRadioGroup extends StatefulWidget {
  String selectedValue;
  String label;
  final String option1;
  final String option2;
  final String option3;
  final String option4;
  final ValueChanged<String> onChanged;

  CustomRadioGroup({
    this.label="",
    required this.selectedValue,
    required this.option1,
    required this.option2,
    required this.option3,
    required this.option4,
    required this.onChanged,
  });

  @override
  _CustomRadioGroupState createState() => _CustomRadioGroupState();
}

class _CustomRadioGroupState extends State<CustomRadioGroup>{
  DateTime testDate=DateTime.now();
  TextEditingController dateController=TextEditingController(
      text: "DD/MM/YYYY"
  );
  void _handleRadioValueChange(String value) {
    setState((){
      widget.selectedValue = value;
    });
    widget.onChanged(value);
  }
  Future<void> _selectDate(BuildContext context) async{
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: testDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != dateController.text) {
      setState((){
        testDate=picked;
        dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
      _handleRadioValueChange(dateController.text);
    }
  }


  Widget buildRadioButton(String value, String label){
    return GestureDetector(
      onTap: () {
        _handleRadioValueChange(value);
      },
      child: Row(
        children: [
          Container(
            width: 15.0,
            height: 15.0,
            padding: const EdgeInsets.all(1.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color:  Colors.black,
                width: 2.0,
              ),
            ),
            child: widget.selectedValue == value
                ? Container(
              width: 11.0,
              height: 11.0,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
              ),
            )
                : Container(),
          ),
          const SizedBox(width: 8.0),
          Text(
            label,
            style: const TextStyle(
              fontFamily: "Poppins",
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xff030303),
              height: 21/14,
            ),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }

  Widget buildDateRadioButton(String value, String label){
    return GestureDetector(
      onTap: () {
        _selectDate(context);
      },
      child: Container(
        child: Row(
          children: [
            Container(
              width: 15.0,
              height: 15.0,
              padding: const EdgeInsets.all(2.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color:  Colors.black,
                  width: 2.0,
                ),
              ),
              child: widget.selectedValue == value
                  ? Container(
                width: 9.0.w,
                height: 9.0.h,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                ),
              )
                  : Container(),
            ),
            const SizedBox(width: 8.0),
            Text(
              label,
              style: const TextStyle(
                fontFamily: "Poppins",
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xff030303),
                height: 21/14,
              ),
              textAlign: TextAlign.left,
            )
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {

     if(widget.label=="Job Type"){
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              buildRadioButton(widget.option1, widget.option1),
              SizedBox(width: 60.0.w),
              buildRadioButton(widget.option2, widget.option2),
            ],
          ),
          SizedBox(height: 4.h,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              buildRadioButton(widget.option3, widget.option3),
              SizedBox(width: 60.0.w),
              buildRadioButton(widget.option4, widget.option4),
            ],
          ),
        ],
      );
    }

    else{
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              buildDateRadioButton(dateController.text, dateController.text),
              SizedBox(width: 60.0.w),
              buildRadioButton(widget.option2, widget.option2),
            ],
          ),

        ],
      );
    }
  }
}
