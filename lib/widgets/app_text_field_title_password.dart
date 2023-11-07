import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lost_and_found_app_staff/utils/app_layout.dart';

import '../utils/colors.dart';

class AppTextFieldTitlePassword extends StatefulWidget {
  late var textController;
  final String hintText;
  final String titleText;
  final String validator;

  AppTextFieldTitlePassword({
    Key? key,
    required this.textController,
    required this.hintText,
    required this.titleText,
    required this.validator,
  }) : super(key: key);

  @override
  _AppTextFieldTitlePasswordState createState() =>
      _AppTextFieldTitlePasswordState();
}

class _AppTextFieldTitlePasswordState extends State<AppTextFieldTitlePassword> {
  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 20),
          child: Text(
            widget.titleText,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Gap(AppLayout.getHeight(15)),
        Container(
          height: AppLayout.getHeight(55),
          margin: EdgeInsets.only(
              left: AppLayout.getHeight(20), right: AppLayout.getHeight(20)),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(AppLayout.getHeight(20)),
            boxShadow: [
              BoxShadow(
                blurRadius: 4,
                spreadRadius: 4,
                offset: Offset(0, 4),
                color: Colors.grey.withOpacity(0.2),
              ),
            ],
          ),
          child: TextFormField(
            onSaved: (value) => widget.textController = value,
            style: Theme.of(context).textTheme.headlineSmall,
            controller: widget.textController,
            obscureText: _obscureText, // Use _obscureText to toggle visibility
            decoration: InputDecoration(
              isDense: true,
              hintText: widget.hintText,
              hintStyle: Theme.of(context).textTheme.labelSmall,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppLayout.getHeight(20)),
                borderSide: BorderSide(
                  width: 1.0,
                  color: Colors.white,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppLayout.getHeight(20)),
                borderSide: BorderSide(width: 1.0, color: Colors.white),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: _togglePasswordVisibility,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return widget.validator;
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
