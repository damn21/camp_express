import 'package:camp_express/controller/auth_controller.dart';
import 'package:camp_express/screens/home/help/ayuda.dart';
import 'package:camp_express/screens/home/sell/vendido.dart';
import 'package:camp_express/screens/home/sell/venta.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/login_controller.dart';

Widget menuLateral(Size size) {
  LoginController loginController = Get.find();
  return Drawer(
    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
    child: Column(
      children: <Widget>[
        AppBar(
          elevation: 0,
          title: Image.asset(
            'assets/images/logo.png',
            height: size.height * 0.07,
            width: size.width * 0.35,
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.sell_outlined,
              color: Color.fromARGB(255, 78, 160, 62)),
          title: const Text(
            'Vender',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 78, 160, 62)),
          ),
          tileColor: Colors.white.withOpacity(0.7),
          onTap: () {
            Get.to(() => const Venta());
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.local_shipping,
              color: Color.fromARGB(255, 78, 160, 62)),
          title: const Text(
            'Productos vendidos',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 78, 160, 62)),
          ),
          tileColor: Colors.white.withOpacity(0.7),
          onTap: () {
            Get.to(() => const Vendido());
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.help_outline_outlined,
              color: Color.fromARGB(255, 78, 160, 62)),
          title: const Text(
            'Ayuda',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 78, 160, 62)),
          ),
          tileColor: Colors.white.withOpacity(0.7),
          onTap: () {
            Get.to(() => const Ayuda());
          },
        ),
        const Divider(),
        ListTile(
          key: const Key('cerrar_sesion'),
          leading: const Icon(Icons.exit_to_app,
              color: Color.fromARGB(255, 78, 160, 62)),
          title: const Text(
            'Cerrar sesión',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 78, 160, 62)),
          ),
          tileColor: Colors.white.withOpacity(0.7),
          onTap: () async {
            // loginController.cerrarSesion();
            AuthController authController = Get.find();
            await authController.logOut();
          },
        ),
        const Divider(),
      ],
    ),
  );
}
