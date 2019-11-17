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
  var white;
  var black;
  var activePlayer;
  var idOnPlay; // stores the current index of stone placed that way you know if the
  //path wraps back to the beginning (e.g. one player captures the other player)

  void initState() {
    super.initState();
    buttonsList = doInit();
  }

  // Initializes the grid
  List<List<GameButton>> doInit() {
    white = new List();
    black = new List();
    activePlayer = 1;
    int n = 19;
    int count = 1;
    List <List<GameButton>> buttons = new List.generate(n, (i) => new List(n));
    for(int i = 0; i < n; i++){
      for(int j = 0; j < n; j++){
        buttons[i][j] = new GameButton(id: count);
        count++;
      }
    }
    return buttons;
  }

  // when button is clicked
  void placeStone(GameButton gb) {
    int currentIndex = gb.id;
    print(currentIndex);
    idOnPlay = gb.id;
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
      gb.enabled = false;
      checkAround(currentIndex, 1, "");
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
  void checkAround(int index, int count, String dontCheckDirectionToThe) {

    // When this changes there is a winner
    var winner = -1;

    // Test what recursive call were at
    print("Top of check around" + count.toString()+" Current index: "+index.toString()+"\n");


    // STONE CAPTURES THE ENEMY condition
    if (idOnPlay == index && count > 1) {
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

    // STONE CHECKS

    void checkLeftStone(index){
      if (white.contains(index - 1) && dontCheckDirectionToThe != "No left" &&
          foundOriginalNode == false) {
        checkAround(index - 1, count + 1, "No right");
      }

    }
    void checkRightStone(index){
      if (white.contains(index + 1) && dontCheckDirectionToThe != "No right" &&
          foundOriginalNode == false) {
        checkAround(index + 1, count + 1, "No left");
      }
    }
    void checkUpperStone(index){
      if (white.contains(index - 20) && dontCheckDirectionToThe != "No up" &&
          foundOriginalNode == false) {
        checkAround(index - 20, count + 1, "No down");
      }
    }

    void checkDownStone(index){
      if (white.contains(index + 20) && dontCheckDirectionToThe != "No down" &&
          foundOriginalNode == false) {
        checkAround(index + 20, count + 1, "No up");
      }
    }

    void checkUpperLeftDiagonalStone(index){
      if (white.contains(index - 21) &&
          dontCheckDirectionToThe != "No up left diagonal" &&
          foundOriginalNode == false) {
        checkAround(index - 21, count + 1, "No down right diagonal");
      }
    }

    void checkUpperRightDiagonalStone(index){
      if (white.contains(index - 19) &&
          dontCheckDirectionToThe != "No up right diagonal" &&
          foundOriginalNode == false) {
        checkAround(index - 19, count + 1, "No down left diagonal");
      }
    }

    void checkLowerLeftDiagonalStone(index){
      if (white.contains(index + 19) &&
          dontCheckDirectionToThe != "No down left diagonal" &&
          foundOriginalNode == false) {
        checkAround(index + 19, count + 1, "No up right diagonal");
      }
    }

    void checkLowerRightDiagonalStone(index){
      if (white.contains(index + 21) &&
          dontCheckDirectionToThe != "No down right diagonal" &&
          foundOriginalNode == false) {
        checkAround(index + 21, count + 1, "No up left diagonal");
      }
    }


    void checkTheVeryFirstStone(){
      if (white.contains(21) && dontCheckDirectionToThe != "No down" &&
          foundOriginalNode == false) {
        //pass 21 for check
        count++;
        checkAround(21, count, "No up");
      }
      if (white.contains(2) && dontCheckDirectionToThe != "No right" &&
          foundOriginalNode == false) {
        //pass 21 for check
        count++;
        checkAround(2, count, "No left");
      }
    }

    void checkTheSecondStone(){
      if (white.contains(1) && dontCheckDirectionToThe != "No left" &&
          foundOriginalNode == false) {
        count++;
        checkAround(1, count, "No right");
      }
      if (white.contains(21) && dontCheckDirectionToThe != "No down left diagonal" &&
          foundOriginalNode == false) {
        count++;
        checkAround(21, count, "No up right diagonal");
      }
    }

    void checkTheStoneJustUnderTheFirstStone(){
      if (white.contains(1) && dontCheckDirectionToThe != "No up" &&
          foundOriginalNode == false) {
        count++;
        checkAround(1, count, "No down");
      }
      //checks diagonal nodes
      if (white.contains(2) && dontCheckDirectionToThe != "No up right diagonal" &&
          foundOriginalNode == false) {
        count++;
        checkAround(2, count, "No down left diagonal");
      }
    }
    void checkTopRightStone(){
      if (white.contains(19) && dontCheckDirectionToThe != "No left" &&
          foundOriginalNode == false) {
        //pass 19
        count++;
        checkAround(19, count, "No right");
      }
      if (white.contains(40) && dontCheckDirectionToThe != 'No down' &&
          foundOriginalNode == false) {
        count++;
        checkAround(40, count, "No up");
      }
    }
    void checkStoneJustBelowTopRightStone(){
      if (white.contains(20) && dontCheckDirectionToThe != "No up" &&
          foundOriginalNode == false) {
        count++;
        checkAround(20, count, "No down");
      }
      if (white.contains(19) && dontCheckDirectionToThe != "No up left diagonal" &&
          foundOriginalNode == false) {
        count++;
        checkAround(19, count, "No down right diagonal");
      }
    }
    void checkStoneJustLeftOfTopRightStone(){
      if (white.contains(20) && dontCheckDirectionToThe != "No right" &&
          foundOriginalNode == false) {
        count++;
        checkAround(20, count, "No left");
      }
      if (white.contains(40) && dontCheckDirectionToThe != "No down right diagonal" &&
          foundOriginalNode == false) {
        count++;
        checkAround(40, count, "No up left diagonal");
      }
    }

    void checkLowerRightStone(){
      if (white.contains(399) && dontCheckDirectionToThe != "No left" &&
          foundOriginalNode == false) {
        //pass 19
        count++;
        checkAround(399, count, "No right");
      }
      if (white.contains(380) && dontCheckDirectionToThe != "No up" &&
          foundOriginalNode == false) {
        count++;
        checkAround(380, count, "No down");
      }
    }
    void checkStoneJustLeftOfLowerRightStone(){
      if (white.contains(400) && dontCheckDirectionToThe != 'No right' &&
          foundOriginalNode == false) {
        count++;
        checkAround(400, count, "No left");
      }
      if (white.contains(380) && dontCheckDirectionToThe != 'No up right diagonal' &&
          foundOriginalNode == false) {
        count++;
        checkAround(380, count, "No down left diagonal");
      }
    }
    void checkStoneJustAboveLowerRightStone(){
      if (white.contains(400) && dontCheckDirectionToThe != 'No up' &&
          foundOriginalNode == false) {
        count++;
        checkAround(400, count, "No down");
      }
      if (white.contains(399) && dontCheckDirectionToThe != 'No down left diagonal' &&
          foundOriginalNode == false) {
        count++;
        checkAround(399, count, "No up right diagonal");
      }
    }
    void checkLowerLeftStone(){
      if (white.contains(361) && dontCheckDirectionToThe != "No up" &&
          foundOriginalNode == false) {
        //pass 21 for check
        count++;
        checkAround(361, count, "No down");
      }
      if (white.contains(382) && dontCheckDirectionToThe != "No right" &&
          foundOriginalNode == false) {
        //pass 21 for check
        count++;
        checkAround(382, count, "No left");
      }
    }

    void checkStoneJustAboveLowerLeftStone(){
      if (white.contains(381) && dontCheckDirectionToThe != "No down" &&
          foundOriginalNode == false) {
        count++;
        checkAround(381, count, "No up");
      }
      if (white.contains(382) && dontCheckDirectionToThe != "No down right diagonal" &&
          foundOriginalNode == false) {
        count++;
        checkAround(382, count, "No up left diagonal");
      }
      if (white.contains(342) && dontCheckDirectionToThe != "No up right diagonal" &&
          foundOriginalNode == false) {
        count++;
        checkAround(342, count, "No down left diagonal");
      }
    }

    void checkStoneJustRightOfLowerLeftStone(){
      if (white.contains(381) && dontCheckDirectionToThe != "No left" &&
          foundOriginalNode == false) {
        count++;
        checkAround(381, count, "No right");
      }
      if (white.contains(361) && dontCheckDirectionToThe != "No up left diagonal" &&
          foundOriginalNode == false) {
        count++;
        checkAround(361, count, "No down right diagonal");
      }
      if (white.contains(342) && dontCheckDirectionToThe != "No up right diagonal" &&
          foundOriginalNode == false) {
        count++;
        checkAround(342, count, "No down left diagonal");
      }
    }
    //top left corner - white
    if (index == 1 && foundOriginalNode == false) {
      checkTheVeryFirstStone();
    }
    if (index == 2 && foundOriginalNode == false) {
      checkTheSecondStone();
    }
    if (index == 21 && foundOriginalNode == false) {
      checkTheStoneJustUnderTheFirstStone();
    }




    //top right corner white
    if (index == 20 && foundOriginalNode == false) {
      checkTopRightStone();
    }
    if (index == 19 && foundOriginalNode == false) {
      checkStoneJustLeftOfTopRightStone();
    }
    if (index == 40 && foundOriginalNode == false) {
      checkStoneJustBelowTopRightStone();
    }


    //Checks the top row

    if (index >= 2 && index <= 19 && foundOriginalNode == false) {
      checkLeftStone(index);
      checkRightStone(index);
      checkDownStone(index);
      checkLowerLeftDiagonalStone(index);
      checkLowerRightDiagonalStone(index);
    }

    // it's not an exception therefore check current node
    // ... since you're in the if condition
    //checkAround(i);



    //bottom left corner white
    if (index == 381 && foundOriginalNode == false) {
      checkLowerLeftStone();
    }
    if (index == 361 && foundOriginalNode == false) {
      checkStoneJustAboveLowerLeftStone();
    }
    if (index == 382 && foundOriginalNode == false) {
      checkStoneJustRightOfLowerLeftStone();
    }



    //bottom right corner white
    if (index == 400 && foundOriginalNode == false) {
      checkLowerRightStone();
    }
    if (index == 399 && foundOriginalNode == false) {
      checkStoneJustLeftOfLowerRightStone();
    }
    if (index == 380 && foundOriginalNode == false) {
      checkStoneJustAboveLowerRightStone();
    }

    // checks bottom row for white

    if (index >= 360 && index <= 400 && foundOriginalNode == false) {
      checkLeftStone(index);
      checkRightStone(index);
      checkUpperStone(index);
      checkUpperLeftDiagonalStone(index);
      checkUpperRightDiagonalStone(index);
    }


    // check left column for white

    if (index % 21 == 0 && foundOriginalNode == false && index != 21) {
      checkRightStone(index);
      checkUpperStone(index);
      checkDownStone(index);
      checkUpperRightDiagonalStone(index);
      checkLowerRightDiagonalStone(index);
    }


    // check right column for white

    if (index % 20 == 0 && foundOriginalNode == false && index != 20) {
      checkLeftStone(index);
      checkUpperStone(index);
      checkDownStone(index);
      checkUpperLeftDiagonalStone(index);
      checkLowerLeftDiagonalStone(index);
    }


    //if(index >= 22 && index <= 359 && foundOriginalNode == false){
    // check the inside border of white

    // check i + 1 , i - 1, i + 20, i - 20
    // diagonals
    // check i + 19 , i + 21, i - 19, i - 21
    //checkAround(i);





    checkLeftStone(index);
    checkRightStone(index);
    checkUpperStone(index);
    checkDownStone(index);
    checkUpperLeftDiagonalStone(index);
    checkUpperRightDiagonalStone(index);
    checkLowerLeftDiagonalStone(index);
    checkLowerRightDiagonalStone(index);





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


