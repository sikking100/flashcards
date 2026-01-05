import 'dart:convert';

class ModelSettings {
  final int dailyGoal;
  final bool showOnboarding;
  final bool notificationEnabled;
  ModelSettings({required this.dailyGoal, required this.showOnboarding, required this.notificationEnabled});

  ModelSettings copyWith({int? dailyGoal, bool? showOnboarding, bool? notificationEnabled}) {
    return ModelSettings(
      dailyGoal: dailyGoal ?? this.dailyGoal,
      showOnboarding: showOnboarding ?? this.showOnboarding,
      notificationEnabled: notificationEnabled ?? this.notificationEnabled,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'dailyGoal': dailyGoal, 'showOnboarding': showOnboarding, 'notificationEnabled': notificationEnabled};
  }

  factory ModelSettings.fromMap(Map<String, dynamic> map) {
    return ModelSettings(
      dailyGoal: map['dailyGoal'] as int,
      showOnboarding: map['showOnboarding'] as bool,
      notificationEnabled: map['notificationEnabled'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory ModelSettings.fromJson(String source) => ModelSettings.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ModelSettings(dailyGoal: $dailyGoal, showOnboarding: $showOnboarding, notificationEnabled: $notificationEnabled)';

  @override
  bool operator ==(covariant ModelSettings other) {
    if (identical(this, other)) return true;

    return other.dailyGoal == dailyGoal && other.showOnboarding == showOnboarding && other.notificationEnabled == notificationEnabled;
  }

  @override
  int get hashCode => dailyGoal.hashCode ^ showOnboarding.hashCode ^ notificationEnabled.hashCode;
}
