class AppUser {
  String phone;
  String firstName;
  String lastName;
  String photo =
      "https://firebasestorage.googleapis.com/v0/b/pharmacy-app-ffac0.appspot.com/o/avatar.jpg?alt=media&token=231f9a7e-0dd8-496d-9d4f-7f068484dde4";

  AppUser(this.phone, this.firstName, this.lastName);

  String fullName() => "$firstName $lastName";
}
