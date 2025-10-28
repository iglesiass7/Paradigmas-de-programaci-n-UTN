class Recuerdo {
  
  const descripcion
  const fecha
  const emocionDominanteActual

  method afectarA(unaPersona) {
    emocionDominanteActual.influirEn(unaPersona, self)
  }

  method esDificilDeExplicar() = descripcion.words().size() > 10

  method esAlegre() = emocionDominanteActual == alegre

}

