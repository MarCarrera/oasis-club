class Usuario {
  final String idUsuario;
  final String nombre;
  final String correo;
  final List<String> idesCategorias;
  final List<String> idesEquipos;
  final String categorias;
  final List<String> nombresEquipos;

  Usuario({
    required this.idUsuario,
    required this.nombre,
    required this.correo,
    required this.idesCategorias,
    required this.idesEquipos,
    required this.categorias,
    required this.nombresEquipos,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      idUsuario: json['id_usuario'].toString(),
      nombre: json['nombre'],
      correo: json['correo'],
      idesCategorias: List<String>.from(json['ides_categorias'] ?? []),
      idesEquipos: List<String>.from(json['ides_equipos'] ?? []),
      categorias: json['categorias'],
      nombresEquipos:
          List<String>.from((json['nombres_equipos'] ?? '').split(',')),
    );
  }
}

class LoginRequest {
  final String opcion;
  final String correo;
  final String contrasena;
  final String tokenBitala;

  LoginRequest({
    required this.opcion,
    required this.correo,
    required this.contrasena,
    required this.tokenBitala,
  });

  Map<String, String> toMap() {
    return {
      'opcion': opcion,
      'correo': correo,
      'contrasena': contrasena,
      'tokenBitala': tokenBitala,
    };
  }
}

class Entrenamiento {
  final String lugar;
  final String fecha;
  final String hora;
  final String estado;
  final String equipo;
  final String responsable;
  final dynamic integrantes;
  final String observaciones;
  final String fechaParseada;

  Entrenamiento({
    required this.lugar,
    required this.fecha,
    required this.hora,
    required this.estado,
    required this.equipo,
    required this.responsable,
    this.integrantes,
    required this.observaciones,
    required this.fechaParseada,
  });

  factory Entrenamiento.fromJson(Map<String, dynamic> json) {
    return Entrenamiento(
      lugar: json['lugar'],
      fecha: json['fecha'],
      hora: json['hora'],
      estado: json['estado'],
      equipo: json['equipo'],
      responsable: json['responsable'],
      integrantes: json['integrantes'],
      observaciones: json['observaciones'],
      fechaParseada: json['fecha_parseada'],
    );
  }
}

class ProfileData {
  final String id;
  final String name;
  final String email;
  final String height;
  final String weight;
  final String age;
  final String foot;
  final List<String> categories;
  final String position;
  final String profileImage;

  ProfileData({
    required this.id,
    required this.name,
    required this.email,
    required this.height,
    required this.weight,
    required this.age,
    required this.foot,
    required this.categories,
    required this.position,
    required this.profileImage,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      id: json['id_usuario'].toString(),
      name: json['nombre'],
      email: json['correo'],
      height: json['estatura'] ?? '',
      weight: json['peso'] ?? '',
      age: json['edad'] ?? '',
      foot: json['pie'] ?? '',
      categories: List<String>.from(json['categorias'] ?? []),
      position: json['posiciones'] ?? '',
      profileImage: json['foto_perfil'] ?? 'profile_default.png',
    );
  }

  ProfileData copyWith({
    String? id,
    String? name,
    String? email,
    String? height,
    String? weight,
    String? age,
    String? foot,
    List<String>? categories,
    String? position,
    String? profileImage,
  }) {
    return ProfileData(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      age: age ?? this.age,
      foot: foot ?? this.foot,
      categories: categories ?? this.categories,
      position: position ?? this.position,
      profileImage: profileImage ?? this.profileImage,
    );
  }
}

class ProximoPartido {
  final String idTorneo;
  final String torneo;
  final String detalle;
  final String fecha;
  final String hora;
  final String lugar;
  final String equipoLocal;
  final String equipoVisitante;
  final String escudoLocal;
  final String escudoVisitante;
  final String golesLocal;
  final String golesVisitante;
  final String estado;

  ProximoPartido({
    required this.idTorneo,
    required this.torneo,
    required this.detalle,
    required this.fecha,
    required this.hora,
    required this.lugar,
    required this.equipoLocal,
    required this.equipoVisitante,
    required this.escudoLocal,
    required this.escudoVisitante,
    required this.golesLocal,
    required this.golesVisitante,
    required this.estado,
  });

  factory ProximoPartido.fromJson(Map<String, dynamic> json) {
    return ProximoPartido(
      idTorneo: json['id_torneo']?.toString() ?? '',
      torneo: json['Torneo'] ?? '',
      detalle: json['detalle'] ?? '',
      fecha: json['fecha'] ?? '',
      hora: json['hora'] ?? '',
      lugar: json['lugar'] ?? '',
      equipoLocal: json['Equipo_Local'] ?? '',
      equipoVisitante: json['Equipo_Visitante'] ?? '',
      escudoLocal: json['Escudo_local'] ?? '',
      escudoVisitante: json['Escudo_Visitante'] ?? '',
      golesLocal: json['goles_local']?.toString() ?? '',
      golesVisitante: json['goles_visitante']?.toString() ?? '',
      estado: json['estado'] ?? '',
    );
  }
}

class EstadisticasJugador {
  final String torneo;
  final String equipo;
  final String jugador;
  final String partidosJugados;
  final String minutos;
  final String goles;
  final String golesPenal;
  final String autogoles;
  final String asistencias;
  final String tarjetasAmarillas;
  final String tarjetasRojas;
  final String lesiones;

  EstadisticasJugador({
    required this.torneo,
    required this.equipo,
    required this.jugador,
    required this.partidosJugados,
    required this.minutos,
    required this.goles,
    required this.golesPenal,
    required this.autogoles,
    required this.asistencias,
    required this.tarjetasAmarillas,
    required this.tarjetasRojas,
    required this.lesiones,
  });

