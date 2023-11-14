import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/loader_provider.dart';

class LargeElevatedButton extends ConsumerWidget {
  final String title;
  final VoidCallback function;
  const LargeElevatedButton({
    super.key,
    required this.title,
    required this.function,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loader = ref.watch(loadingControllerProvider);
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        minimumSize: const Size.fromHeight(45),
      ),
      onPressed: loader ? () {} : function,
      child: loader
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            )
          : Text(
              title,
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
    );
  }
}
