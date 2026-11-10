import 'package:flutter/widgets.dart';

class CustomText extends StatelessWidget {
  final String text;
  final Color? color;
  final FontWeight? weight;
  final double size;
  final TextAlign? textAlign;

  const CustomText({super.key, required this.text,  this.color,  this.weight, required this.size, this.textAlign});
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(color: color, fontWeight: weight , fontSize:size ,  ),
    );
  }
}