  factory EstadisticasJugador.fromJson(Map<String, dynamic> json) {
    return EstadisticasJugador(
      torneo: json['torneo'],
      equipo: json['equipo'],
      jugador: json['jugador'],
      partidosJugados: json['partidos_jugados'].toString(),
      minutos: json['minutos'].toString(),
      goles: json['goles'].toString(),
      golesPenal: json['goles_penal'].toString(),
      autogoles: json['autogoles'].toString(),
      asistencias: json['asistencias'].toString(),
      tarjetasAmarillas: json['tarjetas_amarillas'].toString(),
      tarjetasRojas: json['tarjetas_rojas'].toString(),
      lesiones: json['lesiones'].toString(),
    );
  }
}

class Notificaciones {
  final String idNotificacion;
  final String color;
  final String titulo;
  final String categoria;
  final String fecha;
  final String hora;
  final String lugar;
  final String icon;
  final String horaFormato;
  final String fechaParseada;
  final String fechaEmision;
  final String horaEmision;
  final String idEvento;
  final String tabla;

  Notificaciones({
    required this.idNotificacion,
    required this.color,
    required this.titulo,
    required this.categoria,
    required this.fecha,
    required this.hora,
    required this.lugar,
    required this.icon,
    required this.horaFormato,
    required this.fechaParseada,
    required this.fechaEmision,
    required this.horaEmision,
    required this.idEvento,
    required this.tabla,
  });

  factory Notificaciones.fromJson(Map<String, dynamic> json) {
    return Notificaciones(
      idNotificacion: json['id_notificacion'].toString(),
      titulo: json['titulo'],
      color: json['color'],
      categoria: json['Categoria'],
      fecha: json['fecha'].toString(),
      hora: json['hora'].toString(),
      lugar: json['lugar'].toString(),
      icon: json['icono'].toString(),
      horaFormato: json['hora_formato'].toString(),
      fechaParseada: json['fecha_parseada'].toString(),
      fechaEmision: json['fecha_emision'].toString(),
      horaEmision: json['hora_emision'].toString(),
      idEvento: json['id_evento'].toString(),
      tabla: json['tabla'].toString(),
    );
  }
}

class Detalle {
  final String minuto;
  final String titulo;
  final String jugador;
  final String complemento;
  final String icono;
  final String color;
  final String tipo;

  Detalle({
    required this.minuto,
    required this.titulo,
    required this.jugador,
    required this.complemento,
    required this.icono,
    required this.color,
    required this.tipo,
  });

  factory Detalle.fromJson(Map<String, dynamic> json) {
    return Detalle(
      minuto: json['minuto'],
      titulo: json['titulo'],
      jugador: json['jugador'] ?? '',
      complemento: json['complemento'],
      icono: json['icono'],
      color: json['color'],
      tipo: json['tipo'],
    );
  }
}

class PartidoJugado {
  final String idPartido;
  final String idEquipo;
  final String torneo;
  final String detalle;
  final String fecha;
  final String hora;
  final String lugar;
  final String equipoLocal;
  final String equipoVisitante;
  final String escudoLocal;
  final String escudoVisitante;
  final String golesLocal;
  final String golesVisitante;
  final String estado;
  final String fechaParseada;
  final List<Detalle> detalles;

  PartidoJugado({
    required this.idPartido,
    required this.idEquipo,
    required this.torneo,
    required this.detalle,
    required this.fecha,
    required this.hora,
    required this.lugar,
    required this.equipoLocal,
    required this.equipoVisitante,
    required this.escudoLocal,
    required this.escudoVisitante,
    required this.golesLocal,
    required this.golesVisitante,
    required this.estado,
    required this.fechaParseada,
    required this.detalles,
  });

  factory PartidoJugado.fromJson(Map<String, dynamic> json) {
    return PartidoJugado(
      idPartido: json['id_partidos'].toString(),
      idEquipo: json['id_equipo'].toString(),
      torneo: json['torneo'],
      detalle: json['detalle'],
      fecha: json['fecha'],
      hora: json['hora'],
      lugar: json['lugar'],
      equipoLocal: json['equipo_local'],
      equipoVisitante: json['equipo_visitante'],
      escudoLocal: json['escudo_local'],
      escudoVisitante: json['escudo_visitante'],
      golesLocal: json['goles_local'].toString(),
      golesVisitante: json['goles_visitante'].toString(),
      estado: json['estado'],
      fechaParseada: json['fecha_parseada'],
      detalles: (json['detalles'] as List)
          .map((detalle) => Detalle.fromJson(detalle))
          .toList(),
    );
  }
}

class Noticia {
  final String idNoticia;
  final String idCategoria;
  final String categoria;
  final String titulo;
  final String cuerpo;
  final String fechaEmision;
  final String horaEmision;
  final String fotoNoticia;
  final String fechaParseada;

  Noticia({
    required this.idNoticia,
    required this.idCategoria,
    required this.categoria,
    required this.titulo,
    required this.cuerpo,
    required this.fechaEmision,
    required this.horaEmision,
    required this.fotoNoticia,
    required this.fechaParseada,
  });

  factory Noticia.fromJson(Map<String, dynamic> json) {
    return Noticia(
        idNoticia: json['id_noticia'].toString(),
        idCategoria: json['id_categoria'].toString(),
        categoria: json['categoria'],
        titulo: json['titulo'],
        cuerpo: json['cuerpo'],
        fechaEmision: json['fecha_emision'],
        horaEmision: json['hora_emision'],
        fotoNoticia: json['foto_noticia'],
        fechaParseada: json['fecha_parseada']);
  }
}
