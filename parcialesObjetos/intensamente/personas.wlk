import recuerdos.*

class Persona {
  var nivelFelicidad = 1000
  var emocionDominante
  const recuerdosDelDia = []
  const pensamientosCentrales = #{}
  const procesosMentales = [
    { self.asentamiento() },
    { self.asentamientoSelectivo("importante") },
    { self.profundizacion() },
    { self.controlHormonal() },
    { self.restauracionCognitiva() },
    { self.liberacionRecuerdosDelDia() }
  ]
  const memoriaALargoPlazo = []
  var edad
  
  //1)
  method vivirUnEvento(unaDescripcion) {
    const recuerdoAsociado = new Recuerdo(descripcion = unaDescripcion, fecha = new Date(), emocionDominanteActual = emocionDominante)
    recuerdosDelDia.add(recuerdoAsociado)
  }  

  //2)
  method asentar(unRecuerdo) {
    unRecuerdo.afectarA(self)
  }

  method estaFeliz() = nivelFelicidad >= 500

  method agregarAPensamientosCentrales(unRecuerdo) {
    pensamientosCentrales.add(unRecuerdo)
  }
  
  method nivelFelicidad() = nivelFelicidad

  /* method disminuirFelicidad(unaCantidad) {
    nivelFelicidad -= unaCantidad
    self.verificarFelicidad()
  } creo que aca rompo encapsulamiento de class persona */

  method disminuirFelicidadEn(unaCantidad) {
    nivelFelicidad -= (nivelFelicidad * unaCantidad)
    self.verificarFelicidad()
  }

  method verificarFelicidad() {
    if(nivelFelicidad < 1) {
      throw new DomainException(message = "Nivel de felicidad muy bajo")
    }
  }

  //3)

  method recuerdosRecientes() = recuerdosDelDia.reverse().take(5)

  //4)

  method pensamientosCentrales() = pensamientosCentrales

  //5)

  method pensamientosCentralesDificiles() = pensamientosCentrales.filter {unRecuerdo => unRecuerdo.esDificilDeExplicar()}

  //6)
  method negarRecuerdo(unRecuerdo) = emocionDominante.negar(unRecuerdo)


  method asentamiento() {
    recuerdosDelDia.forEach({ r => self.asentar(r) })
  }

  method asentamientoSelectivo(palabraClave) {
    const recuerdosEspecificos = recuerdosDelDia.filter({ r => r.descripcion.contains(palabraClave) })
    recuerdosEspecificos.forEach({ r => self.asentar(r)
     })
  }

  method profundizacion() {
    const recuerdosAProfundizar = recuerdosDelDia.filter({ r =>
      not pensamientosCentrales.contains(r) and not self.negarRecuerdo(r)
    })
    recuerdosAProfundizar.forEach({ r => memoriaALargoPlazo.add(r) })
  }

  method controlHormonal() {
    const hayPensamientoRepetido = pensamientosCentrales.any({ p => memoriaALargoPlazo.contains(p) })
    const todasMismaEmocion = recuerdosDelDia.forAll({ r => r.emocionDominanteActual == recuerdosDelDia.first().emocionDominanteActual })

    if (hayPensamientoRepetido or todasMismaEmocion) {
      self.disminuirFelicidadEn(0.15)
      pensamientosCentrales.take(3).forEach({ p => pensamientosCentrales.remove(p) })
    }
  }

  method restauracionCognitiva() {
    nivelFelicidad = Math.min(nivelFelicidad + 100, 1000)
  }

  method liberarRecuerdosDelDia() {
    recuerdosDelDia.clear()
  }

  method dormir() {
    procesosMentales.forEach({ proceso => proceso() })
}  

 method rememorar() {
    const fechaLimite = edad / 2
    const recuerdosPosibles = memoriaALargoPlazo.filter({ r => r.fecha < fechaLimite })
    
    if (recuerdosPosibles.size() > 0) {
      const recuerdoElegido = recuerdosPosibles.anyOne()
      pensamientosCentrales.add(recuerdoElegido)
    }

method cantidadRepeticiones(recuerdo) {
  memoriaALargoPlazo.filter({ r => r == "recuerdo" }).size()
}

method cantidadRepeticiones(recuerdo) {
  memoriaALargoPlazo.contains(recuerdo).size()
}

method tieneDejaVu() {
  pensamientosCentrales.any({ p => memoriaALargoPlazo.contains(p) })
}





}}
