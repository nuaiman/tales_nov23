import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/controllers/auth_controller.dart';

import '../views/share_tale_view.dart';

AppBar talesViewAppBar(BuildContext context, WidgetRef ref) {
  return AppBar(
    automaticallyImplyLeading: false,
    leading: IconButton(
        onPressed: () {
          ref.read(authControllerProvider.notifier).logout(context);
        },
        icon: const Icon(Icons.exit_to_app)),
    centerTitle: true,
    title: const Text('Tales'),
    actions: [
      IconButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const ShareTaleView(),
            ));
          },
          icon: const Icon(Icons.add)),
    ],
  );
}

class ReactionSizedBox extends StatelessWidget {
  final String pngTitle;
  const ReactionSizedBox({
    super.key,
    required this.pngTitle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      width: 30,
      child: Image.asset('assets/emojis/$pngTitle.png'),
    );
  }
}
