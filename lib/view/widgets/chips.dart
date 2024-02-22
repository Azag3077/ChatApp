import 'package:flutter/material.dart';

class CategoryChip extends StatelessWidget {
  const CategoryChip({
    Key? key,
    required this.text,
    this.isSelected = false,
    this.onPressed,
  }) : super(key: key);
  final String text;
  final bool isSelected;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: isSelected ? Theme.of(context).primaryColor : Colors.white,
        borderRadius: BorderRadius.circular(30.0),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
        ),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0xFFE2E8F0),
            blurRadius: 3.0,
          ),
        ],
      ),
      child: MaterialButton(
        onPressed: onPressed,
        padding: const EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 5.0,
        ),
        minWidth: 0,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 11,
            color: isSelected ? Colors.white : Colors.blueGrey.shade700,
          ),
        ),
      ),
    );
  }
}
