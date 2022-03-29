import 'package:flutter/material.dart';

Padding buildButton(Size size, String texto) {
  return Padding(
    padding: EdgeInsets.only(
      top: size.height * 0.8,
      right: size.width * 0.03,
      left: size.width * 0.08,
    ),
    child: SizedBox(
      height: size.height * 0.08,
      width: size.width * 0.75,
      child: InkWell(
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              15,
            ),
            color: const Color.fromARGB(255, 78, 160, 62),
          ),
          child: Align(
            child: Text(
              texto,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
