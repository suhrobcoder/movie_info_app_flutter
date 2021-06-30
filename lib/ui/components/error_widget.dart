import 'package:flutter/material.dart';

class ErrorVidget extends StatelessWidget {
  final String error;
  final Function onRetry;
  const ErrorVidget(this.error, this.onRetry, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(error),
          OutlinedButton(
            onPressed: () => onRetry(),
            child: Text("Retrty"),
          ),
        ],
      ),
    );
  }
}
