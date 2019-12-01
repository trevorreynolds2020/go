import 'package:flutter/material.dart';
import 'home_page.dart';

class CurrentMove extends StatelessWidget {
  @override
  String player;

  CurrentMove(this.player);

  Widget build(BuildContext context) {
    return Container(child: Text("Current move: "+player),);
  }
}
