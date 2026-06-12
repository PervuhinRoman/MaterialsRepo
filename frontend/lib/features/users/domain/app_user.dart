class AppUser {
  const AppUser({
    required this.id,
    required this.email,
    required this.username,
    required this.role,
    required this.isActive,
    required this.createdAt,
  });

  final String id;
  final String email;
  final String username;
  final String role;
  final bool isActive;
  final DateTime createdAt;

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
    id: json['id'] as String,
    email: json['email'] as String,
    username: json['username'] as String,
    role: json['role'] as String,
    isActive: json['is_active'] as bool,
    createdAt: DateTime.parse(json['created_at'] as String),
  );

  AppUser copyWith({bool? isActive}) => AppUser(
    id: id,
    email: email,
    username: username,
    role: role,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt,
  );
}
