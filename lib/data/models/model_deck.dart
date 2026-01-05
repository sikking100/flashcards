import 'dart:convert';

class ModelDeck {
  final String? id;
  final String title;
  final String description;
  final int totalCards;
  final int createdAt;
  final int updatedAt;
  final String? coverImage;
  ModelDeck({
    this.id,
    required this.title,
    required this.description,
    required this.totalCards,
    required this.createdAt,
    required this.updatedAt,
    this.coverImage,
  });

  ModelDeck copyWith({String? title, String? description, int? totalCards, int? createdAt, int? updatedAt, String? coverImage, String? id}) {
    return ModelDeck(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      totalCards: totalCards ?? this.totalCards,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      coverImage: coverImage ?? this.coverImage,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'description': description,
      'totalCards': totalCards,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'coverImage': coverImage,
    };
  }

  static ModelDeck toNew(String title) {
    return ModelDeck(
      title: title,
      description: '',
      totalCards: 0,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );
  }

  factory ModelDeck.fromMap(Map<String, dynamic> map, String id) {
    return ModelDeck(
      id: id,
      title: map['title'] as String,
      description: map['description'] as String,
      totalCards: map['totalCards'] as int,
      createdAt: map['createdAt'] as int,
      updatedAt: map['updatedAt'] as int,
      coverImage: map['coverImage'] != null ? map['coverImage'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'ModelDeck(title: $title, description: $description, totalCards: $totalCards, createdAt: $createdAt, updatedAt: $updatedAt, coverImage: $coverImage)';
  }

  @override
  bool operator ==(covariant ModelDeck other) {
    if (identical(this, other)) return true;

    return other.title == title &&
        other.description == description &&
        other.totalCards == totalCards &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.coverImage == coverImage;
  }

  @override
  int get hashCode {
    return title.hashCode ^ description.hashCode ^ totalCards.hashCode ^ createdAt.hashCode ^ updatedAt.hashCode ^ coverImage.hashCode;
  }
}
