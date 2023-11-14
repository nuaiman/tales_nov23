import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:tales_nov23/core/failure.dart';
import 'package:tales_nov23/core/type_defs.dart';
import 'package:tales_nov23/models/comment_model.dart';

import '../constants/appwrite_constants.dart';
import '../core/appwrite_providers.dart';

abstract class ICommentApi {
  FutureEither<Document> shareComment(CommentModel comment);
  Future<List<Document>> getComments();
  Stream<RealtimeMessage> getLatestComment();
  FutureVoid updateComment(CommentModel comment);
  FutureVoid deleteComment(String commentId);
}
// -----------------------------------------------------------------------------

class CommentApi implements ICommentApi {
  final Databases _db;
  final Realtime _realtime;
  CommentApi({
    required Databases databases,
    required Realtime realtime,
  })  : _db = databases,
        _realtime = realtime;

  @override
  FutureEither<Document> shareComment(CommentModel comment) async {
    try {
      final document = await _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.commentsCollection,
        documentId: comment.id,
        data: comment.toMap(),
      );
      return right(document);
    } on AppwriteException catch (e, stackTrace) {
      return left(
          Failure(e.message ?? 'Some unexpected error occured!', stackTrace));
    } catch (e, stackTrace) {
      return left(Failure(e.toString(), stackTrace));
    }
  }

  @override
  Future<List<Document>> getComments() async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.commentsCollection,
      queries: [
        Query.orderDesc('time'),
      ],
    );
    return documents.documents;
  }

  @override
  Stream<RealtimeMessage> getLatestComment() {
    final realtime = _realtime.subscribe([
      'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.commentsCollection}.documents'
    ]).stream;
    return realtime;
  }

  @override
  FutureVoid updateComment(CommentModel comment) async {
    await _db.updateDocument(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.commentsCollection,
      documentId: comment.id,
      data: comment.toMap(),
    );
  }

  @override
  FutureVoid deleteComment(String commentId) async {
    await _db.deleteDocument(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.commentsCollection,
      documentId: commentId,
    );
  }
}
// -----------------------------------------------------------------------------

final commentApiProvider = Provider((ref) {
  final databases = ref.watch(appwriteDatabaseProvider);
  final realtime = ref.watch(appwriteRealtimeProvider);
  return CommentApi(
    databases: databases,
    realtime: realtime,
  );
});
