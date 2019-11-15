import 'package:flutter/material.dart';
import 'game_button.dart';
import 'custom_dialog.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<GameButton> buttonsList;

// var count;
  var white;
  var black;
  var activePlayer;
  var idOnPlay; // stores the current index of stone placed that way you know if the
  //path wraps back to the beginning (e.g. one player captures the other player)

  void initState(){
    super.initState();
    buttonsList = doInit();
  }

  // Initializes the grid
  List<GameButton> doInit(){
    white = new List();
    black = new List();
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
        white.add(gb.id);
        // testing
      }
      else{
        gb.text = "";
        gb.bg = Colors.black;
        activePlayer = 1;
        black.add(gb.id);
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

  bool foundOriginalNode = false;
  // pass in current point
  void checkAround(int index, int count, String skipDirection){
    var winner = -1;
    print("Top of check around" +count.toString());
    // if the stones wrap back around flip the area covered
    if(idOnPlay == index && count > 1){
      //call flip
      print("Found original node!!!");
      Flip();
      foundOriginalNode = true;
      return;
    }
    // after recursion set is created goes back up to the top and resets
    if(foundOriginalNode == true){
      foundOriginalNode = false;
    }
    if(foundOriginalNode == false){
      if(index >= 1 && index <= 20 && foundOriginalNode == false){

        //top left corner - white
        if(index == 1 && foundOriginalNode == false){
          if(white.contains(21) && skipDirection != "No down" && foundOriginalNode == false) {
            //pass 21 for check
            count++;
            checkAround(21, count, "No up");
          }
          if(white.contains(2) && skipDirection != "No right" && foundOriginalNode == false) {
            //pass 21 for check
            count++;
            checkAround(2, count, "No left");
          }
        }
        if(index == 2 && foundOriginalNode == false){
          if(white.contains(1) && skipDirection != "No left" && foundOriginalNode == false){
            count++;
            checkAround(1, count, "No right");
          }
          if(white.contains(21) && skipDirection != "No down left diagonal" && foundOriginalNode == false){
            count++;
            checkAround(21, count, "No up right diagonal");
          }
        }
        if(index == 21 && foundOriginalNode == false){
//          if(white.contains(31) && skipDirection != "No down" && foundOriginalNode == false){
//            count++;
//            checkAround(31, count, "No up");
//          }
          if(white.contains(1) && skipDirection != "No up" && foundOriginalNode == false){
            count++;
            checkAround(1, count, "No down");
          }
          //checks diagonal nodes
          if(white.contains(2) && skipDirection != "No up right diagonal" && foundOriginalNode == false){
            count++;
            checkAround(2, count, "No down left diagonal");
          }

        }
//          if(index == 22){ does this make sense
//            if(white.contains(22) && skipDirection != "No right"){
//              count++;
//              checkAround(22,count, "No left");
//            }
//          }



        //top right corner white
        if(index == 20 && foundOriginalNode == false){
          if(white.contains(19) && skipDirection != "No left" && foundOriginalNode == false){
            //pass 19
            count++;
            checkAround(19,count, "No right");
          }
          if(white.contains(40) && skipDirection != 'No down' && foundOriginalNode == false){
            count++;
            checkAround(40,count,"No up");
          }
        }
        if(index == 19 && foundOriginalNode == false){
          if(white.contains(20) && skipDirection != "No right" && foundOriginalNode == false){
            count++;
            checkAround(20,count,"No left");
          }
        }
        if(index == 40 && foundOriginalNode == false){
          if(white.contains(20) && skipDirection != "No up" && foundOriginalNode == false){
            count++;
            checkAround(20, count,"No down");
          }
        }



        //Checks the top row

        if(index >= 2 && index <= 19 && foundOriginalNode == false){
          if(white.contains(index-1) && skipDirection != "No left" && foundOriginalNode == false){
            count++;
            checkAround(index-1,count,"No right");
          }
          if(white.contains(index+1) && skipDirection != "No right" && foundOriginalNode == false){
            count++;
            checkAround(index+1,count,"No left");
          }
          if(white.contains(index+20) && skipDirection != "No down" && foundOriginalNode == false){
            count++;
            checkAround(index+20,count,"No up");
          }
        }

        // it's not an exception therefore check current node
        // ... since you're in the if condition
        //checkAround(i);

      }




      //bottom left corner white
      if(index == 381 && foundOriginalNode == false){
        if(white.contains(361) && skipDirection != "No up" && foundOriginalNode == false) {
          //pass 21 for check
          count++;
          checkAround(361, count, "No down");
        }
        if(white.contains(382) && skipDirection != "No right" && foundOriginalNode == false) {
          //pass 21 for check
          count++;
          checkAround(382, count, "No left");
        }
      }
      if(index == 361 && foundOriginalNode == false){
        if(white.contains(381) && skipDirection != "No down" && foundOriginalNode == false){
          count++;
          checkAround(381, count, "No up");
        }
      }
//        if(index == 362 && foundOriginalNode == false){
//          if(white.contains(361) && skipDirection != 'No left' && foundOriginalNode == false){
//            count++;
//            checkAround(361, count, "No right");
//          }
//        }




      //bottom right corner white
      if(index == 400 && foundOriginalNode == false){
        if(white.contains(399) && skipDirection != "No left" && foundOriginalNode == false){
          //pass 19
          count++;
          checkAround(399,count, "No right");
        }
        if(white.contains(380) && skipDirection != "No up" && foundOriginalNode == false) {
          count++;
          checkAround(380, count, "No down");
        }
      }
      if(index == 399 && foundOriginalNode == false){
        if(white.contains(400) && skipDirection != 'No right' && foundOriginalNode == false){
          count++;
          checkAround(400, count, "No left");
        }
      }
      if(index == 380 && foundOriginalNode == false){
        if(white.contains(400) && skipDirection != 'No up' && foundOriginalNode == false){
          count++;
          checkAround(400, count, "No down");
        }
      }

      // checks bottom row for white

      if(index >= 362 && index <= 398 && foundOriginalNode == false){
        if(white.contains(index-1) && skipDirection != "No left" && foundOriginalNode == false){
          count++;
          checkAround(index-1,count,"No right");
        }
        if(white.contains(index+1) && skipDirection != "No right" && foundOriginalNode == false){
          count++;
          checkAround(index+1,count,"No left");
        }
        if(white.contains(index-20) && skipDirection != "No up" && foundOriginalNode == false){
          count++;
          checkAround(index-20,count,"No down");
        }
      }





      if(index % 21 == 0 && foundOriginalNode == false && index != 21){
        // check left column for white

        if(white.contains(index+1) && skipDirection != "No right" && foundOriginalNode == false){
          count++;
          checkAround(index+1,count,"No left");
        }
        if(white.contains(index+20) && skipDirection != "No down" && foundOriginalNode == false){
          count++;
          checkAround(index+20,count,"No up");
        }
        if(white.contains(index-20) && skipDirection != "No up" && foundOriginalNode == false){
          count++;
          checkAround(index-20,count,"No down");
        }
      }



      if(index % 20 == 0 && foundOriginalNode == false && index != 20){

        // check right column for white

        if(white.contains(index-1) && skipDirection != "No left" && foundOriginalNode == false){
          count++;
          checkAround(index-1,count,"No right");
        }
        if(white.contains(index+20) && skipDirection != "No down" && foundOriginalNode == false){
          count++;
          checkAround(index+20,count,"No up");
        }
        if(white.contains(index-20) && skipDirection != "No up" && foundOriginalNode == false){
          count++;
          checkAround(index-20,count,"No down");
        }
      }


      //if(index >= 22 && index <= 359 && foundOriginalNode == false){
      // check the inside border of white

      // check i + 1 , i - 1, i + 20, i - 20
      // diagonals
      // check i + 19 , i + 21, i - 19, i - 21
      //checkAround(i);


      if(white.contains(index+20) && skipDirection != "No down" && foundOriginalNode == false){
        checkAround(index+20,count+1,"No up");
      }
      if(white.contains(index-20) && skipDirection != "No up" && foundOriginalNode == false){
        checkAround(index-20, count+1,"No down");
      }
      if(white.contains(index-1) && skipDirection != "No left" && foundOriginalNode == false){
        checkAround(index-1, count+1, "No right");
      }
      if(white.contains(index+1) && skipDirection != "No right" && foundOriginalNode == false){
        checkAround(index+1,count+1, "No left");
      }


      //}
    }

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

