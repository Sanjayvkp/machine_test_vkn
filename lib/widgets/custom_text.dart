import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';

enum TextType {
  heading,
  subheading,
  body,
  caption,
  button,
}

class CustomText extends StatelessWidget {
  final String text;
  final TextType type;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? lineHeight;

  const CustomText({
    super.key,
    required this.text,
    this.type = TextType.body,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.fontSize,
    this.fontWeight,
    this.lineHeight,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle getTextStyle() {
      switch (type) {
        case TextType.heading:
          return GoogleFonts.poppins(
            fontSize: fontSize ?? 24,
            fontWeight: fontWeight ?? FontWeight.bold,
            color: color ?? AppColors.textPrimary,
            height: lineHeight,
          );
        case TextType.subheading:
          return GoogleFonts.poppins(
            fontSize: fontSize ?? 18,
            fontWeight: fontWeight ?? FontWeight.w600,
            color: color ?? AppColors.textPrimary,
            height: lineHeight,
          );
        case TextType.body:
          return GoogleFonts.poppins(
            fontSize: fontSize ?? 14,
            fontWeight: fontWeight ?? FontWeight.normal,
            color: color ?? AppColors.textPrimary,
            height: lineHeight,
          );
        case TextType.caption:
          return GoogleFonts.poppins(
            fontSize: fontSize ?? 12,
            fontWeight: fontWeight ?? FontWeight.normal,
            color: color ?? AppColors.textSecondary,
            height: lineHeight,
          );
        case TextType.button:
          return GoogleFonts.poppins(
            fontSize: fontSize ?? 15,
            fontWeight: fontWeight ?? FontWeight.w500,
            color: color ?? AppColors.textPrimary,
            height: lineHeight,
          );
      }
    }

    return Text(
      text,
      style: getTextStyle(),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
