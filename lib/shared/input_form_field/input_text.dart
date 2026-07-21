import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InputText extends StatelessWidget {
  final String? label, hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final FocusNode? currentFocusNode;
  final FocusNode? nextFocusNode;
  final Widget? suffixIconWidget, prefixIconWidget;
  final int? maxLines;
  final double topMargin;
  final double borderRadius;
  final EdgeInsets? contentPadding;
  final TextInputType? textInputType;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  // final VoidCallback? onSaved;
  final VoidCallback? onEditingComplete;
  final bool enabled, autofocus, readOnly;
  final Color? fillColor, borderColor;
  final TextStyle? hintStyle;
  final List<String>? autofillHints;

  const InputText({
    super.key,
    this.label,
    this.contentPadding,
    this.hint,
    this.controller,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.fillColor,
    this.currentFocusNode,
    this.nextFocusNode,
    this.suffixIconWidget,
    this.prefixIconWidget,
    this.maxLines = 1,
    this.topMargin = 25.0,
    this.textInputType,
    this.enabled = true,
    this.readOnly = false,
    this.borderRadius = 10,
    this.autofocus = false,
    // this.onSaved ,
    this.onEditingComplete,
    this.hintStyle,
    this.borderColor,
    this.autofillHints,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: topMargin),
      child: TextFormField(
        autofillHints: autofillHints,
        // onSaved: onSaved,
        onEditingComplete: onEditingComplete,
        autofocus: autofocus,
        enabled: enabled,
        readOnly: readOnly,
        onChanged: onChanged,
        keyboardType: textInputType,
        controller: controller,
        maxLines: maxLines,
        validator: validator,
        focusNode: currentFocusNode,
        onFieldSubmitted:
            onFieldSubmitted ??
            (value) {
              if (nextFocusNode != null) {
                FocusScope.of(context).requestFocus(nextFocusNode);
              }
            },
        decoration: InputDecoration(
          contentPadding: contentPadding ?? const EdgeInsets.all(0),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: OutlineInputBorder(
            // borderRadius: BorderRadius.circular(0),
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              color: fillColor ?? Colors.transparent,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            // borderRadius: BorderRadius.circular(0),
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            // borderRadius: BorderRadius.circular(0),
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              color: borderColor ?? fillColor ?? Colors.transparent,
              width: 2,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),

            // borderRadius: BorderRadius.circular(0),
            borderSide: BorderSide(
              color: borderColor ?? fillColor ?? Colors.transparent,
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            // borderRadius: BorderRadius.circular(0),
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              color: borderColor ?? fillColor ?? Colors.transparent,
              width: 2,
            ),
          ),
          label: label != null
              ? Text(label!, style: TextStyle(fontSize: 13.sp, height: 1.3))
              : null,
          hintText: hint,
          hintStyle:
              hintStyle ??
              TextStyle(fontSize: 13.sp, height: 1.3, color: Colors.black38),
          suffixIcon: suffixIconWidget,
          prefixIcon: prefixIconWidget,
          filled: true,
          isDense: true,
          // fillColor: const Color(0xff151515),
          fillColor: fillColor ?? Colors.grey[100],
        ),
      ),
    );
  }
}
