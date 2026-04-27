class ApiModel {
  final int id;
  final String name;
  final String username;
  final String phone;

  ApiModel({
    required this.id,
    required this.name,
    required this.username,
    required this.phone,
  });

  factory ApiModel.fromJson(Map<String, dynamic> json){
    return ApiModel(
      id: json['id'], 
      name: json['name'], 
      username: json['username'], 
      phone: json['phone']);
  }
}
