import 'package:flutter/material.dart';

void main() => runApp(CalculatorBody());

class CalculatorBody extends StatefulWidget {
  @override
  _CalculatorBodyState createState() => _CalculatorBodyState();
}

class _CalculatorBodyState extends State<CalculatorBody> {
  final List<String> content = [
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

  CustomStk object = CustomStk();

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
                      object.getCurrentString(),
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
                4, (buttonIndex) => _buildButton(buttonIndex, index * 4))),
      );
    else
      return Expanded(
        child: Row(
          children: List.generate(2, (index) => _buildButton(16, index))
        ),
      );
  }

  _buildButton(int index, int count) {
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
                object.num1 = "";
                result = object.pop();
              } else if (text == "AC")
                result = object.clear();
              else if (text == "=") {
                result = object.result;
                object.clear();
              } else
                result = object.push(text);
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

  List<String> operators = ["+", "*", "-", "/"];
  List<String> numbers =
      List.generate(11, (number) => (number == 10) ? "." : number.toString());

  List<String> cstStk = [];
  List<String> opnStk = [];
  List<String> oprStk = [];
  List<double> rstStk = [];

  double push(String item) {
    if (operators.contains(item)) {
      (cstStk.isEmpty) ? cstStk.add("0") : 0;
      cstStk.add(item);
      num1 = "";
    } else if (numbers.contains(item)) {
      num1 += item;
      if (cstStk.isNotEmpty && !operators.contains(cstStk.last))
        cstStk.removeLast();
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

      if (operators.contains(currentItem)) {
        while (oprStk.isNotEmpty &&
            hasHigherPriority(currentItem, oprStk.last)) {
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

      if (operators.contains(currentItem))
        doOperation(currentItem);
      else
        rstStk.add(double.parse(currentItem));
    }
    if (rstStk.length == 0)
      return 0;
    else
      return rstStk[0];
  }

  bool hasHigherPriority(String item, String topOfStk) {
    int currentPriority = getPriority(item);
    int topOfStkPriority = getPriority(topOfStk);

    if (item == topOfStk) return false;

    if (topOfStkPriority >= currentPriority)
      return true;
    else
      return false;
  }

  int getPriority(item) {
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

  doOperation(String operatorSymbol) {
    double num1, num2;
    if (rstStk.length == 1) return rstStk[0];

    num1 = rstStk.last;
    rstStk.removeLast();

    num2 = rstStk.last;
    rstStk.removeLast();

    switch (operatorSymbol) {
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
    return result;
  }

  getCurrentString() {
    String temp = "";
    for (i = 0; i < cstStk.length; i++) temp += cstStk[i];
    return temp;
  }
}
