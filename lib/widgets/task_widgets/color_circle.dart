import 'package:flutter/material.dart';

class ColorCircle extends StatelessWidget {
  final Color color;
  final String value;
  final String selected;
  final void Function(String) onSelect;

  const ColorCircle({
    super.key,
    required this.color,
    required this.value,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onSelect(value),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: selected == value ? Colors.black : Colors.transparent,
            width: 2,
          ),
        ),
      ),
    );
  }
}
