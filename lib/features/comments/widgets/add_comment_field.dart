import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tales_nov23/features/comments/controllers/comment_controller.dart';
import 'package:tales_nov23/models/tale_model.dart';

class AddCommentField extends ConsumerStatefulWidget {
  final TaleModel tale;
  const AddCommentField({
    super.key,
    required this.tale,
  });

  @override
  ConsumerState<AddCommentField> createState() => _AddCommentFieldState();
}

class _AddCommentFieldState extends ConsumerState<AddCommentField> {
  final _textController = TextEditingController();
  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              controller: _textController,
              decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.all(8),
                  border: OutlineInputBorder(),
                  hintText: 'add comment'),
            ),
          ),
          Container(
            height: 55,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: Card(
              color: const Color(0xFF242424),
              child: RotatedBox(
                quarterTurns: 3,
                child: IconButton(
                  onPressed: () {
                    if (_textController.text.isEmpty) {
                      return;
                    }
                    ref.read(commentsControllerProvider.notifier).addComment(
                        context, widget.tale, _textController.text.trim());
                    _textController.clear();
                    FocusManager.instance.primaryFocus!.unfocus();
                  },
                  icon: const Icon(Icons.send, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
