personaje(pumkin,ladron([licorerias, estacionesDeServicio])).
personaje(honeyBunny,ladron([licorerias, estacionesDeServicio])).
personaje(vincent, mafioso(maton)).
personaje(jules, mafioso(maton)).
personaje(marsellus, mafioso(capo)).
personaje(winston,mafioso(resuelveProblemas)).
personaje(mia, actriz([foxForceFive])).
personaje(butch, boxeador).

pareja(marsellus, mia).
pareja(pumkin, honeyBunny).

%trabajaPara(Empleador, Empleado)
trabajaPara(marsellus, vincent).
trabajaPara(marsellus, jules).
trabajaPara(marsellus, winston).

amigo(vincent, jules).
amigo(jules, jimmie).
amigo(vincent, elVendedor).

%encargo(Solicitante, Encargado, Tarea). 
%las tareas pueden ser cuidar(Protegido), ayudar(Ayudado), buscar(Buscado, Lugar)
encargo(marsellus, vincent,   cuidar(mia)).
encargo(vincent,  elVendedor, cuidar(mia)).
encargo(marsellus, winston, ayudar(jules)).
encargo(marsellus, winston, ayudar(vincent)).
encargo(marsellus, vincent, buscar(butch, losAngeles)).

/* 1. esPeligroso/1. Nos dice si un personaje es peligroso. Eso ocurre cuando:
-realiza alguna actividad peligrosa: ser matón, o robar licorerías. 
-tiene empleados peligrosos
*/

/* caso que icimos con cata

esPeligroso(Personaje):-
    personaje(Personaje,mafioso(maton)),
    trabajaPara(Personaje, OtroPersonaje),
    esPeligroso(OtroPersonaje).

esPeligroso(Personaje):-
    personaje(Personaje,ladron(ListadeLugares)),
    member(licorerias,ListadeLugares),
    trabajaPara(Personaje, OtroPersonaje),
    esPeligroso(OtroPersonaje).
*/

/* caso de que ambas condiciones a la vez sean peligrosos

esPeligroso(Personaje) :-
    actividadPeligrosa(Personaje),
    tieneEmpleadoPeligroso(Personaje).

actividadPeligrosa(Personaje) :-
    personaje(Personaje, mafioso(maton)).
actividadPeligrosa(Personaje) :-
    personaje(Personaje, ladron(Lugares)),
    member(licorerias, Lugares).

tieneEmpleadoPeligroso(Personaje) :-
    trabajaPara(Personaje, Empleado),
    esPeligroso(Empleado).
*/

/* caso 2 condiciones distintas disyuncion*/

esPeligroso(Personaje) :-
    personaje(Personaje, mafioso(maton)).

esPeligroso(Personaje) :-
    personaje(Personaje, ladron(Lugares)),
    member(licorerias, Lugares).

esPeligroso(Personaje) :-
    trabajaPara(Personaje, Empleado),
    esPeligroso(Empleado).

/*
2. duoTemible/2 que relaciona dos personajes cuando son peligrosos y además 
son pareja o amigos. Considerar que Tarantino también nos dió los siguientes hechos:

amigo(vincent, jules).
amigo(jules, jimmie).
amigo(vincent, elVendedor).
*/
/* version con cata
duoTemible(Personaje,OtroPersonaje):-
    esPeligroso(Personaje),
    esPeligroso(OtroPersonaje),
    Persona \= OtroPersonaje,
    pareja(Personaje, OtroPersonaje).

duoTemible(Personaje,OtroPersonaje):-
    esPeligroso(Personaje),
    esPeligroso(OtroPersonaje),
    Persona \= OtroPersonaje,
    amigo(Personaje, OtroPersonaje).
*/
%version chat
relacion(Persona, Otra) :-
    pareja(Persona, Otra).
relacion(Persona, Otra) :-
    pareja(Otra, Persona).
relacion(Persona, Otra) :-
    amigo(Persona, Otra).
relacion(Persona, Otra) :-
    amigo(Otra, Persona).

duoTemible(P1, P2) :-
    esPeligroso(P1),
    esPeligroso(P2),
    relacion(P1, P2),
    P1 \= P2,
    P1 @< P2.  % evita duplicados invirtiendo el orden alfabético

