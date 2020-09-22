import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'constants.dart';

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  String result = "";
  int operand1;
  int operand2;
  final List completedAnswersList = List.generate(
      9, (i) => List<int>.filled(9, 0, growable: false),
      growable: false);
  final LayerLink resultDisplayLink = LayerLink();

  @override
  void initState() {
    operand1 = Random().nextInt(8) + 2;
    operand2 = Random().nextInt(8) + 2;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Multiply Game'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // Multiplication Table widget
          Table(
            children: populateMultiplicationTable(),
          ),
          CompositedTransformTarget(
            link: resultDisplayLink,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '$operand1 x $operand2 = ',
                  style: TextStyle(
                    fontSize: 40.0,
                    color: Colors.purple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  result,
                  style: TextStyle(
                    fontSize: 40.0,
                    color: Colors.purple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                NumberpadButton(
                  child: Text('1'),
                  action: () {
                    setState(() {
                      updateResult('1');
                    });
                  },
                ),
                NumberpadButton(
                  child: Text('2'),
                  action: () {
                    setState(() {
                      updateResult('2');
                    });
                  },
                ),
                NumberpadButton(
                  child: Text('3'),
                  action: () {
                    setState(() {
                      updateResult('3');
                    });
                  },
                ),
                NumberpadButton(
                  child: Text('4'),
                  action: () {
                    setState(() {
                      updateResult('4');
                    });
                  },
                ),
                NumberpadButton(
                  child: Text('5'),
                  action: () {
                    setState(() {
                      updateResult('5');
                    });
                  },
                ),
                NumberpadButton(
                  child: Icon(FontAwesomeIcons.trashAlt),
                  action: () {
                    setState(() {
                      clearResult();
                    });
                  },
                  color: Color(0xFFE4242E),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                NumberpadButton(
                  child: Text('6'),
                  action: () {
                    setState(() {
                      updateResult('6');
                    });
                  },
                ),
                NumberpadButton(
                  child: Text('7'),
                  action: () {
                    setState(() {
                      updateResult('7');
                    });
                  },
                ),
                NumberpadButton(
                  child: Text('8'),
                  action: () {
                    setState(() {
                      updateResult('8');
                    });
                  },
                ),
                NumberpadButton(
                  child: Text('9'),
                  action: () {
                    setState(() {
                      updateResult('9');
                    });
                  },
                ),
                NumberpadButton(
                  child: Text('0'),
                  action: () {
                    setState(() {
                      updateResult('0');
                    });
                  },
                ),
                NumberpadButton(
                  child: Icon(FontAwesomeIcons.check),
                  action: () {
                    setState(() {
                      checkResult();
                    });
                  },
                  color: Color(0xFF51BD1F),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Populate the multiplication table
  List<TableRow> populateMultiplicationTable() {
    List<TableRow> table = List<TableRow>();

    for (int indexVertical = 1; indexVertical <= 9; indexVertical++) {
      final tableRow = List<Widget>();
      if (indexVertical == 1) {
        // Populate cells 2 to 9 of each row of multiplication table
        for (int indexHorizontal = 1; indexHorizontal <= 9; indexHorizontal++) {
          tableRow.add(
            Container(
              margin: EdgeInsets.all(1.0),
              padding: EdgeInsets.symmetric(vertical: 5.0),
              color: multiplierCellColor,
              child: Center(
                child: Text(
                  indexHorizontal.toString(),
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ),
          );
        }
      } else {
        tableRow.add(
          Container(
            margin: EdgeInsets.all(1.0),
            padding: EdgeInsets.symmetric(vertical: 5.0),
            color: Color(0xFF51BD1F),
            child: Center(
              child: Text(
                indexVertical.toString(),
                style: TextStyle(fontSize: 20.0),
              ),
            ),
          ),
        );
        // Populate cells 2 to 9 of each row of multiplication table
        for (int indexHorizontal = 2; indexHorizontal <= 9; indexHorizontal++) {
          tableRow.add(
            MTCell(
              x: indexVertical,
              y: indexHorizontal,
              solved: (completedAnswersList[indexHorizontal - 1]
                          [indexVertical - 1] ==
                      0)
                  ? false
                  : true,
            ),
          );
        }
      }
      table.add(TableRow(
        children: tableRow,
      ));
    }

    return table;
  }

  void updateResult(String enteredDigit) {
    if (result.length < 2 && enteredDigit.length == 1) {
      if (result.length == 0 && enteredDigit == '0') {
        return;
      }
      result += enteredDigit;
    }
  }

  void clearResult() {
    result = "";
  }

  void checkResult() {
    //TODO: Add hits and misses to display at the end
    if (int.parse(result) == operand1 * operand2) {
      showResult(context, true);
      print("The answer is correct.");
      completedAnswersList[operand2 - 1][operand1 - 1] = 1;

      do {
        operand1 = Random().nextInt(8) + 2;
        operand2 = Random().nextInt(8) + 2;
      } while (completedAnswersList[operand2 - 1][operand1 - 1] == 1);
    } else {
      showResult(context, false);
      print('The answer is not correct.');
      //TODO: Add an Overlay or Stack to show whether the result is correct
    }
    clearResult();
  }

  void showResult(BuildContext context, bool correct) async {
    //TODO: Check if renderBox is relevant here
    RenderBox renderBox = context.findRenderObject();
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);
    print(size.height.toString() + "w: " + size.width.toString());

    OverlayState overlayState = Overlay.of(context);
    OverlayEntry resultDisplay = OverlayEntry(
        builder: (context) => AnimatedPositioned(
              duration: Duration(seconds: 1),
              child: CompositedTransformFollower(
                // offset: Offset(
                //   0.0,
                //   size.height - 10.0,
                // ),
                link: resultDisplayLink,
                child: Text((correct) ? 'Yes!' : 'No...'),
              ),
            ));
    overlayState.insert(resultDisplay);

    await Future.delayed(Duration(seconds: 2));
    resultDisplay.remove();
  }
}

class NumberpadButton extends StatelessWidget {
  NumberpadButton({this.child, this.action, Color color}) {
    this.color = color == null ? Color(0xFFFF6D00) : color;
  }
  final Widget child;
  final Function action;
  Color color;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: action,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      fillColor: color,
      constraints: BoxConstraints.tightFor(width: 50.0, height: 50.0),
      elevation: 6.0,
      child: child,
    );
  }
}

class MTCell extends StatelessWidget {
  MTCell({
    @required this.x,
    @required this.y,
    @required this.solved,
  });
  final int x;
  final int y;
  final bool solved;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(1.0),
      padding: EdgeInsets.symmetric(vertical: 5.0),
      color: (solved) ? solvedCellColor : hiddenCellColor,
      child: Center(
        child: (solved)
            ? Text(
                (x * y).toString(),
                style: TextStyle(fontSize: 20.0),
              )
            : Text(""),
      ),
    );
  }
}
