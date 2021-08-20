import 'package:flutter/material.dart';
import 'package:movie_info_app_flutter/ui/theme/colors.dart';

class ErrorVidget extends StatelessWidget {
  final String error;
  final Function onRetry;
  const ErrorVidget(this.error, this.onRetry, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(error),
          OutlinedButton(
            onPressed: () => onRetry(),
            child: const Text(
              "Retry",
              style: TextStyle(color: textColor),
            ),
          ),
        ],
      ),
    );
  }
}
