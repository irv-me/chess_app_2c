import "package:chess_app_2c/components/square.dart";
import "package:flutter/material.dart";
import 'package:chess_app_2c/helper/helper_methods.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        itemCount: 64,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
       itemBuilder: (context, index) {
        return Square(isWhite: isWhite(index));
       },
       )
    );
  }
}