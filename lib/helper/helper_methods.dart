bool isWhite(int index) {
  int x = index  ~/ 8; //Integer division| row
  int y = index % 8; // remainder| Column
 
  //alternate colors
  bool isWhite = (x + y) % 2 == 0;

  return isWhite;
}