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
          decoration: const BoxDecoration(
            color: Colors.orange,
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
            margin: const EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 10.0,
            ),
            child: Text(
              item.title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xff0f1015),
                height: 21/14,
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
        style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w300,
        color: Color(0xff0f1015),
        height: 24/16,
      ),
      ),
    );
  }
}
