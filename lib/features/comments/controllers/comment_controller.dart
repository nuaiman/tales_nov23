import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tales_nov23/apis/comments_api.dart';
import 'package:tales_nov23/models/comment_model.dart';
import 'package:tales_nov23/models/tale_model.dart';

import '../../../constants/appwrite_constants.dart';
import '../../../core/utils.dart';

class CommentsController extends StateNotifier<List<CommentModel>> {
  final CommentApi _commentsApi;
  CommentsController({required CommentApi commentsApi})
      : _commentsApi = commentsApi,
        super([]);

  void addComment(BuildContext context, TaleModel tale, String text) async {
    CommentModel comment = CommentModel(
      taleId: tale.id,
      userId: tale.userId,
      userName: tale.userName,
      userImageUrl: tale.userImageUrl,
      text: text,
      reactionValue: 'null',
      unlikedIds: [tale.userId],
      likeIds: [],
      laughIds: [],
      loveIds: [],
      angryIds: [],
      time: DateTime.now(),
    );
    final result = await _commentsApi.shareComment(comment);
    result.fold(
      (l) => showSnackbar(context, l.message),
      (r) => null,
    );
  }

  void getAllComments(String currentUserId) async {
    final commentsList = await _commentsApi.getComments();

    state = commentsList.map((comment) {
      CommentModel eitableComment = CommentModel.fromMap(comment.data);

      if (eitableComment.likeIds.contains(currentUserId)) {
        eitableComment = eitableComment.copyWith(reactionValue: 'like');
      } else if (eitableComment.laughIds.contains(currentUserId)) {
        eitableComment = eitableComment.copyWith(reactionValue: 'laugh');
      } else if (eitableComment.loveIds.contains(currentUserId)) {
        eitableComment = eitableComment.copyWith(reactionValue: 'love');
      } else if (eitableComment.angryIds.contains(currentUserId)) {
        eitableComment = eitableComment.copyWith(reactionValue: 'angry');
      } else {
        eitableComment =
            eitableComment.copyWith(reactionValue: 'like_outlined');
      }
      return eitableComment;
    }).toList();
    final newState = [...state.toSet().toList()];
    state = newState;
  }

  void startListeningForUpdates(
      String currentUserId, BuildContext context, WidgetRef ref) {
    final commentsStream = _commentsApi.getLatestComment();
    commentsStream.listen((RealtimeMessage message) {
      if (message.events.contains(
          'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.commentsCollection}.documents.*.create')) {
        getAllComments(currentUserId);
      } else if (message.events.contains(
          'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.commentsCollection}.documents.*.update')) {
        final updatedIndex = state.indexWhere((element) =>
            element.id == CommentModel.fromMap(message.payload).id);
        state.removeWhere((element) =>
            element.id == CommentModel.fromMap(message.payload).id);
        state.insert(updatedIndex, CommentModel.fromMap(message.payload));
        final newState = [...state];
        state = newState;
      }
    }).onError((_) {
      startListeningForUpdates(currentUserId, context, ref);
    });
  }

