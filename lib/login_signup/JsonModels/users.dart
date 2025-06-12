class Users {
  final int? usrId;
  final String usrName;
  final String usrPassword;
  final String? nama;

  Users({
    this.usrId, 
    required this.usrName, 
    required this.usrPassword,
    this.nama,
  });

  factory Users.fromMap(Map<String, dynamic> json) => Users(
    usrId: json["usrId"],
    usrName: json["usrName"],
    usrPassword: json["usrPassword"],
    nama: json["nama"],
  );

  Map<String, dynamic> toMap() => {
    "usrId": usrId,
    "usrName": usrName,
    "usrPassword": usrPassword,
    "nama": nama,
  };
}
