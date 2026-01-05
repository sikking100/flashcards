import 'package:flutter/material.dart';

class WidgetLoading extends StatelessWidget {
  const WidgetLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 10, width: 10, child: CircularProgressIndicator.adaptive());
  }
}
