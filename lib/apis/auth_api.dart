import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../constants/appwrite_constants.dart';
import '../core/appwrite_providers.dart';
import '../core/failure.dart';
import '../core/type_defs.dart';
import '../models/user_model.dart';

abstract class IAuthApi {
  Future<User?> getCurrentAccount();

  FutureEither<User> signup({
    required String userId,
    required String email,
    required String password,
  });

  FutureEither<Session> login({
    required String email,
    required String password,
  });

  Future<void> recoverPassword(String email);

  FutureEitherVoid updateProfile({required UserModel user});

  FutureEither<Document> getUserWithId({required String userId});

  FutureEitherVoid logout();
}
// -----------------------------------------------------------------------------

class AuthApi implements IAuthApi {
  final Account _account;
  final Databases _databases;
  AuthApi({
    required Account account,
    required Databases databases,
  })  : _account = account,
        _databases = databases;

  @override
  Future<User?> getCurrentAccount() async {
    try {
      return await _account.get();
    } on AppwriteException catch (_) {
      return null;
    }
  }

  @override
  FutureEither<User> signup({
    required String userId,
    required String email,
    required String password,
  }) async {
    try {
      final user = await _account.create(
          userId: userId, email: email, password: password);
      return right(user);
    } on AppwriteException catch (e, stackTrace) {
      return Left(Failure(
          e.message ?? 'Couldn\'t create session. Please try again later.',
          stackTrace));
    } catch (e, stackTrace) {
      return left(Failure(e.toString(), stackTrace));
    }
  }

  @override
  FutureEither<Session> login({
    required String email,
    required String password,
  }) async {
    try {
      final session =
          await _account.createEmailSession(email: email, password: password);
      return right(session);
    } on AppwriteException catch (e, stackTrace) {
      return Left(Failure(
          e.message ?? 'Couldn\'t verify session. Please try again later.',
          stackTrace));
    } catch (e, stackTrace) {
      return left(Failure(e.toString(), stackTrace));
    }
  }

  @override
  FutureEitherVoid updateProfile({required UserModel user}) async {
    try {
      await _account.updateName(name: user.name);

      try {
        await _databases.updateDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.usersCollection,
          documentId: user.userId,
          data: user.toMap(),
        );
      } on AppwriteException catch (_) {
        await _databases.createDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.usersCollection,
          documentId: user.userId,
          data: user.toMap(),
        );
      }

      return right(null);
    } on AppwriteException catch (e, stackTrace) {
      return left(Failure(e.message ?? 'Couldn\'t update profile', stackTrace));
    }
  }

  @override
  FutureEither<Document> getUserWithId({required String userId}) async {
    try {
      Document document = await _databases.getDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.usersCollection,
        documentId: userId,
      );
      return right(document);
    } on AppwriteException catch (e, stackTrace) {
      return left(
        Failure(
          e.message ?? 'Couldn\'t get user with the particular ID',
          stackTrace,
        ),
      );
    }
  }

  @override
  FutureEitherVoid logout() async {
    try {
      await _account.deleteSession(sessionId: 'current');
      return right(null);
    } on AppwriteException catch (e, stackTrace) {
      return left(
          Failure(e.message ?? 'Some unexpected error occured!', stackTrace));
    } catch (e, stackTrace) {
      return left(Failure(e.toString(), stackTrace));
    }
  }

  @override
  Future<void> recoverPassword(String email) async {
    await _account.createRecovery(email: email, url: '');
  }
}
// -----------------------------------------------------------------------------

final authApiProvider = Provider((ref) {
  final account = ref.watch(appwriteAccountProvider);
  final databases = ref.watch(appwriteDatabaseProvider);
  return AuthApi(
    account: account,
    databases: databases,
  );
});
