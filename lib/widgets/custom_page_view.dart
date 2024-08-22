import 'package:flutter/material.dart';

class CustomPageView extends StatelessWidget {
  final PageController controller;
  final List<Widget> children;

  const CustomPageView({
    super.key,
    required this.controller,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: controller,
      children: children,
    );
  }
}
