class UserModal {
  final int uId;
  late String name;
  late int age;

  UserModal(
    this.uId,
    this.name,
    this.age,
  );

  factory UserModal.fromMap({required Map data}) => UserModal(
        data['uId'],
        data['name'],
        data['age'],
      );

  Map<String, dynamic> get toMap => {
        'uId': uId,
        'name': name,
        'age': age,
      };
}
