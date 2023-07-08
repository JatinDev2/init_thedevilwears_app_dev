import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';

class _AZItem extends ISuspensionBean {
  final String title;
  final String tag;
  _AZItem({
    required this.title,
    required this.tag,
  });
  @override
  String getSuspensionTag() => tag;
}

class AlphaBetScrollPage extends StatefulWidget {
  double height;
  String query_check;
  final List<String> items;
  final ValueChanged<String> onClickedItem;

  AlphaBetScrollPage({
    required this.height,
    required this.query_check,
    required this.items,
    required this.onClickedItem,
  });

  @override
  State<AlphaBetScrollPage> createState() => _AlphaBetScrollPageState();
}

class _AlphaBetScrollPageState extends State<AlphaBetScrollPage> with WidgetsBindingObserver {
  String selectedTag="A";
  List<_AZItem> items = [];
  @override
  void initState() {
    super.initState();
  }

  void initList(List<String> items) {
    this.items = items.map((item) => _AZItem(
      title: item,
      tag: item[0].toUpperCase(),
    )).toList();
    SuspensionUtil.sortListBySuspensionTag(this.items);
    SuspensionUtil.setShowSuspensionStatus(this.items);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    initList(widget.items);
    return AzListView(
      physics: NeverScrollableScrollPhysics(),
      data: items,
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildListItem(item);
      },
      indexBarOptions: IndexBarOptions(
        selectTextStyle:TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
        indexHintTextStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
        needRebuild: true,
        indexHintAlignment: Alignment.centerRight,
        indexHintOffset: Offset(-10, 0),
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
            color: Colors.orange,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Center(
            child: Text(
              hint,
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildListItem(_AZItem item) {
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
            margin: EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 10.0,
            ),
            child: Text(
              item.title,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xff0F1015),
              ),
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
        style: TextStyle(
          fontSize: 18,
          fontWeight: selectedTag==tag? FontWeight.bold : FontWeight.w500,
          color: Color(0xff0F1015),
        ),
      ),
    );
  }
}
