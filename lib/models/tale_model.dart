import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

@immutable
class TaleModel {
  final String id;
  final String userId;
  final String userName;
  final String userImageUrl;
  final String? title;
  final List<String>? images;
  final List<String> commentIds;
  final DateTime time;
  final String reactionValue;
  final List<String> unlikedIds;
  final List<String> likeIds;
  final List<String> laughIds;
  final List<String> loveIds;
  final List<String> angryIds;
  TaleModel({
    String? id,
    DateTime? time,
    required this.userId,
    required this.userName,
    required this.userImageUrl,
    this.title,
    this.images,
    required this.commentIds,
    required this.reactionValue,
    required this.unlikedIds,
    required this.likeIds,
    required this.laughIds,
    required this.loveIds,
    required this.angryIds,
  })  : id = id ?? const Uuid().v4(),
        time = time ?? DateTime.now();

  TaleModel copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userImageUrl,
    String? title,
    List<String>? images,
    List<String>? commentIds,
    DateTime? time,
    String? reactionValue,
    List<String>? unlikedIds,
    List<String>? likeIds,
    List<String>? laughIds,
    List<String>? loveIds,
    List<String>? angryIds,
  }) {
    return TaleModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userImageUrl: userImageUrl ?? this.userImageUrl,
      title: title ?? this.title,
      images: images ?? this.images,
      commentIds: commentIds ?? this.commentIds,
      time: time ?? this.time,
      reactionValue: reactionValue ?? this.reactionValue,
      unlikedIds: unlikedIds ?? this.unlikedIds,
      likeIds: likeIds ?? this.likeIds,
      laughIds: laughIds ?? this.laughIds,
      loveIds: loveIds ?? this.loveIds,
      angryIds: angryIds ?? this.angryIds,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'userId': userId});
    result.addAll({'userName': userName});
    result.addAll({'userImageUrl': userImageUrl});
    if (title != null) {
      result.addAll({'title': title});
    }
    if (images != null) {
      result.addAll({'images': images});
    }
    result.addAll({'commentIds': commentIds});
    result.addAll({'time': time.millisecondsSinceEpoch});
    result.addAll({'unlikedIds': unlikedIds});
    result.addAll({'likeIds': likeIds});
    result.addAll({'laughIds': laughIds});
    result.addAll({'loveIds': loveIds});
    result.addAll({'angryIds': angryIds});

    return result;
  }

  factory TaleModel.fromMap(Map<String, dynamic> map) {
    return TaleModel(
      id: map['\$id'] ?? '',
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      userImageUrl: map['userImageUrl'] ?? '',
      title: map['title'],
      images: List<String>.from(map['images']),
      commentIds: List<String>.from(map['commentIds']),
      time: DateTime.fromMillisecondsSinceEpoch(map['time']),
      reactionValue: map['reactionValue'] ?? '',
      unlikedIds: List<String>.from(map['unlikedIds']),
      likeIds: List<String>.from(map['likeIds']),
      laughIds: List<String>.from(map['laughIds']),
      loveIds: List<String>.from(map['loveIds']),
      angryIds: List<String>.from(map['angryIds']),
    );
  }

  String toJson() => json.encode(toMap());

  factory TaleModel.fromJson(String source) =>
      TaleModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TaleModel(id: $id, userId: $userId, userName: $userName, userImageUrl: $userImageUrl, title: $title, images: $images, commentIds: $commentIds, time: $time, reactionValue: $reactionValue, unlikedIds: $unlikedIds, likeIds: $likeIds, laughIds: $laughIds, loveIds: $loveIds, angryIds: $angryIds)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TaleModel &&
        other.id == id &&
        other.userId == userId &&
        other.userName == userName &&
        other.userImageUrl == userImageUrl &&
        other.title == title &&
        listEquals(other.images, images) &&
        listEquals(other.commentIds, commentIds) &&
        other.time == time &&
        other.reactionValue == reactionValue &&
        listEquals(other.unlikedIds, unlikedIds) &&
        listEquals(other.likeIds, likeIds) &&
        listEquals(other.laughIds, laughIds) &&
        listEquals(other.loveIds, loveIds) &&
        listEquals(other.angryIds, angryIds);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        userName.hashCode ^
        userImageUrl.hashCode ^
        title.hashCode ^
        images.hashCode ^
        commentIds.hashCode ^
        time.hashCode ^
        reactionValue.hashCode ^
        unlikedIds.hashCode ^
        likeIds.hashCode ^
        laughIds.hashCode ^
        loveIds.hashCode ^
        angryIds.hashCode;
  }
}
