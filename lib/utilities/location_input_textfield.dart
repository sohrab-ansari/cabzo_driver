import 'package:nzcu_driver/utilities/colors/colors_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LocationInputTextfield extends StatefulWidget {
  final String preffixImage;
  final Color? backgroundColor;
  final String? hintText;
  final double? hintFontSize;
  final double? preffixhorizontalPadding;
  final double? preffixverticalPadding;
  final TextEditingController? address;
  final VoidCallback onPressed;
  final String? additionalImage;

  /// NEW: Enable text editing (default false for backward compatibility)
  final bool isEditable;

  /// NEW: Callback when text changes
  final ValueChanged<String>? onChanged;

  /// NEW: Show clear button when text is present
  final bool showClearButton;

  /// NEW: Callback when clear button is pressed
  final VoidCallback? onClear;

  const LocationInputTextfield({
    super.key,
    this.backgroundColor,
    this.hintText,
    this.additionalImage,
    required this.onPressed,
    this.preffixhorizontalPadding,
    this.preffixverticalPadding,
    required this.preffixImage,
    this.hintFontSize,
    this.address,
    this.isEditable = false,
    this.onChanged,
    this.showClearButton = false,
    this.onClear,
  });

  @override
  State<LocationInputTextfield> createState() => _LocationInputTextfieldState();
}

class _LocationInputTextfieldState extends State<LocationInputTextfield> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: widget.isEditable ? null : widget.onPressed,
      child: TextFormField(
        controller: widget.address,
        cursorColor: ColorsList.textColor,
        cursorWidth: 2.0,
        cursorHeight: w * 0.05,
        readOnly: !widget.isEditable,
        onChanged: widget.onChanged,
        onTap: widget.isEditable ? null : widget.onPressed,
        style: GoogleFonts.blinker(
          color: Colors.black,
          fontSize: w * .04,
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          hintText: widget.hintText ?? "",
          hintStyle: GoogleFonts.blinker(
            color: Colors.black54,
            fontSize: widget.hintFontSize ?? w * .04,
            fontWeight: FontWeight.w400,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(w * .03),
            borderSide: BorderSide(
              color: ColorsList.textfieldBorderColorSe,
              width: 1.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(w * .03),
            borderSide: BorderSide(
              color: ColorsList.textfieldBorderColorSe,
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(w * .03),
            borderSide: BorderSide(
              color: ColorsList.textfieldBorderColorSe,
              width: 2,
            ),
          ),
          isCollapsed: true,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(
            vertical: w * .035,
            horizontal: w * .04,
          ),
          filled: true,
          fillColor: widget.backgroundColor ?? ColorsList.scaffoldColor,
          prefixIcon: Padding(
            padding: EdgeInsets.only(
              left: widget.preffixhorizontalPadding ?? w * .02,
              top: widget.preffixverticalPadding ?? w * .04,
              bottom: widget.preffixverticalPadding ?? w * .04,
            ),
            child: Image.asset(
              widget.preffixImage,
              width: w * .05,
              height: w * .05,
            ),
          ),
          suffixIcon:
              widget.showClearButton &&
                  widget.address != null &&
                  widget.address!.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.close, size: w * .05, color: Colors.grey),
                  onPressed: () {
                    widget.address?.clear();
                    widget.onClear?.call();
                  },
                )
              : null,
        ),
      ),
    );
  }
}