/*
3.  estaEnProblemas/1: un personaje está en problemas cuando 
el jefe es peligroso y le encarga que cuide a su pareja
o bien, tiene que ir a buscar a un boxeador. 
Además butch siempre está en problemas. 

Ejemplo:

? estaEnProblemas(vincent)
yes. %porque marsellus le pidió que cuide a mia, y porque tiene que ir a buscar a butch

La información de los encargos está codificada en la base de la siguiente forma: 

%encargo(Solicitante, Encargado, Tarea). 
%las tareas pueden ser cuidar(Protegido), ayudar(Ayudado), buscar(Buscado, Lugar)
encargo(marsellus, vincent,   cuidar(mia)).
encargo(vincent,  elVendedor, cuidar(mia)).
encargo(marsellus, winston, ayudar(jules)).
encargo(marsellus, winston, ayudar(vincent)).
encargo(marsellus, vincent, buscar(butch, losAngeles)).
*/

estaEnProblemas(Personaje):-
    trabajaPara(Jefe, Personaje),
    esPeligroso(Jefe),
    pareja(Jefe, Pareja),
    encargo(Jefe, Personaje, cuidar(Pareja)).

estaEnProblemas(Personaje):-
    encargo(_, Personaje, buscar(Boxeador, _)),
    personaje(Boxeador, boxeador).

estaEnProblemas(butch).

/*4.  sanCayetano/1:  es quien a todos los que tiene cerca les da trabajo (algún encargo). 
Alguien tiene cerca a otro personaje si es su amigo o empleado. 
*/
/* versión con cata, esta mal porque aca esta diciendo que basta con que se cumpla uno, y dice que tiene que cumplir todos
tieneCerca(Personaje,OtroPersonaje):-
    amigo(Personaje, OtroPersonaje).

tieneCerca(Personaje,OtroPersonaje):-
    trabajaPara(Personaje, OtroPersonaje).

sanCayetano(Personaje):-
    tieneCerca(Personaje,OtroPersonaje),
    encargo(Personaje, OtroPersonaje, _).
*/

tieneCerca(Personaje, OtroPersonaje) :-
    amigo(Personaje, OtroPersonaje).

tieneCerca(Personaje, OtroPersonaje) :-
    trabajaPara(Personaje, OtroPersonaje).

sanCayetano(Personaje) :-
    personaje(Personaje, _),
    forall(
        tieneCerca(Personaje, Otro),
        encargo(Personaje, Otro, _)
    ).

/*5. masAtareado/1. Es el más atareado aquel que tenga más encargos que cualquier otro personaje.*/

masAtareado(Personaje) :-
    personaje(Personaje, _),
    obtenerEncargos(Personaje, Encargos),
    forall(
        (personaje(Otro, _), Otro \= Personaje),
        (obtenerEncargos(Otro, OtrosEncargos), Encargos >= OtrosEncargos)
    ).

/*encargos que recibe
obtenerEncargos(Personaje,Encargos):-
    personaje(Personaje, _),
    findall(Encargo,encargo(_, Personaje, Encargo),ListaDeEncargos),
    length(ListaDeEncargos, Encargos).
*/
%encargos que hace
obtenerEncargos(Personaje, Cantidad) :-
    personaje(Personaje, _),
    findall(Tarea, encargo(Personaje, _, Tarea), ListaTareas),
    length(ListaTareas, Cantidad).

/*6. personajesRespetables/1: genera la lista de todos los personajes respetables. 
Es respetable cuando su actividad tiene un nivel de respeto mayor a 9. Se sabe que:
Las actrices tienen un nivel de respeto de la décima parte de su cantidad de peliculas.
Los mafiosos que resuelven problemas tienen un nivel de 10 de respeto, los matones 1 y los capos 20.
Al resto no se les debe ningún nivel de respeto. 
*/

personajesRespetables(Personajes) :-
    findall(Personaje,
        (nivelDeRespeto(Personaje, Nivel), Nivel > 9),
        Personajes).

nivelDeRespeto(Personaje, Nivel) :-
    personaje(Personaje, actriz(Peliculas)),
    length(Peliculas, Cantidad),
    Nivel is Cantidad / 10.

nivelDeRespeto(Personaje, 10) :-
    personaje(Personaje, mafioso(resuelveProblemas)).

nivelDeRespeto(Personaje, 1) :-
    personaje(Personaje, mafioso(maton)).

nivelDeRespeto(Personaje, 20) :-
    personaje(Personaje, mafioso(capo)).

