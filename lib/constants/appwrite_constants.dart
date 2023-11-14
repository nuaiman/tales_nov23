import 'secret_keys.dart';

class AppwriteConstants {
  static const String projectId = projectIdSecretPass;
  static const String databaseId = '655225cfce2a1940eade';
  static const String endPoint = 'https://cloud.appwrite.io/v1';

  static const String usersCollection = '655225decf122b6bc97f';
  static const String talesCollection = '655373ef10bae559d10a';
  static const String commentsCollection = '6553b0df62a2b77a37e8';

  static const String userImagesBucket = '655228395b781cc2a42d';
  static String appwriteUserPictureUrl(String imageId) =>
      '$endPoint/storage/buckets/$userImagesBucket/files/$imageId/view?project=$projectId&mode=admin';

  static const String taleImagesBucket = '65534aec71fefd74907b';
  static String appwriteTalesPictureUrl(String imageId) =>
      '$endPoint/storage/buckets/$taleImagesBucket/files/$imageId/view?project=$projectId&mode=admin';
}
