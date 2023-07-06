import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:lookbook/widgets/status_bar_app_bar.dart';
import 'package:lookbook/widgets/scroll_widget.dart';
import 'package:lookbook/widgets/filter_chip.dart';
import 'package:lookbook/screens/search/search_bloc.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with SingleTickerProviderStateMixin {

  late TabController _tabController;
  final SearchBloc _searchBloc = SearchBloc();
  final List<String> _filters = ['Woman', 'Men', 'Kids', '...'];
  int _selected = 0;

  _select(int index) {
    setState(() {
      _selected = index;
      _tabController.animateTo(index);
    });
  }

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    // _tabController.addListener(() => _select(_tabController.index));
    _searchBloc.add(const SearchGetData());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
          child: Text('Search Screen')
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
