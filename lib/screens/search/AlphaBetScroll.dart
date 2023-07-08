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
      data: items,
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildListItem(item);
      },
      indexBarOptions: IndexBarOptions(
        indexHintTextStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
        needRebuild: true,
        indexHintAlignment: Alignment.centerRight,
        indexHintOffset: Offset(-10, 0),
        selectItemDecoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.orange,
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      indexBarHeight:widget.height,

      indexHintBuilder: (context, hint) {
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
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget buildHeader(String tag) {
    return Container(
      margin: EdgeInsets.only(right: 16),
      padding: EdgeInsets.only(left: 16),
      color: Colors.grey.shade100,
      height: 20,
      alignment: Alignment.centerLeft,
      child: Text(
        tag,
        softWrap: false,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
