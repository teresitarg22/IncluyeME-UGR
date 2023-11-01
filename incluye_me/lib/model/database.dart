import 'user.dart';

class MockDatabase {
  static final List<User> users = [
    User(name: 'Profesor 1', email: 'profesor1@email.com', isTeacher: true),
  ];

  static User? getUserByEmail(String email) {
    try {
      return users.firstWhere((user) => user.email == email);
    } catch (e) {
      return null;
    }
  }
}
