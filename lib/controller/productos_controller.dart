import 'package:camp_express/controller/auth_controller.dart';
import 'package:camp_express/domain/orden.dart';
import 'package:camp_express/domain/productos.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class ProductosController extends GetxController {
  AuthController authController = Get.find();
  /*final List<Producto> _producto = <Producto>[
    Producto('0', 'Papas criollas', 7200, "0\$ - 149.0\$", '470 g', 5.0,
        'assets/images/papas.png'),
    Producto('1', 'Mazorca', 6800, '150.0\$ - 499.0\$', '2 und', 3.5,
        'assets/images/maiz.png'),
    Producto('2', 'Patilla', 7497, '500.0\$ - 1500.0\$', '1 und', 2.5,
        'assets/images/sandia.png'),
    Producto('3', 'Arroz', 9600, '500.0\$ - 1500.0\$', '3000 g', 4.0,
        'assets/images/arroz.png'),
    Producto('4', 'Tomate', 7800, '500.0\$ - 1500.0\$', '1 kg', 3.5,
        'assets/images/tomate.png')
  ].obs;*/
  final List<Producto> _producto = <Producto>[].obs;
  final List<String> _productoPos = <String>[].obs;
  final List<Producto> _favoritos = <Producto>[].obs;
  final List<String> _productoPosFav = <String>[].obs;
  final List<Producto> _carrito = <Producto>[].obs;
  late final RxDouble _total = 0.0.obs;
  final List<Orden> _ordenes = <Orden>[].obs;

  List<Producto> get producto => _producto;
  List<String> get productoPos => _productoPos;
  List<Producto> get favoritos => _favoritos;
  List<String> get productoPosFav => _productoPosFav;
  List<Producto> get carrito => _carrito;
  double get total => _total.value;
  List<Orden> get ordenes => _ordenes;
  void addProduct() {
    List<dynamic> postList = [];
    List<String> keyList = [];
    //Referenciar la base de datos
    DatabaseReference postsRef = FirebaseDatabase.instance.ref('Productos');
    //Escuchar y obtener los valores del Realtime Database
    postsRef.onValue.listen((DatabaseEvent event) {
      //productosController.reiniciar();
      var data = event.snapshot.value;
      if (data != null) {
        Map<String, dynamic>.from(data as dynamic).forEach((key, value) {
          keyList.add(key);
          postList.add(value);
        });
      }
      _producto.clear();
      //_favoritos.clear();
      for (var i = 0; i < postList.length; i++) {
        _producto.add(
          Producto(
            postList[i]['key'].toString(),
            postList[i]['product'].toString(),
            double.parse(postList[i]['price']),
            "0\$ - 149.0\$",
            postList[i]['quantity'].toString(),
            5.0,
            postList[i]['image'].toString(),
            postList[i]['favorito'] == 'false' ? false : true,
            postList[i]['email'].toString(),
          ),
        );
        _productoPos.add(keyList[i]);
        /* if (postList[i]['favorito'] == 'true') {
          _favoritos.add(
            Producto(
              postList[i]['key'].toString(),
              postList[i]['product'].toString(),
              double.parse(postList[i]['price']),
              "0\$ - 149.0\$",
              postList[i]['quantity'].toString(),
              5.0,
              postList[i]['image'].toString(),
              true,
              postList[i]['email'].toString(),
            ),
          );
        }*/
      }
      keyList = [];
      postList = [];
    });
  }

  void addFavProduct() {
    List<dynamic> favList = [];
    List<String> favkeyList = [];
    //Referenciar la base de datos
    DatabaseReference favRef = FirebaseDatabase.instance.ref('Favoritos');
    favRef.onValue.listen((DatabaseEvent event) {
      var data = event.snapshot.value;
      if (data != null) {
        Map<String, dynamic>.from(data as dynamic).forEach((key, value) {
          favkeyList.add(key);
          favList.add(value);
        });
      }
      _favoritos.clear();
      for (var i = 0; i < favList.length; i++) {
        if (favList[i]['email'] == authController.userEmail()) {
          _favoritos.add(
            Producto(
              favList[i]['key'].toString(),
              favList[i]['product'].toString(),
              double.parse(favList[i]['price'].toString()),
              "0\$ - 149.0\$",
              favList[i]['quantity'].toString(),
              5.0,
              favList[i]['image'].toString(),
              true,
              favList[i]['email'].toString(),
            ),
          );
          print('Entroooooooo1');
          _productoPosFav.add(favkeyList[i]);
        }
      }
      favkeyList = [];
      favList = [];
    });
  }

  //Marcar si un producto se encuentra en favoritos y guardar en una lista de favoritos
  ajustarFavorito(String id) {
    var producto = _producto.firstWhere((element) => element.id == id);
    var indice = _producto.indexWhere((element) => element.id == id);
    var referencia = FirebaseDatabase.instance
        .ref()
        .child('Productos')
        .child(productoPos[indice]);
    var ref = FirebaseDatabase.instance.ref('Favoritos');
    if (producto.favorito == false) {
      producto.favorito = true;
      _favoritos.add(producto);
      //Modificar favorito en base de datos
      var data = {'favorito': 'true'};
      referencia.update(data);

      //Añadir el producto en la coleccion Favoritos
      var data2 = {
        'key': producto.id,
        'image': producto.image,
        'product': producto.nombre,
        'price': producto.precio,
        'quantity': producto.cantidad,
        'email': authController.userEmail(),
      };
      ref.push().set(data2);
    } else {
      producto.favorito = false;
      var indice2 = _favoritos.indexWhere((element) => element.id == id);
      _favoritos.removeAt(indice2);
      //Modificar favorito en base de datos
      var data = {'favorito': 'false'};
      //Modificar favorito en base de datos
      referencia.update(data);
      //Eliminar el producto en la coleccion Favoritos
      ref.child(_productoPosFav[indice2]).remove();
    }
    _producto.fillRange(indice, indice + 1, producto);
  }

  //Si el producto está en favorito esto devuelve true o false para que el ícono de corazón se rellene o no
  obtenerFavorito(String id) {
    var producto = _producto.firstWhere((element) => element.id == id);
    return producto.favorito;
  }

