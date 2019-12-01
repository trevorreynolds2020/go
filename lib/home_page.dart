import 'package:flutter/material.dart';
import 'game_button.dart';
import 'custom_dialog.dart';
import 'current_move.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<List<GameButton>> buttonsList;

// var count;
  List<String> capturedStones = new List<String>();
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

  void changeTurn(){
    setState(() {
      if (activePlayer == 1) {
        activePlayer = 2;
        // testing
      }
      else {
        activePlayer = 1;
      }
    });
  }

  String currentStoneColor(){
    if (activePlayer == 1) {
      return "White";
      // testing
    }
    else {
      return "Black";
    }
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


  List<String> captured = new List<String>();
  void checkCapturedRow(int x, int y, dynamic player, dynamic capturedPlayer){
    if(capturedPlayer.contains(convertCooridnate(x, y+1))){
      print("contains");
      captured.add(convertCooridnate(x, y+1));
      print(captured);
      checkCapturedRow(x,y+1,player,capturedPlayer);
    }
    else if(player.contains(convertCooridnate(x, y+1))){
      print("hit the right white");
    }
    else{
      print("Didn't find anything");
    }
  }
  // send array of coordinates
  void Capture(var player, List<String> border) {
    // TAKES CARE OF ROW
    // if row matches go down the line until you find the matching node
    // ... take the difference between the nodes and start from initial node
    // ... loops for the difference and capture all non-current type nodes
    print(border);
    print("A");
    print(player);
    var minX = 18;
    var minY = 18;
    var maxX = 0;
    var maxY = 0;
    var surroundingStone = player;
    var surroundedStone;

    if (activePlayer == 1) {
      surroundedStone = white;
      // testing
    }
    else {
      surroundedStone = black;
    }

    print("B");
    for(int i = 0; i < border.length; i++){
      List<String> pair = border[i].split(",");
      int x = int.parse(pair[0]);
      int y = int.parse(pair[1]);
      print(x);
      print(y);
      // remove top row
      if(x < minX){
        minX = x;
      }
      //remove bottom row
      if(x > maxX){
        maxX = x;
      }
    }

    print("B2");

    for(int i = 0; i < border.length; i++){
      print("Pre removal");
      print(border);
      List<String> pair = border[i].split(",");
      int x = int.parse(pair[0]);
      int y = int.parse(pair[1]);
      if(x == minX){
        border.removeAt(i);
        i = i - 1;
        // may have to decrement i depending on how remove at works
      }
      if(x == maxX){
        border.removeAt(i);
        i = i - 1;
      }
      print("Removal on border");
      print(border);
    }



    bool captureCompleted;


    // Runs while the border list has stones left
    while(border.length > 0){
      // finds far upper left stone
      for(int i = 0; i < border.length; i++){
        List<String> pair = border[i].split(",");
        int x = int.parse(pair[0]);
        int y = int.parse(pair[1]);
        if(y < minY){
          print("this new min y "+y.toString());
          minY = y;
          minX = x;
        }
        if(y == minY){
          if(x < minX){
            minX = x;
          }
        }
        if(y > maxY){
          maxY = y;
          maxX = x;
        }
        if(y == maxY){
          if(x > maxX){
            maxX = x;
          }
        }
      }

      print(minX);
      print(minY);
      print("D");
      print("Surrounded");
      print(surroundedStone);
      // Checks far upper left stone from left -> right
      checkCapturedRow(minX, minY, surroundingStone, surroundedStone);
      // If the function found a origin and destination with stones inbetween
      // add those stones to captured stones
      print(captured);
      if(captured != null){
        capturedStones.addAll(captured);
        captured.clear(); //clear list
        print("Captured stones current");
        print(capturedStones);
        for(int i = 0; i < border.length; i++){
          List<String> pair = border[i].split(",");
          int x = int.parse(pair[0]);
          int y = int.parse(pair[1]);
          if(x == minX){
            print("Min="+border[i].toString());
            border.removeAt(i); // remove the capturing stones in that row to signify
            // its been checked
            if(border.length == 0){
              captureCompleted = true;
            }
          }
        }
      }
      // if the algorithm decides there's no stones in that row
      // empty the list, which will break the loop and go back into the game
      else{
        border = new List<String>();
      }

      //remove all captured stones
      if(captureCompleted == true){
        print("Captured completed");
      }


      print("E");

    }

    if(captureCompleted) {

        print("Preremoval at bottom & buttonsList");
        print(surroundedStone);
        print(buttonsList);
        for (int i = 0; i < capturedStones.length; i++) {
          if (surroundedStone.contains(capturedStones[i])) {
            List<String> pair = capturedStones[i].split(",");
            int x = int.parse(pair[0]);
            int y = int.parse(pair[1]);
            buttonsList[x][y] = new GameButton();
            surroundedStone.remove(capturedStones[i]);
          }
        }

        print(surroundedStone);

    }






//
//    if (activePlayer == 1) {
//      player = Colors.white;
//      activePlayer = 2;
//      // testing
//    }
//    else {
//      player = Colors.black;
//      activePlayer = 1;
//    }


    // if the the space doesn't have anything available and it's not the surrounding players color THEN add it to list of captured
    // vertices





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
  // TOP condition if initial node is equal to current node send path to Capture()

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
      //call capture
      print("Found original node!!!");
      Capture(player,border);
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
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Row(children: <Widget>[
        RaisedButton(
          child: Text("Pass"),
          onPressed: () => changeTurn()
        ),
        CurrentMove(currentStoneColor())
      ],),
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



