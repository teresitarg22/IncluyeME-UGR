import 'package:flutter/material.dart';
import '../model/user.dart';

class UserCard extends StatelessWidget {
  final User user;
  final VoidCallback onTap;

  const UserCard({
    Key? key,
    required this.user,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: ListTile(
        title: Text("${user.nombre} ${user.apellidos}"),
        subtitle: Text(user.correo),
        leading: const Icon(Icons.person, size: 45),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                // Lógica para editar usuario
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                // Lógica para eliminar usuario
              },
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
