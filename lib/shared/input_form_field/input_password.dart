import 'package:flutter/material.dart';

enum ObscureText { show, hide }

class InputPassword extends StatelessWidget {
  final String? label;
  final String hint;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final FocusNode? currentFocusNode;
  final double borderRadius;

  final FocusNode? nextFocusNode;
  final double topMargin;
  final Widget? suffixIconWidget, prefixIconWidget;

  final bool enabled;
  final Color? fillColor, borderColor;

  final List<String>? autofillHints;

  InputPassword({
    super.key,
    this.label,
    required this.hint,
    required this.controller,
    this.validator,
    this.currentFocusNode,
    this.nextFocusNode,
    this.topMargin = 25.0,
    this.borderRadius = 10,
    this.suffixIconWidget,
    this.prefixIconWidget,
    this.enabled = true,
    this.autofillHints,
    this.fillColor,
    this.borderColor,
  });

  final ValueNotifier<ObscureText> _obscureNotifier =
      ValueNotifier<ObscureText>(ObscureText.hide);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ObscureText>(
      valueListenable: _obscureNotifier,
      builder: (context, val, _) {
        return Container(
          margin: EdgeInsets.only(top: topMargin),
          child: TextFormField(
            autofillHints: autofillHints,
            enabled: enabled,
            controller: controller,
            validator: validator,
            focusNode: currentFocusNode,
            onFieldSubmitted: (value) {
              if (nextFocusNode != null) {
                FocusScope.of(context).requestFocus(nextFocusNode);
              }
            },
            obscureText: val == ObscureText.hide,
            decoration: InputDecoration(
              errorMaxLines: 5,
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
                  ? Text(
                      label!,
                      style: const TextStyle(
                        color: Colors.black87,
                        height: 1.3,
                      ),
                    )
                  : null,
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.grey, height: 1.3),
              suffixIcon: IconButton(
                onPressed: () {
                  if (val == ObscureText.hide) {
                    _obscureNotifier.value = ObscureText.show;
                  } else {
                    _obscureNotifier.value = ObscureText.hide;
                  }
                },
                icon: Icon(
                  val == ObscureText.hide
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.grey,
                ),
              ),
              prefixIcon: prefixIconWidget,
              filled: true,
              fillColor: fillColor ?? Colors.grey[100],
            ),
          ),
        );
      },
    );
  }
}
