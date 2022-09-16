import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton(
      {Key? key,
      required this.buttonText,
      required this.buttonTextColor,
      required this.buttonColor,
      required this.callback})
      : super(key: key);

  final String buttonText;
  final Color buttonTextColor;
  final Color buttonColor;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
          backgroundColor: buttonColor,
          padding: const EdgeInsets.fromLTRB(70, 12, 70, 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          side: BorderSide(
              width: 3, color: Theme.of(context).colorScheme.primary)),
      onPressed: callback,
      child: Text(buttonText,
          style: TextStyle(fontSize: 20, color: buttonTextColor)),
    );
  }
}
