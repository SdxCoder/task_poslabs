import 'package:meta/meta.dart';

/*
 * @class   User
 * @desc    Represents a user with id, first name, last name, full name, and email
 */

class User {
  final String uid;
  final String firstName;
  final String lastName;
  final String name;
  final String email;

  /*
   * @desc   Constructs a user from uid, first name, last name, name, and email 
   * 
   * @param  uid - a string representing a unique identifier of user.
   * @param  firstName - a string representing first name of user.
   * @param  lastName - a string representing last name of user.
   * @param  firstName - a string representing full name of user.
   * @param  email - a string representing email of user.
   * 
   * @assert uid and name can't be null
   * 
   */
  User(
      {@required this.uid,
      this.firstName,
      this.lastName,
      @required this.name,
      this.email})
      : assert(uid != null && name != null);


   /*
   * @desc   Constructs a user from json object.
   * @param  json - a json object holding uid, first name, last name, name
   *         and email key-values
   */

  User.fromJson(Map<String, dynamic> json)
      : uid = json['id'],
        firstName = json['first_name'],
        lastName = json['last_name'],
        name = json['name'],
        email = json['email'];

   /*
   * @desc     Converts a user object to a map object
   * 
   * @returns  Returns a map(key-value) object created from this class's uid, 
   *           firstName, lastName, name and email.
   */

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['id'] = this.uid;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['name'] = this.name;
    data['email'] = this.email;
    return data;
  }
}
