//Created by giangtpu on 08/06/2023.
//Giangbb Studio
//giangtpu@gmail.com
class UserModel {
  final String name;
  final String uid;
  final String? profilePic;
  final bool isOnline;
  final String phoneNumber;
  final List<String> groupId;

  static const fieldIsOnline = 'isOnline';

  UserModel({
    required this.name,
    required this.uid,
    required this.isOnline,
    required this.phoneNumber,
    required this.groupId,
    this.profilePic,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uid': uid,
      'profilePic': profilePic ?? '',
      'isOnline': isOnline,
      'phoneNumber': phoneNumber,
      'groupId': groupId,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      uid: map['uid'] ?? '',
      profilePic: map['profilePic'] ?? '',
      isOnline: map['isOnline'] ?? false,
      phoneNumber: map['phoneNumber'] ?? '',
      groupId: List<String>.from(map['groupId']),
    );
  }
}
