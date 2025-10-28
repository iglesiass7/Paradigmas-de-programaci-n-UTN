
object alegre {

  method influirEn(unaPersona, unRecuerdo) {
    if(unaPersona.estaFeliz()) {
      unaPersona.agregarAPensamientosCentrales(unRecuerdo)
    }
  }

  method negar(unRecuerdo) = not unRecuerdo.esAlegre()
}

object triste {

  method influirEn(unaPersona, unRecuerdo) {
    unaPersona.agregarAPensamientosCentrales(unRecuerdo)
   // unaPersona.disminuirFelicidad(0.1 * unaPersona.nivelFelicidad())
   // //creo que aca rompo encapsulamiento de class persona
    unaPersona.disminuirFelicidadEn(0.1)
  }

  method negar(unRecuerdo) = unRecuerdo.esAlegre()
}

class Emocion {

    method influirEn(unaPersona, unRecuerdo) {}

    method negar(unRecuerdo) = false
}

const disgusto = new Emocion()
const furioso = new Emocion()
const temeroso = new Emocion()

class EmocionCompuesta {
  const emociones = []

  method influirEn(unaPersona, unRecuerdo) {
    emociones.forEach({ e => e.influirEn(unaPersona, unRecuerdo) })
  }

  method negar(unRecuerdo) {
    emociones.all({ e => e.negar(unRecuerdo) })
  }

  method esAlegre() {
    emociones.any({ e => e == "alegre" })
  }
}

