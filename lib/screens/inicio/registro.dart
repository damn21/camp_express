import 'package:camp_express/widgets/inicio/input.dart';
import 'package:camp_express/widgets/inicio/contrasena.dart';
import 'package:camp_express/widgets/inicio/confirmar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/login_controller.dart';
import '../../widgets/inicio/confirmar.dart';

class Registro extends StatelessWidget {
  const Registro({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LoginController loginController = Get.find();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromARGB(255, 215, 233, 167),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(top: 50.0, bottom: 45),
                    child: const Image(
                        image: AssetImage('assets/images/logo.png')),
                  )
                ]),
            Form(
              child: Container(
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 78, 160, 62),
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                height: 605,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(50.0, 36.0, 50, 0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          const Text(
                            'Registro',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Raleway',
                              fontSize: 30.0,
                              color: Colors.white,
                            ),
                          ),
                          //Textfield del correo
                          const Campo(),
                          //Textfield de la contraseña
                          const Contrasena(),
                          //Textfield de confirmar contraseña
                          const Confirmar(),
                          Container(
                            padding: const EdgeInsets.only(top: 45),
                            child: ElevatedButton(
                                key: const Key('boton_registro'),
                                onPressed: () {
                                  loginController.crearUsuario(
                                      loginController.campo,
                                      loginController.contrasena,
                                      loginController.confirmarContrasena);
                                },
                                style: ElevatedButton.styleFrom(
                                    primary: const Color.fromARGB(
                                        255, 215, 233, 167),
                                    fixedSize: const Size(314.0, 70.0),
                                    onPrimary:
                                        const Color.fromARGB(255, 78, 160, 62),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 22),
                                    textStyle: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700)),
                                child: const Text('Registrarme')),
                          ),
                          Container(
                              alignment: Alignment.center,
                              child: TextButton(
                                child: const Text(
                                  'Iniciar sesión',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17.0,
                                      decoration: TextDecoration.underline),
                                ),
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                      context, "login");
                                },
                              )),
                          Container(
                            alignment: Alignment.centerRight,
                            child: Obx(() => Text(loginController.mensaje2,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 15.0,
                                ))),
                          )
                        ],
                      ),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
