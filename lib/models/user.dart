class User {
  //attributs
  late String id;
  late String firstname;
  late String lastname;
  String? avatar;
  DateTime? birthday;
  String? nickname;
  late String email;
  List? favorites;

  //variable calculé
  String get fullName {
    return firstname + " " + lastname;
  }

  //un ou des constructeurs

  User.empty() {
    id = "";
    firstname = "";
    lastname = "";
    email = "";
  }

  //méthode
}
