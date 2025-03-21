import "package:chess_app_2c/components/dead_piece.dart";
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
  List<List<int>> validMoves = [];

  //a list of white pieces that have been taken by the black player
  List<ChessPiece> whitePiecesTaken = [];

  //a list of black pieces that have been taken by the white player
  List<ChessPiece> blackPiecesTaken = [];

  //a booleon to indicate whos turn it is
  bool isWhiteTurn = true;

  //initial position of kings
  List<int> whiteKingPosition = [7, 4];
  List<int> blackKingPosition = [0, 4];
  bool checkStatus = false;
 //bool pieces
  bool whiteKingMoved = false;
  bool blackKingMoved = false;
  bool whiteRookAMoved = false;
  bool whiteRookHMoved = false;
  bool blackRookAMoved = false;
  bool blackRookHMoved = false;

  //castling bools
  bool whiteCastlingAAvailable = false;
  bool blackCastlingAAvailable = false;
  bool whiteCastlingHAvailable = false;
  bool blackCastlingHAvailable = false;



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

    newBoard[0][0] = ChessPiece(
        type: ChessPieceType.rook,
        isWhite: false,
        imagePath: 'assets/images/rook.png');
    newBoard[0][7] = ChessPiece(
        type: ChessPieceType.rook,
        isWhite: false,
        imagePath: 'assets/images/rook.png');
    newBoard[7][0] = ChessPiece(
        type: ChessPieceType.rook,
        isWhite: true,
        imagePath: 'assets/images/rook.png');
    newBoard[7][7] = ChessPiece(
        type: ChessPieceType.rook,
        isWhite: true,
        imagePath: 'assets/images/rook.png');

    //PLace knights
    newBoard[0][1] = ChessPiece(
        type: ChessPieceType.knight,
        isWhite: false,
        imagePath: 'assets/images/knight.png');
    newBoard[0][6] = ChessPiece(
        type: ChessPieceType.knight,
        isWhite: false,
        imagePath: 'assets/images/knight.png');
    newBoard[7][1] = ChessPiece(
        type: ChessPieceType.knight,
        isWhite: true,
        imagePath: 'assets/images/knight.png');
    newBoard[7][6] = ChessPiece(
        type: ChessPieceType.knight,
        isWhite: true,
        imagePath: 'assets/images/knight.png');
    //place bishops
    newBoard[0][2] = ChessPiece(
        type: ChessPieceType.bishop,
        isWhite: false,
        imagePath: 'assets/images/bishop.png');
    newBoard[0][5] = ChessPiece(
        type: ChessPieceType.bishop,
        isWhite: false,
        imagePath: 'assets/images/bishop.png');
    newBoard[7][2] = ChessPiece(
        type: ChessPieceType.bishop,
        isWhite: true,
        imagePath: 'assets/images/bishop.png');
    newBoard[7][5] = ChessPiece(
        type: ChessPieceType.bishop,
        isWhite: true,
        imagePath: 'assets/images/bishop.png');

    //Queen
    newBoard[0][3] = ChessPiece(
        type: ChessPieceType.queen,
        isWhite: false,
        imagePath: 'assets/images/queen.png');
    newBoard[7][3] = ChessPiece(
        type: ChessPieceType.queen,
        isWhite: true,
        imagePath: 'assets/images/queen.png');

    //king
    newBoard[0][4] = ChessPiece(
        type: ChessPieceType.king,
        isWhite: false,
        imagePath: 'assets/images/king.png');
    newBoard[7][4] = ChessPiece(
        type: ChessPieceType.king,
        isWhite: true,
        imagePath: 'assets/images/king.png');

    board = newBoard;
  }

  //USER SELECTED PIECE
  void pieceSelected(int row, int col) {
    setState(() {
      //no piece has been selected yet, this is the first selection
      if (selectedPiece == null && board[row][col] != null) {
        if (board[row][col]!.isWhite == isWhiteTurn) {
          selectedPiece = board[row][col];
          selectedRow = row;
          selectedCol = col;
        }
      }

      //there is a piece already selected, user is selecting another of their pieces
      else if (board[row][col] != null &&
          board[row][col]!.isWhite == selectedPiece!.isWhite) {
        selectedPiece = board[row][col];
        selectedRow = row;
        selectedCol = col;
      }

      //if there is a piece selected and user taps on a square that is a valid move, move there
      else if (selectedPiece != null &&
          validMoves.any((element) => element[0] == row && element[1] == col)) {
        movePiece(row, col);
      }

      //If a piece is selected, calculate it's valid moves
      validMoves = calculatedRealValidMoves(
          selectedRow, selectedCol, selectedPiece, true);
    });
  }

  // CALCULATE RAW VALID MOVES
  List<List<int>> calculatedRawValidMoves(int row, int col, ChessPiece? piece) {
    List<List<int>> candidateMoves = [];

    if (piece == null) {
      return [];
    }

    //different directions based on their color
    int direction = piece.isWhite ? -1 : 1;

    switch (piece.type) {
      case ChessPieceType.pawn:
        //pawn can move forward if square is not occupied
        if (isInBoard(row + direction, col) &&
            board[row + direction][col] == null) {
          candidateMoves.add([row + direction, col]);
        }
        //pawn can move 2 squares forward if they are at their initial potition
        if ((row == 1 && !piece.isWhite) || (row == 6 && piece.isWhite)) {
          if (isInBoard(row + 2 * direction, col) &&
              board[row + 2 * direction][col] == null &&
              board[row + direction][col] == null) {
            candidateMoves.add([row + 2 * direction, col]);
          }
        }
        //pawn can capture diagonally

        if (isInBoard(row + direction, col - 1) &&
            board[row + direction][col - 1] != null &&
            board[row + direction][col - 1]!.isWhite != piece.isWhite) {
          candidateMoves.add([row + direction, col - 1]);
        }

        if (isInBoard(row + direction, col + 1) &&
            board[row + direction][col + 1] != null &&
            board[row + direction][col + 1]!.isWhite != piece.isWhite) {
          candidateMoves.add([row + direction, col + 1]);
        }

        //pawn can "En passant" allows a pawn to capture an adjacent enemy pawn that has just moved two squares forward, as if it had only moved one square. this can only be done the turn after
        if (lastDoubleMovePawnPosition != null) {
        int lastRow = lastDoubleMovePawnPosition![0];
        int lastCol = lastDoubleMovePawnPosition![1];
        if ((row == lastRow) && (col - 1 == lastCol || col + 1 == lastCol)) {
          if (board[lastRow][lastCol]!.type == ChessPieceType.pawn &&
              board[lastRow][lastCol]!.isWhite != piece.isWhite) {
            candidateMoves.add([row + direction, lastCol]);
          }
        }
      }
        //pawns can promote to any other piece when they reach the other side of the board
        //this is handled in movePiece function

        break;
      case ChessPieceType.rook:
        //horizontal and vertical directions
        var directions = [
          [-1, 0], //up
          [1, 0], //down
          [0, -1], //left
          [0, 1], //right
        ];

        for (var direction in directions) {
          var i = 1;
          while (true) {
            var newRow = row + i * direction[0];
            var newCol = col + i * direction[1];
            if (!isInBoard(newRow, newCol)) {
              break;
            }
            if (board[newRow][newCol] != null) {
              if (board[newRow][newCol]!.isWhite != piece.isWhite) {
                candidateMoves.add([newRow, newCol]); //kill
              }
              break; //blocked
            }
            candidateMoves.add([newRow, newCol]);
            i++;
          }
        }

        break;
      case ChessPieceType.knight:
        var knightMoves = [
          [-2, -1],
          [-2, 1],
          [-1, -2],
          [-1, 2],
          [2, -1],
          [2, 1],
          [1, -2],
          [1, 2],
        ];

        for (var move in knightMoves) {
          var newRow = row + move[0];
          var newCol = col + move[1];
          if (!isInBoard(newRow, newCol)) {
            continue;
          }
          if (board[newRow][newCol] != null) {
            if (board[newRow][newCol]!.isWhite != piece.isWhite) {
              candidateMoves.add([newRow, newCol]); //kill
            }
            continue;
          }
          candidateMoves.add([newRow, newCol]);
        }
        break;
      case ChessPieceType.bishop:
        var directions = [
          [-1, -1], //up left
          [-1, 1], //up right
          [1, -1], //down left
          [1, 1], //down right
        ];

        for (var direction in directions) {
          var i = 1;
          while (true) {
            var newRow = row + i * direction[0];
            var newCol = col + i * direction[1];
            if (!isInBoard(newRow, newCol)) {
              break;
            }
            if (board[newRow][newCol] != null) {
              if (board[newRow][newCol]!.isWhite != piece.isWhite) {
                candidateMoves.add([newRow, newCol]); //kill
              }
              break; //blocked
            }
            candidateMoves.add([newRow, newCol]);
            i++;
          }
        }
        break;
      case ChessPieceType.queen:
        // rook and bishop into 1 piece
        var directions = [
          [-1, 0], //up
          [1, 0], //down
          [0, -1], //left
          [0, 1], //right
          [-1, -1], //up left
          [-1, 1], //up right
          [1, -1], //down left
          [1, 1], //down right
        ];
        for (var direction in directions) {
          var i = 1;
          while (true) {
            var newRow = row + i * direction[0];
            var newCol = col + i * direction[1];
            if (!isInBoard(newRow, newCol)) {
              break;
            }
            if (board[newRow][newCol] != null) {
              if (board[newRow][newCol]!.isWhite != piece.isWhite) {
                candidateMoves.add([newRow, newCol]); //kill
              }
              break; //blocked
            }
            candidateMoves.add([newRow, newCol]);
            i++;
          }
        }
        break;
      case ChessPieceType.king:
        //all directions 1 step
        var directions = [
          [-1, 0], //up
          [1, 0], //down
          [0, -1], //left
          [0, 1], //right
          [-1, -1], //up left
          [-1, 1], //up right
          [1, -1], //down left
          [1, 1], //down right
        ];
        for (var direction in directions) {
          var newRow = row + direction[0];
          var newCol = col + direction[1];
          if (!isInBoard(newRow, newCol)) {
            continue;
          }
          if (board[newRow][newCol] != null) {
            if (board[newRow][newCol]!.isWhite != piece.isWhite) {
              candidateMoves.add([newRow, newCol]); //kill
            }
            continue; //blocked
          }
          candidateMoves.add([newRow, newCol]);
        }
        //TODO castling
        if (piece.isWhite) {
          if (!whiteKingMoved && !whiteRookAMoved) {
            if (board[7][1] == null && board[7][2] == null && board[7][3] == null) {
              whiteCastlingAAvailable = true;
            }
            else {
              whiteCastlingAAvailable = false;
            }
          }
          if (!whiteKingMoved && !whiteRookHMoved) {
            if (board[7][5] == null && board[7][6] == null) {
              whiteCastlingHAvailable = true;
            }
            else {
              whiteCastlingHAvailable = false;
            }
          }
          if (!blackKingMoved && !blackRookAMoved) {
            if (board[0][1] == null && board[0][2] == null && board[0][3] == null) {
              blackCastlingAAvailable = true;
            }
            else {
              blackCastlingAAvailable = false;
            }
          }
          if (!blackKingMoved && !blackRookHMoved) {
            if (board[0][5] == null && board[0][6] == null) {
              blackCastlingHAvailable = true;
            }
            else {
              blackCastlingHAvailable = false;
            }
          }

        
        }

        break;
    }

    return candidateMoves;
  }

  // CALCULATE REAL VALID MOVES
  List<List<int>> calculatedRealValidMoves(
      int row, int col, ChessPiece? piece, bool checkSimulation) {
    List<List<int>> realValidMoves = [];
    List<List<int>> candidateMoves = calculatedRawValidMoves(row, col, piece);

    //after generating all candidate moves, filter out any that would result in a check
    if (checkSimulation) {
      for (var move in candidateMoves) {
        int endRow = move[0];
        int endCol = move[1];

        //this will simulate the future move to see if its
        if (simulatedMoveIsSafe(piece!, row, col, endRow, endCol)) {
          realValidMoves.add(move);
        }
      }
    } else {
      realValidMoves = candidateMoves;
    }
    return realValidMoves;
  }

  // MOVE PIECE
  void movePiece(int newRow, int newCol) {
    //CLEAR THE LAST DOUBLE MOVED PAWN POSITION
    if (!pawnDoubleMoved) {
      lastDoubleMovePawnPosition = null;
      }
      pawnDoubleMoved = false;
    
    //if the new spot has an enemy piece
    if (board[newRow][newCol] != null) {
      //add the captured piece to the appropiate list
      var capturedPiece = board[newRow][newCol];
      if (capturedPiece!.isWhite) {
        whitePiecesTaken.add(capturedPiece);
      } else {
        blackPiecesTaken.add(capturedPiece);
      }
      } else if (selectedPiece!.type == ChessPieceType.pawn && lastDoubleMovePawnPosition != null) {
    // Handle en passant capture
    int lastRow = lastDoubleMovePawnPosition![0];
    int lastCol = lastDoubleMovePawnPosition![1];
    if (selectedRow == lastRow && newCol == lastCol && (newRow - lastRow).abs() == 1) {
      var capturedPiece = board[lastRow][lastCol];
      if (capturedPiece!.isWhite) {
        whitePiecesTaken.add(capturedPiece);
      } else {
        blackPiecesTaken.add(capturedPiece);
      }
      board[lastRow][lastCol] = null;
    }
  }

   


    //check if the piece being moves is a king
    if (selectedPiece!.type == ChessPieceType.king) {
      //update the king's position
      if (selectedPiece!.isWhite) {
        whiteKingMoved = true;
        whiteKingPosition = [newRow, newCol];
        whiteCastlingAAvailable = false;
        whiteCastlingHAvailable = false;
      } else {
        blackKingMoved = true;
        blackKingPosition = [newRow, newCol];
        blackCastlingAAvailable = false;
        blackCastlingHAvailable = false;
      }
    }
  
    

    //check if the piece being moved is a rook
    if (selectedPiece!.type == ChessPieceType.rook) {
      //update the rook's position
      if (selectedPiece!.isWhite) {
        if (selectedRow == 7 && selectedCol == 0) {
          whiteRookAMoved = true;
        } else if (selectedRow == 7 && selectedCol == 7) {
          whiteRookHMoved = true;
        }
      } else {
        if (selectedRow == 0 && selectedCol == 0) {
          blackRookAMoved = true;
        } else if (selectedRow == 0 && selectedCol == 7) {
          blackRookHMoved = true;
        }
      }
    }
    

    //move the piece to the new position and clear the old spot
    board[newRow][newCol] = selectedPiece;
    board[selectedRow][selectedCol] = null;

    //check if piece double moved (actually not)
    if (selectedPiece!.type == ChessPieceType.pawn && (newRow - selectedRow).abs() == 2) {
      pawnJustdoubleMoved(newRow,newCol);
    }

    //check if the piece being moved is a pawn
    if (selectedPiece!.type == ChessPieceType.pawn &&
        (newRow == 0 || newRow == 7)) {
      showPromotionDialog(newRow, newCol);
    }

    //see if any kings are under attack
    if (isKingInCheck(!isWhiteTurn)) {
      checkStatus = true;
    } else {
      checkStatus = false;
    }

    //clear selection
    setState(() {
      selectedPiece = null;
      selectedRow = -1;
      selectedCol = -1;
      validMoves = [];
    });
    //check if it's checkmate
    if (isCheckMate(!isWhiteTurn)) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text('Checkmate!'),
                content: Text(isWhiteTurn ? 'Black wins!' : 'White wins!'),
                actions: [
                  TextButton(
                    onPressed: resetGame,
                    child: const Text("Play again"),
                  )
                ],
              ));
    }
    //change turns
    isWhiteTurn = !isWhiteTurn;
  }

  void showPromotionDialog(int row, int col) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Promote Pawn'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Queen'),
              onTap: () {
                promotePawn(row, col, ChessPieceType.queen);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Rook'),
              onTap: () {
                promotePawn(row, col, ChessPieceType.rook);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Bishop'),
              onTap: () {
                promotePawn(row, col, ChessPieceType.bishop);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Knight'),
              onTap: () {
                promotePawn(row, col, ChessPieceType.knight);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    },
  );
}
 List<int>? lastDoubleMovePawnPosition;
  // bool to track if pawn just doublemoved to clear it after the next turn
  bool pawnDoubleMoved = false;

  void pawnJustdoubleMoved(row,col) {
    lastDoubleMovePawnPosition = [row,col];
    pawnDoubleMoved = true;
  }

  void promotePawn(int row, int col, ChessPieceType newType) {
  setState(() {
    board[row][col] = ChessPiece(
      type: newType,
      isWhite: board[row][col]!.isWhite,
      imagePath: 'assets/images/${newType.toString().split('.').last}.png',
    );

    // Clear selection
    selectedPiece = null;
    selectedRow = -1;
    selectedCol = -1;
    validMoves = [];
  });
  }

  //IS KING IN CHECK?
  bool isKingInCheck(bool isWhiteKing) {
    //get king pos
    List<int> kingPosition =
        isWhiteKing ? whiteKingPosition : blackKingPosition;

    //check if any enemy piece can attack the king
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        //skipcempty squares and pieces of the same color as the king
        if (board[i][j] == null || board[i][j]!.isWhite == isWhiteKing) {
          continue;
        }
        List<List<int>> pieceValidMoves =
            calculatedRealValidMoves(i, j, board[i][j], false);
        //check if the king's position is in the valid moves of the enemy piece
        if (pieceValidMoves.any((move) =>
            move[0] == kingPosition[0] && move[1] == kingPosition[1])) {
          return true;
        }
      }
    }
    return false;
  }

  //SIMULATED A FUTURE MOVE TO SEE IF SAFE
  bool simulatedMoveIsSafe(
      ChessPiece piece, int startRow, int startCol, int endRow, int endCol) {
    //save the current board state
    ChessPiece? originalDestinationPiece = board[endRow][endCol];

    //if the piece is the king, save its current position and update the next one
    List<int>? originalKingPosition;
    if (piece.type == ChessPieceType.king) {
      originalKingPosition =
          piece.isWhite ? whiteKingPosition : blackKingPosition;

      //update the king position
      if (piece.isWhite) {
        whiteKingPosition = [endRow, endCol];
      } else {
        blackKingPosition = [endRow, endCol];
      }
    }
    //simulate the move
    board[endRow][endCol] = piece;
    board[startRow][startCol] = null;

    //is the king in check after the move?
    bool kingInCheck = isKingInCheck(piece.isWhite);

    //restore to original board state
    board[endRow][endCol] = originalDestinationPiece;
    board[startRow][startCol] = piece;
    //if the piece was the king restore it  original position

    if (piece.type == ChessPieceType.king) {
      if (piece.isWhite) {
        whiteKingPosition = originalKingPosition!;
      } else {
        blackKingPosition = originalKingPosition!;
      }
    }
    //return true if the king is not in check
    return !kingInCheck;
  }

  //IS IT CHECKMATE?
  bool isCheckMate(bool isWhiteKing) {
    // if the king is not in check, then is not checkmate
    if (!isKingInCheck(isWhiteKing)) {
      return false;
    }
    // if there is atleast one legal move for any of the player pieces, then its not checkmate
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        if (board[i][j] == null || board[i][j]!.isWhite != isWhiteKing) {
          continue;
        }
        List<List<int>> pieceValidMoves =
            calculatedRealValidMoves(i, j, board[i][j], true);

        //if this piece has any valid moves, then its not checkmate
        if (pieceValidMoves.isNotEmpty) {
          return false;
        }
      }
    }
    //if no piece has any valid moves, then its checkmate
    return true;
  }

  //RESET GAME
  void resetGame() {
    Navigator.pop(context);
    _initializeBoard();
    checkStatus = false;
    whitePiecesTaken.clear();
    blackPiecesTaken.clear();
    blackKingPosition = [0, 4];
    whiteKingPosition = [7, 4];
    setState(() {});
  }

    // Perform White A-side castling
  void performWhiteAcasling() {
    setState(() {
      board[7][2] = board[7][4]; // Move king
      board[7][4] = null;
      board[7][3] = board[7][0]; // Move rook
      board[7][0] = null;
      whiteKingMoved = true;
      whiteRookAMoved = true;
      whiteCastlingAAvailable = false;
      whiteCastlingHAvailable = false;
      whiteKingPosition = [7, 2];
      isWhiteTurn = false;
    });
  }

  // Perform White H-side castling
  void performWhiteHcasling() {
    setState(() {
      board[7][6] = board[7][4]; // Move king
      board[7][4] = null;
      board[7][5] = board[7][7]; // Move rook
      board[7][7] = null;
      whiteKingMoved = true;
      whiteRookHMoved = true;
      blackCastlingAAvailable = false;
      blackCastlingHAvailable = false;
      
      whiteKingPosition = [7, 6];
      isWhiteTurn = false;
    });
  }

  // Perform Black A-side castling
  void performBlackAcasling() {
    setState(() {
      board[0][2] = board[0][4]; // Move king
      board[0][4] = null;
      board[0][3] = board[0][0]; // Move rook
      board[0][0] = null;
      blackKingMoved = true;
      blackRookAMoved = true;
      blackKingPosition = [0, 2];
      isWhiteTurn = true;
    });
  }

  // Perform Black H-side castling
  void performBlackHcasling() {
    setState(() {
      board[0][6] = board[0][4]; // Move king
      board[0][4] = null;
      board[0][5] = board[0][7]; // Move rook
      board[0][7] = null;
      blackKingMoved = true;
      blackRookHMoved = true;
      blackKingPosition = [0, 6];
      isWhiteTurn = true;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: blackSquarecolor,
        body: Column(
          children: [
            //WHITE PIECES TAKEN
            Expanded(
                child: GridView.builder(
              itemCount: whitePiecesTaken.length,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8),
              itemBuilder: (context, index) => DeadPiece(
                imagePath: whitePiecesTaken[index].imagePath,
                isWhite: true,
              ),
            )),
            //perform castling buttons
            whiteCastlingAAvailable && isWhiteTurn ? GestureDetector(
              onTap: () {
                performWhiteAcasling();
              },
              child: SizedBox(
                width: 128, // Set the desired width
                height: 64, // Set the desired height
                child: Image.asset(
                  'assets/images/0-0-0.png',
                  filterQuality: FilterQuality.none,
                  color: whitePiececolor,
                  fit: BoxFit.contain, // Adjust the fit property as needed
                ),
              ),
            ) : Container(),
            whiteCastlingHAvailable && isWhiteTurn ? GestureDetector(
              onTap: () {
                performWhiteHcasling();
              },
              child: SizedBox(
                width: 128, // Set the desired width
                height: 64, // Set the desired height
                child: Image.asset(
                  'assets/images/0-0.png',
                  filterQuality: FilterQuality.none,
                  color: whitePiececolor,
                  fit: BoxFit.contain, // Adjust the fit property as needed
                ),
              ),
            ) : Container(),
            blackCastlingAAvailable && !isWhiteTurn ? GestureDetector(
              onTap: () {
                performBlackAcasling();
              },
              child: SizedBox(
                width: 128, // Set the desired width
                height: 64, // Set the desired height
                child: Image.asset(
                  'assets/images/0-0-0.png',
                  filterQuality: FilterQuality.none,
                  color: blackPiececolor,
                  fit: BoxFit.contain, // Adjust the fit property as needed
                ),
              ),
            ) : Container(),
            blackCastlingHAvailable && !isWhiteTurn ? GestureDetector(
              onTap: () {
                performBlackHcasling();
              },
              child: SizedBox(
                width: 128, // Set the desired width
                height: 64, // Set the desired height
                child: Image.asset(
                  'assets/images/0-0.png',
                  filterQuality: FilterQuality.none,
                  color: blackPiececolor,
                  fit: BoxFit.contain, // Adjust the fit property as needed
                ),
              ),
            ) : Container(),

            //CHESS BOARD
            Expanded(
              flex: 4,
              child: GridView.builder(
                itemCount: 64,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 8),
                itemBuilder: (context, index) {
                  //get the row and the col of this square
                  int row = index ~/ 8;
                  int col = index % 8;

                  //check if the square is selected
                  bool isSelected = selectedRow == row && selectedCol == col;

                  //check if the square is valid
                  bool isValidMove = false;
                  for (var position in validMoves) {
                    //compare row and col
                    if (position[0] == row && position[1] == col) {
                      isValidMove = true;
                    }
                  }

                  return Square(
                    isWhite: isWhite(index),
                    piece: board[row][col],
                    isSelected: isSelected,
                    isValidMove: isValidMove,
                    onTap: () => pieceSelected(row, col),
                  );
                },
              ),
            ),

            //BLACK PIECES TAKEN
            Expanded(
                child: GridView.builder(
              itemCount: blackPiecesTaken.length,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8),
              itemBuilder: (context, index) => DeadPiece(
                imagePath: blackPiecesTaken[index].imagePath,
                isWhite: false,
              ),
            )),
          ],
        ));
  }
}
