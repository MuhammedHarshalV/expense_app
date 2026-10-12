import 'package:flutter/material.dart';

class AppMessage {
  static void show(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.onSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Center(
            child: Text(
              "Alert",
              style: TextStyle(
                fontFamily: "Notche",
                fontWeight: FontWeight.bold,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Text(
                  message,
                  style: TextStyle(
                    fontFamily: "Notche",
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
