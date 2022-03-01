import 'dart:math';

import 'package:flutter/material.dart';

class BackGround extends StatelessWidget {
  const BackGround({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const boxDecoration = BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.1, 0.8],
            colors: [Color(0xff2E305F), Color(0xff202333)]));
    return Stack(
      children: [
        Container(
          decoration: boxDecoration,
        ),
        const _PinkBox()
      ],
    );
  }
}

class _PinkBox extends StatelessWidget {
  const _PinkBox({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Positioned(
      top: -145,
      left: -72,
      child: Transform.rotate(
        angle: pi - 0.7,
        child: Container(
          height: size.height * 0.6,
          width: size.width * 0.9 + 13,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(60),
              gradient: const LinearGradient(colors: [
                Color.fromRGBO(236, 98, 188, 1),
                Color.fromRGBO(241, 142, 172, 1)
              ])),
        ),
      ),
    );
  }
}
