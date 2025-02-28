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

  //the current selected piece on the board, if no piece = null
  ChessPiece? selectedPiece;

  //row index of the selected piece
  //default value
  
  int selectedRow = -1;
  
  //col index of the selected piece
  //default value
  int selectedCol = -1;

  //a list of valid moves for the currently selected piece



  @override
  void initState() {
    super.initState();
    _initializeBoard();
  }

  //initialize board
  void _initializeBoard() {
    //Initialize the board with nulls, meaning no pieces in those positions
    List<List<ChessPiece?>> newBoard =
        List.generate(8, (index) => List.generate(8, (index) => null));

    //Place pawns
    for (int i = 0; i < 8; i++) {
      newBoard[1][i] = ChessPiece(
        type: ChessPieceType.pawn,
        isWhite: false,
        imagePath: 'assets/images/pawn.png',
      );
      newBoard[6][i] = ChessPiece(
        type: ChessPieceType.pawn,
        isWhite: true,
        imagePath: 'assets/images/pawn.png',
      );
    }

    //Place Rooks

    newBoard[0][0] = ChessPiece(type: ChessPieceType.rook, isWhite: false, imagePath: 'assets/images/rook.png');
    newBoard[0][7] = ChessPiece(type: ChessPieceType.rook, isWhite: false, imagePath: 'assets/images/rook.png');
    newBoard[7][0] = ChessPiece(type: ChessPieceType.rook, isWhite: true, imagePath: 'assets/images/rook.png');
    newBoard[7][7] = ChessPiece(type: ChessPieceType.rook, isWhite: true, imagePath: 'assets/images/rook.png');

    //PLace knights
    newBoard[0][1] = ChessPiece(type: ChessPieceType.knight, isWhite: false, imagePath: 'assets/images/knight.png');
    newBoard[0][6] = ChessPiece(type: ChessPieceType.knight, isWhite: false, imagePath: 'assets/images/knight.png');
    newBoard[7][1] = ChessPiece(type: ChessPieceType.knight, isWhite: true, imagePath: 'assets/images/knight.png');
    newBoard[7][6] = ChessPiece(type: ChessPieceType.knight, isWhite: true, imagePath: 'assets/images/knight.png');
    //place bishops
    newBoard[0][2] = ChessPiece(type: ChessPieceType.bishop, isWhite: false, imagePath: 'assets/images/bishop.png');
    newBoard[0][5] = ChessPiece(type: ChessPieceType.bishop, isWhite: false, imagePath: 'assets/images/bishop.png');
    newBoard[7][2] = ChessPiece(type: ChessPieceType.bishop, isWhite: true, imagePath: 'assets/images/bishop.png');
    newBoard[7][5] = ChessPiece(type: ChessPieceType.bishop, isWhite: true, imagePath: 'assets/images/bishop.png');

    //Queen
    newBoard[0][3] = ChessPiece(type: ChessPieceType.queen, isWhite: false, imagePath: 'assets/images/queen.png');
    newBoard[7][3] = ChessPiece(type: ChessPieceType.queen, isWhite: true, imagePath: 'assets/images/queen.png');

    //king
    newBoard[0][4] = ChessPiece(type: ChessPieceType.king, isWhite: false, imagePath: 'assets/images/king.png');
    newBoard[7][4] = ChessPiece(type: ChessPieceType.king, isWhite: true, imagePath: 'assets/images/king.png');


    board = newBoard;
  }

  //user selected piece
  void pieceSelected(int row, int col) {
    setState(() {
      //selected a piece if there is a piece in that position
      if (board[row][col] != null) {
        selectedPiece = board[row][col];
        selectedRow = row;
        selectedCol = col;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: blackSquarecolor,
        body: GridView.builder(
          itemCount: 64,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 8),
          itemBuilder: (context, index) {
            //get the row and the col of this square
            int row  = index ~/ 8;
            int col = index % 8;

            //check if the square is selected
            bool isSelected = selectedRow == row && selectedCol == col;
            return Square(
              isWhite: isWhite(index),
              piece: board[row][col],
              isSelected: isSelected,
              onTap: () => pieceSelected(row, col),
            );
          },
        ));
  }
}
