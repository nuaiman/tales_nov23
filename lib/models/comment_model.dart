import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

@immutable
class CommentModel {
  final String id;
  final String taleId;
  final String userId;
  final String userName;
  final String userImageUrl;
  final String text;
  final DateTime time;
  final String reactionValue;
  final List<String> likeIds;
  final List<String> unlikedIds;
  final List<String> laughIds;
  final List<String> loveIds;
  final List<String> angryIds;
  CommentModel({
    String? id,
    DateTime? time,
    required this.taleId,
    required this.userId,
    required this.userName,
    required this.userImageUrl,
    required this.text,
    required this.reactionValue,
    required this.likeIds,
    required this.unlikedIds,
    required this.laughIds,
    required this.loveIds,
    required this.angryIds,
  })  : id = id ?? const Uuid().v4(),
        time = time ?? DateTime.now();

  CommentModel copyWith({
    String? id,
    String? taleId,
    String? userId,
    String? userName,
    String? userImageUrl,
    String? text,
    DateTime? time,
    String? reactionValue,
    List<String>? likeIds,
    List<String>? unlikedIds,
    List<String>? laughIds,
    List<String>? loveIds,
    List<String>? angryIds,
  }) {
    return CommentModel(
      id: id ?? this.id,
      taleId: taleId ?? this.taleId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userImageUrl: userImageUrl ?? this.userImageUrl,
      text: text ?? this.text,
      time: time ?? this.time,
      reactionValue: reactionValue ?? this.reactionValue,
      likeIds: likeIds ?? this.likeIds,
      unlikedIds: unlikedIds ?? this.unlikedIds,
      laughIds: laughIds ?? this.laughIds,
      loveIds: loveIds ?? this.loveIds,
      angryIds: angryIds ?? this.angryIds,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'taleId': taleId});
    result.addAll({'userId': userId});
    result.addAll({'userName': userName});
    result.addAll({'userImageUrl': userImageUrl});
    result.addAll({'text': text});
    result.addAll({'time': time.millisecondsSinceEpoch});
    result.addAll({'likeIds': likeIds});
    result.addAll({'unlikedIds': unlikedIds});
    result.addAll({'laughIds': laughIds});
    result.addAll({'loveIds': loveIds});
    result.addAll({'angryIds': angryIds});

    return result;
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      id: map['\$id'] ?? '',
      taleId: map['taleId'] ?? '',
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      userImageUrl: map['userImageUrl'] ?? '',
      text: map['text'] ?? '',
      time: DateTime.fromMillisecondsSinceEpoch(map['time']),
      reactionValue: map['reactionValue'] ?? '',
      likeIds: List<String>.from(map['likeIds']),
      unlikedIds: List<String>.from(map['unlikedIds']),
      laughIds: List<String>.from(map['laughIds']),
      loveIds: List<String>.from(map['loveIds']),
      angryIds: List<String>.from(map['angryIds']),
    );
  }

  String toJson() => json.encode(toMap());

  factory CommentModel.fromJson(String source) =>
      CommentModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CommentModel(id: $id, taleId: $taleId, userId: $userId, userName: $userName, userImageUrl: $userImageUrl, text: $text, time: $time, reactionValue: $reactionValue, likeIds: $likeIds, unlikedIds: $unlikedIds, laughIds: $laughIds, loveIds: $loveIds, angryIds: $angryIds)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CommentModel &&
        other.id == id &&
        other.taleId == taleId &&
        other.userId == userId &&
        other.userName == userName &&
        other.userImageUrl == userImageUrl &&
        other.text == text &&
        other.time == time &&
        other.reactionValue == reactionValue &&
        listEquals(other.likeIds, likeIds) &&
        listEquals(other.unlikedIds, unlikedIds) &&
        listEquals(other.laughIds, laughIds) &&
        listEquals(other.loveIds, loveIds) &&
        listEquals(other.angryIds, angryIds);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        taleId.hashCode ^
        userId.hashCode ^
        userName.hashCode ^
        userImageUrl.hashCode ^
        text.hashCode ^
        time.hashCode ^
        reactionValue.hashCode ^
        likeIds.hashCode ^
        unlikedIds.hashCode ^
        laughIds.hashCode ^
        loveIds.hashCode ^
        angryIds.hashCode;
  }
}
