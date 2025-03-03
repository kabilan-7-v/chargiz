import 'package:flutter/material.dart';

showStatus(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.blue.shade200,
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      behavior: SnackBarBehavior.floating,
      content: Text(
        content,
        maxLines: 3,
        style: TextStyle(color: Colors.black),
      ),
      duration: const Duration(milliseconds: 1500),
    ),
  );
}
