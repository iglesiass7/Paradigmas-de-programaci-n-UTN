%hormiga(Nombre).
%vaquitaSanAntonio(Nombre,Peso).
%cucaracha(Nombre,Tamaño,Peso).

 %comio(Personaje, Bicho).
 comio(pumba, vaquitaSanAntonio(gervasia,3)).
 comio(pumba, hormiga(federica)).
 comio(pumba, hormiga(tuNoEresLaReina)).
 comio(pumba, cucaracha(ginger,15,6)).
 comio(pumba, cucaracha(erikElRojo,25,70)).
 comio(timon, vaquitaSanAntonio(romualda,4)).
 comio(timon, cucaracha(gimeno,12,8)).
 comio(timon, cucaracha(cucurucha,12,5)).
 comio(simba, vaquitaSanAntonio(remeditos,4)).
 comio(simba, hormiga(schwartzenegger)).
 comio(simba, hormiga(niato)).
 comio(simba, hormiga(lula)).

 pesoHormiga(2).

 %peso(Personaje, Peso)
 peso(pumba, 100).
 peso(timon, 50).
 peso(simba, 200).

 peso(cucaracha(_,_,Peso),Peso).
 peso(vaquitaSanAntonio(_,Peso),Peso).
 peso(hormiga(_),2).

/*
a) Qué cucaracha es jugosita: ó sea, hay otra con su mismo tamaño pero ella es más gordita.
?- jugosita(cucaracha(gimeno,12,8)).
Yes */

jugosita(cucaracha(Nombre,Tamanio,Peso)):-
    comio(_, cucaracha(Nombre,Tamanio,Peso)),
    comio(_, cucaracha(OtroNombre,Tamanio,OtroPeso)),
    Nombre \= OtroNombre,
    Peso > OtroPeso.
/*
b) Si un personaje es hormigofílico... (Comió al menos dos hormigas).
?- hormigofilico(X).
X = pumba;
X = simba.
*/

hormigofilico(Personaje):-
    comio(Personaje, hormiga(Nombre)),
    comio(Personaje, hormiga(OtroNombre)),
    Nombre \= OtroNombre.

/*
c) Si un personaje es cucarachofóbico (no comió cucarachas).
?- cucarachofobico(X).
X = simba
*/

cucarachofobico(Personaje):-
    comio(Personaje, _),
    not(comio(Personaje, cucaracha(_,_,_))).

/*
d) Conocer al conjunto de los picarones. Un personaje es picarón si comió una cucaracha jugosita ó si se
come a Remeditos la vaquita. Además, pumba es picarón de por sí.
?- picarones(L).
L = [pumba, timon, simba]
*/

picaron(pumba).

picaron(Personaje):-
    comio(Personaje, cucaracha(Nombre,Tamanio,Peso)),
    jugosita(cucaracha(Nombre,Tamanio,Peso)).

picaron(Personaje):-
     comio(Personaje, vaquitaSanAntonio(remeditos,4)).

picarones(Personajes):-
    findall(Personaje,picaron(Personaje),Personajes).

/*
a) Se quiere saber cuánto engorda un personaje (sabiendo que engorda una cantidad igual a la suma de
los pesos de todos los bichos en su menú). Los bichos no engordan.
?- cuantoEngorda(Personaje, Peso).
Personaje= pumba
Peso = 83;
Personaje= timon
Peso = 17;
Personaje= simba
Peso = 10
*/

cuantoEngorda(Personaje, Peso):-
   comio(Personaje,_),
   findall(Peso, pesoDeSusComidas(Personaje, Peso), ListaDePesos),
   sum_list(ListaDePesos, Peso).

pesoDeSusComidas(Personaje, Peso):-
    comio(Personaje,Presa),
    peso(Presa,Peso).

%persigue(Hiena, Personaje).
persigue(scar, timon).
persigue(scar, pumba).
persigue(shenzi, simba).
persigue(shenzi, scar).
persigue(banzai, timon).
comio(shenzi,hormiga(conCaraDeSimba)).
peso(scar, 300).
peso(shenzi, 400).
peso(banzai, 500).
persigue(scar, mufasa).

