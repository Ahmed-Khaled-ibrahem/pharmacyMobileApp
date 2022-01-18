class AppUser {
  String phone;
  String firstName;
  String lastName;

  AppUser(this.phone, this.firstName, this.lastName);

  String fullName() => "$firstName $lastName";
}
