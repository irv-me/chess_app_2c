import "package:chess_app_2c/values/colors.dart";
import "package:flutter/material.dart";

class DeadPiece extends StatelessWidget {
  final String imagePath;
  final bool isWhite;
  const DeadPiece({
    super.key,
    required this.imagePath,
    required this.isWhite,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imagePath,
      color: isWhite ? whiteSquarecolor : blackPiececolor,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.none,
    );
  }
}
