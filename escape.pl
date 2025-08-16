%persona(Apodo, Edad, Peculiaridades). 
persona(ale, 15, [claustrofobia, cuentasRapidas, amorPorLosPerros]). 
persona(agus, 25, [lecturaVeloz, ojoObservador, minuciosidad]). 
persona(fran, 30, [fanDeLosComics]). 
persona(rolo, 12, []).

%esSalaDe(NombreSala, Empresa). 
esSalaDe(elPayasoExorcista, salSiPuedes). 
esSalaDe(socorro, salSiPuedes). 
esSalaDe(linternas, elLaberintoso). 
esSalaDe(guerrasEstelares, escapepepe). 
esSalaDe(fundacionDelMulo, escapepepe).
esSalaDe(estrellasDePelea, supercelula).
esSalaDe(choqueDeLaRealeza, supercelula).
esSalaDe(miseriaDeLaNoche, sKPista).

%vertigo no cuenta con salas, por lo que no puede ser definida.

/*6) ¡Cada vez hay más salas y empresas! Conozcámoslas para agregarlas a nuestro
sistema:
● La empresa supercelula es dueña de salas de escape familiares
ambientadas en videojuegos. La sala estrellasDePelea cuenta con 7
habitaciones pero lamentablemente no sabemos la cantidad que tiene su
nueva sala choqueDeLaRealeza.
● La empresa SKPista (fanática de un famoso escritor) es la dueña de una
única sala terrorífica para mayores de 21 llamada miseriaDeLaNoche que
nos asegura 150 sustos.
● La nueva empresa que se suma a esta gran familia es Vertigo, pero aún no
cuenta con salas.*/

%terrorifica(CantidadDeSustos, EdadMinima). 
%familiar(Tematica, CantidadDeHabitaciones). 
%enigmatica(Candados). 

%sala(Nombre, Experiencia). 
sala(estrellasDePelea, familiar(videojuegos, 7)). 
sala(choqueDeLaRealeza, familiar(videojuegos, _)).
sala(miseriaDeLaNoche, terrorifica(150, 21)). 
sala(elPayasoExorcista, terrorifica(100, 18)). 
sala(socorro, terrorifica(20, 12)). 
sala(linternas, familiar(comics, 5)). 
sala(guerrasEstelares, familiar(futurista, 7)). 
sala(fundacionDelMulo, enigmatica([combinacionAlfanumerica, deLlave, 
deBoton])).

/*
1) nivelDeDificultadDeLaSala/2: para cada sala nos dice su dificultad. Para las salas
de experiencia terrorífica el nivel de dificultad es la cantidad de sustos menos la
edad mínima para ingresar. Para las de experiencia familiar es 15 si es de una
temática futurista y para cualquier otra temática es la cantidad de habitaciones. El de
las enigmáticas es la cantidad de candados que tenga.*/

nivelDeDificultadDeLaSala(Sala, Dificultad):-
    sala(Sala, Experiencia),
    dificultadExperiencia(Experiencia,Dificultad).

dificultadExperiencia(terrorifica(CantidadDeSustos, EdadMinima),Dificultad):-
    Dificultad is CantidadDeSustos - EdadMinima.

dificultadExperiencia(familiar(futurista, _), 15).

dificultadExperiencia(familiar(_, Dificultad), Dificultad).

dificultadExperiencia(enigmatica(Candados), Dificultad):-
    length(Candados, Dificultad).

/*
2) puedeSalir/2: una persona puede salir de una sala si la dificultad de la sala es 1 o
si tiene más de 13 años y la dificultad es menor a 5. En ambos casos la persona no
debe ser claustrofóbica.
*/

esClaustrofobica(Persona):-
    persona(Persona, _, Peculiaridades),
    member(claustrofobia, Peculiaridades).
    
puedeSalir(Persona,Sala):-
    persona(Persona, _, _ ),
    nivelDeDificultadDeLaSala(Sala, 1),
    not(esClaustrofobica(Persona)).

puedeSalir(Persona,Sala):-
    persona(Persona, Edad, _ ),
    Edad > 13,
    nivelDeDificultadDeLaSala(Sala, Dificultad),
    Dificultad < 5,
    not(esClaustrofobica(Persona)).

/*3) tieneSuerte/2: una persona tiene suerte en una sala si puede salir de ella aún sin
tener ninguna peculiaridad.
*/

tieneSuerte(Persona,Sala):-
    persona(Persona,_,Peculiaridades),
    puedeSalir(Persona,Sala),
    not(member(_,Peculiaridades)).

/*
4) esMacabra/1: una empresa es macabra si todas sus salas son de experiencia
terrorífica.*/

esMacabra(Empresa):-
    esSalaDe(_, Empresa),
    forall(esSalaDe(UnaSala, Empresa),sala(UnaSala, terrorifica(_, _))).

/*5) empresaCopada/1: una empresa es copada si no es macabra y el promedio de
dificultad de sus salas es menor a 4.
*/

empresaCopada(Empresa):-
    esSalaDe(_, Empresa),
    not(esMacabra(Empresa)),
    findall(Dificultad,dificultadSala(Empresa,Sala,Dificultad),ListaDeDificultadDeSalas),
    promedioDeDificultadDeSalas(ListaDeDificultadDeSalas,Promedio),
    Promedio < 4.

dificultadSala(Empresa,Sala,Dificultad):-
    esSalaDe(Sala, Empresa),
    nivelDeDificultadDeLaSala(Sala, Dificultad).

promedioDeDificultadDeSalas(ListaDeDificultadDeSalas,Promedio):-
    length(ListaDeDificultadDeSalas,CantidadDeSalas),
    sumlist(ListaDeDificultadDeSalas,TotalDificultad),
    Promedio is TotalDificultad/CantidadDeSalas.

/*6) ¡Cada vez hay más salas y empresas! Conozcámoslas para agregarlas a nuestro
sistema:
● La empresa supercelula es dueña de salas de escape familiares
ambientadas en videojuegos. La sala estrellasDePelea cuenta con 7
habitaciones pero lamentablemente no sabemos la cantidad que tiene su
nueva sala choqueDeLaRealeza.
● La empresa SKPista (fanática de un famoso escritor) es la dueña de una
única sala terrorífica para mayores de 21 llamada miseriaDeLaNoche que
nos asegura 150 sustos.
● La nueva empresa que se suma a esta gran familia es Vertigo, pero aún no
cuenta con salas.*/