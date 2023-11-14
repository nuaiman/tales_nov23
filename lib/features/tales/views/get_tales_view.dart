import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../comments/controllers/comment_controller.dart';
import '../controllers/tale_controller.dart';

class GetTalesView extends ConsumerStatefulWidget {
  const GetTalesView({super.key});

  @override
  ConsumerState<GetTalesView> createState() => _GetTalesViewState();
}

class _GetTalesViewState extends ConsumerState<GetTalesView> {
  @override
  Widget build(BuildContext context) {
    final currentUser = ref.read(authControllerProvider);
    ref
        .read(talesControllerProvider.notifier)
        .getAllTales(currentUser.userId, context, ref);
    ref
        .read(commentsControllerProvider.notifier)
        .getAllComments(currentUser.userId);
    ref
        .read(talesControllerProvider.notifier)
        .startListeningForUpdates(currentUser.userId, context, ref);
    ref
        .read(commentsControllerProvider.notifier)
        .startListeningForUpdates(currentUser.userId, context, ref);
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          color: Colors.black,
        ),
      ),
    );
  }
}
