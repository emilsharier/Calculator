import 'package:flutter/material.dart';

void main() => runApp(Calculator());

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  final List content = [
    "1",
    "2",
    "3",
    "+",
    "4",
    "5",
    "6",
    "-",
    "7",
    "8",
    "9",
    "*",
    "C",
    "0",
    ".",
    "/",
    "AC",
    "=",
  ];

  double result = 0;

  CustomStk obj = CustomStk();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Calculator"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.bottomRight,
                decoration: BoxDecoration(color: Colors.blue),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      result.toString(),
                      style: TextStyle(
                        fontSize: 45.0,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      obj.getExpr(),
                      style: TextStyle(
                        fontSize: 30.0,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 300.0,
              child: Column(
                  children: List.generate(5, (index) => _buildRows(index))),
            ),
          ],
        ),
      ),
    );
  }

  _buildRows(index) {
    if (index != 4)
      return Expanded(
        child: Row(
            children: List.generate(
                4, (buttonIndex) => _buildBtn(buttonIndex, index * 4))),
      );
    else
      return Expanded(
        child: Row(children: List.generate(2, (index) => _buildBtn(16, index))),
      );
  }

  _buildBtn(index, count) {
    String text = content[index + count];
    return Expanded(
      child: SizedBox.expand(
        child: OutlineButton(
          child: Text(
            text,
            style: TextStyle(fontSize: 25.0),
          ),
          onPressed: () {
            setState(() {
              if (text == "C") {
                obj.num1 = "";
                result = obj.pop();
              } else if (text == "AC")
                result = obj.clear();
              else if (text == "=") {
                result = obj.result;
                obj.clear();
                obj.cstStk.add(result.toString());
              } else
                result = obj.push(text);
            });
          },
        ),
      ),
    );
  }
}

class CustomStk {
  String num1 = "";
  double result = 0;
  int i;

  List oprs = ["+", "*", "-", "/"];
  List nmbrs =
      List.generate(11, (number) => (number == 10) ? "." : number.toString());

  List cstStk = [];
  List opnStk = [];
  List oprStk = [];
  List<double> rstStk = [];

  double push(item) {
    if (oprs.contains(item)) {
      (cstStk.isEmpty) ? cstStk.add("0") : 0;
      cstStk.add(item);
      num1 = "";
    } else if (nmbrs.contains(item)) {
      num1 += item;
      if (cstStk.isNotEmpty && !oprs.contains(cstStk.last)) cstStk.removeLast();
      cstStk.add(num1);
    }
    result = refractor();
    return result;
  }

  double refractor() {
    String currentItem = "";
    oprStk.clear();
    opnStk.clear();
    rstStk.clear();
    for (i = 0; i < cstStk.length; i++) {
      currentItem = cstStk[i];

      if (oprs.contains(currentItem)) {
        while (oprStk.isNotEmpty && highP(currentItem, oprStk.last)) {
          opnStk.add(oprStk.last);
          oprStk.removeLast();
        }
        oprStk.add(currentItem);
      } else
        opnStk.add(currentItem);
    }
    while (oprStk.isNotEmpty) {
      opnStk.add(oprStk.last);
      oprStk.removeLast();
    }
    for (i = 0; i < opnStk.length; i++) {
      currentItem = opnStk[i];

      if (oprs.contains(currentItem))
        doOperation(currentItem);
      else
        rstStk.add(double.parse(currentItem));
    }
    if (rstStk.length == 0)
      return 0;
    else
      return rstStk[0];
  }

  bool highP(item, topOfStk) {
    int currentP = getP(item);
    int tosP = getP(topOfStk);

    if (item == topOfStk) return false;

    if (tosP >= currentP)
      return true;
    else
      return false;
  }

  int getP(item) {
    switch (item) {
      case "*":
      case "/":
        return 2;
        break;
      case "+":
      case "-":
        return 1;
        break;
      default:
        return -1;
        break;
    }
  }

  doOperation(oprsymbol) {
    double num1, num2;
    if (rstStk.length == 1) return rstStk[0];

    num1 = rstStk.last;
    rstStk.removeLast();

    num2 = rstStk.last;
    rstStk.removeLast();

    switch (oprsymbol) {
      case "+":
        rstStk.add(num1 + num2);
        break;
      case "-":
        rstStk.add(num2 - num1);
        break;
      case "*":
        rstStk.add(num1 * num2);
        break;
      case "/":
        rstStk.add(num2 / num1);
        break;
      default:
        break;
    }
  }

  pop() {
    if (cstStk.isNotEmpty) {
      String tempString = cstStk.last;
      if (tempString.length == 1)
        cstStk.removeLast();
      else {
        tempString = tempString.substring(0, tempString.length - 1);
        cstStk.removeLast();
        cstStk.add(tempString);
      }
    }
    return refractor();
  }

  clear() {
    result = 0;
    num1 = "";
    cstStk.clear();
    opnStk.clear();
    oprStk.clear();
    rstStk.clear();
    return 0.0;
  }

  getExpr() {
    String temp = "";
    for (i = 0; i < cstStk.length; i++) temp += cstStk[i];
    return temp;
  }
}
