import 'package:flutter/material.dart';

class WaitWidget extends StatelessWidget {
  const WaitWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
