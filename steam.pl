juego(accion(callOfDuty), 5).
juego(accion(batmanAA), 10).
juego(mmorpg(wow, 5000000), 30).
juego(mmorpg(lineage2, 6000000), 15).
juego(puzzle(plantsVsZombies, 40, media), 10).
juego(puzzle(tetris, 10, facil), 0).

oferta(callOfDuty, 10).
oferta(plantsVsZombies, 50).

usuario(nico, [batmanAA, plantsVsZombies, tetris], [compra(lineage2)]).
usuario(fede, [], [regalo(callOfDuty, nico), regalo(wow, nico)]).
usuario(rasta, [lineage2], []).
usuario(agus, [], []).
usuario(felipe, [plantsVsZombies], [compra(tetris)]).

precioDeJuego(Nombre, Precio):-
    juego(accion(Nombre), Precio).
precioDeJuego(Nombre, Precio):-
    juego(mmorpg(Nombre, _), Precio).
precioDeJuego(Nombre, Precio):-
    juego(puzzle(Nombre, _, _), Precio).

cuantoSale(Nombre,Valor):-
    precioDeJuego(Nombre, Precio),
    oferta(Nombre, Descuento),
    Valor is Precio - (Precio * Descuento / 100),
    Valor >= 0.

cuantoSale(Nombre,Precio):-
    precioDeJuego(Nombre, Precio),
    not(oferta(Nombre, Descuento)).

juegoPopular(Nombre):-
    juego(accion(Nombre), _).

juegoPopular(Nombre):-
    juego(mmorpg(Nombre, Usuarios), _),
    Usuarios > 1000000.
    
juegoPopular(Nombre):-
    juego(puzzle(Nombre, _, facil), _).

juegoPopular(Nombre):-
    juego(puzzle(Nombre, 25, _), _).

tieneUnBuenDescuento(Nombre):-
    oferta(Nombre, Descuento),
    Descuento > 50.

obtenerNombreDeAdquisicion(regalo(Nombre, _),Nombre).
obtenerNombreDeAdquisicion(compra(Nombre),Nombre).

adictoALosDescuentos(Usuario):-
    usuario(Usuario, _, Adquisiciones),
    forall((member(Adquisicion, Adquisiciones),obtenerNombreDeAdquisicion(Adquisicion,Nombre)),
        tieneUnBuenDescuento(Nombre) ).

fanaticoDe(Usuario,Genero):-
usuario(Usuario,Juegos,_),
member(Nombre,Juegos),
member(Nombre2,Juegos),
esDeGenero(Nombre, Genero),
esDeGenero(Nombre2, Genero),
Nombre \= Nombre2.

esDeGenero(Nombre, accion):-
juego(accion(Nombre), _).

esDeGenero(Nombre, mmorpg):-
juego(mmorpg(Nombre, _), _).

esDeGenero(Nombre, puzzle):-
juego(puzzle(Nombre, _, _), _).

monotematico(Usuario,Genero):-
    usuario(Usuario,Juegos,_),
    member(Nombre,Juegos),
    esDeGenero(Nombre, Genero),
    forall(
        member(Juego,Juegos), (esDeGenero(Juego,Genero))
        ).
/*
monotematico(Usuario,Genero):-
    usuario(Usuario,Juegos,_),
    forall(
        member(Juego,Juegos), (esDeGenero(Juego,accion))
        ).

monotematico(Usuario,Genero):-
    usuario(Usuario,Juegos,_),
    forall(
        member(Juego,Juegos), (esDeGenero(Juego,mmorpg))
        ).

monotematico(Usuario,Genero):-
    usuario(Usuario,Juegos,_),
    forall(
        member(Juego,Juegos), (esDeGenero(Juego,puzzle))
        ).
*/
buenosAmigos(Usuario,OtroUsuario):-
    usuario(Usuario, _, _),
    usuario(OtroUsuario, _, _),
    leRegala(Usuario,OtroUsuario),
    leRegala(OtroUsuario,Usuario),
    Usuario \= OtroUsuario.

leRegala(Usuario,OtroUsuario):-
    usuario(Usuario, _, Adquisiciones),
    member(regalo(NombreJuego,OtroUsuario),Adquisiciones),
    juegoPopular(NombreJuego).
/*
buenosAmigos(Usuario,OtroUsuario):-
    usuario(Usuario, _, Adquisiciones),
    usuario(OtroUsuario, _, Adquisiciones1),
    member(regalo(_,OtroUsuario),Adquisiciones),
    member(regalo(_,Usuario),Adquisiciones1),
    Usuario \= OtroUsuario.
*/
cuantoGastara(Usuario,CantidadDeDinero):-
    usuario(Usuario, _, Adquisiciones),
    findall(
        Precio,(
        member(Adquisicion,Adquisiciones), obtenerNombreDeAdquisicion(Adquisicion,Nombre),
        cuantoSale(Nombre, Precio)),
        Precios),
    sum_list(Precios, CantidadDeDinero).