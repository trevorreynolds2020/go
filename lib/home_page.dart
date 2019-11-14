import 'package:flutter/material.dart';
import 'game_button.dart';
import 'custom_dialog.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<GameButton> buttonsList;

  var count;
  var player1;
  var player2;
  var activePlayer;
  var idOnPlay; // stores the current index of stone placed that way you know if the
  //path wraps back to the beginning (e.g. one player captures the other player)

  void initState(){
    super.initState();
    buttonsList = doInit();
  }

  // Initializes the grid
  List<GameButton> doInit(){
    player1 = new List();
    player2 = new List();
    activePlayer = 1;
    List<GameButton> buttons = new List(400);
    for(int i = 0; i < buttons.length; i++){
      buttons[i] = new GameButton(id: i+1);
    }
    return buttons;
  }

  // when button is clicked
  void placeStone(GameButton gb)
  {
    int currentIndex = gb.id;
    print(currentIndex);
    idOnPlay = gb.id;
    setState(() {
      if(activePlayer == 1){
        gb.text = "";
        gb.bg = Colors.white;
        activePlayer = 2;
        player1.add(gb.id);
      }
      else{
        gb.text = "";
        gb.bg = Colors.black;
        activePlayer = 1;
        player2.add(gb.id);
      }
      gb.enabled = false;
      checkAround(currentIndex, 1,"");
    });
  }

  // send array of coordinates
  void Flip(){
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

  // pass in current point
  void checkAround(int index, int count, String skipDirection){
    var winner = -1;

    // if the stones wrap back around flip the area covered
    if(idOnPlay == index && count > 1){
      //call flip
      print("Found original node!!!");
      Flip();
      return;
    }
    print("checkAround"+count.toString());
    if(index >= 1 && index <= 20){
      // checks top row for white
      for(int i = 1; i <= 20; i++){
        if(player1.contains(i)){
          //top left corner
          if(index == 1){
            if(player1.contains(21)){
              //pass 21 for check
              count++;
              //checkAround(21, count);
              print("found exception");
            }
            if(index == 2){
              //pass 2 for check
              count++;
              //checkAround(2,count);
            }
          }
          //top right corner
          else if(index == 1){
            if(player1.contains(19)){
              //pass 19
              count++;
              //checkAround(19,count);
            }
            if(index == 40){
              //pass 40
            }
          }

          // it's not an exception therefore check current node
          // ... since you're in the if condition
          //checkAround(i);
        }
      }
    }


    if(index >= 380 && index <= 400){
      // checks bottom row for white
      for(int i = 380; i<400; i++){
        if(player1.contains(i)){
          if(player1.contains(360)){
            if(player1.contains(320)){
              //check 320
            }
            if(player1.contains(361)){
              //check 361
            }
          }
          if(player1.contains(400)){
            if(player1.contains(360)){
              //check 360
            }
            if(player1.contains(399)){
              //check 399
            }
          }
          // otherwise check current index
        }
      }
    }


    if(index >= 21 && index <=361){
      // check left column for white
      for(int i = 21; i < 361; i+=20){
        if(player1.contains(i)){
          // check i + 1
        }
      }
    }



    if(index >= 40 && index <= 360){

      // check right column for white
      for(int i = 40; i < 360; i += 20){
        if(player1.contains(i)){
          // check i - 1
        }
      }
    }


    if(index >= 22 && index <= 359){
      // check the inside border of white

          // check i + 1 , i - 1, i + 20, i - 20
          // diagonals
          // check i + 19 , i + 21, i - 19, i - 21
          //checkAround(i);


          if(player1.contains(index+20) && skipDirection != "No down"){
            checkAround(index+20,count+1,"No up");
          }
          if(player1.contains(index-20) && skipDirection != "No up"){
            checkAround(index-20, count+1,"No down");
          }
          if(player1.contains(index-1) && skipDirection != "No left"){
            checkAround(index-1, count+1, "No right");
          }
          if(player1.contains(index+1) && skipDirection != "No right"){
            checkAround(index+1,count+1, "No left");
          }


    }





//    if(player1.contains(1) && player1.contains(5) && player1.contains(9)){
//      winner = 1;
//    }
//    if(player2.contains(7) && player2.contains(8) && player2.contains(9)){
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
        itemCount: buttonsList.length,
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 20,
            childAspectRatio: 1,
            crossAxisSpacing: 1.0,
            mainAxisSpacing: 1.0
        ),
        itemBuilder: (context, i)=> new SizedBox(
          width: 100.0,
          height: 100.0,
          child: new RaisedButton(
            padding: const EdgeInsets.all(1.0),
            onPressed: buttonsList[i].enabled
                ?()=> placeStone(buttonsList[i])
                :null,
            child: new Text(
              buttonsList[i].text,
              style: new TextStyle(color: Colors.white, fontSize: 20.0),
            ),
            color: buttonsList[i].bg,
            disabledColor: buttonsList[i].bg,
          ),
        ),
      ),
    );
  }
}
