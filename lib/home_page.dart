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

  // when button is clicked
  void placeStone(GameButton gb) {

    //Covert to x , y coordinates
    List<String> coordinates = gb.id.split(",");
    var x = int.parse(coordinates[0]);
    var y = int.parse(coordinates[1]);
    xOnCurrentPlay = x;
    yOnCurrentPlay = y;

    //Saves string pair - just to make comparing easier
    currentXY = gb.id;

    setState(() {
      if (activePlayer == 1) {
        gb.text = "";
        gb.bg = Colors.white;
        activePlayer = 2;
        white.add(gb.id);
        // testing
      }
      else {
        gb.text = "";
        gb.bg = Colors.black;
        activePlayer = 1;
        black.add(gb.id);
      }
      checkAround(x, y, currentXY, 1, "");
      gb.enabled = false;
      print(currentXY);
    });
  }

  // send array of coordinates
  void Flip() {
    // TAKES CARE OF ROW
    // if row matches go down the line until you find the matching node
    // ... take the difference between the nodes and start from initial node
    // ... loops for the difference and flip all non-current type nodes
    print("flip black nodes inside the space");
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
  void checkAround(int x, int y, String currentXY, int count, String dontCheckDirectionToThe) {

    // We have to currentXY to make checking the ids on each vertex easier
    // When this changes there is a winner
    var winner = -1;
    print("Recursive call: "+count.toString()+" on "+currentXY);

    // STONE CAPTURES THE ENEMY condition
    if (xOnCurrentPlay == x && yOnCurrentPlay == y && count > 1) {
      //call flip
      print("Found original node!!!");
      Flip();
      foundOriginalNode = true;
      return;
    }




    // Keeps the method from executing unnecessary recursion
    if (foundOriginalNode == true) {
      foundOriginalNode = false;
    }

    String convertCooridnate(int x, int y){
      return x.toString()+","+y.toString();
    }
    // STONE CHECKS

    void checkLeftStone(x, y){
      String checkIndex = convertCooridnate(x, y - 1);
      print("Left stone " + checkIndex);
      if (white.contains(checkIndex) && dontCheckDirectionToThe != "left" &&
          foundOriginalNode == false) {
        checkAround(x, y-1, checkIndex, count + 1, "right");
      }
    }
    void checkRightStone(x,y){
      String checkIndex = convertCooridnate(x, y + 1);
      print("Right stone " + checkIndex);
      if (white.contains(checkIndex) && dontCheckDirectionToThe != "right" &&
          foundOriginalNode == false) {
        checkAround(x,y+1, checkIndex, count + 1, "left");
      }
    }
    void checkUpperStone(x,y){
      String checkIndex = convertCooridnate(x+1, y);
      if (white.contains(checkIndex) && dontCheckDirectionToThe != "right" &&
          foundOriginalNode == false) {
        checkAround(x+1, y, checkIndex, count + 1, "down");
      }
    }

    void checkDownStone(x,y){
      String checkIndex = convertCooridnate(x-1, y);
      if (white.contains(checkIndex) && dontCheckDirectionToThe != "down" &&
          foundOriginalNode == false) {
        checkAround(x-1, y, checkIndex, count + 1, "right");
      }
    }

    void checkUpperLeftDiagonalStone(x,y){
      String checkIndex = convertCooridnate(x+1, y + 1);
      if (white.contains(checkIndex) &&
          dontCheckDirectionToThe != "upper left" &&
          foundOriginalNode == false) {
        checkAround(x+1, y+1, checkIndex, count + 1, "lower right");
      }
    }

    void checkUpperRightDiagonalStone(x,y){
      String checkIndex = convertCooridnate(x+1, y - 1);
      if (white.contains(checkIndex) &&
          dontCheckDirectionToThe != "upper right" &&
          foundOriginalNode == false) {
        checkAround(x+1, y-1, checkIndex, count + 1, "lower left");
      }
    }

    void checkLowerLeftDiagonalStone(x,y){
      String checkIndex = convertCooridnate(x + 1, y - 1);
      if (white.contains(checkIndex) &&
          dontCheckDirectionToThe != "lower left" &&
          foundOriginalNode == false) {
        checkAround(x+1, y-1, checkIndex, count + 1, "upper right");
      }
    }

    void checkLowerRightDiagonalStone(x,y){
      String checkIndex = convertCooridnate(x + 1, y + 1);
      if (white.contains(checkIndex) &&
          dontCheckDirectionToThe != "lower right" &&
          foundOriginalNode == false) {
        checkAround(x + 1, y +1, checkIndex, count + 1, "upper left");
      }
    }


    void checkTheVeryFirstStone(){
      String checkIndex = convertCooridnate(1,0);
      if (white.contains(checkIndex) && dontCheckDirectionToThe != "down" &&
          foundOriginalNode == false) {
        //pass 21 for check
        count++;
        checkAround(1,0,checkIndex, count, "right");
      }
      checkIndex = convertCooridnate(0,1);
      if (white.contains(checkIndex) && dontCheckDirectionToThe != "right" &&
          foundOriginalNode == false) {
        //pass 21 for check
        count++;
        checkAround(0,1,checkIndex, count, "left");
      }
    }

    void checkTheSecondStone(){
      String checkIndex = convertCooridnate(0,0);
      if (white.contains(checkIndex) && dontCheckDirectionToThe != "left" &&
          foundOriginalNode == false) {
        count++;
        checkAround(0,0, checkIndex, count, "right");
      }
      checkIndex = convertCooridnate(1,0);
      if (white.contains(checkIndex) && dontCheckDirectionToThe != "lower left" &&
          foundOriginalNode == false) {
        count++;
        checkAround(1,0, checkIndex, count, "upper right");
      }
    }

    void checkTheStoneJustUnderTheFirstStone(){
      String checkIndex = convertCooridnate(0,0);
      if (white.contains(checkIndex) && dontCheckDirectionToThe != "right" &&
          foundOriginalNode == false) {
        count++;
        checkAround(0,0, checkIndex, count, "down");
      }
      checkIndex = convertCooridnate(0,1);
      //checks diagonal nodes
      if (white.contains(checkIndex) && dontCheckDirectionToThe != "upper right" &&
          foundOriginalNode == false) {
        count++;
        checkAround(0,1, checkIndex, count, "lower left");
      }
    }
    void checkTopRightStone(){
      String checkIndex = convertCooridnate(0,19);
      if (white.contains(checkIndex) && dontCheckDirectionToThe != "left" &&
          foundOriginalNode == false) {
        //pass 19
        count++;
        checkAround(0,18, checkIndex, count, "right");
      }
      checkIndex = convertCooridnate(1,18);
      if (white.contains(checkIndex) && dontCheckDirectionToThe != 'down' &&
          foundOriginalNode == false) {
        count++;
        checkAround(1,18, checkIndex, count, "right");
      }
    }
    void checkStoneJustBelowTopRightStone(){
      String checkIndex = convertCooridnate(1,18);
      if (white.contains(checkIndex) && dontCheckDirectionToThe != "right" &&
          foundOriginalNode == false) {
        count++;
        checkAround(1,18, checkIndex, count, "down");
      }
      checkIndex = convertCooridnate(0,18);
      if (white.contains(checkIndex) && dontCheckDirectionToThe != "upper left" &&
          foundOriginalNode == false) {
        count++;
        checkAround(0,18, checkIndex, count, "lower right");
      }
    }
    void checkStoneJustLeftOfTopRightStone(){
      String checkIndex = convertCooridnate(0,17);
      if (white.contains(checkIndex) && dontCheckDirectionToThe != "right" &&
          foundOriginalNode == false) {
        count++;
        checkAround(0,17,checkIndex, count, "left");
      }
      checkIndex = convertCooridnate(1,18);
      if (white.contains(checkIndex) && dontCheckDirectionToThe != "lower right" &&
          foundOriginalNode == false) {
        count++;
        checkAround(1,18,checkIndex, count, "upper left");
      }
    }

    void checkLowerRightStone(){
      String checkIndex = convertCooridnate(18,17);
      if (white.contains(checkIndex) && dontCheckDirectionToThe != "left" &&
          foundOriginalNode == false) {
        //pass 19
        count++;
        checkAround(18,17,checkIndex, count, "right");
      }
      checkIndex = convertCooridnate(17,18);
      if (white.contains(checkIndex) && dontCheckDirectionToThe != "right" &&
          foundOriginalNode == false) {
        count++;
        checkAround(17,18, checkIndex, count, "down");
      }
    }
    void checkStoneJustLeftOfLowerRightStone(){
      String checkIndex = convertCooridnate(18,18);
      if (white.contains(checkIndex) && dontCheckDirectionToThe != 'right' &&
          foundOriginalNode == false) {
        count++;
        checkAround(18,18, checkIndex, count, "left");
      }
      checkIndex = convertCooridnate(17,18);
      if (white.contains(checkIndex) && dontCheckDirectionToThe != 'upper right' &&
          foundOriginalNode == false) {
        count++;
        checkAround(17,18, checkIndex, count, "lower left");
      }
    }
    void checkStoneJustAboveLowerRightStone(){
      String checkIndex = convertCooridnate(18,18);
      if (white.contains(checkIndex) && dontCheckDirectionToThe != 'right' &&
          foundOriginalNode == false) {
        count++;
        checkAround(18,18,checkIndex, count, "down");
      }
      checkIndex = convertCooridnate(18,17);
      if (white.contains(checkIndex) && dontCheckDirectionToThe != 'lower left' &&
          foundOriginalNode == false) {
        count++;
        checkAround(18,17,checkIndex, count, "upper right");
      }
    }
    void checkLowerLeftStone(){
      String checkIndex = convertCooridnate(18,0);
      if (white.contains(checkIndex) && dontCheckDirectionToThe != "right" &&
          foundOriginalNode == false) {
        //pass 21 for check
        count++;
        checkAround(18,0,checkIndex, count, "down");
      }
      checkIndex = convertCooridnate(18,1);
      if (white.contains(checkIndex) && dontCheckDirectionToThe != "right" &&
          foundOriginalNode == false) {
        //pass 21 for check
        count++;
        checkAround(18,1,checkIndex, count, "left");
      }
    }

    void checkStoneJustAboveLowerLeftStone(){
      String checkIndex = convertCooridnate(18,0);
      if (white.contains(checkIndex) && dontCheckDirectionToThe != "down" &&
          foundOriginalNode == false) {
        count++;
        checkAround(18,0,checkIndex, count, "right");
      }
      checkIndex = convertCooridnate(18,1);
      if (white.contains(checkIndex) && dontCheckDirectionToThe != "lower right" &&
          foundOriginalNode == false) {
        count++;
        checkAround(18,1,checkIndex, count, "upper left");
      }
      checkIndex = convertCooridnate(17,1);
      if (white.contains(checkIndex) && dontCheckDirectionToThe != "upper right" &&
          foundOriginalNode == false) {
        count++;
        checkAround(17,1,checkIndex, count, "lower left");
      }
    }

    void checkStoneJustRightOfLowerLeftStone(){
      String checkIndex = convertCooridnate(18,0);
      if (white.contains(checkIndex) && dontCheckDirectionToThe != "left" &&
          foundOriginalNode == false) {
        count++;
        checkAround(18,0,checkIndex, count, "right");
      }
      checkIndex = convertCooridnate(17,0);
      if (white.contains(checkIndex) && dontCheckDirectionToThe != "upper left" &&
          foundOriginalNode == false) {
        count++;
        checkAround(17,0,checkIndex, count, "lower right");
      }
      checkIndex = convertCooridnate(17,1);
      if (white.contains(checkIndex) && dontCheckDirectionToThe != "upper right" &&
          foundOriginalNode == false) {
        count++;
        checkAround(17,1,checkIndex, count, "lower left");
      }
    }

    //top left corner - white
    if (x == 0 && y == 0 && foundOriginalNode == false) {
      checkTheVeryFirstStone();
    }
    if (x == 0 && y == 1 && foundOriginalNode == false) {
      checkTheSecondStone();
    }
    if (x == 1 && y == 0 && foundOriginalNode == false) {
      checkTheStoneJustUnderTheFirstStone();
    }




    //top right corner white
    if (x == 0 && y == 18 && foundOriginalNode == false) {
      checkTopRightStone();
    }
    if (x == 0 && y == 17 && foundOriginalNode == false) {
      checkStoneJustLeftOfTopRightStone();
    }
    if (x == 1 && y == 18 && foundOriginalNode == false) {
      checkStoneJustBelowTopRightStone();
    }


    //Checks the top row

    if (x == 0 && y >= 1 && y <= 17 && foundOriginalNode == false) {
      checkLeftStone(x,y);
      checkRightStone(x,y);
      checkDownStone(x,y);
      checkLowerLeftDiagonalStone(x,y);
      checkLowerRightDiagonalStone(x,y);
    }

    // it's not an exception therefore check current node
    // ... since you're in the if condition
    //checkAround(i);



    //bottom left corner white
    if (x == 18 && y == 0 && foundOriginalNode == false) {
      checkLowerLeftStone();
    }
    if (x == 17 && y == 0 && foundOriginalNode == false) {
      checkStoneJustAboveLowerLeftStone();
    }
    if (x == 18 && y == 1 && foundOriginalNode == false) {
      checkStoneJustRightOfLowerLeftStone();
    }



    //bottom right corner white
    if (x == 18 && y == 18 && foundOriginalNode == false) {
      checkLowerRightStone();
    }
    if (x == 18 && y == 17 && foundOriginalNode == false) {
      checkStoneJustLeftOfLowerRightStone();
    }
    if (x == 17 && y == 18 && foundOriginalNode == false) {
      checkStoneJustAboveLowerRightStone();
    }

    // checks bottom row for white

    if (x == 18 && y >= 1 && y <=17 && foundOriginalNode == false) {
      checkLeftStone(x,y);
      checkRightStone(x,y);
      checkUpperStone(x,y);
      checkUpperLeftDiagonalStone(x,y);
      checkUpperRightDiagonalStone(x,y);
    }


    // check left column for white

    if (y == 0 && foundOriginalNode == false && x == 1 && y == 0) {
      print("check left column");
      checkRightStone(x,y);
      checkUpperStone(x,y);
      checkDownStone(x,y);
      checkUpperRightDiagonalStone(x,y);
      checkLowerRightDiagonalStone(x,y);
    }


    // check right column for white

    if (y == 18 && foundOriginalNode == false && x == 0 && y == 18) {
      checkLeftStone(x,y);
      checkUpperStone(x,y);
      checkDownStone(x,y);
      checkUpperLeftDiagonalStone(x,y);
      checkLowerLeftDiagonalStone(x,y);
    }


    //if(index >= 22 && index <= 359 && foundOriginalNode == false){
    // check the inside border of white

    // check i + 1 , i - 1, i + 20, i - 20
    // diagonals
    // check i + 19 , i + 21, i - 19, i - 21
    //checkAround(i);





    checkLeftStone(x,y);
    checkRightStone(x,y);
    checkUpperStone(x,y);
    checkDownStone(x,y);
    checkUpperLeftDiagonalStone(x,y);
    checkUpperRightDiagonalStone(x,y);
    checkLowerLeftDiagonalStone(x,y);
    checkLowerRightDiagonalStone(x,y);





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



