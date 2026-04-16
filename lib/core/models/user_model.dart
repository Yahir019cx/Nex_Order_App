enum UserRole { admin, mesero }

extension UserRoleLabel on UserRole {
  String get label => switch (this) {
        UserRole.admin   => 'Admin',
        UserRole.mesero  => 'Mesero',
      };
}

class UserModel {
  final int id;
  final String name;
  final UserRole role;
  final bool isActive;

  const UserModel({
    required this.id,
    required this.name,
    required this.role,
    this.isActive = true,
  });

  UserModel copyWith({
    String? name,
    UserRole? role,
    bool? isActive,
  }) =>
      UserModel(
        id: id,
        name: name ?? this.name,
        role: role ?? this.role,
        isActive: isActive ?? this.isActive,
      );
}

List<UserModel> initialMockUsers = [
  UserModel(id: 1, name: 'Carlos Rodríguez', role: UserRole.admin,  isActive: true),
  UserModel(id: 2, name: 'Patricia López',   role: UserRole.admin,  isActive: true),
  UserModel(id: 3, name: 'María González',   role: UserRole.mesero, isActive: true),
  UserModel(id: 4, name: 'Juan Pérez',       role: UserRole.mesero, isActive: true),
  UserModel(id: 5, name: 'Ana Martínez',     role: UserRole.mesero, isActive: true),
  UserModel(id: 6, name: 'Luis Hernández',   role: UserRole.mesero, isActive: false),
];
