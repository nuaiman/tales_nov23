import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tales_nov23/features/tales/controllers/tale_controller.dart';

import '../widgets/tale_tile.dart';
import '../widgets/tales_screen_utils.dart';

class TalesView extends ConsumerWidget {
  const TalesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(talesControllerProvider);
    final tales = ref.watch(talesControllerProvider);
    return Scaffold(
      appBar: talesViewAppBar(context, ref),
      body: ListView.builder(
        itemCount: tales.length,
        itemBuilder: (context, index) => TaleTile(
          tale: tales[index],
        ),
      ),
    );
  }
}
