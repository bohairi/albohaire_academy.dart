class ModelUsers {
  String? id;
  String? email;
  String fullName;
  String userName;
  String password;
  String? phoneNumber;
  String? dateOfBirth;
  String? address;
  double? latitude;
  double? longitude;
  String? role;
  String? profileImage;

  ModelUsers({
    this.id,
    this.email,
    required this.fullName,
    required this.userName,
    required this.password,
    this.phoneNumber,
    this.dateOfBirth,
    this.address,
    this.latitude,
    this.longitude,
    this.role,
    this.profileImage,
  });

  ModelUsers copyWith({
    String? id,
    String? email,
    String? fullName,
    String? userName,
    String? password,
    String? phoneNumber,
    String? dateOfBirth,
    String? address,
    double? latitude,
    double? longitude,
    String? role,
    String? profileImage,
  }) {
    return ModelUsers(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      userName: userName ?? this.userName,
      password: password ?? this.password,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      role: role ?? this.role,
      profileImage: profileImage ?? this.profileImage,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "email": email,
      "fullName": fullName,
      "userName": userName,
      "password": password,
      "phoneNumber": phoneNumber,
      "dateOfBirth": dateOfBirth,
      "address": address,
      "latitude": latitude,
      "longitude": longitude,
      "role": role,
      "profileImage": profileImage,
    };
  }

  factory ModelUsers.fromMap(Map<String, dynamic> map, String docId) {
    return ModelUsers(
      id: docId,
      email: map["email"],
      fullName: map["fullName"] ?? "",
      userName: map["userName"] ?? "",
      password: map["password"] ?? "",
      phoneNumber: map["phoneNumber"],
      dateOfBirth: map["dateOfBirth"],
      address: map["address"],
      latitude: map["latitude"] != null
          ? (map["latitude"] as num).toDouble()
          : null,
      longitude: map["longitude"] != null
          ? (map["longitude"] as num).toDouble()
          : null,
      role: map["role"],
      profileImage: map["profileImage"],
    );
  }
}