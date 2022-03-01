import 'package:flutter/material.dart';
import 'package:massive_messages/widgets/background.dart';

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
            children: const [_CustomTitles()],
          ),
        )
      ]),
    );
  }
}

class _CustomTitles extends StatelessWidget {
  const _CustomTitles({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Classify transaction',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
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
