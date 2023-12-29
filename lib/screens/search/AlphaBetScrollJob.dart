import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'JobSearchScreen.dart';

class _AZItem extends ISuspensionBean {
  final String title;
  final String tag;
  String imageUrl;
  String category;
  String subCategory;
  int numberOfJobOpenings;
  String location;

  _AZItem({
    required this.title,
    required this.tag,
    required this.imageUrl,
    required this.category,
    required this.location,
    required this.numberOfJobOpenings,
    required this.subCategory,
  });
  @override
  String getSuspensionTag() => tag;
}

class AlphaBetScrollPageJob extends StatefulWidget {
  double height;
  String query_check;
  // final List<String> items;
  final List<JobOpening> jobList;
  final ValueChanged<String> onClickedItem;

  AlphaBetScrollPageJob({
    required this.height,
    required this.query_check,
    // required this.items,
    required this.jobList,
    required this.onClickedItem,
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

  String formatSubCategories(String subCategories) {
    var subCategoryList = subCategories.split(', ');
    // If there are more than three subcategories, take only the first three
    if (subCategoryList.length > 3) {
      subCategoryList = subCategoryList.take(3).toList();
    }
    // Join the list back into a string separated by commas
    return subCategoryList.join(', ');
  }


  void initList(List<JobOpening> items) {
    this.items = items.map((item) => _AZItem(
      title: item.brandName,
      tag: item.brandName[0].toUpperCase(),
      imageUrl: item.imageUrl,
      category: item.category,
      location: item.location,
      numberOfJobOpenings: item.numberOfJobOpenings,
      subCategory:item.subCategory,
    )).toList();

    SuspensionUtil.sortListBySuspensionTag(this.items);
    SuspensionUtil.setShowSuspensionStatus(this.items);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    initList(widget.jobList);
    return AzListView(
      data: items,
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildListItem(item);
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
    );
  }

  Widget _buildListItem(_AZItem item){
    final tag = item.getSuspensionTag();
    final offStage = !item.isShowSuspension;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Offstage(offstage: offStage, child: buildHeader(tag)),
        GestureDetector(
          onTap: (){
            widget.onClickedItem(item.title);
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
                  radius: 24.r,
                  backgroundImage: NetworkImage(
                    item.imageUrl,
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
                      "${item.category} • ${formatSubCategories(item.subCategory)}",
                      style: const TextStyle(
                        fontFamily: "Poppins",
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
        )
      ],
    );
  }

  Widget buildHeader(String tag) {
    return Container(
      margin: const EdgeInsets.only(
        left: 8,
        top: 20,
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
}
