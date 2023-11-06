class User {
  String dni;
  String gender;
  String name;
  String lastName;
  String dateOfBirth;
  String password;
  String healthCard;
  String homeAddress;
  String phone;
  String email;
  String photo;
  String medicalRecord;
  String allergiesIntolerances;
  String additionalMedicalInformation;
  String fontType;
  String fontSize;
  String appFormat;
  bool touchscreen;
  String tutorDni;

  User({
    required this.dni,
    required this.name,
    required this.email,
    required this.password,
    required this.lastName,
    required this.dateOfBirth,
    required this.healthCard,
    required this.homeAddress,
    required this.phone,
    required this.photo,
    required this.medicalRecord,
    required this.allergiesIntolerances,
    required this.additionalMedicalInformation,
    required this.fontType,
    required this.fontSize,
    required this.appFormat,
    required this.touchscreen,
    required this.tutorDni,
    required this.gender,
  });
}
