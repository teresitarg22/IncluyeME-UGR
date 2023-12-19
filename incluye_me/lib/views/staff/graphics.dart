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

  int tareasCompletadas = 0;
  int tareasNoCompletadas = 0;
  int tareasTotales = 0;
  List<int> idTareasSemanales = [];

  double tareasCompletadasPorcentaje = 50.0;
  double tareasNoCompletadasPorcentaje = 50.0;

  // --------------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    tareasFuture = setTareas();
    setState(() {
      setDatos();
    });
  }

  // -------------------------------------------------------------------

  Future<List<Map<String, dynamic>>> setTareas() async {
    return controlador.getTareaAsignadaPorEstudiante(
        widget.nombre, widget.apellidos);
  }

  // -------------------------------------------------------------------

  Future<void> setDatos() async {
    var tareas = await tareasFuture;
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

      datosCargados = true;
      tareasCompletadasPorcentaje = (tareasCompletadas / tareasTotales) * 100;
      tareasNoCompletadasPorcentaje =
          (tareasNoCompletadas / tareasTotales) * 100;
    }
  }

  // -------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gráfica Semanal',
          style: TextStyle(fontSize: 20, color: Colors.white),
          textAlign: TextAlign.center,
          selectionColor: Colors.white,
        ),
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
      ),
      body: datosCargados
          ? PieChart(
              swapAnimationDuration: const Duration(milliseconds: 1500),
              PieChartData(
                startDegreeOffset: 90,
                sectionsSpace: 0,
                centerSpaceRadius: 60,
                sections: loadDatos(),
              ))
          : const Center(
              child: CircularProgressIndicator(),
            ),
      bottomNavigationBar: CustomNavigationBar(
        userName: widget.userName,
        userSurname: widget.userSurname,
      ),
    );
  }

  // --------------------------------------------------------------

  List<PieChartSectionData> loadDatos() {
    return [
      PieChartSectionData(
        color: const Color.fromARGB(255, 139, 243, 143),
        value: tareasCompletadasPorcentaje,
        title: 'Tareas Realizadas: $tareasCompletadas',
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
        title: ' Tareas No Realizadas: $tareasNoCompletadas',
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
