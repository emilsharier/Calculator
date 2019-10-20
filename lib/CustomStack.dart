class CustomStack {
  String num1 = "";
  String symbol;
  String tempValue = "";

  double result = 0;
  double temp = 0;
  int i;
  int pos = 0;

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
        // operationStack.add(double.parse(num1));
        // operatorStack.add(item);
        if (customStack.isEmpty) {
          customStack.add("0");
        }
        customStack.add(item);
        num1 = "";

        break;
    }
    print("Custom Stack .....");
    print(customStack);

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
    print(operatorStack);
    while (operatorStack.isNotEmpty) {
      operationStack.add(operatorStack.last);
      print("Adding " + operatorStack.last);
      operatorStack.removeLast();
    }

    print("Operation stack ....");
    print(operationStack);

    for (i = 0; i < operationStack.length; i++) {
      currentItem = operationStack[i];

      switch (currentItem) {
        case "+":
          addNumbers();
          break;
        case "-":
          subtractNumbers();
          break;
        case "*":
          multiplyNumbers();
          break;
        case "/":
          divideNumbers();
          break;
          break;

        default:
          resultStack.add(double.parse(currentItem));
          break;
      }
    }
    print("\n");

    print("The result stack is .... ");
    print(resultStack);
    if (resultStack.length == 0) {
      return 0;
    } else {
      return resultStack[0];
    }
  }

  bool hasHigherPriority(String item, String topOfStack) {
    int currentPriority = -1;
    int topOfStackPriority = -1;

    if (item == topOfStack) {
      return false;
    }
    currentPriority = getPriority(item);
    topOfStackPriority = getPriority(topOfStack);

    if (topOfStackPriority >= currentPriority) {
      return true;
    } else {
      return false;
    }
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

  addNumbers() {
    double num1, num2;
    if (resultStack.length == 1) {
      return resultStack[0];
    }
    num1 = resultStack.last;
    resultStack.removeLast();

    num2 = resultStack.last;
    resultStack.removeLast();

    resultStack.add(num1 + num2);
  }

  subtractNumbers() {
    double num1, num2;
    if (resultStack.length == 1) {
      return resultStack[0];
    }
    num1 = resultStack.last;
    resultStack.removeLast();

    num2 = resultStack.last;
    resultStack.removeLast();

    resultStack.add(num2 - num1);
  }

  multiplyNumbers() {
    double num1, num2;
    if (resultStack.length == 1) {
      return resultStack[0];
    }
    num1 = resultStack.last;
    resultStack.removeLast();

    num2 = resultStack.last;
    resultStack.removeLast();

    resultStack.add(num1 * num2);
  }

  divideNumbers() {
    double num1, num2;
    if (resultStack.length == 1) {
      return resultStack[0];
    }
    num1 = resultStack.last;
    resultStack.removeLast();

    num2 = resultStack.last;
    resultStack.removeLast();

    resultStack.add(num2 / num1);
  }

  pop() {
    if (customStack.length == 0) {
      print("Stack is empty!");
    } else {
      customStack.removeLast();
      print("Popped from Stack!");
    }
    _viewCurrentStack();

    return refractor();
  }

  _viewCurrentStack() {
    print(customStack);
  }

  double getResult() {
    return 1;
  }

  getNum() {
    for (int i = 0; i < customStack.length; i++) {
      num1 += customStack[i];
    }
    result = double.parse(num1);
    customStack.clear();
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

  equalToFunction() {
    double temp = result;
    clear();
    return temp;
  }

  getCurrentString() {
    String temp = "";
    for (i = 0; i < customStack.length; i++) {
      temp += customStack[i];
    }

    return temp;
  }
}
