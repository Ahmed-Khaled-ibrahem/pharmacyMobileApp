class AppUser {
  String phone;
  String firstName;
  String lastName;
  String photo;
  String? address;

  AppUser(this.phone, this.firstName, this.lastName, this.photo, this.address);

  String fullName() => "$firstName $lastName";
}
