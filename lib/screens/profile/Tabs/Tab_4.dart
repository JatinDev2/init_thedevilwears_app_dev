import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:faker_dart/faker_dart.dart';

class tabFour extends StatefulWidget {
  const tabFour({super.key});

  @override
  State<tabFour> createState() => _tabFourState();
}

class _tabFourState extends State<tabFour> {

  List gridItems=[];
  final form=GlobalKey<FormState>();
  TextEditingController _nameOfFolder=TextEditingController();

  void submitform(){
    final faker = Faker.instance;
    if(form.currentState!.validate()){
      form.currentState!.save();
      setState(() {
        gridItems.add(GridData(
          name: _nameOfFolder.text,
          imgUrl: '${faker.image.unsplash.image(keyword: 'fashion')},${Random().nextInt(100)}',
          numberOfItems:"10",
        ),);
      });
      Navigator.of(context).pop();
      _showConfirmDialogue();
    }
    else{
      return;
    }
  }

  void _showDialogue(){
    showDialog(
      context: context,
      builder: (context) => Theme(
        data: ThemeData(
          dialogTheme: DialogTheme(
            elevation: 0,
          ),
        ),
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: EdgeInsets.only(
              top: 40,
              bottom: 40,
              left: 15,
              right: 10
          ),
          content: Form(
            key: form,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Collection Name",
                  style: const TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff0f0f0f),
                    height: 30/20,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 13,),
                Container(
                  margin: EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _nameOfFolder,
                    decoration: InputDecoration(
                      hintText: "Enter you collection name here",
                      hintStyle:const TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff686868),
                      height: 21/14,
                    ),
                    ),
                    validator: (value){
                      if(value!.isEmpty){
                        return "Please Enter a name for the folder";
                      }
                    },
                  ),
                ),
                SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        submitform();
                      },
                      child: Container(
                        height: 44,
                        width: 153,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Center(
                          child: Text(
                            "Create Now",
                            style: const TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 24/16,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  void _showConfirmDialogue(){
    showDialog(
      context: context,
      builder: (context) => Theme(
        data: ThemeData(
          dialogTheme: DialogTheme(
            elevation: 0,
          ),
        ),
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: EdgeInsets.only(
              top: 40,
              bottom: 40,
              left: 15,
              right: 10
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                'assets/confirm_img.svg',
                semanticsLabel: 'My SVG Image',
                height: 100,
                width: 70,
              ),

              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Your new Collection is created! ",
                    style: const TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff121212),
                      height: 21/14,
                    ),
                    textAlign: TextAlign.left,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  @override
  void initState() {
    // TODO: implement initState
    gridItems=  GridData.generateDummyGridData();
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
     child: Container(
       color: Color(0xffF8F8F8),
       child: GridView.builder(
         itemCount: gridItems.length,
         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
           crossAxisCount: 2,
           mainAxisSpacing: 4,
           crossAxisSpacing: 4,
           childAspectRatio: 100 / 150,
         ),
         itemBuilder: (context, index) => _gridItem(index),
       ),
     ),
    );
  }

  Widget _gridItem(int index) {
    GridData item = gridItems[index];
    if(index==0) {
      return GestureDetector(
        onTap: _showDialogue,
        child: Container(
          height: 250,
          width: 200,
          decoration: const BoxDecoration(
            color: Color(0xffF8F8F8),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle
                  ),
                  child: SvgPicture.asset("assets/Pluse.svg"),
                ),
                SizedBox(height: 16,),
                const Text(
                  "Create a folder ",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff0f1015),
                    height: 18/12,
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }


    return GestureDetector(
      child: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 1.0,
              child: FadeInImage(
                placeholder: MemoryImage(kTransparentImage),
                image: NetworkImage(item.imgUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 13.w,
                vertical: 13.h,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.center,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black,
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name.toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "${item.numberOfItems} ${item.name}",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}

class GridData{
  String imgUrl;
  String name;
  String numberOfItems;

  GridData({
    required this.name,
    required this.imgUrl,
    required this.numberOfItems,
});

 static List<GridData> generateDummyGridData() {
    final faker = Faker.instance;
    List<GridData> items = [];

    for (int i = 0; i < 3; i++){
      if(i==0){
        items.add(GridData(
          imgUrl: '${faker.image.unsplash.image(keyword: 'fashion')},${Random().nextInt(100)}',
          name: "listings",
          numberOfItems: "10",
        ));
      }
      if(i==1){
        items.add(GridData(
          imgUrl: '${faker.image.unsplash.image(keyword: 'fashion')},${Random().nextInt(100)}',
          name: "listings",
          numberOfItems: "10",
        ));
      }
      if(i==2){
        items.add(GridData(
          imgUrl: '${faker.image.unsplash.image(keyword: 'fashion')},${Random().nextInt(100)}',
          name: "lookbooks",
          numberOfItems: "45",
        ));
      }
    }
    return items;
  }

}
