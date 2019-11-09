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

  CustomStack object = CustomStack();

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

class CustomStack {
  String num1 = "";
  double result = 0;
  int i;

  List<String> operators = ["+", "*", "-", "/"];

  List<String> customStack = [];
  List<String> operationStack = [];
  List<String> operatorStack = [];
  List<double> resultStack = [];

  double push(String item) {
    switch (item) {
      case "1":
      case "2":
      case "3":
      case "4":
      case "5":
      case "6":
      case "7":
      case "8":
      case "9":
      case "0":
      case ".":
        num1 += item;
        if (customStack.length != 0 &&
            customStack.last != "*" &&
            customStack.last != "-" &&
            customStack.last != "+" &&
            customStack.last != "/") {
          customStack.removeLast();
        }
        customStack.add(num1);

        break;
      case "+":
      case "-":
      case "*":
      case "/":
        (customStack.isEmpty) ? customStack.add("0") : 0;

        customStack.add(item);
        num1 = "";
        break;
    }
    result = refractor();
    return result;
  }

  double refractor() {
    String currentItem = "";
    operatorStack.clear();
    operationStack.clear();
    resultStack.clear();
    for (i = 0; i < customStack.length; i++) {
      currentItem = customStack[i];
      switch (currentItem) {
        case "+":
        case "-":
        case "*":
        case "/":
          while (operatorStack.isNotEmpty &&
              hasHigherPriority(currentItem, operatorStack.last)) {
            operationStack.add(operatorStack.last);
            operatorStack.removeLast();
          }
          operatorStack.add(currentItem);
          break;
        default:
          operationStack.add(currentItem);
          break;
      }
    }
    while (operatorStack.isNotEmpty) {
      operationStack.add(operatorStack.last);
      operatorStack.removeLast();
    }
    for (i = 0; i < operationStack.length; i++) {
      currentItem = operationStack[i];

      switch (currentItem) {
        case "+":
        case "-":
        case "*":
        case "/":
          doOperation(currentItem);
          break;

        default:
          resultStack.add(double.parse(currentItem));
          break;
      }
    }
    if (resultStack.length == 0)
      return 0;
    else
      return resultStack[0];
  }

  bool hasHigherPriority(String item, String topOfStack) {
    int currentPriority = getPriority(item);
    int topOfStackPriority = getPriority(topOfStack);

    if (item == topOfStack) return false;

    if (topOfStackPriority >= currentPriority)
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
    if (resultStack.length == 1) return resultStack[0];

    num1 = resultStack.last;
    resultStack.removeLast();

    num2 = resultStack.last;
    resultStack.removeLast();

    switch (operatorSymbol) {
      case "+":
        resultStack.add(num1 + num2);
        break;
      case "-":
        resultStack.add(num2 - num1);
        break;
      case "*":
        resultStack.add(num1 * num2);
        break;
      case "/":
        resultStack.add(num2 / num1);
        break;
      default:
        break;
    }
  }

  pop() {
    if (customStack.length != 0) {
      String tempString = customStack.last;
      if (tempString.length == 1)
        customStack.removeLast();
      else {
        tempString = tempString.substring(0, tempString.length - 1);
        customStack.removeLast();
        customStack.add(tempString);
      }
    }
    return refractor();
  }

  clear() {
    result = 0;
    num1 = "";
    customStack.clear();
    operationStack.clear();
    operatorStack.clear();
    resultStack.clear();
    return result;
  }

  getCurrentString() {
    String temp = "";
    for (i = 0; i < customStack.length; i++) temp += customStack[i];
    return temp;
  }
}
