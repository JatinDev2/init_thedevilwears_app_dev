import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lookbook/HomeScreen/studentModel.dart';
import 'package:lookbook/ProfileViews/brandProfileView/brandProfileView.dart';
import 'package:lookbook/ProfileViews/studentProfileView/studentProfileView.dart';

import '../profile/profileModels/workModel.dart';
import 'JobSearchScreen.dart';

class _AZItem extends ISuspensionBean {
  final String title;
  final String tag;
  String role;
  String companiesWorkedIn;
  String imgUrl;
  final StudentProfile studentProfile;

  _AZItem({
    required this.title,
    required this.tag,
    required this.role,
    required this.imgUrl,
    required this.companiesWorkedIn,
    required this.studentProfile,
  });
  @override
  String getSuspensionTag() => tag;
}

class AlphaBetScrollPagePeople extends StatefulWidget {
  double height;
  String query_check;
  // final List<String> items;
  final List<StudentProfile> peopleList;
  final ValueChanged<String> onClickedItem;
  final List selectedItems;
  final Map<String,dynamic> selectedOptionsMap;

  AlphaBetScrollPagePeople({
    required this.height,
    required this.query_check,
    // required this.items,
    required this.peopleList,
    required this.onClickedItem,
    required this.selectedOptionsMap,
    required this.selectedItems,
  });

  @override
  State<AlphaBetScrollPagePeople> createState() => _AlphaBetScrollPagePeopleState();
}

class _AlphaBetScrollPagePeopleState extends State<AlphaBetScrollPagePeople> with WidgetsBindingObserver {
  String selectedTag="A";
  List<_AZItem> items = [];
  @override
  void initState() {
    super.initState();
  }

  String formatSubCategories(List<String> subCategoryList) {
    // Check if there are more than three subcategories
    if (subCategoryList.length >2) {
      // Take only the first three subcategories
      List<String> displayedSubCategories = subCategoryList.take(2).toList();
      int remainingCount = subCategoryList.length - 2;
      // Join the first three subcategories and append the count of additional subcategories
      return '${displayedSubCategories.join(' • ')}, +${remainingCount} more';
    }

    // If three or less, just join the list back into a string separated by commas
    return subCategoryList.join(', ');
  }



  String formatCompanyNames(List<WorkModel>? workExperience, {int maxDisplay = 1}) {
    if (workExperience == null || workExperience.isEmpty) {
      return 'No Companies';
    }
    String allCompanies = workExperience.map((e) => e.companyName).join(', ');
    List<String> companyList = allCompanies.split(' • ');
    if (companyList.length <= maxDisplay) {
      return allCompanies;
    } else {
      String displayedCompanies = companyList.take(maxDisplay).join(', ');
      int remainingCount = companyList.length - maxDisplay;
      return '$displayedCompanies, ...+${remainingCount}';
    }
  }


  void initList(List<StudentProfile> items) {
    this.items = items.map((item) => _AZItem(
      title: "${item.firstName} ${item.lastName}",
      tag: item.firstName![0].toUpperCase(),
      imgUrl: "https://t4.ftcdn.net/jpg/04/24/15/27/360_F_424152729_5jNBK6XVjsoWvTtGEljfSCOWv4Taqivl.jpg",
      role: formatSubCategories(item.userDescription!),
      // item.userDescription?.join(" • ") ?? 'No description',
      companiesWorkedIn: formatCompanyNames(item.workExperience),
      studentProfile: item
    )).toList();

    SuspensionUtil.sortListBySuspensionTag(this.items);
    SuspensionUtil.setShowSuspensionStatus(this.items);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    initList(widget.peopleList);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if(widget.selectedItems.isNotEmpty)
        Container(
          height: 40,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.selectedItems.length,
              itemBuilder: (BuildContext context, index){
                return _buildChip(widget.selectedItems[index]);
              }
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height - 300,
          child: AzListView(
            data: items,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return _buildListItem(item,index);
            },
            indexBarOptions: IndexBarOptions(
              selectTextStyle:const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              indexHintTextStyle:const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w300,
                color: Color(0xff0f1015),
                height: 468/12,
              ),
              needRebuild: true,
              indexHintAlignment: Alignment.centerRight,
              indexHintOffset: const Offset(-10, 0),
              selectItemDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            indexBarHeight:widget.height,

            indexHintBuilder: (context, hint){
              selectedTag=hint;
              return Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Center(
                  child: Text(
                    hint,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildListItem(_AZItem item, int index){
    final tag = item.getSuspensionTag();
    final offStage = !item.isShowSuspension;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Offstage(offstage: offStage, child: buildHeader(tag)),
        InkWell(
          onTap: (){
            widget.onClickedItem(item.title);
            Navigator.of(context).push(MaterialPageRoute(builder: (_){
              return StudentProfileView(studentProfile: item.studentProfile);
            }));
          },
          child: Container(
            margin: const EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 10.0,
            ),
            child:  Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  radius: 24.r,
                  backgroundImage: NetworkImage(
                    item.imgUrl,
                  ),
                ),
                SizedBox(width: 12.w,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff0f1015),
                        height: 19/13,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      "${item.role}",
                      style: const TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff3f3f3f),
                        height: 21/13,
                      ),
                      textAlign: TextAlign.left,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    Text(
                      "${item.companiesWorkedIn}",
                      style: const TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff8a8a8a),
                        height: 19/13,
                      ),
                      textAlign: TextAlign.left,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        if(index==items.length-1)
          const SizedBox(height: 60,),
      ],
    );
  }

  Widget buildHeader(String tag) {
    return Container(
        margin:  EdgeInsets.only(
          left: 8,
          top: tag=="A"? 2:20,
          bottom: 4,
        ),
        child: Text(
          tag,
          style: const TextStyle(
            fontFamily: "Poppins",
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Color(0xff000000),
            height: 28/20,
          ),
          textAlign: TextAlign.left,
        )
    );
  }

  Widget _buildChip(String tag){
    return Container(
      margin: const EdgeInsets.only(
          top: 2.0,
          right: 7.0,
          bottom: 7.0), // Adjust the margin for tighter packing
      child: GestureDetector(
        onTap: () {

        },
        child: Container(
          // padding: const EdgeInsets.symmetric(horizontal: 2.0),
          // decoration: BoxDecoration(
          //   color: Color(0xffF7F7F7),
          //   border: Border.all(color: Colors.grey.shade300),
          //   borderRadius: BorderRadius.circular(20.0), // Stadium shape
          // ),
          child: Row(
            mainAxisSize: MainAxisSize
                .min, // Use the minimum space that's needed by the child widgets
            children: [
              Text(
                tag,
                style: const TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff303030),
                ),
              ),
              SizedBox(
                width: 4,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    widget.selectedOptionsMap.forEach((key, value) {
                      if(value is List && value.isNotEmpty){
                        if(value.contains(tag)){
                          value.remove(tag);
                        }
                      }
                      else if(value is Map){
                        value.forEach((key, subValue) {
                          if(subValue is List && subValue.isNotEmpty){
                            if(subValue.contains(tag)){
                              subValue.remove(tag);
                            }
                          }
                        });
                      }
                    });
                    widget.selectedItems.remove(tag);
                  });
                },
                child: Icon(
                  Icons.close,
                  size: 13.0,
                  color: Color(0xff303030),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}
