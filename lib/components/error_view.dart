import 'package:flutter/material.dart';
import 'package:pokedex/i18n/strings.g.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({
    required this.text,
    this.retry,
    this.enableRetryButton = true,
    super.key,
  });

  final String text;
  final void Function()? retry;
  final bool enableRetryButton;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text),
          if (enableRetryButton && retry != null)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: ElevatedButton(
                onPressed: retry,
                child: Text(t.retry),
              ),
            ),
        ],
      ),
    );
  }
}
