import 'dart:convert';

class ModelUser {
  final String name;
  final String email;
  final int createdAt;
  final bool onBoardingCompleted;
  ModelUser({required this.name, required this.email, required this.createdAt, required this.onBoardingCompleted});

  ModelUser copyWith({String? name, String? email, int? createdAt, bool? onBoardingCompleted}) {
    return ModelUser(
      name: name ?? this.name,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
      onBoardingCompleted: onBoardingCompleted ?? this.onBoardingCompleted,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'name': name, 'email': email, 'createdAt': createdAt, 'onBoardingCompleted': onBoardingCompleted};
  }

  factory ModelUser.fromMap(Map<String, dynamic> map) {
    return ModelUser(
      name: map['name'] as String,
      email: map['email'] as String,
      createdAt: map['createdAt'] as int,
      onBoardingCompleted: map['onBoardingCompleted'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory ModelUser.fromJson(String source) => ModelUser.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ModelUser(name: $name, email: $email, createdAt: $createdAt, onBoardingCompleted: $onBoardingCompleted)';
  }

  @override
  bool operator ==(covariant ModelUser other) {
    if (identical(this, other)) return true;

    return other.name == name && other.email == email && other.createdAt == createdAt && other.onBoardingCompleted == onBoardingCompleted;
  }

  @override
  int get hashCode {
    return name.hashCode ^ email.hashCode ^ createdAt.hashCode ^ onBoardingCompleted.hashCode;
  }
}
