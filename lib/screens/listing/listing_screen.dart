import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ListingScreen extends StatefulWidget {
  const ListingScreen({Key? key}) : super(key: key);

  @override
  State<ListingScreen> createState() => _ListingScreenState();
}

class _ListingScreenState extends State<ListingScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
          child: Text('Listing Screen')
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
