import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // VARIAVEIS
  final _contaTotal = TextEditingController();
  final _qntPessoas = TextEditingController();
  final _naoBebem = TextEditingController();
  final _bebem = TextEditingController();
  final _valorBebidas = TextEditingController();
  double _porcentagemGarcom = 10;

  var _infoText = "";
  var _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sua Conta Facil"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.refresh),
              onPressed: _resetFields)
        ],
      ),
      body: _body(),
    );
  }

  // PROCEDIMENTO PARA LIMPAR OS CAMPOS
  void _resetFields() {
    _contaTotal.text = "";
    _qntPessoas.text = "";
    _valorBebidas.text = "";
    setState(() {
      _infoText = "";
      _formKey = GlobalKey<FormState>();
    });
  }

  _body() {
    return SingleChildScrollView(
        padding: EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _editText("Total da conta", _contaTotal),
              _editText("Quantidade de pessoas", _qntPessoas),

              Text("\n\nPorcentagem do Garçom:", style: TextStyle(color: Colors.lightBlueAccent, fontSize: 23.0)),
              Slider(value: _porcentagemGarcom,
                 min:0,
                 max:100,
                 divisions: 20,
                 label: _porcentagemGarcom.round().toString(),
                 onChanged: (double value ){
                    setState(() {
                      _porcentagemGarcom=value.roundToDouble();
                    });
                }
                ),
            //print("Valor selecionado: " + valor.toString());

              _editText("Digite o valor total das bebidas:", _valorBebidas),
              _editText("Quantidade de pessoas que bebem", _bebem),
              _editText("Quantidade de pessoas que não bebem", _naoBebem),

              _buttonCalcular(),
              _textInfo(),
            ],
          ),


        ));
  }

  // Widget text
  _editText(String field, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      validator: (s) => _validate(s, field),
      keyboardType: TextInputType.number,
      style: TextStyle(
        fontSize: 22,
        color: Colors.lightBlueAccent,
      ),
      decoration: InputDecoration(
        labelText: field,
        labelStyle: TextStyle(
          fontSize: 22,
          //fontWeight: FontWeight.bold,
          color: Colors.lightBlueAccent,
        ),
      ),
    );
  }

  // PROCEDIMENTO PARA VALIDAR OS CAMPOS
  String _validate(String text, String field) {
    if (text.isEmpty) {
      return "Digite $field";
    }
    return null;
  }

  // Widget button
  _buttonCalcular() {
    return Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 20),
      height: 45,
      child: RaisedButton(
        color: Colors.brown,
        child:
        Text(
          "Calcular",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _calculate();
          }
        },
      ),
    );
  }

  // PROCEDIMENTO PARA CALCULAR OS VALORES
  void _calculate() {
    setState(() {

      double _valorG = double.parse(_contaTotal.text) * _porcentagemGarcom / 100;
      double total = double.parse(_contaTotal.text) + _porcentagemGarcom;
      double _valorIndividualNaoBebem = ( total - double.parse(_valorBebidas.text)) / double.parse(_qntPessoas.text);
      double _valorIndividualBebem = ((_valorIndividualNaoBebem * double.parse(_bebem.text)) + double.parse(_valorBebidas.text)) / double.parse(_bebem.text);
      String resultado = "Valor do Garçom :                                   R\$ " + _valorG.toStringAsPrecision(4) +
          "\n\nValor Total:                                                   R\$ " + total.toStringAsPrecision(4) +
          "\n\nValor Individual de quem não bebe:                             R\$ " + _valorIndividualNaoBebem.toStringAsPrecision(4) +
          "\n\nValor Individual de quem bebe:                                 R\$ " + _valorIndividualBebem.toStringAsPrecision(4);
      _infoText = resultado;
    });
  }

  // // Widget text
  _textInfo() {
    return Text(
      _infoText,
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.brown, fontSize: 25.0, fontWeight: FontWeight.bold),
    );
  }


}