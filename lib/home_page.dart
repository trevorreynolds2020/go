import 'package:flutter/material.dart';
import 'game_button.dart';
import 'custom_dialog.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<List<GameButton>> buttonsList;

// var count;
  Map<int,int> vertex;
  var white;
  var black;
  var activePlayer;
  var xOnCurrentPlay;
  var yOnCurrentPlay;
  var currentXY;// stores the current index of stone placed that way you know if the
  //path wraps back to the beginning (e.g. one player captures the other player)

  void initState() {
    super.initState();
    buttonsList = doInit();
  }

  // Initializes the grid
  List<List<GameButton>> doInit() {
    white = new List();
    black = new List();
    vertex = Map();
    activePlayer = 1;
    int n = 19;
    int count = 1;
    List <List<GameButton>> buttons = new List.generate(n, (i) => new List(n));
    for(int i = 0; i < n; i++){
      for(int j = 0; j < n; j++){
        buttons[i][j] = new GameButton(id: i.toString()+","+j.toString());
        count++;
      }
    }
    return buttons;
  }

  String convertCooridnate(int x, int y){
    return x.toString()+","+y.toString();
  }

  // when button is clicked
  void placeStone(GameButton gb) {

    //Covert to x , y coordinates
    List<String> coordinates = gb.id.split(",");
    List<String> border = new List<String>();
    var x = int.parse(coordinates[0]);
    var y = int.parse(coordinates[1]);
    xOnCurrentPlay = x;
    yOnCurrentPlay = y;
    var currentPlayer;
    //Saves string pair - just to make comparing easier
    currentXY = gb.id;

    setState(() {
      if (activePlayer == 1) {
        gb.text = "";
        gb.bg = Colors.white;
        activePlayer = 2;
        white.add(gb.id);
        currentPlayer = white;
        // testing
      }
      else {
        gb.text = "";
        gb.bg = Colors.black;
        activePlayer = 1;
        black.add(gb.id);
        currentPlayer = black;
      }

      checkAround(x, y, currentXY, 1, "",currentPlayer,border);
      gb.enabled = false;
      print(currentXY);
    });
  }

  // send array of coordinates
  void Flip(dynamic player, List<String> border) {
    // TAKES CARE OF ROW
    // if row matches go down the line until you find the matching node
    // ... take the difference between the nodes and start from initial node
    // ... loops for the difference and flip all non-current type nodes
    print(player);
    var minX;
    var minY;
    var maxX;
    var maxY;
    var coordinates;
    var surroundingStone = player;

    for(int i = 0; i < border.length; i++){
      List<String> pair = border[i].split(",");
      int x = int.parse(pair[0]);
      int y = int.parse(pair[1]);
      if(y <= minY){
        minY = y;
        if(x <= minX){
          minX = x;
        }
      }
      if(y >= maxY){
        maxY = y;
        if(x >= maxX){
          maxX = x;
        }
      }
    }


    if (activePlayer == 1) {
      player = Colors.white;
      activePlayer = 2;
      // testing
    }
    else {
      player = Colors.black;
      activePlayer = 1;
    }

    // if the the space doesn't have anything available and it's not the surrounding players color THEN add it to list of captured
    // vertices
    for(int i = minX; i < maxX-minX; i++){
      for(int j = minY; j < maxY-minY; j++){
        if(player.contains("")){
          if(player.Color.toString() != surroundingStone.Color.toString()){

          }
        }
      }
    }



  }

  // should be a recursive function that stores the initial node
  // checks the surrounding nodes
  // for nodes % 20 only check left up and down
  // unless 20 then only left and down
  // unless 400 then only left and up
  // unless 0 then only right and down
  // unless 380 then only right and up
  // unless %21 only check up down and left
  // unless 1-20 check down left and right
  // unless 380 - 400 check up left and right

  // left -1
  // right +1
  // down +20
  // up -20

  // when you find a touching node add to a node list
  // send the node through a loop that recurively calls the same function
  // ..... checks the surrounds points and applies the same process
  // TOP condition if initial node is equal to current node send path to Flip()

  bool foundOriginalNode = false;

  // pass in current point
  void checkAround(int x, int y, String currentXY, int count, String dontCheckDirectionToThe, dynamic player, List<String> border) {

    bool leftChecked = false;
    bool rightChecked = false;
    bool upChecked = false;
    bool downChecked = false;
    bool upperLeftChecked = false;
    bool upperRightChecked = false;
    bool lowerLeftChecked = false;
    bool lowerRightChecked = false;
    bool firstStoneChecked = false;
    bool secondStoneChecked = false;
//    bool underTheFirstStoneChecked = false;
    bool topRightChecked = false;
    bool leftOfTopRightChecked = false;
    bool underTheTopRightChecked = false;
    bool underTheTopLeftChecked = false;
//    bool lowerRightCornerChecked = false;
    bool leftOfLowerRightChecked = false;
//    bool rightOfLowerRightChecked = false;
    bool lowerLeftCornerStone = false;
    bool aboveLowerRightChecked = false;
    bool aboveLowerLeftChecked = false;
    bool rightOfLowerLeftChecked = false;

    // We have to currentXY to make checking the ids on each vertex easier
    // When this changes there is a winner
    var winner = -1;
    print("-----Recursive call: "+count.toString()+" on "+currentXY);

    // STONE CAPTURES THE ENEMY condition
    if (xOnCurrentPlay == x && yOnCurrentPlay == y && count > 1) {
      //call flip
      print("Found original node!!!");
      Flip(player,border);
      foundOriginalNode = true;
      return;
    }




    // Keeps the method from executing unnecessary recursion
    if (foundOriginalNode == true) {
      foundOriginalNode = false;
    }

    // checks see if the index is valid
    // (1,2) is TRUE
    // (-9,3) is FALSE
    bool indexExists(int x , int y){
      if(x >= 0 && y >= 0 && x <= 18 && y <= 18){
        return true;
      }
      else{
        return false;
      }
    }


    // STONE CHECKS



    void checkLeftStone(x, y, player){
      // Coordinates to check
      x = x;
      y = y -1;
      // Has been checked
      leftChecked = true;
      if(indexExists(x, y)){
        String checkIndex = convertCooridnate(x, y);
        print("Left stone " + checkIndex);
        if (player.contains(checkIndex) && dontCheckDirectionToThe != "left" &&
            foundOriginalNode == false) {
          border.add(checkIndex);
          checkAround(x, y, checkIndex, count + 1, "right",player,border);
        }
      }
    }
    void checkRightStone(x,y,player){
      x = x;
      y = y + 1;
      rightChecked = true;
      if(indexExists(x, y)){
        String checkIndex = convertCooridnate(x, y);
        print("Right stone " + checkIndex);
        if (player.contains(checkIndex) && dontCheckDirectionToThe != "right" &&
            foundOriginalNode == false) {
          border.add(checkIndex);
          checkAround(x,y, checkIndex, count + 1, "left",player,border);
        }
      }
    }
    void checkUpperStone(x,y,player){
      x = x -1;
      y = y;
      upChecked = true;
      if(indexExists(x, y)){
        String checkIndex = convertCooridnate(x, y);
        print("Upper stone " +checkIndex);
        if (player.contains(checkIndex) && dontCheckDirectionToThe != "right" &&
            foundOriginalNode == false) {
          border.add(checkIndex);
          checkAround(x, y, checkIndex, count + 1, "down",player,border);
        }
      }
    }

    void checkDownStone(x,y,player){
      x = x + 1;
      y = y;
      downChecked = true;
      if(indexExists(x, y)){
        String checkIndex = convertCooridnate(x, y);
        print("Lower stone: " +checkIndex);
        if (player.contains(checkIndex) && dontCheckDirectionToThe != "down" &&
            foundOriginalNode == false) {
          border.add(checkIndex);
          checkAround(x, y, checkIndex, count + 1, "right",player,border);
        }
      }
    }

    void checkUpperLeftDiagonalStone(x,y,player){
      x = x - 1;
      y = y - 1;
      upperLeftChecked = true;
      if(indexExists(x, y)){
        String checkIndex = convertCooridnate(x, y);
        print("Upper left diagonal"+checkIndex);
        if (player.contains(checkIndex) &&
            dontCheckDirectionToThe != "upper left" &&
            foundOriginalNode == false) {
          border.add(checkIndex);
          checkAround(x, y, checkIndex, count + 1, "lower right",player,border);
        }
      }
    }

    void checkUpperRightDiagonalStone(x,y,player){
      x = x - 1;
      y = y + 1;
      upperRightChecked = true;
      if(indexExists(x, y)){
        String checkIndex = convertCooridnate(x, y);
        print("Upper right diagonal: "+checkIndex);
        if (player.contains(checkIndex) &&
            dontCheckDirectionToThe != "upper right" &&
            foundOriginalNode == false) {
          border.add(checkIndex);
          checkAround(x, y, checkIndex, count + 1, "lower left",player,border);
        }
      }
    }

    void checkLowerLeftDiagonalStone(x,y,player){
      x = x + 1;
      y = y - 1;
      lowerLeftChecked = true;
      if(indexExists(x, y)){
        String checkIndex = convertCooridnate(x, y);
        print("Lower left diagonal"+checkIndex);
        if (player.contains(checkIndex) &&
            dontCheckDirectionToThe != "lower left" &&
            foundOriginalNode == false) {
          border.add(checkIndex);
          checkAround(x, y, checkIndex, count + 1, "upper right",player,border);
        }
      }
    }

    void checkLowerRightDiagonalStone(x,y,player){
      x = x + 1;
      y = y + 1;
      lowerRightChecked = true;
      if(indexExists(x,y)){
        String checkIndex = convertCooridnate(x,y);
        print("Lower right diagonal"+checkIndex);
        if (player.contains(checkIndex) &&
            dontCheckDirectionToThe != "lower right" &&
            foundOriginalNode == false) {
          border.add(checkIndex);
          checkAround(x,y, checkIndex, count + 1, "upper left",player,border);
        }
      }
    }


    void checkTheVeryFirstStone(player){
      firstStoneChecked = true;
      String checkIndex = convertCooridnate(1,0);
      if (player.contains(checkIndex) && dontCheckDirectionToThe != "down" &&
          foundOriginalNode == false) {
        border.add(checkIndex);
        //pass 21 for check
        count++;
        checkAround(1,0,checkIndex, count, "right",player,border);
      }
      checkIndex = convertCooridnate(0,1);
      if (player.contains(checkIndex) && dontCheckDirectionToThe != "right" &&
          foundOriginalNode == false) {
        border.add(checkIndex);
        //pass 21 for check
        count++;
        checkAround(0,1,checkIndex, count, "left",player,border);
      }
    }

    void checkTheSecondStone(player){
      secondStoneChecked = true;
      String checkIndex = convertCooridnate(0,0);
      if (player.contains(checkIndex) && dontCheckDirectionToThe != "left" &&
          foundOriginalNode == false) {
        border.add(checkIndex);
        count++;
        checkAround(0,0, checkIndex, count, "right",player,border);
      }
      checkIndex = convertCooridnate(1,0);
      if (player.contains(checkIndex) && dontCheckDirectionToThe != "lower left" &&
          foundOriginalNode == false) {
        border.add(checkIndex);
        count++;
        checkAround(1,0, checkIndex, count, "upper right",player,border);
      }
    }

    void checkTheStoneJustUnderTheFirstStone(player){
      underTheTopLeftChecked = true;
      String checkIndex = convertCooridnate(0,0);
      if (player.contains(checkIndex) && dontCheckDirectionToThe != "right" &&
          foundOriginalNode == false) {
        border.add(checkIndex);
        count++;
        checkAround(0,0, checkIndex, count, "down",player,border);
      }
      checkIndex = convertCooridnate(0,1);
      //checks diagonal nodes
      if (player.contains(checkIndex) && dontCheckDirectionToThe != "upper right" &&
          foundOriginalNode == false) {
        border.add(checkIndex);
        count++;
        checkAround(0,1, checkIndex, count, "lower left",player,border);
      }
    }


    //    void checkLowerRightStone(){
//      lowerRightChecked = true;
//      String checkIndex = convertCooridnate(18,17);
//      if (white.contains(checkIndex) && dontCheckDirectionToThe != "left" &&
//          foundOriginalNode == false) {
//        //pass 19
//        count++;
//        checkAround(18,17,checkIndex, count, "right");
//      }
//      checkIndex = convertCooridnate(17,18);
//      if (white.contains(checkIndex) && dontCheckDirectionToThe != "right" &&
//          foundOriginalNode == false) {
//        count++;
//        checkAround(17,18, checkIndex, count, "down");
//      }
//    }
    void checkTopRightStone(player){
      topRightChecked = true;
      String checkIndex = convertCooridnate(0,17);
      if (player.contains(checkIndex) && dontCheckDirectionToThe != "left" &&
          foundOriginalNode == false) {
        border.add(checkIndex);
        //pass 19
        count++;
        checkAround(0,17, checkIndex, count, "right",player,border);
      }
      checkIndex = convertCooridnate(1,18);
      if (player.contains(checkIndex) && dontCheckDirectionToThe != 'down' &&
          foundOriginalNode == false) {
        border.add(checkIndex);
        count++;
        checkAround(1,18, checkIndex, count, "right",player,border);
      }
    }


//    void checkTheVeryFirstStone(player){
//      firstStoneChecked = true;
//      String checkIndex = convertCooridnate(1,0);
//      if (player.contains(checkIndex) && dontCheckDirectionToThe != "down" &&
//          foundOriginalNode == false) {
//        //pass 21 for check
//        count++;
//        checkAround(1,0,checkIndex, count, "right",player);
//      }
//      checkIndex = convertCooridnate(0,1);
//      if (player.contains(checkIndex) && dontCheckDirectionToThe != "right" &&
//          foundOriginalNode == false) {
//        //pass 21 for check
//        count++;
//        checkAround(0,1,checkIndex, count, "left",player);
//      }
//    }

    void checkStoneJustBelowTopRightStone(player){
      underTheTopRightChecked = true;
      String checkIndex = convertCooridnate(2,18);
      if (player.contains(checkIndex) && dontCheckDirectionToThe != "down" &&
          foundOriginalNode == false) {
        border.add(checkIndex);
        count++;
        checkAround(2,18, checkIndex, count, "up",player,border);
      }
      checkIndex = convertCooridnate(0,17);
      if (player.contains(checkIndex) && dontCheckDirectionToThe != "upper left" &&
          foundOriginalNode == false) {
        border.add(checkIndex);
        count++;
        checkAround(0,17, checkIndex, count, "lower right",player,border);
      }

    }




    void checkStoneJustLeftOfTopRightStone(player){
      leftOfTopRightChecked = true;
      String checkIndex = convertCooridnate(0,18);
      if (player.contains(checkIndex) && dontCheckDirectionToThe != "right" &&
          foundOriginalNode == false) {
        border.add(checkIndex);
        count++;
        checkAround(0,17,checkIndex, count, "left",player,border);
      }
      checkIndex = convertCooridnate(1,18);
      if (player.contains(checkIndex) && dontCheckDirectionToThe != "lower right" &&
          foundOriginalNode == false) {
        border.add(checkIndex);
        count++;
        checkAround(1,18,checkIndex, count, "upper left",player,border);
      }
    }

    void checkLowerRightStone(player){
      lowerRightChecked = true;
      String checkIndex = convertCooridnate(18,17);
      if (player.contains(checkIndex) && dontCheckDirectionToThe != "left" &&
          foundOriginalNode == false) {
        border.add(checkIndex);
        //pass 19
        count++;
        checkAround(18,17,checkIndex, count, "right",player,border);
      }
      checkIndex = convertCooridnate(17,18);
      if (player.contains(checkIndex) && dontCheckDirectionToThe != "right" &&
          foundOriginalNode == false) {
        border.add(checkIndex);
        count++;
        checkAround(17,18, checkIndex, count, "down",player,border);
      }
    }
    void checkStoneJustLeftOfLowerRightStone(player){
      leftOfLowerRightChecked = true;
      String checkIndex = convertCooridnate(18,18);
      if (player.contains(checkIndex) && dontCheckDirectionToThe != 'right' &&
          foundOriginalNode == false) {
        border.add(checkIndex);
        count++;
        checkAround(18,18, checkIndex, count, "left",player,border);
      }
      checkIndex = convertCooridnate(17,18);
      if (player.contains(checkIndex) && dontCheckDirectionToThe != 'upper right' &&
          foundOriginalNode == false) {
        border.add(checkIndex);
        count++;
        checkAround(17,18, checkIndex, count, "lower left",player,border);
      }
    }
    void checkStoneJustAboveLowerRightStone(player){
      aboveLowerRightChecked = true;
      String checkIndex = convertCooridnate(18,18);
      if (player.contains(checkIndex) && dontCheckDirectionToThe != 'right' &&
          foundOriginalNode == false) {
        border.add(checkIndex);
        count++;
        checkAround(18,18,checkIndex, count, "down",player,border);
      }
      checkIndex = convertCooridnate(18,17);
      if (player.contains(checkIndex) && dontCheckDirectionToThe != 'lower left' &&
          foundOriginalNode == false) {
        border.add(checkIndex);
        count++;
        checkAround(18,17,checkIndex, count, "upper right",player,border);
      }
    }




    void checkLowerLeftStone(player){
      lowerLeftCornerStone = true;
      String checkIndex = convertCooridnate(18,1);
      if (player.contains(checkIndex) && dontCheckDirectionToThe != "right" &&
          foundOriginalNode == false) {
        border.add(checkIndex);
        //pass 21 for check
        count++;
        checkAround(18,1,checkIndex, count, "left",player,border);
      }
      checkIndex = convertCooridnate(17,0);
      if (player.contains(checkIndex) && dontCheckDirectionToThe != "up" &&
          foundOriginalNode == false) {
        border.add(checkIndex);
        //pass 21 for check
        count++;
        checkAround(17,0,checkIndex, count, "down",player,border);
      }
    }




    void checkStoneJustAboveLowerLeftStone(player){
      aboveLowerLeftChecked = true;
      String checkIndex = convertCooridnate(18,0);
      if (player.contains(checkIndex) && dontCheckDirectionToThe != "down" &&
          foundOriginalNode == false) {
        border.add(checkIndex);
        count++;
        checkAround(18,0,checkIndex, count, "right",player,border);
      }
      checkIndex = convertCooridnate(18,1);
      if (player.contains(checkIndex) && dontCheckDirectionToThe != "lower right" &&
          foundOriginalNode == false) {
        border.add(checkIndex);
        count++;
        checkAround(18,1,checkIndex, count, "upper left",player,border);
      }
      checkIndex = convertCooridnate(17,1);
      if (player.contains(checkIndex) && dontCheckDirectionToThe != "upper right" &&
          foundOriginalNode == false) {
        border.add(checkIndex);
        count++;
        checkAround(17,1,checkIndex, count, "lower left",player,border);
      }
    }

    void checkStoneJustRightOfLowerLeftStone(player){
      rightOfLowerLeftChecked = true;
      String checkIndex = convertCooridnate(18,0);
      if (player.contains(checkIndex) && dontCheckDirectionToThe != "left" &&
          foundOriginalNode == false) {
        border.add(checkIndex);
        count++;
        checkAround(18,0,checkIndex, count, "right",player,border);
      }
      checkIndex = convertCooridnate(17,0);
      if (player.contains(checkIndex) && dontCheckDirectionToThe != "upper left" &&
          foundOriginalNode == false) {
        border.add(checkIndex);
        count++;
        checkAround(17,0,checkIndex, count, "lower right",player,border);
      }
      checkIndex = convertCooridnate(17,1);
      if (player.contains(checkIndex) && dontCheckDirectionToThe != "upper right" &&
          foundOriginalNode == false) {
        border.add(checkIndex);
        count++;
        checkAround(17,1,checkIndex, count, "lower left",player,border);
      }
    }



    //top left corner - white
    if (x == 0 && y == 0 && foundOriginalNode == false) {
      if(!firstStoneChecked)checkTheVeryFirstStone(player);
    }
    if (x == 0 && y == 1 && foundOriginalNode == false) {
      if(!secondStoneChecked)checkTheSecondStone(player);
    }
    if (x == 1 && y == 0 && foundOriginalNode == false) {
      if(!underTheTopLeftChecked)checkTheStoneJustUnderTheFirstStone(player);
    }




    //top right corner white
    if (x == 0 && y == 18 && foundOriginalNode == false) {
      if(!topRightChecked)checkTopRightStone(player);
    }
    if (x == 0 && y == 17 && foundOriginalNode == false) {
      if(!leftOfTopRightChecked)checkStoneJustLeftOfTopRightStone(player);
    }
    if (x == 1 && y == 18 && foundOriginalNode == false) {
      if(!underTheTopRightChecked)checkStoneJustBelowTopRightStone(player);
    }


    //Checks the top row

    if (x == 0 && y >= 1 && y <= 17 && foundOriginalNode == false) {
      if(!leftChecked)checkLeftStone(x,y,player);
      if(!rightChecked)checkRightStone(x,y,player);
      if(!downChecked)checkDownStone(x,y,player);
      if(!lowerLeftChecked)checkLowerLeftDiagonalStone(x,y,player);
      if(!lowerRightChecked)checkLowerRightDiagonalStone(x,y,player);
    }

    // it's not an exception therefore check current node
    // ... since you're in the if condition
    //checkAround(i);



    //bottom left corner white
    if (x == 18 && y == 0 && foundOriginalNode == false) {
      if(!lowerLeftCornerStone)checkLowerLeftStone(player);
    }
    if (x == 17 && y == 0 && foundOriginalNode == false) {
      if(!aboveLowerLeftChecked)checkStoneJustAboveLowerLeftStone(player);
    }
    if (x == 18 && y == 1 && foundOriginalNode == false) {
      if(!rightOfLowerLeftChecked)checkStoneJustRightOfLowerLeftStone(player);
    }



    //bottom right corner white
    if (x == 18 && y == 18 && foundOriginalNode == false) {
      if(!lowerRightChecked)checkLowerRightStone(player);
    }
    if (x == 18 && y == 17 && foundOriginalNode == false) {
      if(!leftOfLowerRightChecked)checkStoneJustLeftOfLowerRightStone(player);
    }
    if (x == 17 && y == 18 && foundOriginalNode == false) {
      if(!aboveLowerRightChecked)checkStoneJustAboveLowerRightStone(player);
    }

    // checks bottom row for white

    if (x == 18 && y >= 1 && y <=17 && foundOriginalNode == false) {
      if(!leftChecked)checkLeftStone(x,y,player);
      if(!rightChecked)checkRightStone(x,y,player);
      if(!upChecked)checkUpperStone(x,y,player);
      if(!upperLeftChecked)checkUpperLeftDiagonalStone(x,y,player);
      if(!upperRightChecked)checkUpperRightDiagonalStone(x,y,player);
    }


    // check left column for white

    if (y == 0 && foundOriginalNode == false && x == 1 && y == 0) {
      print("check left column");
      if(!rightChecked)checkRightStone(x,y,player);
      if(!upChecked)checkUpperStone(x,y,player);
      if(!downChecked)checkDownStone(x,y,player);
      if(!upperRightChecked)checkUpperRightDiagonalStone(x,y,player);
      if(!lowerRightChecked)checkLowerRightDiagonalStone(x,y,player);
    }


    // check right column for white

    if (y == 18 && foundOriginalNode == false && x == 0 && y == 18) {
      if(!leftChecked)checkLeftStone(x,y,player);
      if(!upChecked)checkUpperStone(x,y,player);
      if(!downChecked)checkDownStone(x,y,player);
      if(!upperLeftChecked)checkUpperLeftDiagonalStone(x,y,player);
      if(!lowerLeftChecked)checkLowerLeftDiagonalStone(x,y,player);
    }


    //if(index >= 22 && index <= 359 && foundOriginalNode == false){
    // check the inside border of white

    // check i + 1 , i - 1, i + 20, i - 20
    // diagonals
    // check i + 19 , i + 21, i - 19, i - 21
    //checkAround(i);




      if(!leftChecked)checkLeftStone(x,y,player);
      if(!rightChecked)checkRightStone(x,y,player);
      if(!upChecked)checkUpperStone(x,y,player);
      if(!downChecked)checkDownStone(x,y,player);
      if(!upperLeftChecked)checkUpperLeftDiagonalStone(x,y,player);
      if(!upperRightChecked)checkUpperRightDiagonalStone(x,y,player);
      if(!lowerLeftChecked)checkLowerLeftDiagonalStone(x,y,player);
      if(!lowerRightChecked)checkLowerRightDiagonalStone(x,y,player);







//    if(white.contains(1) && white.contains(5) && white.contains(9)){
//      winner = 1;
//    }
//    if(black.contains(7) && black.contains(8) && black.contains(9)){
//      winner = 2;
//    }
//
//    if(winner != -1){
//      if(winner == 1){
//        showDialog(
//            context: context,
//            builder: (_) => new CustomDialog(
//                "Player 1 Won",
//                "Press the reset button to start again",
//                resetGame));
//
//      }else{
//        showDialog(
//            context: context,
//            builder: (_) => new CustomDialog(
//                "Player 1 Won",
//                "Press the reset button to start again",
//                resetGame));
//      }
//    }


  }


  void resetGame(){
    if(Navigator.canPop(context)) Navigator.pop(context);
    setState(() {
      buttonsList = doInit();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(title: new Text("GO"),),
      body: new GridView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: buttonsList.length * buttonsList.length,
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 19,
            childAspectRatio: 1,
            crossAxisSpacing: 1.0,
            mainAxisSpacing: 1.0
        ),
        itemBuilder: (context, i)=> new SizedBox(
          width: 100.0,
          height: 100.0,
          child: new RaisedButton(
            padding: const EdgeInsets.all(1.0),
            onPressed: buttonsList[(i / buttonsList.length).floor()][(i % buttonsList.length)].enabled
                ?()=> placeStone(buttonsList[(i / buttonsList.length).floor()][(i % buttonsList.length)])
                :null,
            child: new Text(
              buttonsList[(i / buttonsList.length).floor()][(i % buttonsList.length)].text,
              style: new TextStyle(color: Colors.white, fontSize: 20.0),
            ),
            color: buttonsList[(i / buttonsList.length).floor()][(i % buttonsList.length)].bg,
            disabledColor: buttonsList[(i / buttonsList.length).floor()][(i % buttonsList.length)].bg,
          ),
        ),
      ),
    );
  }
}



