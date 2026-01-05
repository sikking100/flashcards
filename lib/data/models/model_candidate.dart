import 'dart:convert';

class ModelCandidate {
  final String? deckId;
  final String front;
  final String back;

  /// "photo" | "ocr" | "bulk" | "manual",
  final String source;
  final int createdAt;

  /// "pending" | "accepted" | "rejected"
  final String status;
  ModelCandidate({this.deckId, required this.front, required this.back, required this.source, required this.createdAt, required this.status});

  ModelCandidate copyWith({String? deckId, String? front, String? back, String? source, int? createdAt, String? status}) {
    return ModelCandidate(
      deckId: deckId ?? this.deckId,
      front: front ?? this.front,
      back: back ?? this.back,
      source: source ?? this.source,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'deckId': deckId, 'front': front, 'back': back, 'source': source, 'createdAt': createdAt, 'status': status};
  }

  factory ModelCandidate.fromMap(Map<String, dynamic> map) {
    return ModelCandidate(
      deckId: map['deckId'] != null ? map['deckId'] as String : null,
      front: map['front'] as String,
      back: map['back'] as String,
      source: map['source'] as String,
      createdAt: map['createdAt'] as int,
      status: map['status'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ModelCandidate.fromJson(String source) => ModelCandidate.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ModelCandidate(deckId: $deckId, front: $front, back: $back, source: $source, createdAt: $createdAt, status: $status)';
  }

  @override
  bool operator ==(covariant ModelCandidate other) {
    if (identical(this, other)) return true;

    return other.deckId == deckId &&
        other.front == front &&
        other.back == back &&
        other.source == source &&
        other.createdAt == createdAt &&
        other.status == status;
  }

  @override
  int get hashCode {
    return deckId.hashCode ^ front.hashCode ^ back.hashCode ^ source.hashCode ^ createdAt.hashCode ^ status.hashCode;
  }
}
