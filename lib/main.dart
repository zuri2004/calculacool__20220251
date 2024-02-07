import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
            .copyWith(secondary: Colors.orange),
      ),
      home: Calculadora(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Calculadora extends StatefulWidget {
  @override
  _CalculadoraState createState() => _CalculadoraState();
}

class _CalculadoraState extends State<Calculadora> {
  String displayText = '';
  double? firstOperand;
  String? operator;
  double? previousResult;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              displayText,
              style: const TextStyle(fontSize: 24.0),
            ),
          ),
          buildRow(['7', '8', '9', '/']),
          buildRow(['4', '5', '6', '*']),
          buildRow(['1', '2', '3', '-']),
          buildRow(['0', '.', '=', '+']),
          buildRow(['C', '⌫']),
        ],
      ),
    );
  }

  Widget buildRow(List<String> buttons) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buttons
          .map((buttonText) =>
              buildButton(buttonText, buttonText == '⌫' ? Icons.backspace : null))
          .toList(),
    );
  }

  Widget buildButton(String buttonText, IconData? icon) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            onButtonPressed(buttonText);
          },
          child: icon != null
              ? Icon(icon, size: 20.0)
              : Text(
                  buttonText,
                  style: const TextStyle(fontSize: 20.0),
                ),
        ),
      ),
    );
  }

  void onButtonPressed(String buttonText) {
    setState(() {
      if (buttonText == '=') {
        calculateResult();
      } else if (isNumeric(buttonText)) {
        displayText += buttonText;
      } else if (buttonText == '.') {
        if (!displayText.contains('.')) {
          displayText += buttonText;
        }
      } else if (buttonText == 'C') {
        clearDisplay();
      } else if (buttonText == '⌫') {
        onDeleteButtonPressed();
      } else {
        if (firstOperand != null && operator != null) {
          calculateResult();
        }
        firstOperand = double.parse(displayText);
        operator = buttonText;
        displayText = '';
      }
    });
  }

  void calculateResult() {
    if (firstOperand != null && operator != null && displayText.isNotEmpty) {
      double secondOperand = double.parse(displayText);
      switch (operator) {
        case '+':
          previousResult = firstOperand! + secondOperand;
          displayText = previousResult.toString();
          break;
        case '-':
          previousResult = firstOperand! - secondOperand;
          displayText = previousResult.toString();
          break;
        case '*':
          previousResult = firstOperand! * secondOperand;
          displayText = previousResult.toString();
          break;
        case '/':
          if (secondOperand != 0) {
            previousResult = firstOperand! / secondOperand;
            displayText = previousResult.toString();
          } else {
            displayText = 'Error';
          }
          break;
      }
    }
  }

  void clearDisplay() {
    setState(() {
      displayText = '';
      firstOperand = null;
      operator = null;
      previousResult = null;
    });
  }

  void onDeleteButtonPressed() {
    setState(() {
      if (displayText.isNotEmpty) {
        displayText = displayText.substring(0, displayText.length - 1);
      }
    });
  }

  bool isNumeric(String buttonText) {
    return double.tryParse(buttonText) != null;
  }
}
