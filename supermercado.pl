%primeraMarca(Marca) 
primeraMarca(laSerenisima). 
primeraMarca(gallo). 
primeraMarca(vienisima). 
 
%precioUnitario(Producto,Precio) 
%donde Producto puede ser 
%arroz(Marca), 
%lacteo(Marca,TipoDeLacteo), 
%salchicas(Marca,Cantidad) 
precioUnitario(arroz(gallo),25.10). 
precioUnitario(lacteo(laSerenisima,leche), 6.00). 
precioUnitario(lacteo(laSerenisima,crema), 4.00). 
precioUnitario(lacteo(gandara,queso(gouda)), 13.00). 
precioUnitario(lacteo(vacalin,queso(mozzarella)), 12.50). 
precioUnitario(salchichas(vienisima,12), 9.80). 
precioUnitario(salchichas(vienisima, 6), 5.80). 
precioUnitario(salchichas(granjaDelSol, 8), 5.10). 

%descuento(Producto, Descuento) 
descuento(lacteo(laSerenisima,leche), 0.20). 
descuento(lacteo(laSerenisima,crema), 0.70). 
descuento(lacteo(gandara,queso(gouda)), 0.70). 
descuento(lacteo(vacalin,queso(mozzarella)), 0.05). 
 
%compro(Cliente,Producto,Cantidad) 
compro(juan,lacteo(laSerenisima,crema),2). 


% 1 Arroz → descuento fijo de $1.50
descuento(arroz(Marca), 1.5):- 
    precioUnitario(arroz(Marca), _).

% 2) Salchichas → $0.50 de descuento si NO son vienisima
descuento(salchichas(Marca, Cantidad), 0.5) :-
    precioUnitario(salchichas(Marca, Cantidad), _), 
    Marca \= vienisima.

% 3) Lácteos → $2 de descuento si son leche o queso de primera marca

descuento(lacteo(Marca, leche), 2.0):-
precioUnitario(lacteo(Marca,leche), _).

/* descuento(lacteo(_, leche), 2.0). si pongo una marca que no existe me va a decir igual que tiene descuento y esta mal 
/*
descuento(lacteo(Marca, queso(_)), 2.0) :-
    primeraMarca(Marca).
*/
descuento(lacteo(Marca, queso(Tipo)), 2) :-
    precioUnitario(lacteo(Marca, queso(Tipo)),_),
    primeraMarca(Marca). 

% 4) Producto con mayor precio unitario → 5% de descuento

descuento(Producto, Descuento) :-
    precioUnitario(Producto, PrecioMax),
    not( (precioUnitario(_, OtroPrecio), OtroPrecio > PrecioMax) ),
    Descuento is PrecioMax * 0.05.
%con forall 
descuento(Producto, Descuento) :-
    precioUnitario(Producto, PrecioMax),
    forall(
        precioUnitario(_, OtroPrecio),
        PrecioMax >= OtroPrecio
    ),
    Descuento is PrecioMax * 0.05.

/*esta mal, mo me importa producto2 en forall, solo los precios y ademas
estoy calculando el valor del producto, no el descuento en si
aplicarDescuento(Producto,Valor):-
    precioUnitario(Producto, PrecioMayor),
    forall(precioUnitario(Producto2,PrecioMenor),PrecioMayor >= PrecioMenor),
    Valor is PrecioMayor - (PrecioMayor * 5 /100).
*/
/*
Punto 2 otra manera de hacerlo

cliente(Cliente) :-
    compro(Cliente, _, _).

compradorCompulsivo(Cliente) :-
    cliente(Cliente),
    forall(compro(Cliente, Producto, _), primeraMarcaConDescuento(Producto)).

primeraMarcaConDescuento(Producto) :-
    descuento(Producto, _),
    esPrimeraMarca(Producto).

esPrimeraMarca(Producto) :-
    marcaProducto(Producto, Marca),
    primeraMarca(Marca).

marcaProducto(arroz(Marca), Marca).
marcaProducto(lacteo(Marca, _), Marca).
marcaProducto(salchichas(Marca, _), Marca). */

compradorCompulsivo(Cliente) :-
    compro(Cliente, _, _),
    forall(
        (
            precioUnitario(Producto, _),
            productoPrimeraMarca(Producto),
            descuento(Producto, _)
        ),
        compro(Cliente, Producto, _)
    ).

% Extrae la marca y verifica si es primera marca
productoPrimeraMarca(arroz(Marca)) :-
    primeraMarca(Marca).
productoPrimeraMarca(lacteo(Marca, _)) :-
    primeraMarca(Marca).
productoPrimeraMarca(salchichas(Marca, _)) :-
    primeraMarca(Marca).

