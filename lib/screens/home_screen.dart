import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:massive_messages/providers/user_provider.dart';
import 'package:massive_messages/widgets/background.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        const BackGround(),
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: const [_CustomTitles(), _CustomTable()],
          ),
        )
      ]),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        iconSize: 27,
        selectedItemColor: const Color.fromRGBO(215, 110, 148, 1),
        unselectedItemColor: const Color.fromRGBO(102, 104, 140, 1),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_view_day), label: 'hola'),
          BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'hola'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'hola'),
        ],
        backgroundColor: const Color.fromRGBO(47, 50, 74, 1),
      ),
    );
  }
}

class _CustomTable extends StatelessWidget {
  const _CustomTable({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Table(
      children: const [
        TableRow(children: [
          _CustomCardContainer(
            icon: Icons.pie_chart,
            color: Colors.lightBlue,
            text: 'General',
          ),
          _CustomCardContainer(
            icon: Icons.bus_alert,
            color: Color.fromARGB(255, 165, 89, 179),
            text: 'Transport',
          )
        ]),
        TableRow(children: [
          _CustomCardContainer(
            icon: Icons.shopping_bag,
            color: Color.fromARGB(255, 189, 93, 192),
            text: 'Shopping',
          ),
          _CustomCardContainer(
            icon: Icons.money,
            color: Color.fromARGB(255, 212, 149, 55),
            text: 'Bills',
          )
        ]),
        TableRow(children: [
          _CustomCardContainer(
            icon: Icons.movie_creation,
            color: Colors.blue,
            text: 'Entertaiment',
          ),
          _CustomCardContainer(
            icon: Icons.local_grocery_store,
            color: Colors.lightGreen,
            text: 'Grocery',
          )
        ]),
      ],
    );
  }
}

class _CustomCardContainer extends StatelessWidget {
  const _CustomCardContainer({
    Key? key,
    required this.icon,
    required this.color,
    required this.text,
  }) : super(key: key);
  final IconData icon;
  final Color color;
  final String text;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('messages');
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: Container(
              height: size.height * 0.2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: const Color.fromRGBO(62, 66, 107, 0.7),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: color,
                    radius: 35,
                    child: Icon(
                      icon,
                      color: Colors.white.withOpacity(0.7),
                      size: 30,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    text,
                    style: TextStyle(color: color),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CustomTitles extends StatelessWidget {
  const _CustomTitles({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return SafeArea(
        child: Container(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bienvenido  ${userProvider.user != null ? userProvider.user['fullName'] : 'sin nombre'}',
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            'Classify this transaction into a particular category',
            maxLines: 2,
            softWrap: false,
            style: TextStyle(fontSize: 14, color: Colors.white),
          )
        ],
      ),
    ));
  }
}
