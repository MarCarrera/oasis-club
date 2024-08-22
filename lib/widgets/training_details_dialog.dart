import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/models/models.dart';

void showTrainingDetailsDialog(
    BuildContext context, Entrenamiento entrenamiento) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: entrenamiento.estado == 'Programado'
            ? const Color.fromARGB(255, 162, 141, 65)
            : entrenamiento.estado == 'Finalizado'
                ? const Color.fromARGB(255, 60, 107, 55)
                : const Color.fromARGB(255, 196, 59, 59),
        title: Text(
          'Detalles del Entrenamiento',
          style: GoogleFonts.mulish(
            textStyle: const TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                'Equipo: ${entrenamiento.equipo}',
                style: GoogleFonts.mulish(
                  textStyle: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              Text(
                'Responsable: ${entrenamiento.responsable}',
                style: GoogleFonts.mulish(
                  textStyle: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              Text(
                'Fecha: ${entrenamiento.fecha}',
                style: GoogleFonts.mulish(
                  textStyle: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              Text(
                'Hora: ${entrenamiento.hora}',
                style: GoogleFonts.mulish(
                  textStyle: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              Text(
                'Lugar: ${entrenamiento.lugar}',
                style: GoogleFonts.mulish(
                  textStyle: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              Text(
                'Observaciones: ${entrenamiento.observaciones}',
                style: GoogleFonts.mulish(
                  textStyle: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              Text(
                'Estado: ${entrenamiento.estado}',
                style: GoogleFonts.mulish(
                  textStyle: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              'Cerrar',
              style: GoogleFonts.mulish(
                textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
