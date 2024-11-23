// // lib/data/models/user_model.dart
// import 'package:flutter/foundation.dart';

// class UserModel {
//   final int id;
//   final String nom;
//   final String prenom;
//   final String telephone;
//   final String? photo;
//   final String email;
//   final double solde;
//   final double promo;
//   final String? carte;
//   final bool etatcarte;
//   final String adresse;
//   final String dateNaissance;
//   final String? secret;
//   final int roleId;
//   final String createdAt;
//   final String updatedAt;
//   final String? accessToken;
//   final String sexe;

//   const UserModel({
//     required this.id,
//     required this.nom,
//     required this.prenom,
//     required this.telephone,
//     this.photo,
//     required this.email,
//     required this.solde,
//     required this.promo,
//     this.carte,
//     required this.etatcarte,
//     required this.adresse,
//     required this.dateNaissance,
//     this.secret,
//     required this.roleId,
//     required this.createdAt,
//     required this.updatedAt,
//     this.accessToken,
//     required this.sexe,
//   });

//   bool get hasSetSecretCode => secret != null && secret!.isNotEmpty;
//   String get numeroCompte => carte ?? '';
//   double get balance => solde;

//   factory UserModel.fromJson(Map<String, dynamic> json) {
//     return UserModel(
//       id: json['id'] ?? 0,
//       nom: json['nom'] ?? '',
//       prenom: json['prenom'] ?? '',
//       telephone: json['telephone'] ?? '',
//       photo: json['photo'],
//       email: json['email'] ?? '',
//       solde: _parseDouble(json['solde']),
//       promo: _parseDouble(json['promo']),
//       carte: json['carte'],
//       etatcarte: json['etatcarte'] ?? false,
//       adresse: json['adresse'] ?? '',
//       dateNaissance: json['date_naissance'] ?? '',
//       secret: json['secret'],
//       roleId: json['role_id'] ?? 2,
//       createdAt: json['created_at'] ?? DateTime.now().toIso8601String(),
//       updatedAt: json['updated_at'] ?? DateTime.now().toIso8601String(),
//       accessToken: json['access_token'],
//       sexe: json['sexe'] ?? '',
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'nom': nom,
//       'prenom': prenom,
//       'telephone': telephone,
//       'photo': photo,
//       'email': email,
//       'solde': solde,
//       'promo': promo,
//       'carte': carte,
//       'etatcarte': etatcarte,
//       'adresse': adresse,
//       'date_naissance': dateNaissance,
//       'secret': secret,
//       'role_id': roleId,
//       'created_at': createdAt,
//       'updated_at': updatedAt,
//       'access_token': accessToken,
//       'sexe': sexe,
//     };
//   }

//   static double _parseDouble(dynamic value) {
//     if (value == null) return 0.0;
//     if (value is num) return value.toDouble();
//     if (value is String) {
//       try {
//         return double.parse(value.replaceAll(",", "."));
//       } catch (e) {
//         debugPrint('Erreur de conversion en double: $e');
//         return 0.0;
//       }
//     }
//     return 0.0;
//   }

//   UserModel copyWith({
//     int? id,
//     String? nom,
//     String? prenom,
//     String? telephone,
//     String? photo,
//     String? email,
//     double? solde,
//     double? promo,
//     String? carte,
//     bool? etatcarte,
//     String? adresse,
//     String? dateNaissance,
//     String? secret,
//     int? roleId,
//     String? createdAt,
//     String? updatedAt,
//     String? accessToken,
//     String? sexe,
//   }) {
//     return UserModel(
//       id: id ?? this.id,
//       nom: nom ?? this.nom,
//       prenom: prenom ?? this.prenom,
//       telephone: telephone ?? this.telephone,
//       photo: photo ?? this.photo,
//       email: email ?? this.email,
//       solde: solde ?? this.solde,
//       promo: promo ?? this.promo,
//       carte: carte ?? this.carte,
//       etatcarte: etatcarte ?? this.etatcarte,
//       adresse: adresse ?? this.adresse,
//       dateNaissance: dateNaissance ?? this.dateNaissance,
//       secret: secret ?? this.secret,
//       roleId: roleId ?? this.roleId,
//       createdAt: createdAt ?? this.createdAt,
//       updatedAt: updatedAt ?? this.updatedAt,
//       accessToken: accessToken ?? this.accessToken,
//       sexe: sexe ?? this.sexe,
//     );
//   }

//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is UserModel &&
//           runtimeType == other.runtimeType &&
//           id == other.id &&
//           telephone == other.telephone;

