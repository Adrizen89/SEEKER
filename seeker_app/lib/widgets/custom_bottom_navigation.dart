import 'package:flutter/material.dart';
import 'package:seeker_app/constants/colors.dart';

class CustomBottomAppBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomAppBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: ColorSelect.grey100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: selectedIndex == 0
                    ? ColorSelect.secondaryColor
                    : Colors.transparent),
            child: IconButton(
              icon: Icon(Icons.map, color: ColorSelect.mainColor),
              onPressed: () => onItemTapped(0),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: selectedIndex == 1
                    ? ColorSelect.secondaryColor
                    : Colors.transparent),
            child: IconButton(
              icon: Icon(Icons.book, color: ColorSelect.mainColor),
              onPressed: () => onItemTapped(1),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: selectedIndex == 2
                    ? ColorSelect.secondaryColor
                    : Colors.transparent),
            child: IconButton(
              icon: Icon(Icons.person, color: ColorSelect.mainColor),
              onPressed: () => onItemTapped(2),
            ),
          )
        ],
      ),
    );
  }
}
