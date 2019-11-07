import 'package:calculator/CustomStack.dart';
import 'package:flutter/material.dart';

void main() => runApp(CalculatorBody());

class CalculatorBody extends StatefulWidget {
  @override
  _CalculatorBodyState createState() => _CalculatorBodyState();
}

class _CalculatorBodyState extends State<CalculatorBody> {
  String num1 = "";

  String num2 = "";

  String op = "";

  int num, temp;

  String calc = "";

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
          children: <Widget>[
            Expanded(
              child: Container(
                // height: 350,
                alignment: Alignment.bottomRight,
                decoration: BoxDecoration(color: Colors.blue),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
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
                        fontSize: 35.0,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 300.0,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        _buildButton("1"),
                        _buildButton("2"),
                        _buildButton("3"),
                        _buildButton("+"),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        _buildButton("4"),
                        _buildButton("5"),
                        _buildButton("6"),
                        _buildButton("-"),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        _buildButton("7"),
                        _buildButton("8"),
                        _buildButton("9"),
                        _buildButton("*"),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        _buildButton("<-"),
                        _buildButton("0"),
                        _buildButton("."),
                        _buildButton("/"),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        _buildButton("CLEAR"),
                        // Spacer(),
                        _buildButton("=")
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildButton(String text) {
    return Expanded(
      child: SizedBox.expand(
        child: OutlineButton(
          child: Text(
            text,
            style: TextStyle(fontSize: 25.0),
          ),
          onPressed: () {
            setState(() {
              if (text == "<-") {
                object.num1 = "";
                result = object.pop();
              } else if (text == "CLEAR") {
                result = object.clear();
              } else if (text == "=") {
                result = object.equalToFunction();
              } else {
                result = object.push(text);
                // result = object.getResult();
              }
            });
          },
        ),
      ),
    );
  }
}
