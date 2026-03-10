import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  bool? enabled,
  List<TextInputFormatter>? inputFormatters, // Added this parameter
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
      enabled: enabled,
      validator: validator,
      autofocus: autofocus,
      onTap: onClicked,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      inputFormatters: inputFormatters, // Added this line
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
  
  // static Widget custTextFormOther({
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






static Widget custTextFormOther3({
  required BuildContext context,
  required String hintText,
  required TextEditingController controller,
  String? Function(String?)? validator,
  Function(String)? onChanged,
  Function(String)? onSubmitted,
  VoidCallback? onClicked,
  VoidCallback? onEditingComplete,
  Function(PointerDownEvent)? onTapOutside,
  int maxLines = 1,
  int? minLines,
  int? maxLength,
  MaxLengthEnforcement? maxLengthEnforcement,
  Widget? prefixIcon,
  Widget? suffixIcon,
  Widget? prefix,
  Widget? suffix,
  BoxConstraints? prefixIconConstraints,
  BoxConstraints? suffixIconConstraints,
  TextInputType keyboardType = TextInputType.text,
  TextInputAction? textInputAction,
  bool autofocus = false,
  bool readOnly = false,
  bool enabled = true,
  bool obscureText = false,
  bool enableSuggestions = true,
  bool autocorrect = true,
  bool enableIMEPersonalizedLearning = true,
  FocusNode? focusNode,
  double? borderRadius,
  Color? borderColor,
  Color? focusedBorderColor,
  Color? errorBorderColor,
  Color? disabledBorderColor,
  Color? hintColor,
  Color? textColor,
  Color? cursorColor,
  Color? backgroundColor,
  FontWeight fontWeight = FontWeight.w500,
  double? fontSize,
  bool filled = false,
  Color? fillColor,
  double? width,
  double? height,
  EdgeInsetsGeometry? contentPadding,
  TextCapitalization textCapitalization = TextCapitalization.none,
  TextAlign textAlign = TextAlign.start,
  TextAlignVertical? textAlignVertical,
  StrutStyle? strutStyle,
  TextDirection? textDirection,
  bool showCursor = true,
  double cursorWidth = 2.0,
  double? cursorHeight,
  Radius? cursorRadius,
  // bool? autocorrect,
  SmartDashesType? smartDashesType,
  SmartQuotesType? smartQuotesType,
  List<TextInputFormatter>? inputFormatters,
  ScrollPhysics? scrollPhysics,
  ScrollPadding = const EdgeInsets.all(20.0),
  DragStartBehavior dragStartBehavior = DragStartBehavior.start,
  bool enableInteractiveSelection = true,
  // SelectionControls? selectionControls,
  Widget? Function(
    BuildContext, {
    required int currentLength,
    required bool isFocused,
    required int? maxLength,
  })? buildCounter,
  String? restorationId,
  // bool enableIMEPersonalizedLearning = true,
  MouseCursor? mouseCursor,
  void Function()? onAppPrivateCommand,
}) {
  double h = MediaQuery.of(context).size.height;
  double w = MediaQuery.of(context).size.width;

  return SizedBox(
    width: width ?? double.infinity,
    height: height,
    child: TextFormField(
      controller: controller,
      focusNode: focusNode,
      readOnly: readOnly,
      enabled: enabled,
      validator: validator,
      autofocus: autofocus,
      obscureText: obscureText,
      autocorrect: autocorrect,
      enableSuggestions: enableSuggestions,
      onTap: onClicked,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      onEditingComplete: onEditingComplete,
      onTapOutside: onTapOutside,
      style: GoogleFonts.lexendDeca(
        fontSize: fontSize ?? w * .040,
        fontWeight: fontWeight,
        color: textColor ?? Colors.black87,
      ),
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      maxLengthEnforcement: maxLengthEnforcement,
      cursorWidth: cursorWidth,
      cursorHeight: cursorHeight ?? h * .025,
      cursorColor: cursorColor ?? Colors.grey,
      cursorRadius: cursorRadius,
      showCursor: showCursor,
      textCapitalization: textCapitalization,
      textAlign: textAlign,
      textAlignVertical: textAlignVertical,
      strutStyle: strutStyle,
      textDirection: textDirection,
      smartDashesType: smartDashesType,
      smartQuotesType: smartQuotesType,
      inputFormatters: inputFormatters,
      scrollPhysics: scrollPhysics,
      // scrollPadding: scrollPadding,
      dragStartBehavior: dragStartBehavior,
      enableInteractiveSelection: enableInteractiveSelection,
      // selectionControls: selectionControls,
      buildCounter: buildCounter,
      restorationId: restorationId,
      enableIMEPersonalizedLearning: enableIMEPersonalizedLearning,
      mouseCursor: mouseCursor,
      // onAppPrivateCommand: onAppPrivateCommand,
      decoration: InputDecoration(
        isDense: true,
        isCollapsed: false,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        prefix: prefix,
        suffix: suffix,
        prefixIconConstraints: prefixIconConstraints,
        suffixIconConstraints: suffixIconConstraints,
        fillColor: fillColor ?? backgroundColor,
        filled: filled,
        counterText: "",
        contentPadding: contentPadding ?? EdgeInsets.symmetric(
          horizontal: w * .020,
          vertical: w * .035,
        ),
        hintText: hintText,
        hintStyle: GoogleFonts.lexendDeca(
          fontSize: fontSize ?? w * .040,
          fontWeight: fontWeight,
          color: hintColor ?? Colors.grey.shade400,
        ),
        hintMaxLines: 1,
        hintTextDirection: textDirection,
        errorStyle: GoogleFonts.lexendDeca(
          fontSize: w * .030,
          color: Colors.red.shade700,
        ),
        errorMaxLines: 3,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        alignLabelWithHint: false,
        
        // Enabled Border
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? w * .020),
          borderSide: BorderSide(
            color: borderColor ?? Colors.grey, 
            width: 1,
          ),
        ),
        
        // Border
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? w * .020),
          borderSide: BorderSide(
            color: borderColor ?? Colors.grey, 
            width: 1,
          ),
        ),
        
        // Focused Border
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? w * .020),
          borderSide: BorderSide(
            color: focusedBorderColor ?? borderColor ?? Colors.blue, 
            width: 1.5,
          ),
        ),
        
        // Error Border
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? w * .020),
          borderSide: BorderSide(
            color: errorBorderColor ?? Colors.red, 
            width: 1,
          ),
        ),
        
        // Focused Error Border
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? w * .020),
          borderSide: BorderSide(
            color: errorBorderColor ?? Colors.red, 
            width: 1.5,
          ),
        ),
        
        // Disabled Border
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? w * .020),
          borderSide: BorderSide(
            color: disabledBorderColor ?? Colors.grey.shade300, 
            width: 1,
          ),
        ),
      ),
    ),
  );
}


}
