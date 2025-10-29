class UserModel {
  final String uid;
  final String username;
  final String email;
  final String photoUrl;

  UserModel({
    required this.uid,
    required this.username,
    required this.email,
    required this.photoUrl,
  });

  // Factory pour convertir Firestore en ==> objet Dart
  factory UserModel.fromMap(Map<String, dynamic> data, String uid) {
    return UserModel(
      uid: uid,
      username: data["username"] ?? "",
      email: data["email"] ?? "",
      photoUrl: data["photoUrl"] ?? "",
    );
  }

  // Convertir objet Dart en Map pour Firestore
  Map<String, dynamic> toMap() {
    return {"username": username, "email": email};
  }
}