/*
b) Pero como indica la ley de la selva, cuando un personaje persigue a otro, se lo termina comiendo, y por lo
tanto también engorda. Realizar una nueva version del predicado cuantoEngorda.
?- cuantoEngorda(scar,Peso).
Peso = 150
(es la suma de lo que pesan pumba y timon)
?- cuantoEngorda(shenzi,Peso).
Peso = 502
(es la suma del peso de scar y simba, mas 2 que pesa la hormiga)
*/
comio2(Personaje,Presa):-
    persigue(Personaje, Presa).

comio2(Personaje,Presa):-
    comio(Personaje,Presa).

cuantoEngorda2(Personaje, PesoT):-
   comio2(Personaje,_),
   findall(Peso, pesoDeSusComidas2(Personaje, Peso), ListaDePesos),
   sum_list(ListaDePesos, PesoT).

pesoDeSusComidas2(Personaje, Peso):-
    comio2(Personaje,Presa),
    peso(Presa,Peso).

/*
cuantoEngorda2(Personaje, PesoTotal):-
   cuantoEngorda(Personaje, Peso1),
   findall(Peso, pesoDeSusPersecuciones(Personaje, Peso), ListaDePesos),
   sum_list(ListaDePesos, Peso2),
    PesoTotal is Peso1 + Peso2.

pesoDeSusPersecuciones(Personaje, Peso):-
    persigue(Personaje, Presa),
    peso(Presa, Peso).
*/
/*
c) Ahora se complica el asunto, porque en realidad cada animal antes de comerse a sus víctimas espera a que
estas se alimenten. De esta manera, lo que engorda un animal no es sólo el peso original de sus víctimas, sino
también hay que tener en cuenta lo que éstas comieron y por lo tanto engordaron. Hacer una última version del
predicado.

?- cuantoEngorda(scar,Peso).
Peso = 250
(150, que era la suma de lo que pesan pumba y timon, más 83 que se come
pumba y 17 que come timon )
?- cuantoEngorda(shenzi,Peso).
Peso = 762
(502 era la suma del peso de scar y simba, mas 2 de la hormiga. A eso se
le suman los 250 de todo lo que engorda scar y 10 que engorda simba)
*/
/*pesoDeSusComidas2(Personaje, Peso) :-
    comio(Personaje, Presa),
    peso(Presa, Peso).

pesoDeSusComidas2(Personaje, Peso) :-
    persigue(Personaje, Presa),
    peso(Presa, Peso).

% Y además, si persigo a alguien, me como también lo que ese alguien comió/persiguió:
pesoDeSusComidas2(Personaje, Peso) :-
    persigue(Personaje, OtraPersona),
    pesoDeSusComidas2(OtraPersona, Peso).
*/
cuantoEngorda3(Personaje, PesoTotall):-
    comio(Personaje,_),
    findall(Peso,(comio(Personaje,OtroPersonaje),pesoTotal(OtroPersonaje,Peso)),ListaDePesos),
    sum_list(ListaDePesos, PesoTotall).

pesoTotal(OtroPersonaje,Peso):-
    cuantoEngorda(OtroPersonaje, Peso1),
    peso(OtroPersonaje,Peso2),
    Peso is Peso1 + Peso2.

/*
3) Buscando el rey...
Sabiendo que todo animal adora a todo lo que no se lo come o no lo
persigue, encontrar al rey. El rey es el animal a quien sólo hay un animal
que lo persigue y todos adoran.
Si se agrega el hecho:
persigue(scar, mufasa).
?- rey(R).
R = mufasa.
(sólo lo persigue scar y todos los adoran)
*/
/*rey(Rey):-
    comio(Rey,_),
    persigue(Personaje,Rey),
    not((persigue(OtroPersonaje,Rey),OtroPersonaje \= Personaje)),
    forall(personaje(Personaje1),adora(Personaje1,Rey)).
*/
adora(Animal, Otro) :-
    animal(Animal),
    animal(Otro),
    Animal \= Otro,
    not(comio(Animal, Otro)),
    not(persigue(Animal, Otro)).

animal(Animal) :- peso(Animal,_).        % los que tienen un peso propio
animal(Animal) :- persigue(Animal,_).    % los que persiguen
animal(Animal) :- persigue(_,Animal).    % los que son perseguidos


rey(Rey) :-
    animal(Rey),
    findall(Perseguidor, persigue(Perseguidor, Rey), Perseguidores),
    length(Perseguidores, 1),
    forall(
        (animal(Animal), Animal \= Rey), adora(Animal, Rey)
    ).