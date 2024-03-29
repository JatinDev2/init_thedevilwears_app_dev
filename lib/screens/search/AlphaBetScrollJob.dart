import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lookbook/Models/ProfileModels/brandModel.dart';

import '../../App Constants/pfpClass.dart';
import '../../profiles/ProfileViews/brandProfileView/brandProfileView.dart';

class _AZItem extends ISuspensionBean{
  final String title;
  final String tag;
  String imageUrl;
  String category;
  String subCategory;
  int numberOfJobOpenings;
  String location;
  BrandProfile brandProfile;

  _AZItem({
    required this.title,
    required this.tag,
    required this.imageUrl,
    required this.category,
    required this.location,
    required this.numberOfJobOpenings,
    required this.subCategory,
    required this.brandProfile,
  });
  @override
  String getSuspensionTag() => tag;
}

class AlphaBetScrollPageJob extends StatefulWidget{
  double height;
  String query_check;
  // final List<String> items;
  final List<BrandProfile> jobList;
  final ValueChanged<String> onClickedItem;
  final List selectedItems;
  final Map<String,dynamic> selectedOptionsMap;
  final VoidCallback onListUpdated;

  AlphaBetScrollPageJob({
    required this.height,
    required this.query_check,
    required this.jobList,
    required this.onClickedItem,
    required this.selectedItems,
    required this.selectedOptionsMap,
    required this.onListUpdated,
  });

  @override
  State<AlphaBetScrollPageJob> createState() => _AlphaBetScrollPageJobState();
}

class _AlphaBetScrollPageJobState extends State<AlphaBetScrollPageJob> with WidgetsBindingObserver {
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




  void initList(List<BrandProfile> items) {
    this.items = items.map((item) => _AZItem(
      title: item.brandName,
      tag: item.brandName[0].toUpperCase(),
      imageUrl: item.brandProfilePicture,
      category: formatSubCategories(item.brandDescription) ?? 'No description',
      location: item.location,
      numberOfJobOpenings: item.numberOfApplications,
      subCategory:"item.subCategory",
      brandProfile: item,
    )).toList();

    SuspensionUtil.sortListBySuspensionTag(this.items);
    SuspensionUtil.setShowSuspensionStatus(this.items);
    setState(() {});
  }

  @override
  Widget build(BuildContext context){
    initList(widget.jobList);
    return Container(
      child: Column(
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
            height: MediaQuery.of(context).size.height-300,
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
      ),
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
              return BrandProfileView(brandProfile: item.brandProfile);
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
                BrandProfilePicRadiusClass(imgUrl: item.imageUrl, radius: 24.r,),
                 SizedBox(width: 12.w,),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(

                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff0f1015),
                          height: 19/13,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        item.category,
                        style: const TextStyle(

                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff3f3f3f),
                          height: 21/13,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        "${item.numberOfJobOpenings} Job Openings , ${item.location}",
                        style: const TextStyle(

                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff8a8a8a),
                          height: 19/13,
                        ),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                      )
                    ],
                  ),
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
        top: tag=="A"? 2: 20,
        bottom: 4,
      ),
      child: Text(
       tag,
        style: const TextStyle(

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
                    widget.onListUpdated();
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

