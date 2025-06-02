class UserModel {
  final String uid;
  final String email;
  final String? name;
  final String? surname;
  final String? birthPlace;
  final String? city;
  final DateTime? birthDate;

  UserModel({
    required this.uid,
    required this.email,
    this.name,
    this.surname,
    this.birthPlace,
    this.city,
    this.birthDate,
  });

  // Düzeltilmiş: fromMap
  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'],
      email: data['email'],
      name: data['ad'],
      surname: data['soyad'],
      birthPlace: data['dogum_yeri'],
      city: data['yasadigi_il'],
      birthDate: data['dogum_tarihi'] != null
          ? DateTime.tryParse(data['dogum_tarihi'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'ad': name,
      'soyad': surname,
      'dogum_yeri': birthPlace,
      'yasadigi_il': city,
      'dogum_tarihi': birthDate?.toIso8601String(),
    };
  }
}
