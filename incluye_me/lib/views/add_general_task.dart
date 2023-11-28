import 'package:flutter/material.dart';
import 'package:incluye_me/model/general_task.dart';

class AddTaskView extends StatefulWidget {
  final Function(Tarea) onAddTask;

  AddTaskView({Key? key, required this.onAddTask}) : super(key: key);

  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskView> {
  final TextEditingController _titleController = TextEditingController();
  List<Paso> pasos = [];

  void addPaso() {
    setState(() {
      pasos.add(Paso(descripcion: '', imagen: ''));
    });
  }

  void _saveTask() {
    final tarea = Tarea(titulo: _titleController.text, pasos: pasos);
    widget.onAddTask(tarea);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Añadir Tarea'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Título de la Tarea'),
              ),
              SizedBox(height: 10),
              for (var i = 0; i < pasos.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: _buildPasoField(i),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 120.0),
                child: ElevatedButton(
                  onPressed: addPaso,
                  child: Text('Añadir Paso'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue, // Establecer color aquí
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 120.0),
                child: ElevatedButton(
                  onPressed: _saveTask,
                  child: Text('Guardar Tarea'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue, // Establecer color aquí
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasoField(int index) {
    return Row(
      children: <Widget>[
        Expanded(
          child: TextFormField(
            onChanged: (value) =>
                setState(() => pasos[index].descripcion = value),
            decoration: InputDecoration(labelText: 'Descripción del Paso'),
          ),
        ),
        IconButton(
          icon: Icon(Icons.image),
          onPressed: () async {
            // Aquí deberías implementar la selección de la imagen
            // Por ejemplo, usando un dialogo para seleccionar una imagen de assets
            String imagePath = await _selectImage();
            setState(() => pasos[index].imagen = imagePath);
          },
        ),
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () => setState(() => pasos.removeAt(index)),
        ),
      ],
    );
  }

  Future<String> _selectImage() async {
    // Implementa la lógica para seleccionar una imagen
    // Por ejemplo, mostrar un diálogo con opciones de imágenes
    // Retorna el path de la imagen seleccionada
    return '';
  }
}
