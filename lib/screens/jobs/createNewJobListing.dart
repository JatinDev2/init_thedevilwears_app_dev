import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lookbook/screens/jobs/previewListingScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../listing/new_listing/dropdown.dart';
import 'confirmJobListing.dart';
import 'job_model.dart';

class CreateNewJobListing extends StatefulWidget {
  const CreateNewJobListing({super.key});

  @override
  State<CreateNewJobListing> createState() => _CreateNewJobListingState();
}

class _CreateNewJobListingState extends State<CreateNewJobListing> {

  String jobType = 'Internship';
  String jobDur = 'Fixed';
  String jobLoc='In office';
  String startDate="Immediately(within next 30 days)";
  String dropdownValue='Fashion Stylist';
  String jobDurValue='Months';
  String stipend="Unpaid";
  String stipendValue="/month";
  bool isLoading=false;
  final _formKey = GlobalKey<FormState>();
  String countryValue = "";
  String stateValue = "";
  String cityValue = "";
  String address = "";


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

  Map<String, bool> checkboxes = {
    'Certificate': false,
    'Letter of Recommendation': false,
    'Flexible work hours': false,
    'Informal dress code': false,
    'Free snacks and beverages': false,
    'Travel allowance':false,
    'Extension of tenure':false,
  };

  TextEditingController responsibilityText=TextEditingController(
    text: "1.\n2.\n3.\n"
  );
  TextEditingController jobDurController=TextEditingController();
  TextEditingController stipendController=TextEditingController();
  TextEditingController officeLocController=TextEditingController();
  TextEditingController openingsController=TextEditingController();
  final CollectionReference listCollection = FirebaseFirestore.instance.collection('jobListing');


  void updateJobType(String type) {
    setState(() {
      jobType = type;
    });
  }

  void updateJobDuration(String duration) {
    setState(() {
      jobDur = duration;
    });
  }

  void updateJobLoc(String type) {
    setState(() {
      jobLoc = type;
    });
  }

