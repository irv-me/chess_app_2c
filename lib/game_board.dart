import "package:chess_app_2c/components/piece.dart";
import "package:chess_app_2c/components/square.dart";
import "package:chess_app_2c/values/colors.dart";
import "package:flutter/material.dart";
import 'package:chess_app_2c/helper/helper_methods.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {  

  //A two dimensional list representing the chess board
  //with each position possibly containing a chess piece
  late List<List<ChessPiece?>> board;
  @override
  void initState() {
    super.initState();
    _initializeBoard();
  }

  //initialize board
  void _initializeBoard() {
    //Initialize the board with nulls, meaning no pieces in those positions
    List<List<ChessPiece?>> newBoard = List.generate(8, (index) => List.generate(8, (index) => null));
  }

  //Pieces
  ChessPiece myPawn = ChessPiece(type: ChessPieceType.pawn, isWhite: true,  imagePath: 'assets/images/pawn.png',);

  @override
  Widget build(BuildContext context) {  
    return Scaffold(
      backgroundColor: blackSquarecolor,
      body: GridView.builder(
        itemCount: 64,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
       itemBuilder: (context, index) {
        return Square(
          isWhite: isWhite(index),
          piece:myPawn,
          
           );
       },
      )
    );
  }
}