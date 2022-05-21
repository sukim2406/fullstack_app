import 'package:flutter/material.dart';

class TextInputWidget extends StatelessWidget {
  final double height;
  final double width;
  final String label;
  final TextEditingController controller;
  final bool obsecure;
  final bool enabled;
  const TextInputWidget({
    Key? key,
    required this.height,
    required this.width,
    required this.controller,
    required this.label,
    required this.obsecure,
    required this.enabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: TextField(
        enabled: enabled,
        controller: controller,
        obscureText: obsecure,
        decoration: InputDecoration(
          labelText: label,
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.blue,
            ),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
            ),
          ),
        ),
      ),
    );
  }
}
