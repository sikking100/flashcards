import 'dart:convert';

class ModelCard {
  final String? id;
  final String front;
  final String back;
  final int? createdAt;
  final int? updatedAt;

  ModelCard({this.id, required this.front, required this.back, this.createdAt, this.updatedAt});

  ModelCard copyWith({String? id, String? front, String? back, int? createdAt, int? updatedAt}) {
    return ModelCard(
      id: id ?? this.id,
      front: front ?? this.front,
      back: back ?? this.back,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory ModelCard.toNew({required String front, required String back}) {
    final now = DateTime.now().millisecondsSinceEpoch;
    return ModelCard(front: front, back: back, createdAt: now, updatedAt: now);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'id': id, 'front': front, 'back': back, 'createdAt': createdAt, 'updatedAt': updatedAt};
  }

  factory ModelCard.fromMap(Map<String, dynamic> map, String id) {
    return ModelCard(
      id: id,
      front: map['front'] as String,
      back: map['back'] as String,
      createdAt: map['createdAt'] as int,
      updatedAt: map['updatedAt'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'ModelCard(id: $id, front: $front, back: $back, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant ModelCard other) {
    if (identical(this, other)) return true;

    return other.id == id && other.front == front && other.back == back && other.createdAt == createdAt && other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^ front.hashCode ^ back.hashCode ^ createdAt.hashCode ^ updatedAt.hashCode;
  }
}
