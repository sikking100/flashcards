// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ModelReview {
  final String id;
  final String idDeck;
  final String front;
  final String back;

  /// date the next review in today's home
  final int nextReview;

  /// for SRS
  final double easiness;

  /// per day
  final int interval;

  /// how many times to be correct
  final int reps;

  /// when the last time user reviewing i
  final int? lastReviewed;

  /// how many times it's wrong / user don't know it
  final int reviewCount;

  factory ModelReview.toNew({required String id, required String idDeck, required String front, required String back}) {
    final now = DateTime.now().millisecondsSinceEpoch;
    return ModelReview(id: id, idDeck: idDeck, front: front, back: back, nextReview: now, easiness: 2.5, interval: 0, reps: 0, reviewCount: 0);
  }

  ModelReview({
    required this.id,
    required this.idDeck,
    required this.front,
    required this.back,
    required this.nextReview,
    required this.easiness,
    required this.interval,
    required this.reps,
    this.lastReviewed,
    required this.reviewCount,
  });

  ModelReview copyWith({
    String? id,
    String? idDeck,
    String? front,
    String? back,
    int? nextReview,
    double? easiness,
    int? interval,
    int? reps,
    int? lastReviewed,
    int? reviewCount,
  }) {
    return ModelReview(
      id: id ?? this.id,
      idDeck: idDeck ?? this.idDeck,
      front: front ?? this.front,
      back: back ?? this.back,
      nextReview: nextReview ?? this.nextReview,
      easiness: easiness ?? this.easiness,
      interval: interval ?? this.interval,
      reps: reps ?? this.reps,
      lastReviewed: lastReviewed ?? this.lastReviewed,
      reviewCount: reviewCount ?? this.reviewCount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'idDeck': idDeck,
      'front': front,
      'back': back,
      'nextReview': nextReview,
      'easiness': easiness,
      'interval': interval,
      'reps': reps,
      'lastReviewed': lastReviewed,
      'reviewCount': reviewCount,
    };
  }

  factory ModelReview.fromMap(Map<String, dynamic> map) {
    return ModelReview(
      id: map['id'] as String,
      idDeck: map['idDeck'] as String,
      front: map['front'] as String,
      back: map['back'] as String,
      nextReview: map['nextReview'] as int,
      easiness: map['easiness'] as double,
      interval: map['interval'] as int,
      reps: map['reps'] as int,
      lastReviewed: map['lastReviewed'] != null ? map['lastReviewed'] as int : null,
      reviewCount: map['reviewCount'] == null ? 0 : map['reviewCount'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory ModelReview.fromJson(String source) => ModelReview.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ModelReview(id: $id, idDeck: $idDeck, front: $front, back: $back, nextReview: $nextReview, easiness: $easiness, interval: $interval, reps: $reps, lastReviewed: $lastReviewed, reviewCount: $reviewCount)';
  }

  @override
  bool operator ==(covariant ModelReview other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.idDeck == idDeck &&
        other.front == front &&
        other.back == back &&
        other.nextReview == nextReview &&
        other.easiness == easiness &&
        other.interval == interval &&
        other.reps == reps &&
        other.lastReviewed == lastReviewed &&
        other.reviewCount == reviewCount;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        idDeck.hashCode ^
        front.hashCode ^
        back.hashCode ^
        nextReview.hashCode ^
        easiness.hashCode ^
        interval.hashCode ^
        reps.hashCode ^
        lastReviewed.hashCode ^
        reviewCount.hashCode;
  }
}
