import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _resultadoText = "Informe seus dados";

  void _resetFields() {
    weightController.text = "";
    heightController.text = "";
    setState(() {
      _resultadoText = "Informe seus dados";
      _formKey = GlobalKey<FormState>();
    });
  }

  FocusNode alturaFocusNode = new FocusNode();
  FocusNode calcularFocusNode = new FocusNode();

  void _calculate() {
    setState(() {
      double weight = double.parse(weightController.text);
      double height = double.parse(heightController.text) / 100;
      double imc = weight / (height * height);

      if (imc < 18.6) {
        _resultadoText = "Abaixo do peso";
      } else if (imc >= 18.6 && imc <= 25) {
        _resultadoText = "Peso ideal";
      } else if (imc > 25 && imc <= 30) {
        _resultadoText = "Levemente acima do peso";
      } else if (imc > 30 && imc <= 35) {
        _resultadoText = "Obesidade grau 2";
      } else if (imc > 35 && imc <= 40) {
        _resultadoText = "Obesidade grau 3";
      } else if (imc > 40) {
        _resultadoText = "Obesidade grau 4";
      }
      _resultadoText += " (${imc.toStringAsPrecision(4)})";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calculadora de IMC"),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _resetFields,
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Icon(
                Icons.person_outline,
                size: 120,
                color: Colors.indigo,
              ),
              TextFormField(
                controller: weightController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.indigo, fontSize: 25),
                maxLength: 4,
                decoration: InputDecoration(
                    labelText: "Peso (Kg)",
                    labelStyle: TextStyle(color: Colors.indigo)),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Insira seu peso";
                  }
                },
                onFieldSubmitted: (String value) {
                  FocusScope.of(context).requestFocus(alturaFocusNode);
                },
              ),
              TextFormField(
                focusNode: alturaFocusNode,
                controller: heightController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.indigo, fontSize: 25),
                maxLength: 3,
                decoration: InputDecoration(
                    labelText: "Altura (Cm)",
                    labelStyle: TextStyle(color: Colors.indigo)),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Insira sua altura";
                  }
                },
                onFieldSubmitted: (String value) {
                  if (_formKey.currentState.validate()) {
                    _calculate();
                  }
                },
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: Container(
                  height: 50,
                  child: RaisedButton(
                    focusNode: calcularFocusNode,
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _calculate();
                      }
                    },
                    child: Text(
                      "Calcular",
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                    color: Colors.indigo,
                  ),
                ),
              ),
              Text(
                _resultadoText,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.indigo, fontSize: 25),
              )
            ],
          ),
        ),
      ),
    );
  }
}