/*
7. hartoDe/2: un personaje está harto de otro, cuando todas las tareas asignadas al primero requieren
 interactuar con el segundo (cuidar, buscar o ayudar) o un amigo del segundo. Ejemplo:

? hartoDe(winston, vincent).
true % winston tiene que ayudar a vincent, y a jules, que es amigo de vincent.
*/
/*
hartoDe(Personaje,OtroPersonaje):-
    personaje(Personaje,_),
    personaje(OtroPersonaje,_),
    forall(encargo(_, Personaje,Tarea),participaEn(Tarea,OtroPersonaje)).

hartoDe(Personaje,OtroPersonaje):-
    personaje(Personaje,_),
    personaje(OtroPersonaje,_),
    amigo(OtroPersonaje, Amigo), ESTA MAL, PORQUE NO RECORRE TODOS LOS AMIGOS, SOLO SE QUEDA CON UNO.
    forall(encargo(_, Personaje,Tarea),participaEn(Tarea,Amigo)).
esta esta bien pero hay cosas que no vimos
hartoDe(Personaje, OtroPersonaje) :-
    personaje(Personaje, _),
    personaje(OtroPersonaje, _),
    forall(
        encargo(_, Personaje, Tarea),
        (
            participaEn(Tarea, Involucrado),
            (Involucrado = OtroPersonaje ; amigo(OtroPersonaje, Involucrado))
        )
    ).
*/
hartoDe(Personaje, OtroPersonaje) :-
    personaje(Personaje, _),
    personaje(OtroPersonaje, _),
    forall(
        encargo(_, Personaje, Tarea),
        participaCon(Tarea, OtroPersonaje)
    ).

participaCon(Tarea, OtroPersonaje) :-
    participaEn(Tarea, OtroPersonaje).
participaCon(Tarea, OtroPersonaje) :-
    participaEn(Tarea, Amigo),
    amigo(OtroPersonaje, Amigo).

participaEn(ayudar(Quien), Quien).
participaEn(cuidar(Quien), Quien).
participaEn(buscar(Quien, _), Quien).

/*8. Ah, algo más: nuestros personajes tienen características. Lo cual es bueno, porque nos ayuda a diferenciarlos cuando están de a dos. Por ejemplo:

caracteristicas(vincent,  [negro, muchoPelo, tieneCabeza]).
caracteristicas(jules,    [tieneCabeza, muchoPelo]).
caracteristicas(marvin,   [negro]).

Desarrollar duoDiferenciable/2, que relaciona a un dúo (dos amigos o una pareja) en el que uno tiene al menos una característica que el otro no. 

ESTA MAL PORQUE FALTA EL CASO EN EL QUE LA OTRA PERSONA TENGA LA CARACTERISTICA DE ESA.

duoDiferenciable(Personaje,OtroPersonaje):-
    relacion(Personaje,OtroPersonaje),
    tienenCaracteristicasEnComun(Personaje,OtroPersonaje).

tienenCaracteristicasEnComun(Personaje,OtroPersonaje):-
    caracteristicas(Personaje,Caracteristicas),
    caracteristicas(OtroPersonaje,OtrasCaracteristicas),
    member(UnaCaracteristica,Caracteristicas),
    not(member(UnaCaracteristica,OtrasCaracteristicas)).
*/

caracteristicas(vincent,  [negro, muchoPelo, tieneCabeza]).
caracteristicas(jules,    [tieneCabeza, muchoPelo]).
caracteristicas(marvin,   [negro]).

duoDiferenciable(P1, P2) :-
    relacion(P1, P2),
    tienenCaracteristicasDistintas(P1,P2).
%como usa chat disyuncion
tienenCaracteristicasDistintas(P1,P2):-
    caracteristicas(P1, C1),
    caracteristicas(P2, C2),
    (
        member(Car, C1), not(member(Car, C2))
        ;
        member(Car, C2), not(member(Car, C1))
    ).
%como usamos nosotros la disyuncion
tienenCaracteristicasDistintas(P1, P2) :-
    caracteristicas(P1, C1),
    caracteristicas(P2, C2),
    member(Car, C1),
    not(member(Car, C2)).

tienenCaracteristicasDistintas(P1, P2) :-
    caracteristicas(P1, C1),
    caracteristicas(P2, C2),
    member(Car, C2),
    not(member(Car, C1)).

/* version topo muy buena

tienenCaracteristicasDistintas(P1, P2) :-
    caracteristicas(P1, C1),
    caracteristicas(P2, C2),
    comprobarOrden(C1,C2).

comprobarOrden(Lista1,Lista2):-
    member(Elemento,Lista1),
    not(member(Elemento,Lista2)).

comprobarOrden(Lista1,Lista2):-
    member(Elemento,Lista2),
    not(member(Elemento,Lista1)).