import 'dart:convert';

class ModelUser {
  final String name;
  final String email;
  final int createdAt;
  final bool onBoardingCompleted;
  final bool isTrial;
  ModelUser({required this.name, required this.email, required this.createdAt, required this.onBoardingCompleted, this.isTrial = true});

  ModelUser copyWith({String? name, String? email, int? createdAt, bool? onBoardingCompleted, bool? isTrial}) {
    return ModelUser(
      name: name ?? this.name,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
      onBoardingCompleted: onBoardingCompleted ?? this.onBoardingCompleted,
      isTrial: isTrial ?? this.isTrial,
    );
  }

  factory ModelUser.fromMap(Map<String, dynamic> map) {
    return ModelUser(
      name: map['name'] as String? ?? 'default',
      email: map['email'] as String? ?? 'default@gmail.com',
      createdAt: map['createdAt'] as int? ?? 0,
      onBoardingCompleted: map['onBoardingCompleted'] as bool? ?? false,
      isTrial: map['isTrial'] as bool? ?? true,
    );
  }

  factory ModelUser.fromJson(String source) => ModelUser.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ModelUser(name: $name, email: $email, createdAt: $createdAt, onBoardingCompleted: $onBoardingCompleted, isTrial: $isTrial)';
  }

  @override
  bool operator ==(covariant ModelUser other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.email == email &&
        other.createdAt == createdAt &&
        other.onBoardingCompleted == onBoardingCompleted &&
        other.isTrial == isTrial;
  }

  @override
  int get hashCode {
    return name.hashCode ^ email.hashCode ^ createdAt.hashCode ^ onBoardingCompleted.hashCode ^ isTrial.hashCode;
  }
}
