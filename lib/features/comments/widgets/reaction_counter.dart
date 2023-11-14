import 'package:flutter/material.dart';

class ReactionCounter extends StatelessWidget {
  final String reactionImage;
  final int reationCount;
  const ReactionCounter({
    super.key,
    required this.reactionImage,
    required this.reationCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          SizedBox(
            height: 20,
            width: 20,
            child: Image.asset('assets/emojis/$reactionImage.png'),
          ),
          Text(reationCount.toString()),
        ],
      ),
    );
  }
}
