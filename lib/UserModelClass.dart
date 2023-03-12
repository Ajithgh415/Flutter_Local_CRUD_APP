class User {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? password;
  String? profilePicture;
  int? isDeleted;

  User({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.password,
    this.profilePicture,
    this.isDeleted
  });
  Map<String, dynamic> toMap() {
    return {
      'id':id,
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'profilePic': profilePicture,
      'isDeleted':isDeleted
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      isDeleted: map['isDeleted'],
      id:map['id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      password: map['password'],
      profilePicture: map['profilePic'],
    );
  }
}
