import 'package:flutter/material.dart';

void main() => runApp(Calculator());

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  List content = ["1","2","3","+","4","5","6","-","7","8","9","*","C","0",".","/","AC","="];
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
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildText(result.toString(), 45.0, Colors.white),
                    _buildText(obj.getExpr(), 30.0, Colors.white54),
                  ],
                ),
              ),
            ),
            Container(
              height: 300.0,
              child: Column(children: List.generate(5, (i) => _buildRows(i))),
            ),
          ],
        ),
      ),
    );
  }

  _buildText(text, size, color) {
    return Text(
      text,
      style: TextStyle(
        fontSize: size,
        color: color,
      ),
    );
  }

  _buildRows(i) {
    if (i != 4)
      return Expanded(
        child: Row(
            children: List.generate(4, (j) => _buildBtn(j, i * 4))),
      );
    else
      return Expanded(
        child: Row(children: List.generate(2, (i) => _buildBtn(16, i))),
      );
  }

  _buildBtn(i, count) {
    String text = content[i + count];
    return Expanded(
      child: SizedBox.expand(
        child: FlatButton(
          child: _buildText(text, 27.0, Colors.blueGrey),
          onPressed: () {
            setState(() {
              if (text == "C") {
                result = obj.pop();
              } else if (text == "AC"){
                obj.clear();
                result = 0.0;
              }
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
  List oprs = ["+","*","-","/"];
  List nmbrs = List.generate(11, (number) => (number == 10) ? "." : number.toString());
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
    result = recalc();
    return result;
  }

  double recalc() {
    String item = "";
    oprStk.clear();
    opnStk.clear();
    rstStk.clear();
    for (i = 0; i < cstStk.length; i++) {
      item = cstStk[i];
      if (oprs.contains(item)) {
        while (oprStk.isNotEmpty && highP(item, oprStk.last)) {
          opnStk.add(oprStk.last);
          oprStk.removeLast();
        }
        oprStk.add(item);
      } else
        opnStk.add(item);
    }
    while (oprStk.isNotEmpty) {
      opnStk.add(oprStk.last);
      oprStk.removeLast();
    }
    for (i = 0; i < opnStk.length; i++) {
      item = opnStk[i];
      if (oprs.contains(item)) doOperation(item);
      else rstStk.add(double.parse(item));
    }
    if (rstStk.isEmpty) return 0;
    else return rstStk[0];
  }

  bool highP(item, topOfStk) {
    int currentP = getP(item);
    int tosP = getP(topOfStk);

    if (item == topOfStk) return false;
    if (tosP >= currentP) return true;
    else return false;
  }

  int getP(item) {
    if (item == "*" || item == "/") return 2;
    else return 1;
  }

  doOperation(symbol) {
    double num1, num2;

    if (rstStk.length == 1) return rstStk[0];
    num1 = rstStk.last;
    rstStk.removeLast();
    num2 = rstStk.last;
    rstStk.removeLast();
    if (symbol == "+") rstStk.add(num1 + num2);
    else if (symbol =="-") rstStk.add(num2 - num1);
    else if (symbol == "*") rstStk.add(num1 * num2);
    else rstStk.add(num2 / num1);
  }

  pop() {
    num1 = "";
    if (cstStk.isNotEmpty) {
      String tmp = cstStk.last;
      if (tmp.length == 1) cstStk.removeLast();
      else {
        tmp = tmp.substring(0, tmp.length - 1);
        cstStk.removeLast();
        cstStk.add(tmp);
      }
    }
    return recalc();
  }

  clear() {
    if(rstStk.isNotEmpty) result = rstStk[0];
    num1 = "";
    cstStk.clear();
    opnStk.clear();
    oprStk.clear();
    rstStk.clear();
    return result;
  }

  getExpr() {
    String temp = "";
    for (i = 0; i < cstStk.length; i++) temp += cstStk[i];
    return temp;
  }
}