  void updateStartDate(String type) {
    setState(() {
      startDate = type;
    });
  }
  //stipend
  void updateStipend(String type) {
    setState(() {
      stipend = type;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_outlined, color: Colors.black,), onPressed: (){
          Navigator.of(context).pop();
        },),
        backgroundColor: Colors.white,
        title: const Text(
          "Create a new listing",
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
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 22.w,
          right: 22.w,
          bottom: 40.h
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 25.h,),
               Text(
                "Job Type",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff2d2d2d),
                  height: (24/16).h,
                ),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 8.h,),
              CustomRadioGroup(
                selectedValue: jobType,
                option1: "Internship",
                option2: "Full time",
                option3: "Freelance",
                option4: '',
                onChanged: (value) {
                  updateJobType(value);
                },
              ),
              SizedBox(height: 15.h,),
             const Divider(height: 2,thickness: 2,color: Color(0xffE7E7E7),),
             SizedBox(height: 14.h,),
               Text(
                "Job profile",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff2d2d2d),
                  height: (24/16).h,
                ),
                textAlign: TextAlign.left,
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child:  DropDown(selectedValue: dropdownValue, items:items ,)
              ),
              const Divider(height: 2,thickness: 2,color: Color(0xffE7E7E7),),
              SizedBox(height: 22.h,),
               Text(
                "Day to day responsibilities should include:",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff2d2d2d),
                  height: (24/16).h,
                ),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 10.h,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                height: 132.h,
                decoration: BoxDecoration(
                  color: const Color(0xffF8F7F7),
                  borderRadius: BorderRadius.circular(14.0.r)
                ),
                child: TextFormField(
                  controller: responsibilityText,
                  decoration:const InputDecoration(
                 border: InputBorder.none,
                  ),
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter responsibilities for the intern.';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 22.h,),
               Text(
                "Job duration",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color:const Color(0xff2d2d2d),
                  height: (24/16).h,
                ),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 16.h,),
              CustomRadioGroup(
                selectedValue: jobDur,
                option1: "Fixed",
                option2: "Project Based",
                option3: "",
                option4: '',
                onChanged: (value) {
                  updateJobDuration(value);
                },
              ),
             if(jobDur=="Fixed")
               SizedBox(height: 18.h,),
              if(jobDur=="Fixed")
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    height: 55.h,
                    width: 242.w,
                    decoration: BoxDecoration(
                        color: const Color(0xffF8F7F7),
                        borderRadius: BorderRadius.circular(14.0.r)
                    ),
                    child: TextFormField(
                      controller: jobDurController,
                      decoration:const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Eg: 3"
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if(jobDur=="Fixed"){
                          if (value == null || value.isEmpty) {
                            return 'Please enter the duration.';
                          }
                          return null;
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 9.w,),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0.w),
                    decoration: BoxDecoration(
                      color: const Color(0xffF8F7F7),
                      borderRadius: BorderRadius.circular(15.0.r)
                    ),
                    child: DropdownButton<String>(
                      value: jobDurValue,
                      onChanged: (String? newValue) {
                        setState(() {
                          jobDurValue = newValue!;
                        });
                      },
                      icon:const Icon(IconlyLight.arrowDown2),
                      underline: Container(),
                      items: <String>['Days', 'Months', 'Years']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),

                ],
              ),
              SizedBox(height: 22.h,),
              const Divider(height: 2,thickness: 2,color: Color(0xffE7E7E7),),
              SizedBox(height: 13.h,),
              Text(
                "Type",
                style:  TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff2d2d2d),
                  height: (24/16).h,
                ),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 7.h,),
              CustomRadioGroup(
                selectedValue: jobLoc,
                option1: "In office",
                option2: "Hybrid",
                option3: "Remote",
                option4: '',
                onChanged: (value) {
                  updateJobLoc(value);
                },
              ),
              SizedBox(height: 15.h,),
              const Divider(height: 2,thickness: 2,color: Color(0xffE7E7E7),),
              SizedBox(height: 13.h,),
              Text(
                "Office location",
                style:  TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff2d2d2d),
                  height: (24/16).h,
                ),
                textAlign: TextAlign.left,
              ),

              Container(
                margin: EdgeInsets.all(20),
                child: CSCPicker(
                  defaultCountry: CscCountry.India,
                  disableCountry: true,
                  layout: Layout.horizontal,
                  //flagState: CountryFlag.DISABLE,
                  onCountryChanged: (country) {},
                  onStateChanged: (state) {
                    if(state!=null){
                      stateValue=state;
                    }
                  },
                  onCityChanged: (city) {
                    if(city!=null){
                      cityValue=city;
                    }
                  },
                  /* countryDropdownLabel: "*Country",
          stateDropdownLabel: "*State",
          cityDropdownLabel: "*City",*/
                  //dropdownDialogRadius: 30,
                  //searchBarRadius: 30,
                ),
              ),


              const Divider(height: 2,thickness: 2,color: Color(0xffE7E7E7),),
              SizedBox(height: 18.h,),
               Text(
                "Tentative start Date",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff2d2d2d),
                  height: (24/16).h,
                ),
                textAlign: TextAlign.left,
              ),
              CustomRadioGroup(
                selectedValue: startDate,
                option1: "Immediately(within next 30 days)",
                option2: "Later",
                option3: "Remote",
                option4: "DD/MM/YYYY",
                label: "Start Date",
                onChanged: (value) {
                  updateStartDate(value);
                },
              ),
              SizedBox(height: 15.h,),
              const Divider(height: 2,thickness: 2,color: Color(0xffE7E7E7),),
              SizedBox(height: 13.h,),
              Text(
                "Stipend",
                style:  TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff2d2d2d),
                  height: (24/16).h,
                ),
                textAlign: TextAlign.left,
              ),
              CustomRadioGroup(
                selectedValue: stipend,
                option1: "Unpaid",
                option2: "Performance Based",
                option3: "Negotiable",
                option4: "Fixed",
                label: "Stipend",
                onChanged: (value) {
                  updateStipend(value);
                },
              ),
              SizedBox(height: 20.h,),
              if(stipend!="Unpaid")
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    height: 55.h,
                    width: 242.w,
                    decoration: BoxDecoration(
                        color: const Color(0xffF8F7F7),
                        borderRadius: BorderRadius.circular(14.0.r)
                    ),
                    child: TextFormField(
                      controller: stipendController,
                      decoration:const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Mention an Amount here"
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value){
                        if(stipend!="Unpaid"){
                          if (value == null || value.isEmpty) {
                            return 'Please enter the amount of stipend.';
                          }
                          return null;
                        }
                       return null;
                      },
                    ),
                  ),
                  SizedBox(width: 9.w,),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0.w),
                    decoration: BoxDecoration(
                        color: const Color(0xffF8F7F7),
                        borderRadius: BorderRadius.circular(15.0.r)
                    ),
                    child: DropdownButton<String>(
                      value: stipendValue,
                      onChanged: (String? newValue) {
                        setState(() {
                          stipendValue = newValue!;
                        });
                      },
                      icon:const Icon(IconlyLight.arrowDown2),
                      underline: Container(),
                      items: <String>['/day', '/month', '/year']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),

                ],
              ),
              SizedBox(height: 22.h,),
              Text(
                "Number of openings (optional)",
                style:  TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff2d2d2d),
                  height: (24/16).h,
                ),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 7.h,),
              TextFormField(
                controller: openingsController,
                decoration: const InputDecoration(
                    hintText: "eg: 5",
                    border: InputBorder.none
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 15.h,),
              const Divider(height: 2,thickness: 2,color: Color(0xffE7E7E7),),
              SizedBox(height: 19.h,),
              Text(
                "Perks",
                style:  TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff2d2d2d),
                  height: (24/16).h,
                ),
                textAlign: TextAlign.left,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: checkboxes.keys.map((String option) {
                  return Row(
                    children: <Widget>[
                      Checkbox(
                        value: checkboxes[option] ?? false,
                        onChanged: (bool? value) {
                          setState(() {
                            checkboxes[option] = value!;
                          });
                        },
                        checkColor: Colors.white,
                        activeColor: Theme.of(context).colorScheme.primary,
                      ),
                      Text(
                        option,
                        style:  TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xff2d2d2d),
                          height: (21/14).h,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  );
                }).toList(),
              ),
              SizedBox(height: 22.h,),
              const Divider(height: 2,thickness: 2,color: Color(0xffE7E7E7),),
              SizedBox(height: 50.h,),
              Container(
                child: Row(
                  mainAxisAlignment: isLoading? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
                  children: [
                    if(!isLoading)
                      GestureDetector(
                        onTap: ()async{
                          if(_formKey.currentState!.validate()){
                            final prefs = await SharedPreferences.getInstance();
                            final userId = prefs.getString('userId');
                            final firstName = prefs.getString('firstName');
                            final lastName = prefs.getString('lastName');
                            List<String>_perks=[];
                            checkboxes.forEach((key, value) {
                              if(value==true){
                                _perks.add(key);
                              }
                            });
                            List<String>tags=[dropdownValue,jobType,jobDurController.text];

                            print("Tags:::::::::::::::::::::::::::::::::::::::::::::::::::::::");
                            print(tags);

                            jobModel newJobModel=jobModel(
                              jobType: jobType,
                              jobProfile: dropdownValue,
                              responsibilities: responsibilityText.text,
                              jobDuration: jobDur,
                              jobDurExact: jobDurController.text,
                              workMode: jobLoc,
                              officeLoc: "$cityValue, $stateValue, India",
                              tentativeStartDate: startDate.toString(),
                              stipend: stipend,
                              stipendAmount:stipendController.text,
                              numberOfOpenings: openingsController.text,
                              perks: _perks,
                              createdAt: DateTime.now().toString(),
                              createdBy: "$firstName $lastName",
                              userId: userId!,
                              jobDurVal:jobDurValue,
                              stipendVal:stipendValue,
                              tags:tags,
                            );
                            Navigator.of(context).push(MaterialPageRoute(builder: (_){
                              return PreviewJobListing(newJobModel: newJobModel,);
                            }));
                          }
                        },
                        child: Container(
                          height: 56.h,
                          width: 176.w,
                          decoration: BoxDecoration(
                            color: const Color(0xffE6E6E6),
                            borderRadius: BorderRadius.circular(5.0.r),
                          ),
                          child: Center(
                            child:  Text(
                              "Preview",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xff373737),
                                height: (24/16).h,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                      ),

                    if(!isLoading)
                      GestureDetector(
                      onTap: ()async{

                        final prefs = await SharedPreferences.getInstance();
                        final userId = prefs.getString('userId');
                        final firstName = prefs.getString('firstName');
                        final lastName = prefs.getString('lastName');
                        List<String>_perks=[];
                        checkboxes.forEach((key, value) {
                          if(value==true){
                            _perks.add(key);
                          }
                        });
                        List<String>tags=[];
                        if(jobDur=="Fixed"){
                          tags=[dropdownValue,jobType,"${jobDurController.text} $jobDurValue"];
                        }
                        else{
                          tags=[dropdownValue,jobType,jobDur];
                        }

                        if(_formKey.currentState!.validate()){

                          listCollection.add({
                            "jobType": jobType,
                            "jobProfile": dropdownValue,
                            "responsibilities": responsibilityText.text,
                            "jobDuration": jobDur,
                            "jobDurationExact": jobDurController.text,
                            "workMode": jobLoc,
                            "officeLoc": "$cityValue, $stateValue, India",
                            "tentativeStartDate": startDate.toString(),
                            "stipend": stipend,
                            "stipendAmount":stipendController.text,
                            "numberOfOpenings": openingsController.text,
                            "perks": _perks,
                            "createdAt": DateTime.now().toString(),
                            "createdBy": "$firstName $lastName",
                            "userId": userId,
                            "jobDurVal":jobDurValue,
                            "stipendVal":stipendValue,
                            "tags": tags,
                          }).then((value) {
                            Navigator.of(context).push(MaterialPageRoute(builder: (_){
                              return const ConfirmJobListingScreen();
                            }));
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
                                "Submit",
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
                    if(isLoading)
                      Center(
                        child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                  ],
                ),
              )
            ],
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
            width: 15.0.w,
            height: 15.0.h,
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
    );
  }

  Widget buildDateRadioButton(String value, String label){
    return GestureDetector(
      onTap: () {
        _selectDate(context);
      },
      child: Row(
        children: [
          Container(
            width: 15.0.w,
            height: 15.0.h,
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
    );
  }


  @override
  Widget build(BuildContext context) {
    if(widget.label.isEmpty ){
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          buildRadioButton(widget.option1, widget.option1),
          SizedBox(width: 34.0.w),
          buildRadioButton(widget.option2, widget.option2),
          if(widget.option3.isNotEmpty)
            SizedBox(width: 34.0.w),
          if(widget.option3.isNotEmpty)
            buildRadioButton(widget.option3, widget.option3),
        ],
      );
    }
    else if(widget.label=="Stipend"){
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
              SizedBox(width: 34.0.w),
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
         buildRadioButton(widget.option1, widget.option1),
         SizedBox(width: 34.0.w),
         buildRadioButton(widget.option2, widget.option2),
       ],
     ),
         SizedBox(height: 4.h,),
         buildDateRadioButton(dateController.text, dateController.text)
       ],
     );
    }
  }
}
