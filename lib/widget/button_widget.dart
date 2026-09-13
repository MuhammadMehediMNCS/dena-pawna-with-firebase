import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;

  const ButtonWidget({
    super.key,
    required this.title,
    required this.onPressed,
    this.backgroundColor = const Color(0xADCD852F),
    this.textColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) => ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      minimumSize: const Size(300.0, 60.0),
      shape: const StadiumBorder(),
      side: const BorderSide(color: Colors.black26)
    ),
    child: Text(
      title,
      style: TextStyle(
        fontFamily: 'NotoSansBengali-Regular',
        fontSize: 24,
        color: textColor,
      ),
    )
  );
}
