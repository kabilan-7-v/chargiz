import 'dart:convert';
import 'dart:math';

import 'package:chargiz/services/common_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

const randEmails = [
  'suresh',
  'ramesh',
  'thothathri',
  'tharkuri',
  'kishore',
  'theduvia',
  'miakutty',
  'sunny',
  'rajesh',
  'kamesh',
  'raahul',
  'kokkikumar',
];

class PaymentServices {
  static final Random random = Random();

  static Future<Map<String, dynamic>?> generateQR({
    required BuildContext context,
    required int totalSum,
    required String serverUri,
  }) async {
    try {
      //   serverUri = 'http://192.168.95.41:3000'; ////// only for testing
      http.Response res =
          await http.post(Uri.parse('$serverUri/api/generate-qr'),
              headers: <String, String>{
                'Content-Type': 'application/json',
              },
              body: jsonEncode({
                'amount': totalSum,
              }));
      final resData = jsonDecode(res.body);
      if (res.statusCode != 200) {
        showStatus(res.body, context);
        throw 'Error in requesting payment session';
      }
      debugPrint(resData.toString());
      return {
        'url': resData['link'],
        'id': resData['id'],
      };
    } catch (e) {
      showStatus(
        "Request failed, try again",
        context,
      );
    }
    return null;
  }

  static Future<bool> verifyPayment({
    required String id,
    required String serverUri,
    required BuildContext context,
  }) async {
    try {
      //   serverUri = 'http://192.168.95.41:3000'; ////// only for testing
      http.Response res = await http.post(Uri.parse('$serverUri/api/verify-qr'),
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'id': id,
          }));
      final resData = jsonDecode(res.body);
      if (res.statusCode != 200) {
        false;
      }
      if (resData['payments_amount_received'] >= resData['payment_amount']) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
