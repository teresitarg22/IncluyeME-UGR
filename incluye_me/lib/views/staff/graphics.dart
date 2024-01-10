import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:incluye_me/controllers/task_controller.dart';
import '../../components/bottom_navigation_bar.dart';

// --------------------------------------------------------------------------------------------

class GraphicsPage extends StatefulWidget {
  final String nombre;
  final String apellidos;
  final String userName;
  final String userSurname;

  GraphicsPage(
      {super.key,
      required this.nombre,
      required this.apellidos,
      required this.userName,
      required this.userSurname});

  @override
  _GraphicsPageState createState() => _GraphicsPageState();
}

// --------------------------------------------------------------------------------------------

class _GraphicsPageState extends State<GraphicsPage> {
  TaskController controlador = TaskController();
  var tareasFuture;
  bool datosCargados = false;

  static int tareasCompletadas = 0;
  static int tareasNoCompletadas = 0;
  static int tareasTotales = 0;
  List<int> idTareasSemanales = [];

  double tareasCompletadasPorcentaje = 50.0;
  double tareasNoCompletadasPorcentaje = 50.0;

  // --------------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    tareasFuture = setTareas();
    setDatos();
  }

  // -------------------------------------------------------------------

  Future<List<Map<String, dynamic>>> setTareas() async {
    return await controlador.getTareaAsignadaPorEstudiante(
        widget.nombre, widget.apellidos);
  }

  // -------------------------------------------------------------------

  Future<void> setDatos() async {
    var tareas = await tareasFuture;
    tareasCompletadas = 0;
    tareasNoCompletadas = 0;

    for (var tarea in tareas) {
      var esSemanal =
          await controlador.esTareaSemamal(tarea['asignada']?['id_tarea']);

      if (esSemanal) {
        var completada =
            await controlador.esTareaCompletada(tarea['asignada']?['id_tarea']);
        idTareasSemanales.add(tarea['asignada']?['id_tarea']);
        tareasTotales++;

        if (completada) {
          tareasCompletadas++;
        } else {
          tareasNoCompletadas++;
        }
      }
    }
    tareasCompletadasPorcentaje = (tareasCompletadas / tareasTotales) * 100;
    tareasNoCompletadasPorcentaje = (tareasNoCompletadas / tareasTotales) * 100;
  }

  // -------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: setDatos(),
      builder: (context, snapshot) {
        // snapshot contiene el estado actual del Future
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Gráfica Semanal',
                style: TextStyle(fontSize: 20, color: Colors.white),
                textAlign: TextAlign.center,
                selectionColor: Colors.white,
              ),
              backgroundColor: Colors.blue,
              iconTheme: const IconThemeData(color: Colors.white),
            ),
            body: PieChart(
                swapAnimationDuration: const Duration(milliseconds: 1500),
                PieChartData(
                  startDegreeOffset: 90,
                  sectionsSpace: 0,
                  centerSpaceRadius: 60,
                  sections: loadDatos(),
                )),
          );
        }
      },
    );
  }

  // --------------------------------------------------------------

  List<PieChartSectionData> loadDatos() {
    return [
      PieChartSectionData(
        color: const Color.fromARGB(255, 139, 243, 143),
        value: tareasCompletadasPorcentaje,
        title: 'Tareas Realizadas: ${tareasCompletadas - 1}',
        radius: 80,
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      PieChartSectionData(
        color: const Color.fromARGB(255, 238, 115, 106),
        value: tareasNoCompletadasPorcentaje,
        title: ' Tareas No Realizadas: ${tareasNoCompletadas - 1}',
        radius: 80,
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    ];
  }
}
