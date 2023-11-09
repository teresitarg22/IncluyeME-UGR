import 'user.dart';

class MockDatabase {
  static final List<User> users = [
    User(
      nombre: 'Profesor1',
      apellidos: 'Smith',
      correo: 'profesor1@email.com',
      foto: 'profile.jpg',
      contrasenia: '12345',
    ),
  ];

  static User? getUserByEmail(String email) {
    try {
      return users.firstWhere((user) => user.correo == email);
    } catch (e) {
      return null;
    }
  }
}
