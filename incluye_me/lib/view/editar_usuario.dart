import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:incluye_me/model/user.dart';

class EditarUsuarioPage extends StatefulWidget {
  final User user;

  EditarUsuarioPage({required this.user});

  @override
  _EditarUsuarioPageState createState() => _EditarUsuarioPageState();
}

class _EditarUsuarioPageState extends State<EditarUsuarioPage> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Usuario'),
        backgroundColor: Color(0xFF29DA81),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FormBuilder(
          key: _fbKey,
          initialValue: {
            'name': widget.user.name,
            'email': widget.user.email,
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListTile(
                title: Text('Nombre: ${widget.user.name}'),
                subtitle: Text('Email: ${widget.user.email}'),
              ),
              Divider(),
              FormBuilderTextField(
                name: 'name',
                decoration: InputDecoration(labelText: 'Nombre'),
              ),
              FormBuilderTextField(
                name: 'email',
                decoration: InputDecoration(labelText: 'Email'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_fbKey.currentState!.saveAndValidate()) {
                    // Guarda los datos actualizados en el objeto User
                    final updatedUser = User(
                      name: _fbKey.currentState!.fields['name']?.value,
                      email: _fbKey.currentState!.fields['email']?.value,
                      isTeacher:
                          widget.user.isTeacher, // No cambiamos el valor.
                    );

                    // Vuelve a la página de detalles del usuario con los datos actualizados
                    Navigator.of(context).pop(updatedUser);
                  }
                },
                child: Text('Guardar Cambios'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
