import 'user.dart';

class MockDatabase {
  static final List<User> users = [
    User(
      dni: '123456789A',
      name: 'Profesor1',
      email: 'profesor1@email.com',
      password: '12345',
      lastName: 'Smith',
      dateOfBirth: '1980-01-15',
      healthCard: 'ABC123456',
      homeAddress: '123 Main Street, City',
      phone: '555-555-5555',
      photo: 'profile.jpg',
      medicalRecord: 'medicalrecord.pdf',
      allergiesIntolerances: 'None',
      additionalMedicalInformation: 'N/A',
      fontType: 'Arial',
      fontSize: '12pt',
      appFormat: 'Mobile',
      touchscreen: true,
      tutorDni: '987654321B',
      gender: 'Male',
    ),
  ];

  static User? getUserByEmail(String email) {
    try {
      return users.firstWhere((user) => user.email == email);
    } catch (e) {
      return null;
    }
  }
}
