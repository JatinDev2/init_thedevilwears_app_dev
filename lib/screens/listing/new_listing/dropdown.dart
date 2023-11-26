import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class DropDown extends StatefulWidget {
  String selectedValue;
  List<String> items;

  DropDown({
   required this.selectedValue,
   required this.items,
});

  @override
  State<DropDown> createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {


  @override
  Widget build(BuildContext context) {
    return  DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          isExpanded: true,
          hint: Text(widget.selectedValue),
          items: widget.items
              .map((String item) =>
              DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: item==widget.selectedValue ? Colors.orange : Colors.black,
                height: 21/14,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          )
          )
              .toList(),
          value: widget.selectedValue,
          onChanged: (value) {
            setState((){
              widget.selectedValue = value!;
            });
          },
          buttonStyleData: ButtonStyleData(
            height: 50,
            width: MediaQuery.of(context).size.width,
            // padding: const EdgeInsets.only(left: 14, right: 14),
            elevation: 2,
          ),
          iconStyleData: const IconStyleData(
            icon: Icon(
              IconlyLight.arrowDown2,
            ),
            iconSize: 24,
            iconEnabledColor: Color(0xff0B1C3F),
            iconDisabledColor: Colors.grey,
          ),
          dropdownStyleData: DropdownStyleData(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
            ),
            offset: const Offset(-20, 0),
            scrollbarTheme: ScrollbarThemeData(
              radius: const Radius.circular(40),
              thickness: MaterialStateProperty.all(6),
              thumbVisibility: MaterialStateProperty.all(true),
            ),
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 40,
            padding: EdgeInsets.only(left: 14, right: 14),
          ),
        ),
      );
  }
}