/*otra manera de hacerlo

totalAPagar(Cliente, Total) :-
    cliente(Cliente),
    findall(Precio, precioFinalCompra(Cliente, Precio), Precios),
    sumlist(Precios, Total).

precioFinalCompra(Cliente, Precio) :-
    compro(Cliente, Producto, Cantidad),
    precioProducto(Producto, PrecioProducto),
    Precio is Cantidad * PrecioProducto.


precioProducto(Producto, Precio) :-
    precioUnitario(Producto, PrecioUnidad),
    descuento(Producto, Descuento),
    Precio is PrecioUnidad - (Descuento * PrecioUnidad).

precioProducto(Producto, PrecioUnidad) :-
    precioUnitario(Producto, PrecioUnidad),
    not(descuento(Producto, _)).*/


totalAPagar(Cliente, Total) :-
    findall(Subtotal,
        (
            compro(Cliente, Producto, Cantidad),
            precioConDescuento(Producto, PrecioFinal),
            Subtotal is PrecioFinal * Cantidad
        ),
        Subtotales),
    sumlist(Subtotales, Total).

% precioConDescuento/2: precio final después de aplicar descuentos
precioConDescuento(Producto, PrecioFinal) :-
    precioUnitario(Producto, PrecioUnitario),
    descuento(Producto, Descuento),
    PrecioFinal is PrecioUnitario - Descuento.

precioConDescuento(Producto, PrecioFinal) :-
    precioUnitario(Producto, PrecioFinal),
    not(descuento(Producto, _)).

/*4) Definir clienteFiel/2 sabiendo que un cliente es fiel
 a la marca X cuando no compra nada de otra marca si también lo vende X.*/
    % Para todo producto comprado con Marca, 
    % no existe compra de mismo tipo con otra marca diferente

clienteFiel(Cliente, Marca) :-
    compro(Cliente, ProductoX, _),
    marcaProducto(ProductoX, Marca),
    forall(
        (
            compro(Cliente, ProductoX, _),
            marcaProducto(ProductoX, Marca)
        ),
        not(
            (
                compro(Cliente, ProductoO, _),
                marcaProducto(ProductoO, OtraMarca),
                OtraMarca \= Marca,
                mismoTipoProducto(ProductoX, ProductoO)
            )
        )
    ).
%version con not
clienteFiel(Cliente, Marca) :-
    compro(Cliente, ProductoX, _),
    marcaProducto(ProductoX, Marca),
    not(
        (
            compro(Cliente, ProductoO, _),
            marcaProducto(ProductoO, OtraMarca),
            OtraMarca \= Marca,
            mismoTipoProducto(ProductoX, ProductoO)
        )
    ).


% extraer la marca de un producto
marcaProducto(arroz(Marca), Marca).
marcaProducto(lacteo(Marca, _), Marca).
marcaProducto(salchichas(Marca, _), Marca).

% verificar si dos productos son del mismo tipo (ignorando marca)
mismoTipoProducto(arroz(_), arroz(_)).
mismoTipoProducto(lacteo(_, Tipo), lacteo(_, Tipo)).
mismoTipoProducto(salchichas(_, Cantidad), salchichas(_, Cantidad)).

dueño(laSerenisima, gandara).
dueño(gandara, vacalín).

/* 5) Definir provee/2 que relaciona una empresa con una lista de todas las cosas que provee ella o alguna de sus
empresas a cargo. Una empresa se considera a cargo de otra si es su dueña o es dueña de una empresa que la
tiene a cargo.

provee(Empresa, Productos) :-
    productoDe(Empresa, _),
    findall(Producto, productoDe(Empresa, Producto), Productos).

productoDe(Empresa, Producto) :-
    producto(Producto),
    proveeLaEmpresa(Producto, Empresa).

proveeLaEmpresa(Producto, Empresa) :-
    marcaProducto(Producto, Empresa).

proveeLaEmpresa(Producto, Empresa) :-
    duenio(Empresa, Marca),
    proveeLaEmpresa(Producto, Marca).
*/

duenio(laSerenisima, gandara).
duenio(gandara, vacalin).

% Relación transitiva de a cargo

aCargoDe(Empresa, Sub) :-
    duenio(Empresa, Sub).
aCargoDe(Empresa, Sub) :-
    duenio(Empresa, Otra),
    aCargoDe(Otra, Sub).

% Una empresa provee un producto si es de su marca o de alguna a su cargo

proveeLaEmpresa(Producto, Empresa) :-
    marcaProducto(Producto, Empresa).
proveeLaEmpresa(Producto, Empresa) :-
    aCargoDe(Empresa, Marca),
    marcaProducto(Producto, Marca).

% Lista de productos que provee la empresa o sus subsidiarias

provee(Empresa, Productos) :-
    proveeLaEmpresa(_, Empresa),
    setof(Producto, proveeLaEmpresa(Producto, Empresa), Productos).