  void reactToComment(
      String value, CommentModel comment, String currentUserId) async {
    CommentModel updatedAbleComment = comment.copyWith(reactionValue: value);
    // ----------------------------------
    if (updatedAbleComment.unlikedIds.contains(currentUserId)) {
      updatedAbleComment.unlikedIds.remove(currentUserId);
    }
    if (updatedAbleComment.likeIds.contains(currentUserId)) {
      updatedAbleComment.likeIds.remove(currentUserId);
    }
    if (updatedAbleComment.laughIds.contains(currentUserId)) {
      updatedAbleComment.laughIds.remove(currentUserId);
    }
    if (updatedAbleComment.loveIds.contains(currentUserId)) {
      updatedAbleComment.loveIds.remove(currentUserId);
    }
    if (updatedAbleComment.angryIds.contains(currentUserId)) {
      updatedAbleComment.angryIds.remove(currentUserId);
    }
    // ----------------------------------
    if (value == 'like') {
      updatedAbleComment.likeIds.add(currentUserId);
    } else if (value == 'laugh') {
      updatedAbleComment.laughIds.add(currentUserId);
    } else if (value == 'love') {
      updatedAbleComment.loveIds.add(currentUserId);
    } else if (value == 'angry') {
      updatedAbleComment.angryIds.add(currentUserId);
    } else if (value == 'like_outlined') {
      updatedAbleComment.unlikedIds.add(currentUserId);
    }
    // -------------------
    if (value == 'like') {
      updatedAbleComment = updatedAbleComment.copyWith(reactionValue: 'like');
    } else if (value == 'laugh') {
      updatedAbleComment = updatedAbleComment.copyWith(reactionValue: 'laugh');
    } else if (value == 'love') {
      updatedAbleComment = updatedAbleComment.copyWith(reactionValue: 'love');
    } else if (value == 'angry') {
      updatedAbleComment = updatedAbleComment.copyWith(reactionValue: 'angry');
    } else if (value == 'like_outlined') {
      updatedAbleComment =
          updatedAbleComment.copyWith(reactionValue: 'like_outlined');
    }
    // -------------------
    final updatableIndex =
        state.indexWhere((element) => element.id == updatedAbleComment.id);
    state.removeAt(updatableIndex);
    state.insert(updatableIndex, updatedAbleComment);
    final newState = [...state.toSet().toList()];
    state = newState;
    await _commentsApi.updateComment(updatedAbleComment);
  }

  // void reactToComment(String value, CommentModel updateAbleComment,
  //     String currentUserId) async {
  //   CommentModel comment = updateAbleComment;
  //   CommentModel updatedComment = comment.copyWith(reactionValue: value);

  //   if (comment.likeIds.contains(currentUserId)) {
  //     comment.likeIds.remove(currentUserId);
  //   }
  //   if (comment.laughIds.contains(currentUserId)) {
  //     comment.laughIds.remove(currentUserId);
  //   }
  //   if (comment.loveIds.contains(currentUserId)) {
  //     comment.loveIds.remove(currentUserId);
  //   }
  //   if (comment.angryIds.contains(currentUserId)) {
  //     comment.angryIds.remove(currentUserId);
  //   }
  //   // ----------------------------------
  //   if (value == 'like') {
  //     comment.likeIds.add(currentUserId);
  //   } else if (value == 'laugh') {
  //     comment.laughIds.add(currentUserId);
  //   } else if (value == 'love') {
  //     comment.loveIds.add(currentUserId);
  //   } else if (value == 'angry') {
  //     comment.angryIds.add(currentUserId);
  //   }
  //   _commentsApi.updateComment(updatedComment);
  //   // -------------------
  //   state = state.map((comment) {
  //     CommentModel eitableComment = comment;
  //     if (eitableComment.likeIds.contains(currentUserId)) {
  //       eitableComment = eitableComment.copyWith(reactionValue: 'like');
  //     } else if (eitableComment.laughIds.contains(currentUserId)) {
  //       eitableComment = eitableComment.copyWith(reactionValue: 'laugh');
  //     } else if (eitableComment.loveIds.contains(currentUserId)) {
  //       eitableComment = eitableComment.copyWith(reactionValue: 'love');
  //     } else if (eitableComment.angryIds.contains(currentUserId)) {
  //       eitableComment = eitableComment.copyWith(reactionValue: 'angry');
  //     } else {
  //       eitableComment =
  //           eitableComment.copyWith(reactionValue: 'like_outlined');
  //     }
  //     return eitableComment;
  //   }).toList();
  //   final newState = [...state.toSet().toList()];
  //   state = newState;
  // }
}
// -----------------------------------------------------------------------------

final commentsControllerProvider =
    StateNotifierProvider<CommentsController, List<CommentModel>>((ref) {
  final commentsApi = ref.watch(commentApiProvider);
  return CommentsController(commentsApi: commentsApi);
});
