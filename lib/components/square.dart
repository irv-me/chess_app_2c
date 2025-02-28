import "package:chess_app_2c/components/piece.dart";
import "package:chess_app_2c/values/colors.dart";
import "package:flutter/material.dart";

class Square extends StatelessWidget {
  final bool isWhite;
  final ChessPiece? piece;

  const Square({super.key, required this.isWhite, required this.piece});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isWhite ? whiteSquarecolor : blackSquarecolor,
      child: piece != null ? Image.asset(
        piece!.imagePath,
        color: piece!.isWhite ? Colors.white: Colors.black,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.none) : null
      
    );
  }
}