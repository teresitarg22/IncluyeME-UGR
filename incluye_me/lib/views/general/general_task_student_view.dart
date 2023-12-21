import 'package:flutter/material.dart';
import 'package:incluye_me/controllers/task_controller.dart';
import 'package:incluye_me/controllers/user_controller.dart' as userController;
import 'package:incluye_me/model/general_task.dart';

class TareaGeneralView extends StatefulWidget {
  final int taskId;
  final VoidCallback? onTaskCompleted;

  TareaGeneralView({Key? key, required this.taskId, this.onTaskCompleted}) : super(key: key);

  @override
  _TareaGeneralViewState createState() => _TareaGeneralViewState();
}

class _TareaGeneralViewState extends State<TareaGeneralView> {
  final TaskController controller = TaskController();
  final userController.Controller uController = userController.Controller();

  int currentPage = 0;

  Future<Tarea> getTareaGeneral() async {
    var tareaGeneral = await controller.getTareaGeneral(widget.taskId);
    if (tareaGeneral is! List<Map<String, dynamic>>) {
      throw Exception("Formato de datos incorrecto");
    }
    return Tarea.fromJson(tareaGeneral[0]);
  }

  Future<List<Paso>> getDetallesPasos(Tarea tarea) async {
    if (tarea.indicesPasos.isEmpty) {
      return [];
    }
    return await controller.obtenerDetallesPasos(tarea.indicesPasos);
  }

  void _handleTaskCompletion() async {
    await uController.completarTarea(widget.taskId);
    widget.onTaskCompleted?.call();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tarea por pasos"),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<Tarea>(
        future: getTareaGeneral(),
        builder: (context, snapshotTarea) {
          if (snapshotTarea.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshotTarea.hasError) {
            return Center(child: Text("Error: ${snapshotTarea.error}"));
          } else if (!snapshotTarea.hasData) {
            return Center(child: Text("No se encontró la tarea"));
          }

          Tarea tarea = snapshotTarea.data!;
          return FutureBuilder<List<Paso>>(
            future: getDetallesPasos(tarea),
            builder: (context, snapshotPasos) {
              if (snapshotPasos.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshotPasos.hasError) {
                return Text("Error al cargar pasos: ${snapshotPasos.error}");
              } else if (!snapshotPasos.hasData) {
                return Text("No se encontraron pasos para esta tarea");
              }

              List<Paso> pasos = snapshotPasos.data!;
              int itemsPerPage = 2;
              int totalPaginas = (pasos.length / itemsPerPage).ceil();
              int startIndex = currentPage * itemsPerPage;
              int endIndex = (currentPage + 1) * itemsPerPage;
              endIndex = endIndex > pasos.length ? pasos.length : endIndex;
              List<Paso> pasosEnPagina = pasos.sublist(startIndex, endIndex);

              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(tarea.titulo, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)), // Título de la tarea
                    ),
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1, // Una sola columna
                          childAspectRatio: 1.0, // Elementos cuadrados
                        ),
                        itemCount: pasosEnPagina.length,
                        itemBuilder: (context, index) {
                          final paso = pasosEnPagina[index];
                          return Card( // Usar Card para un mejor efecto visual
                            child: Column(
                              children: [
                                Expanded(
                                  child: paso.imagen.isNotEmpty
                                      ? Image.memory(
                                    paso.imagen,
                                    fit: BoxFit.contain,
                                  )
                                      : Container(
                                    color: Colors.grey,
                                    child: Center(child: Text('No Image')),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "${startIndex + index + 1}. ${paso.descripcion.toUpperCase()}",
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    if (currentPage == totalPaginas - 1) // Si estamos en la última página
                      ElevatedButton.icon(
                        icon: Icon(Icons.check, color: Colors.white),
                        label: Text('HECHO'),
                        onPressed: _handleTaskCompletion,
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green, // Botón verde
                          onPrimary: Colors.white, // Texto blanco
                          minimumSize: Size(double.infinity, 50), // Tamaño mínimo del botón
                        ),
                      ),
                    if (totalPaginas > 1)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back),
                            onPressed: currentPage > 0
                                ? () {
                              setState(() {
                                currentPage--;
                              });
                            }
                                : null,
                          ),
                          Text("Página ${currentPage + 1} de $totalPaginas"),
                          IconButton(
                            icon: Icon(Icons.arrow_forward),
                            onPressed: currentPage < totalPaginas - 1
                                ? () {
                              setState(() {
                                currentPage++;
                              });
                            }
                                : null,
                          ),
                        ],
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