//   @override
//   int get hashCode => id.hashCode ^ telephone.hashCode;

//   get transactions => null;

//   get points => null;

//   get niveau => null;

//   static forRegistration({required String nom, required String prenom, required String telephone, required String email, required String adresse, required String dateNaissance, required String sexe, String? photo}) {}
// }


import 'package:flutter/foundation.dart';

class UserModel {
  final int id;
  final String nom;
  final String prenom;
  final String telephone;
  final String? photo; // Photo optionnelle
  final String email;
  final double solde;
  final double promo;
  final String? carte;
  final bool etatcarte;
  final String adresse;
  final String dateNaissance;
  final String? secret;
  final int roleId;
  final String createdAt;
  final String updatedAt;
  final String? accessToken;
  final String sexe;

  const UserModel({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.telephone,
    this.photo, // Optionnel
    required this.email,
    required this.solde,
    required this.promo,
    this.carte,
    required this.etatcarte,
    required this.adresse,
    required this.dateNaissance,
    this.secret,
    required this.roleId,
    required this.createdAt,
    required this.updatedAt,
    this.accessToken,
    required this.sexe,
  });

  bool get hasSetSecretCode => secret != null && secret!.isNotEmpty;
  String get numeroCompte => carte ?? '';
  double get balance => solde;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      nom: json['nom'] ?? '',
      prenom: json['prenom'] ?? '',
      telephone: json['telephone'] ?? '',
      photo: json['photo'], // Peut être null
      email: json['email'] ?? '',
      solde: _parseDouble(json['solde']),
      promo: _parseDouble(json['promo']),
      carte: json['carte'],
      etatcarte: json['etatcarte'] ?? false,
      adresse: json['adresse'] ?? '',
      dateNaissance: json['date_naissance'] ?? '',
      secret: json['secret'],
      roleId: json['role_id'] ?? 2,
      createdAt: json['created_at'] ?? DateTime.now().toIso8601String(),
      updatedAt: json['updated_at'] ?? DateTime.now().toIso8601String(),
      accessToken: json['access_token'],
      sexe: json['sexe'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'telephone': telephone,
      'photo': photo,
      'email': email,
      'solde': solde,
      'promo': promo,
      'carte': carte,
      'etatcarte': etatcarte,
      'adresse': adresse,
      'date_naissance': dateNaissance,
      'secret': secret,
      'role_id': roleId,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'access_token': accessToken,
      'sexe': sexe,
    };
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) {
      try {
        return double.parse(value.replaceAll(",", "."));
      } catch (e) {
        debugPrint('Erreur de conversion en double: $e');
        return 0.0;
      }
    }
    return 0.0;
  }

  UserModel copyWith({
    int? id,
    String? nom,
    String? prenom,
    String? telephone,
    String? photo,
    String? email,
    double? solde,
    double? promo,
    String? carte,
    bool? etatcarte,
    String? adresse,
    String? dateNaissance,
    String? secret,
    int? roleId,
    String? createdAt,
    String? updatedAt,
    String? accessToken,
    String? sexe,
  }) {
    return UserModel(
      id: id ?? this.id,
      nom: nom ?? this.nom,
      prenom: prenom ?? this.prenom,
      telephone: telephone ?? this.telephone,
      photo: photo ?? this.photo,
      email: email ?? this.email,
      solde: solde ?? this.solde,
      promo: promo ?? this.promo,
      carte: carte ?? this.carte,
      etatcarte: etatcarte ?? this.etatcarte,
      adresse: adresse ?? this.adresse,
      dateNaissance: dateNaissance ?? this.dateNaissance,
      secret: secret ?? this.secret,
      roleId: roleId ?? this.roleId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      accessToken: accessToken ?? this.accessToken,
      sexe: sexe ?? this.sexe,
    );
  }

  static UserModel forRegistration({
    required String nom,
    required String prenom,
    required String telephone,
    required String email,
    required String adresse,
    required String dateNaissance,
    required String sexe,
    String? photo, // Optionnel
  }) {
    return UserModel(
      id: 0,
      nom: nom,
      prenom: prenom,
      telephone: telephone,
      photo: photo,
      email: email,
      solde: 0.0,
      promo: 0.0,
      carte: null,
      etatcarte: false,
      adresse: adresse,
      dateNaissance: dateNaissance,
      secret: null,
      roleId: 2,
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
      accessToken: null,
      sexe: sexe,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          telephone == other.telephone;

  @override
  int get hashCode => id.hashCode ^ telephone.hashCode;
}
