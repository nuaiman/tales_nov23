import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/comment_model.dart';
import '../../auth/controllers/auth_controller.dart';
import '../controllers/comment_controller.dart';

class CommentEditDialog extends ConsumerStatefulWidget {
  final String initialValue;
  final CommentModel comment;
  const CommentEditDialog({
    super.key,
    required this.initialValue,
    required this.comment,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CommentEditDialogState();
}

class _CommentEditDialogState extends ConsumerState<CommentEditDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Comment'),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(
          hintText: 'Enter text',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            String newText = _controller.text;
            final currentUser = ref.watch(authControllerProvider);
            ref
                .read(commentsControllerProvider.notifier)
                .updateComment(currentUser.userId, newText, widget.comment);
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
