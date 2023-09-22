import 'package:app_imc_flutter/models/imc_model.dart';
import 'package:app_imc_flutter/pages/grid_imc.dart';
import 'package:flutter/material.dart';

class HomeApp extends StatefulWidget {
  const HomeApp({super.key});

  @override
  State<HomeApp> createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  List<ImcModel> listIMC = [];

  late double width = MediaQuery.of(context).size.width;
  TextEditingController pesoController = TextEditingController();
  TextEditingController alturaController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // model1.setPeso(84.5);
    // model1.setAltura(185);
    // model1.setDataCalculoIMC();
    // model1.setIMC(24.1);
    // listIMC.add(model1);
  }

  Future<void> _salvarIMC(ImcModel data) async {
    setState(() {
      listIMC.removeWhere((element) => element.getDataCalculoIMC() == data);
    });
  }

  void _calculate() {
    setState(() {
      ImcModel imcModel = ImcModel();
      imcModel.setId(listIMC.length + 1);
      imcModel.setDataCalculoIMC();
      imcModel.setPeso(double.parse(pesoController.text));
      imcModel.setAltura(double.parse(alturaController.text) / 100);
      double imc =
          imcModel.getPeso() / (imcModel.getAltura() * imcModel.getAltura());
      imcModel.setIMC(imc);
      listIMC.add(imcModel);
      pesoController.text = "";
      alturaController.text = "";
      // if (imc < 18.6) {
      //   _infoText = "Abaixo do Peso (${imc.toStringAsPrecision(4)})";
      // } else if (imc >= 18.6 && imc < 24.9) {
      //   _infoText = "Peso Ideal (${imc.toStringAsPrecision(4)})";
      // } else if (imc >= 24.9 && imc < 29.9) {
      //   _infoText = "Levemente Acima do Peso (${imc.toStringAsPrecision(4)})";
      // } else if (imc >= 29.9 && imc < 34.9) {
      //   _infoText = "Obesidade Grau I (${imc.toStringAsPrecision(4)})";
      // } else if (imc >= 34.9 && imc < 39.9) {
      //   _infoText = "Obesidade Grau II (${imc.toStringAsPrecision(4)})";
      // } else if (imc >= 39.9) {
      //   _infoText = "Obesidade Grau III (${imc.toStringAsPrecision(4)})";
      // }
    });
    FocusScope.of(context).unfocus();
  }

  _showAlertIMC(BuildContext context) {
    Widget salvarButton = SizedBox(
      width: 100,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
        child: const Text("Salvar"),
        onPressed: () {
          _calculate();
          Navigator.of(context).pop();
        },
      ),
    );

    Widget cancelarButton = SizedBox(
      width: 100,
      //height: 100.0,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
        child: const Text("Cancelar"),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );

    //configura o AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text(
        "Calcular IMC?",
        style: TextStyle(fontSize: 18.0),
      ),
      content: SizedBox(
        width: width,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.person_outline,
                  size: 120.0,
                  color: Colors.green,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Peso (kg)",
                    labelStyle: TextStyle(
                      color: Colors.green,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.green,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 130, 223, 133),
                      ),
                    ),
                  ),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 25.0,
                  ),
                  controller: pesoController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Insira seu Peso!";
                    } else {
                      return null;
                    }
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Altura (cm)",
                    labelStyle: TextStyle(
                      color: Colors.green,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.green,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 130, 223, 133),
                      ),
                    ),
                  ),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 25.0,
                  ),
                  controller: alturaController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Insira sua Altura!";
                    } else {
                      return null;
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        salvarButton,
        cancelarButton,
      ],
      actionsAlignment: MainAxisAlignment.spaceEvenly,
    );
    //exibe o diálogo
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calculadora de IMC"),
        centerTitle: true,
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                pesoController.text = "";
                alturaController.text = "";
                listIMC.clear();
              });
            },
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () {
                _showAlertIMC(context);
              },
              child: const Text("Calcular IMC"),
            ),
            const SizedBox(
              height: 40,
            ),
            SizedBox(
              width: width,
              child: SingleChildScrollView(
                child: GridIMC(listImc: listIMC),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
