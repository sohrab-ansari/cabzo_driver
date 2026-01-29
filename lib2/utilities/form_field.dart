import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppFormFields {

  
  static Widget custTextFormOther2({
  required BuildContext context,
  required String hintText,
  required TextEditingController controller,
  String? Function(String?)? validator,
  Function(String)? onChanged,
  Function(String)? onSubmitted,
  VoidCallback? onClicked,
  int maxLines = 1,
  int? maxLength,
  Widget? prefixIcon,
  Widget? suffixIcon,
  TextInputType keyboardType = TextInputType.text,
  bool autofocus = false,
  bool readOnly = false,
  bool enabled = true, // Added enabled parameter
  FocusNode? focusNode,
  double? borderRadius,
  Color? borderColor,
  Color? hintColor,
  Color? textColor,
  FontWeight fontWeight = FontWeight.w500,
  double? fontSize,
  bool filled = false,
  Color? fillColor,
  double? width,
  double? height,
}) {
  double h = MediaQuery.of(context).size.height;
  double w = MediaQuery.of(context).size.width;

  // Determine the actual disabled state
  final bool isDisabled = !enabled;
  
  // For disabled fields, we make them read-only and apply disabled styling
  final bool finalReadOnly = readOnly || isDisabled;

  return SizedBox(
    width: width ?? double.infinity,
    height: height,
    child: TextFormField(
      controller: controller,
      cursorHeight: h * .025,
      cursorColor: isDisabled ? Colors.transparent : Colors.grey, // Hide cursor when disabled
      focusNode: focusNode,
      readOnly: finalReadOnly,
      validator: validator,
      autofocus: autofocus,
      onTap: isDisabled ? null : onClicked, // Disable onTap when disabled
      onChanged: isDisabled ? null : onChanged, // Disable onChanged when disabled
      onFieldSubmitted: isDisabled ? null : onSubmitted, // Disable onSubmitted when disabled
      style: GoogleFonts.lexendDeca(
        fontSize: fontSize ?? w * .040,
        fontWeight: fontWeight,
        color: isDisabled 
            ? Colors.grey.shade600  // Dimmed text color for disabled state
            : (textColor ?? Colors.black87),
      ),
      keyboardType: keyboardType,
      maxLines: maxLines,
      maxLength: maxLength,
      decoration: InputDecoration(
        isDense: true,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        fillColor: isDisabled 
            ? (fillColor ?? Colors.grey.shade200)  // Default grey background for disabled
            : fillColor,
        filled: filled || isDisabled, // Always filled when disabled
        counterText: "",
        contentPadding: EdgeInsets.symmetric(
          horizontal: w * .020,
          vertical: w * .035,
        ),
        hintText: hintText,
        hintStyle: GoogleFonts.lexendDeca(
          fontSize: fontSize ?? w * .040,
          fontWeight: fontWeight,
          color: isDisabled 
              ? Colors.grey.shade500  // Dimmed hint color for disabled
              : (hintColor ?? Colors.grey.shade400),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? w * .020),
          borderSide: BorderSide(
            color: isDisabled 
                ? Colors.grey.shade300  // Lighter border for disabled
                : (borderColor ?? Colors.grey), 
            width: 1
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? w * .020),
          borderSide: BorderSide(
            color: isDisabled 
                ? Colors.grey.shade300  // Lighter border for disabled
                : (borderColor ?? Colors.grey), 
            width: 1
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? w * .020),
          borderSide: BorderSide(
            color: isDisabled 
                ? Colors.grey.shade300  // Lighter border for disabled (even when focused)
                : (borderColor ?? Colors.grey), 
            width: 1
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? w * .020),
          borderSide: BorderSide(
            color: Colors.grey, 
            width: 1
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? w * .020),
          borderSide: BorderSide(
            color: Colors.grey.shade300,  // Explicit disabled border style
            width: 1
          ),
        ),
      ),
    ),
  );
}
  // static Widget custTextFormOther2({
  //   required BuildContext context,
  //   required String hintText,
  //   required TextEditingController controller,
  //   String? Function(String?)? validator,
  //   Function(String)? onChanged,
  //   Function(String)? onSubmitted,
  //   VoidCallback? onClicked,
  //   int maxLines = 1,
  //   int? maxLength,
  //   Widget? prefixIcon,
  //   Widget? suffixIcon,
  //   TextInputType keyboardType = TextInputType.text,
  //   bool autofocus = false,
  //   bool readOnly = false,
  //   FocusNode? focusNode,
  //   double? borderRadius,
  //   Color? borderColor,
  //   Color? hintColor,
  //   Color? textColor,
  //   FontWeight fontWeight = FontWeight.w500,
  //   double? fontSize,
  //   bool filled = false,
  //   Color? fillColor,
  //   double? width,
  //   double? height,
  // }) {
  //   double h = MediaQuery.of(context).size.height;
  //   double w = MediaQuery.of(context).size.width;

  //   return SizedBox(
  //     width: width ?? double.infinity,
  //     height: height,
  //     child: TextFormField(
  //       controller: controller,
  //       cursorHeight: h * .025,
  //       cursorColor: Colors.grey,
  //       focusNode: focusNode,
  //       readOnly: readOnly,
  //       validator: validator,
  //       autofocus: autofocus,
  //       onTap: onClicked,
  //       onChanged: onChanged,
  //       onFieldSubmitted: onSubmitted,
  //       style: GoogleFonts.lexendDeca(
  //         fontSize: fontSize ?? w * .040,
  //         fontWeight: fontWeight,
  //         color: textColor ?? Colors.black87,
  //       ),
  //       keyboardType: keyboardType,
  //       maxLines: maxLines,
  //       maxLength: maxLength,
  //       decoration: InputDecoration(
  //         isDense: true,
  //         prefixIcon: prefixIcon,
  //         suffixIcon: suffixIcon,
  //         fillColor: fillColor,
  //         filled: filled,
  //         counterText: "",
  //         contentPadding: EdgeInsets.symmetric(
  //           horizontal: w * .020,
  //           vertical: w * .035,
  //         ),
  //         hintText: hintText,
  //         hintStyle: GoogleFonts.lexendDeca(
  //           fontSize: fontSize ?? w * .040,
  //           fontWeight: fontWeight,
  //           color: hintColor ?? Colors.grey.shade400,
  //         ),
  //         enabledBorder: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(borderRadius ?? w * .020),
  //           borderSide: BorderSide(color: borderColor ?? Colors.grey, width: 1),
  //         ),
  //         border: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(borderRadius ?? w * .020),
  //           borderSide: BorderSide(color: borderColor ?? Colors.grey, width: 1),
  //         ),
  //         focusedBorder: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(borderRadius ?? w * .020),
  //           borderSide: BorderSide(color: borderColor ?? Colors.grey, width: 1),
  //         ),
  //         errorBorder: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(borderRadius ?? w * .020),
  //           borderSide: BorderSide(color: Colors.grey, width: 1),
  //         ),
  //       ),
  //     ),
  //   );
  // }



  
  static Widget custTextFormOther({
    required BuildContext context,
    required String hintText,
    required TextEditingController controller,
    String? Function(String?)? validator,
    Function(String)? onChanged,
    Function(String)? onSubmitted,
    VoidCallback? onClicked,
    int maxLines = 1,
    int? maxLength,
    Widget? prefixIcon,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
    bool autofocus = false,
    bool readOnly = false,
    FocusNode? focusNode,
    double? borderRadius,
    Color? borderColor,
    Color? hintColor,
    Color? textColor,
    FontWeight fontWeight = FontWeight.w500,
    double? fontSize,
    bool filled = false,
    Color? fillColor,
    double? width,
    double? height,
  }) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: TextFormField(
        controller: controller,
        cursorHeight: h * .025,
        cursorColor: Colors.grey,
        focusNode: focusNode,
        readOnly: readOnly,
        validator: validator,
        autofocus: autofocus,
        onTap: onClicked,
        onChanged: onChanged,
        onFieldSubmitted: onSubmitted,
        style: GoogleFonts.lexendDeca(
          fontSize: fontSize ?? w * .040,
          fontWeight: fontWeight,
          color: textColor ?? Colors.black87,
        ),
        keyboardType: keyboardType,
        maxLines: maxLines,
        maxLength: maxLength,
        decoration: InputDecoration(
          isDense: true,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          fillColor: fillColor,
          filled: filled,
          counterText: "",
          contentPadding: EdgeInsets.symmetric(
            horizontal: w * .020,
            vertical: w * .035,
          ),
          hintText: hintText,
          hintStyle: GoogleFonts.lexendDeca(
            fontSize: fontSize ?? w * .040,
            fontWeight: fontWeight,
            color: hintColor ?? Colors.grey.shade400,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? w * .020),
            borderSide: BorderSide(color: borderColor ?? Colors.grey, width: 1),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? w * .020),
            borderSide: BorderSide(color: borderColor ?? Colors.grey, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? w * .020),
            borderSide: BorderSide(color: borderColor ?? Colors.grey, width: 1),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? w * .020),
            borderSide: BorderSide(color: Colors.grey, width: 1),
          ),
        ),
      ),
    );
  }



}
