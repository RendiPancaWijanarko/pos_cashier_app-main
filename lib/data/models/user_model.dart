import '../../domain/entities/user_entity.dart';

class UserModel {
  String id;
  String? email;
  String? phone;
  String? name;
  String? gender;
  String? birthdate;
  String? imageUrl;
  String? authProvider;
  String? createdAt;
  String? updatedAt;

  UserModel({
    required this.id,
    this.email,
    this.phone,
    this.name,
    this.gender,
    this.birthdate,
    this.imageUrl,
    this.authProvider,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'] ?? json['email'],
      phone: json['phone'] ?? json['phone'],
      name: json['name'] ?? json['name'],
      gender: json['gender'] ?? json['gender'],
      birthdate: json['birthdate'] ?? json['birthdate'],
      imageUrl: json['image_data'] ?? json['imageUrl'],
      authProvider: json['auth_provider'] ?? json['authProvider'],
      createdAt: json['created_at'] ?? json['createdAt'],
      updatedAt: json['updated_at'] ?? json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'phone': phone,
      'name': name,
      'gender': gender,
      'birthdate': birthdate,
      'image_data': imageUrl,
      'auth_provider': authProvider,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      phone: entity.phone,
      name: entity.name,
      gender: entity.gender,
      birthdate: entity.birthdate,
      imageUrl: entity.imageUrl,
      authProvider: entity.authProvider?.value,
      createdAt: entity.createdAt ?? DateTime.now().toIso8601String(),
      updatedAt: entity.updatedAt ?? DateTime.now().toIso8601String(),
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      phone: phone,
      name: name,
      gender: gender,
      birthdate: birthdate,
      imageUrl: imageUrl,
      authProvider: AuthProvider.fromValue(authProvider),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Convert a Firebase-like user object to UserModel.
  /// The parameter is typed as `dynamic` so this method does not
  /// require importing `firebase_auth` and will not force network
  /// dependencies for offline builds. It expects the object to have
  /// `uid`, `email`, `phoneNumber`, `displayName`, and `photoURL`.
  factory UserModel.fromFirebaseUser(
    dynamic firebaseUser, {
    AuthProvider authProvider = AuthProvider.google,
  }) {
    return UserModel(
      id: firebaseUser?.uid ?? '',
      email: firebaseUser?.email,
      phone: firebaseUser?.phoneNumber,
      name: firebaseUser?.displayName,
      gender: null,
      birthdate: null,
      imageUrl: firebaseUser?.photoURL,
      authProvider: authProvider.value,
      createdAt: null,
      updatedAt: null,
    );
  }
}
