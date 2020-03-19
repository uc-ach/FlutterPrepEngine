part of uc.core;

class UserData {
  static const tableName = 'UserData';

  String userGuid;

  String userData;

  UserData(this.userGuid, this.userData);

  factory UserData.fromMap(Map<String, dynamic> data) {
    return UserData(
      data['user_guid'],
      data['user_data'],
    );
  }
  Map<String, dynamic> toMap() => {
        "user_guid": userGuid,
        "user_data": userData,
      };
}
