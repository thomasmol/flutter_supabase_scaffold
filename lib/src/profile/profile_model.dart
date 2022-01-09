class Profile {
  Profile({
    required this.id,
    required this.firstName,
    required this.lastName,
     this.avatarUrl,
    required this.createdAt,
    required this.updatedAt,
  });
  late final String id;
  late final String firstName;
  late final String lastName;
  late final String? avatarUrl;
  late final String createdAt;
  late final String updatedAt;
  
  Profile.fromJson(Map<String, dynamic> json){
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    avatarUrl = json['avatar_url'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['first_name'] = firstName;
    _data['last_name'] = lastName;
    _data['avatar_url'] = avatarUrl;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    return _data;
  }
}