import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:incluye_me/controllers/task_controller.dart';
import '../components/bottom_navigation_bar.dart';

class EstadisticaPage extends StatefulWidget {
  @override
  _EstadisticaPageState createState() => _EstadisticaPageState();
}

class _EstadisticaPageState extends State<EstadisticaPage> {
  Controller controlador = Controller();
  var tareasFuture;
  bool datosCargados = false;

  int tareasCompletadas = 0;
  int tareasNoCompletadas = 0;
  int tareasTotales = 0;
  List<int> idTareasSemanales = [];

  double tareasCompletadasPorcentaje = 50.0;
  double tareasNoCompletadasPorcentaje = 50.0;

  @override
  void initState() {
    super.initState();
    tareasFuture = setTareas();
    setState(() {
      setDatos();
    });
  }

  Future<List<Map<String, dynamic>>> setTareas() async {
    return controlador.getTareaAsignadaPorEstudiante("Sergio", "Lopez");
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gráfico Semanal',
          style: TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
          selectionColor: Colors.white,
        ),
        backgroundColor: Colors.blue,
      ),
      body: datosCargados
          ? PieChart(
              swapAnimationDuration: Duration(milliseconds: 1500),
              PieChartData(
                startDegreeOffset: 90,
                sectionsSpace: 0,
                centerSpaceRadius: 60,
                sections: loadDatos(),
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  List<PieChartSectionData> loadDatos() {
    return [
      PieChartSectionData(
        color: const Color.fromARGB(255, 139, 243, 143),
        value: tareasCompletadasPorcentaje,
        title: 'Tareas Realizadas: ${tareasCompletadas}',
        radius: 80,
        titleStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      PieChartSectionData(
        color: const Color.fromARGB(255, 238, 115, 106),
        value: tareasNoCompletadasPorcentaje,
        title: ' Tareas No Realizadas: ${tareasNoCompletadas}',
        radius: 80,
        titleStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    ];
  }
}