//Marcar si un producto está en el carrito y guardarlo en una lista del carrito
  agregarCarrito(String id) {
    var producto = _producto.firstWhere((element) => element.id == id);
    var indice = _producto.indexWhere((element) => element.id == id);
    if (producto.cesta == false) {
      producto.cesta = true;
      _carrito.add(producto);
    } else {
      producto.cesta = false;
      producto.cantidadCarrito = 0;
      var indice3 = _carrito.indexWhere((element) => element.id == id);
      _carrito.removeAt(indice3);
      _total.value = _total.value - producto.subtotal;
      producto.subtotal = 0;
    }
    _producto.fillRange(indice, indice + 1, producto);
  }

//Si el producto está en el carrito, el botón de agregar al carrito cambiará a rojo o verde dependiendo
  estadoCarrito(String id) {
    var producto = _producto.firstWhere((element) => element.id == id);
    return producto.cesta;
  }

//Eliminar todos los productos de la lista del carrito
  vaciarCarrito() {
    _carrito.removeRange(0, _carrito.length);
    for (var i = 0; i < _producto.length; i++) {
      _producto.elementAt(i).cesta = false;
      _producto.elementAt(i).cantidadCarrito = 0;
      _producto.elementAt(i).subtotal = 0.0;
      _producto.fillRange(i, i + 1, _producto.elementAt(i));
    }
    _total.value = 0.0;
  }

//Aumentar la cantidad del producto al carrito
  addCantidad(String id) {
    var _actualizar = _producto.firstWhere((element) => element.id == id);
    var indice = _producto.indexWhere((element) => element.id == id);
    if (_actualizar.cantidadCarrito < 50) {
      _actualizar.cantidadCarrito += 1;
      _producto.fillRange(indice, indice + 1, _actualizar);
      suma(_actualizar.precio);
      subtotal(id);
    }
  }

//Disminuir la cantidad del producto al carrito
  resCantidad(String id) {
    var _actualizar = _producto.firstWhere((element) => element.id == id);
    var indice = _producto.indexWhere((element) => element.id == id);
    if (_actualizar.cantidadCarrito > 0) {
      _actualizar.cantidadCarrito -= 1;
      _producto.fillRange(indice, indice + 1, _actualizar);
      resta(_actualizar.precio);
      subtotal(id);
    }
  }

  int cantidadCarrito(String id) {
    var cant = _producto.firstWhere((element) => element.id == id);
    return cant.cantidadCarrito;
  }

//Sumar al precio total a pagar
  suma(double x) {
    _total.value = _total.value + x;
  }

//Restar al precio total a pagar
  resta(double x) {
    _total.value = _total.value - x;
  }

//Obtener el subtotal generado por la cantidad de un producto
  subtotal(String id) {
    var producto = _producto.firstWhere((element) => element.id == id);
    var indice = _producto.indexWhere((element) => element.id == id);
    producto.subtotal = producto.cantidadCarrito * producto.precio;
    _producto.fillRange(indice, indice + 1, producto);
  }

  double obtenerSubtotal(String id) {
    var producto = _producto.firstWhere((element) => element.id == id);
    return producto.subtotal;
  }

//Agrega el total con el tiempo que se compró, además con los productos y sus cantidades, por último los precios a una lista de ordenes
  agregarOrden(DateTime date) {
    List productos = [];
    List<String> cantidades = [];
    List precios = [];
    for (var i = 0; i < _carrito.length; i++) {
      productos.add(_carrito.elementAt(i).nombre);
      var unir = _carrito.elementAt(i).cantidadCarrito.toString() + 'x';
      cantidades.add(unir);
      precios.add(_carrito.elementAt(i).precio);
    }
    _ordenes.add(Orden(_total.value, date, productos, cantidades, precios));
  }
}
