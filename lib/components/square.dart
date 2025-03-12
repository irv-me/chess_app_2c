import "package:chess_app_2c/components/piece.dart";
import "package:chess_app_2c/values/colors.dart";
import "package:flutter/material.dart";

class Square extends StatelessWidget {
  final bool isWhite;
  final ChessPiece? piece;
  final bool isSelected;
  final bool isValidMove;
  final void Function()? onTap;

  const Square(
      {super.key,
      required this.isWhite,
      required this.piece,
      required this.isSelected,
      required this.onTap,
      required this.isValidMove});

  @override
  Widget build(BuildContext context) {
    Color? squareColor;

 //if selected, square new color
  if (isSelected) {
    squareColor = selectedSquarecolor;
  } else if (isValidMove) {
    squareColor = validMoveSquarecolor;
  } else {
    squareColor = isWhite ? whiteSquarecolor : blackSquarecolor;
  }

  return GestureDetector(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
        color: squareColor,
        border: Border.all(color: squareColor, width: 0), // Remove border
      ),
      child: piece != null
          ? Image.asset(
              piece!.imagePath,
              color: piece!.isWhite ? whitePiececolor : blackPiececolor,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.none,
            )
          : null,
    ),
  );
}
}