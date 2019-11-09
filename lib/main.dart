import 'package:flutter/material.dart';

void main() => runApp(CalculatorBody());

class CalculatorBody extends StatefulWidget {
  @override
  _CalculatorBodyState createState() => _CalculatorBodyState();
}

class _CalculatorBodyState extends State<CalculatorBody> {
  final List<String> contentOfButton = [
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
          title: Text("Calculator - beta"),
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
          children: [
            _buildButton(16, 0),
            _buildButton(17, 0),
          ],
        ),
      );
  }

  _buildButton(int index, int count) {
    String text = contentOfButton[index + count];
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

  List<String> customStk = [];
  List<String> operationStk = [];
  List<String> operatorStk = [];
  List<double> resultStk = [];

  double push(String item) {
    if (operators.contains(item)) {
      (customStk.isEmpty) ? customStk.add("0") : 0;
      customStk.add(item);
      num1 = "";
    } else if (numbers.contains(item)) {
      num1 += item;
      if (customStk.isNotEmpty && !operators.contains(customStk.last))
        customStk.removeLast();
      customStk.add(num1);
    }
    result = refractor();
    return result;
  }

  double refractor() {
    String currentItem = "";
    operatorStk.clear();
    operationStk.clear();
    resultStk.clear();
    for (i = 0; i < customStk.length; i++) {
      currentItem = customStk[i];

      if (operators.contains(currentItem)) {
        while (operatorStk.isNotEmpty &&
            hasHigherPriority(currentItem, operatorStk.last)) {
          operationStk.add(operatorStk.last);
          operatorStk.removeLast();
        }
        operatorStk.add(currentItem);
      } else
        operationStk.add(currentItem);
    }
    while (operatorStk.isNotEmpty) {
      operationStk.add(operatorStk.last);
      operatorStk.removeLast();
    }
    for (i = 0; i < operationStk.length; i++) {
      currentItem = operationStk[i];

      if (operators.contains(currentItem))
        doOperation(currentItem);
      else
        resultStk.add(double.parse(currentItem));
    }
    if (resultStk.length == 0)
      return 0;
    else
      return resultStk[0];
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
    if (resultStk.length == 1) return resultStk[0];

    num1 = resultStk.last;
    resultStk.removeLast();

    num2 = resultStk.last;
    resultStk.removeLast();

    switch (operatorSymbol) {
      case "+":
        resultStk.add(num1 + num2);
        break;
      case "-":
        resultStk.add(num2 - num1);
        break;
      case "*":
        resultStk.add(num1 * num2);
        break;
      case "/":
        resultStk.add(num2 / num1);
        break;
      default:
        break;
    }
  }

  pop() {
    if (customStk.length != 0) {
      String tempString = customStk.last;
      if (tempString.length == 1)
        customStk.removeLast();
      else {
        tempString = tempString.substring(0, tempString.length - 1);
        customStk.removeLast();
        customStk.add(tempString);
      }
    }
    return refractor();
  }

  clear() {
    result = 0;
    num1 = "";
    customStk.clear();
    operationStk.clear();
    operatorStk.clear();
    resultStk.clear();
    return result;
  }

  getCurrentString() {
    String temp = "";
    for (i = 0; i < customStk.length; i++) temp += customStk[i];
    return temp;
  }
}
