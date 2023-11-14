import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import '../core/failure.dart';
import '../core/type_defs.dart';

import '../constants/appwrite_constants.dart';
import '../core/appwrite_providers.dart';
import '../models/tale_model.dart';

abstract class ITaleApi {
  FutureEither<Document> shareTale(TaleModel tale);
  Future<List<Document>> getTales();
  Stream<RealtimeMessage> getLatestTale();
  FutureVoid deleteTale(String taleId);
  FutureVoid updateTale(TaleModel tale);
}
// -----------------------------------------------------------------------------

class TaleApi implements ITaleApi {
  final Databases _db;
  final Realtime _realtime;
  TaleApi({
    required Databases databases,
    required Realtime realtime,
  })  : _db = databases,
        _realtime = realtime;

  @override
  FutureEither<Document> shareTale(TaleModel tale) async {
    try {
      final document = await _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.talesCollection,
        documentId: tale.id,
        data: tale.toMap(),
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
  Future<List<Document>> getTales() async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.talesCollection,
      queries: [
        Query.orderDesc('time'),
      ],
    );
    return documents.documents;
  }

  @override
  Stream<RealtimeMessage> getLatestTale() {
    final realtime = _realtime.subscribe([
      'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.talesCollection}.documents'
    ]).stream;
    return realtime;
  }

  @override
  FutureVoid deleteTale(String taleId) async {
    await _db.deleteDocument(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.talesCollection,
      documentId: taleId,
    );
  }

  @override
  FutureVoid updateTale(TaleModel tale) async {
    await _db.updateDocument(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.talesCollection,
      documentId: tale.id,
      data: tale.toMap(),
    );
  }
}
// -----------------------------------------------------------------------------

final taleApiProvider = Provider((ref) {
  final databases = ref.watch(appwriteDatabaseProvider);
  final realtime = ref.watch(appwriteRealtimeProvider);
  return TaleApi(
    databases: databases,
    realtime: realtime,
  );
});
