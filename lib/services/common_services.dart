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

String calculateTravelTime(double distanceInKm) {
  const double speedKmPerHour = 40.0;
  double timeInHours = distanceInKm / speedKmPerHour;

  int hours = timeInHours.floor();
  int minutes = ((timeInHours - hours) * 60).ceil();

  if (hours > 0 && minutes > 0) {
    return "$hours hrs $minutes mins";
  } else if (hours > 0) {
    return "$hours hrs";
  } else {
    return "$minutes mins";
  }
}

double calculateTimeInSeconds(double distanceInKm) {
  const double speedKmPerHour = 40.0;
  double timeInHours = distanceInKm / speedKmPerHour;

  return (timeInHours * 3600);
}
