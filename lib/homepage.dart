import 'package:flutter/material.dart';
import 'package:pixel_minesweeper/bomb.dart';
import 'package:pixel_minesweeper/gridbox.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int numberOfSquares = 9 * 9;
  int numberInEachRow = 9;
  var boxStatus = []; //[number of bombs around, true/false]
  final List<int> bombLocation = [
    1,
    2,
    3,
    11,
    26,
  ];

  bool bombsRevealed = false;

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < numberOfSquares; i++) {
      boxStatus.add([0, false]);
    }

    scanBombs();
  }

  void restartGame() {
    setState(() {
      bombsRevealed = false;
      for (int i = 0; i < numberOfSquares; i++) {
        boxStatus[i][1] = false;
      }
    });
  }

  void revealBoxNumbers(index) {
    if (boxStatus[index][0] != 0) {
      setState(() {
        boxStatus[index][1] = true;
      });
    } else if (boxStatus[index][0] == 0) {
      setState(() {
        boxStatus[index][1] = true;
        if (index % numberInEachRow != 0) {
          if (boxStatus[index - 1][0] == 0 &&
              boxStatus[index - 1][1] == false) {
            revealBoxNumbers(index - 1);
          }
          boxStatus[index - 1][1] = true;
        } //reveal all left 0 boxes
        if (index % numberInEachRow != 0 && index >= numberInEachRow) {
          if (boxStatus[index - 1 - numberInEachRow][0] == 0 &&
              boxStatus[index - 1 - numberInEachRow][1] == false) {
            revealBoxNumbers(index - 1 - numberInEachRow);
          }
          boxStatus[index - 1 - numberInEachRow][1] = true;
        } //reveal all top left 0 boxes
        if (index >= numberInEachRow) {
          if (boxStatus[index - numberInEachRow][0] == 0 &&
              boxStatus[index - numberInEachRow][1] == false) {
            revealBoxNumbers(index - numberInEachRow);
          }
          boxStatus[index - numberInEachRow][1] = true;
        } //reveal all top 0 boxes
        if (index >= numberInEachRow &&
            index % numberInEachRow != numberInEachRow - 1) {
          if (boxStatus[index + 1 - numberInEachRow][0] == 0 &&
              boxStatus[index + 1 - numberInEachRow][1] == false) {
            revealBoxNumbers(index + 1 - numberInEachRow);
          }
          boxStatus[index + 1 - numberInEachRow][1] = true;
        } //reveal all top right 0 boxes
        if (index % numberInEachRow != numberInEachRow - 1) {
          if (boxStatus[index + 1][0] == 0 &&
              boxStatus[index + 1][1] == false) {
            revealBoxNumbers(index + 1);
          }
          boxStatus[index + 1][1] = true;
        } //reveal all right boxes
        if (index % numberInEachRow != numberInEachRow - 1 &&
            index < numberOfSquares - numberInEachRow) {
          if (boxStatus[index + 1 + numberInEachRow][0] == 0 &&
              boxStatus[index + 1 + numberInEachRow][1] == false) {
            revealBoxNumbers(index + 1 + numberInEachRow);
          }
          boxStatus[index + 1 + numberInEachRow][1] = true;
        } //reveal all bottom right boxes
        if (index < numberOfSquares - numberInEachRow) {
          if (boxStatus[index + numberInEachRow][0] == 0 &&
              boxStatus[index + numberInEachRow][1] == false) {
            revealBoxNumbers(index + numberInEachRow);
          }
          boxStatus[index + numberInEachRow][1] = true;
        } //reveal all bottom boxes
        if (index < numberOfSquares - numberInEachRow &&
            index % numberInEachRow != 0) {
          if (boxStatus[index - 1 + numberInEachRow][0] == 0 &&
              boxStatus[index - 1 + numberInEachRow][1] == false) {
            revealBoxNumbers(index - 1 + numberInEachRow);
          }
          boxStatus[index - 1 + numberInEachRow][1] = true;
        } //reveal all bottom left boxes
      });
    }
  }

  void scanBombs() {
    for (int i = 0; i < numberOfSquares; i++) {
      int numberOfBombsAround = 0;

      if (bombLocation.contains(i - 1) && i % numberOfSquares != 0) {
        numberOfBombsAround++;
      } //left square

      if (bombLocation.contains(i - 1 - numberInEachRow) &&
          i % numberOfSquares != 0 &&
          i >= numberOfSquares) {
        numberOfBombsAround++;
      } // left top square

      if (bombLocation.contains(i - numberInEachRow) && i >= numberInEachRow) {
        numberOfBombsAround++;
      } // top

      if (bombLocation.contains(i + 1 - numberInEachRow) &&
          i % numberOfSquares != numberInEachRow - 1 &&
          i >= numberInEachRow) {
        numberOfBombsAround++;
      } // top right

      if (bombLocation.contains(i + 1) &&
          i % numberOfSquares != numberOfSquares - 1) {
        numberOfBombsAround++;
      } //right

      if (bombLocation.contains(i + 1 + numberInEachRow) &&
          i % numberOfSquares != numberOfSquares - 1 &&
          i < numberOfSquares - numberInEachRow) {
        numberOfBombsAround++;
      } //bottom right

      if (bombLocation.contains(i + numberInEachRow) &&
          i < numberOfSquares - numberInEachRow) {
        numberOfBombsAround++;
      } //bottom

      if (bombLocation.contains(i - 1 - numberInEachRow) &&
          i % numberOfSquares != 0 &&
          i < numberOfSquares - numberInEachRow) {
        numberOfBombsAround++;
      } // bottom left

      setState(() {
        boxStatus[i][0] = numberOfBombsAround;
      });
    }
  }

  void playerLost() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.grey[900],
            title: Center(
              heightFactor: 1,
              child: Text(
                'YOU LOST!',
                style: TextStyle(color: Colors.blueAccent),
              ),
            ),
            content: Center(
              heightFactor: 1,
              child: Text(
                'Replay?',
                style: TextStyle(color: Colors.blueAccent),
              ),
            ),
            actions: [
              Center(
                heightFactor: 0.6,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blueAccent,
                    onPrimary: Colors.black,
                  ),
                  child: Icon(Icons.replay_circle_filled_outlined),
                  onPressed: () {
                    restartGame();
                    Navigator.pop(context);
                  },
                ),
              )
            ],
          );
        });
  }

  void checkWin() {
    int unrevealedBoxes = 0;

    for (int i = 0; i < numberOfSquares; i++) {
      if (boxStatus[i][1] == false) {
        unrevealedBoxes++;
      }
    }

    if (unrevealedBoxes == bombLocation.length) {
      playerWon();
    }
  }

  void playerWon() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.grey[900],
            title: Center(
              heightFactor: 1,
              child: Text(
                'CONGRATS! YOU WON!',
                style: TextStyle(color: Colors.blueAccent),
              ),
            ),
            content: Center(
              heightFactor: 1,
              child: Text(
                'Replay?',
                style: TextStyle(color: Colors.blueAccent),
              ),
            ),
            actions: [
              Center(
                heightFactor: 0.6,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blueAccent,
                    onPrimary: Colors.black,
                  ),
                  child: Icon(Icons.replay_circle_filled_outlined),
                  onPressed: () {
                    restartGame();
                    Navigator.pop(context);
                  },
                ),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueAccent[100],
        body: Column(
          children: [
            Container(
              height: 150,
              color: Colors.blueAccent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        bombLocation.length.toString(),
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Bombs',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: restartGame,
                    child: Card(
                      child: Icon(
                        Icons.replay_circle_filled_outlined,
                        size: 40,
                      ),
                      color: Colors.blueAccent,
                      elevation: 10,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '0',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Time',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: numberOfSquares,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: numberInEachRow),
                  itemBuilder: (context, index) {
                    if (bombLocation.contains(index)) {
                      return MyBomb(
                        revealed: bombsRevealed,
                        function: () {
                          setState(() {
                            bombsRevealed = true;
                          });
                          playerLost();
                        },
                      );
                    } else {
                      return GridBox(
                        params: boxStatus[index][0],
                        revealed: boxStatus[index][1],
                        function: () {
                          revealBoxNumbers(index);
                          checkWin();
                        },
                      );
                    }
                  }),
            ),
            //Padding(padding: const EdgeInsets.only(bottom: 40.0),
            //child: ,)
          ],
        ));
  }
}
