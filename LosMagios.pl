:- dynamic not/2.

persona(bart).
persona(larry).
persona(otto).
persona(marge).

%los magios son functores alMando(nombre, antiguedad), novato(nombre) y elElegido(nombre).
persona(alMando(burns,29)).
persona(alMando(clark,20)).
persona(novato(lenny)).
persona(novato(carl)).
persona(elElegido(homero)).

hijo(homero,abbe).
hijo(bart,homero).
hijo(larry,burns).

salvo(carl,lenny).
salvo(homero,larry).
salvo(otto,burns).

%Los beneficios son funtores confort(descripcion), confort(descripcion, caracteristica), 
% dispersion(descripcion), economico(descripcion, monto).
gozaBeneficio(carl, confort(sillon)).
gozaBeneficio(lenny, confort(sillon)).
gozaBeneficio(lenny, confort(estacionamiento, techado)).
gozaBeneficio(carl, confort(estacionamiento, libre)).
gozaBeneficio(clark, confort(viajeSinTráfico)).
gozaBeneficio(clark, dispersion(fiestas)).
gozaBeneficio(burns, dispersion(fiestas)).
gozaBeneficio(lenny, economico(descuento, 500)).

/*1) Saber si una persona puede ser aspiranteMagio/1. Un aspirante a 
magio es una persona que es descendiente de un magio o le salvó la vida a un magio.*/

aspiranteMagio(Persona) :-
    persona(Persona),
    descendenteMagio(Persona).

aspiranteMagio(Persona) :-
    persona(Persona),
    salvo(Persona, OtraPersona),
    esMagio(OtraPersona).
%recursivo
descendenteMagio(Persona) :-
    hijo(Persona, Padre),
    esMagio(Padre).

descendenteMagio(Persona) :-
    hijo(Persona, Padre),
    descendenteMagio(Padre).

esMagio(Persona) :- 
    persona(alMando(Persona, _)).

esMagio(Persona) :- 
    persona(novato(Persona)).

esMagio(Persona) :- 
    persona(elElegido(Persona)).

/*2) Saber quien puede dar órdenes a otro, puedeDarOrdenes/2. 
 Los magios alMando/2 pueden dar órdenes a un magio novato o a otro magio alMando/2 de nro  menor a él. elElegido/1 puede dar ordenes a todos los magios.*/

puedeDarOrdenes(Persona, OtraPersona) :-
    persona(alMando(Persona, _)),
    persona(novato(OtraPersona)).

puedeDarOrdenes(Persona, OtraPersona) :-
    persona(alMando(Persona, Nivel1)),
    persona(alMando(OtraPersona, Nivel2)),
    Nivel1 > Nivel2.

puedeDarOrdenes(Persona, OtraPersona) :-
    persona(elElegido(Persona)),
    esMagio(OtraPersona).


/*3) Definir el predicado sienteEnvidia/2,  relaciona una persona con una lista de personas a las cuales envídia. 
Un aspirante a magio envidia a los magios. 
Una persona que no puede ser aspirante a magio envidia a los aspirantes a magio.
Un novato magio envidia a un magio al mando
*/

sienteEnvidia(Persona, OtrasPersonas) :-
    persona(Persona),
    findall(OtraPersona, (tieneEnvidia(Persona, OtraPersona),
              Persona \= OtraPersona), OtrasPersonas).

tieneEnvidia(Persona, OtraPersona) :-
    aspiranteMagio(Persona),
    esMagio(OtraPersona).

tieneEnvidia(Persona, OtraPersona) :-
    persona(Persona),
    not(aspiranteMagio(Persona)),
    aspiranteMagio(OtraPersona).

tieneEnvidia(Persona, OtraPersona) :-
    persona(novato(Persona)),
    persona(alMando(OtraPersona, _)).

/*4) Definir el predicado masEnvidioso/1, permite conocer las personas más envidiosas. (Nota: definirlo sin usar forall/2).*/

masEnvidioso(Persona) :-
    cantidadDePersonasEnvidiadas(Persona, Cantidad),
    forall(cantidadDePersonasEnvidiadas(_, OtraCantidad), Cantidad >= OtraCantidad).

cantidadDePersonasEnvidiadas(Persona, Cantidad) :-
    sienteEnvidia(Persona, OtrasPersonas),
    length(OtrasPersonas, Cantidad).

masEnvidioso(Persona) :-
    cantidadDePersonasEnvidiadas(Persona, Cantidad),
    not( (
        cantidadDePersonasEnvidiadas(_, OtraCantidad),
        OtraCantidad > Cantidad
    )).

/*
5) Definir el predicado soloLoGoza/2, que relaciona una persona y el  beneficio que sólo es aprovechado por él y nadie más de la logia. 
?-soloLoGoza(Persona, Beneficio)
Persona = clark;
Beneficio = confort(viajeSinTráfico);
*/

%esta mal
soloLoGoza(Persona, Beneficio) :-
    gozaBeneficio(Persona, Beneficio),
    forall(gozaBeneficio(Persona, OtroBeneficio) , Beneficio \= OtroBeneficio).
%esta mal

soloLoGoza(Persona, Beneficio) :-
    gozaBeneficio(Persona, Beneficio),
    forall(
    (gozaBeneficio(OtraPersona, OtroBeneficio), OtraPersona \= Persona),Beneficio \= OtroBeneficio).

soloLoGoza(Persona, Beneficio) :-
    gozaBeneficio(Persona, Beneficio),
     not((gozaBeneficio(OtraPersona, Beneficio), OtraPersona \= Persona)).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% las de abajo son validas pero no lo vimos
soloLoGoza(Persona, Beneficio) :-
    gozaBeneficio(Persona, Beneficio),
    forall((gozaBeneficio(OtraPersona, Beneficio)),Persona = OtraPersona).

soloLoGoza(Persona, Beneficio) :-
    gozaBeneficio(Persona, Beneficio),
    forall((gozaBeneficio(OtraPersona, Beneficio), OtraPersona \= Persona), false).


/*6) Definir el predicado tipoDeBeneficioMasAprovechado/1,  permite conocer el tipo de beneficio más aprovechado por los participantes de la logia.
?- tipoDeBenefioMasAprovechado(Cual)
Cual = confort.
*/

tipoBeneficio(confort(_), confort).
tipoBeneficio(confort(_, _), confort).
tipoBeneficio(dispersion(_), dispersion).
tipoBeneficio(economico(_, _), economico).

cantidadPorTipo(Tipo, Cantidad) :-
    tipoBeneficio(_, Tipo),
    findall(Tipo, (gozaBeneficio(_, Beneficio), tipoBeneficio(Beneficio, Tipo)), Lista),
    length(Lista, Cantidad).

tipoDeBeneficioMasAprovechado(TipoMax) :-
    member(TipoMax, [confort, dispersion, economico]),
    cantidadPorTipo(TipoMax, CantMax),
    forall(
        (member(OtroTipo, [confort, dispersion, economico]), cantidadPorTipo(OtroTipo, Cant)),
        CantMax >= Cant
    ).

% Justificar:
% ¿Dónde se aprovecho el uso del polimorfismo? ¿Con qué objetivo?
% El polimorfismo se aprovecho en esMagio para ver los distintos tipos de casos en las que una Persona podria ser magio (novato, alMando, elElegido)