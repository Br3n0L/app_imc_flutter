import 'package:app_imc_flutter/models/imc_model.dart';
import 'package:app_imc_flutter/pages/grid_imc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../repositories/imc_repository.dart';

class HomeApp extends StatefulWidget {
  const HomeApp({super.key});

  @override
  State<HomeApp> createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  late double width = MediaQuery.of(context).size.width;
  TextEditingController nomeController = TextEditingController();
  TextEditingController pesoController = TextEditingController();
  TextEditingController alturaController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ImcRepository imcRepository = ImcRepository();

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late final SharedPreferences prefs;
  @override
  void initState() {
    super.initState();
    initSharedPrefs();
  }

  initSharedPrefs() async {
    prefs = await _prefs;
    nomeController.text = prefs.getString("nome") ?? "";
    alturaController.text = prefs.getString("altura") ?? "";
  }

  _gravarImc(ImcModel model) async {
    await imcRepository.salvar(model);
  }

  Future<void> _calculate() async {
    ImcModel imcModel = ImcModel();
    imcModel.setId(0);
    imcModel.setDataCalculoIMC();
    imcModel.setPeso(double.parse(pesoController.text));
    imcModel.setAltura(double.parse(prefs.getString("altura")!) / 100);
    double imc =
        imcModel.getPeso() / (imcModel.getAltura() * imcModel.getAltura());
    imcModel.setIMC(imc);
    setState(() async {
      await _gravarImc(imcModel);
      pesoController.text = "";
    });
    FocusScope.of(context).unfocus();
  }

  void _storeSettings() {
    prefs.setString("nome", nomeController.text);
    prefs.setString("altura", alturaController.text);
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
                Text("Nome: ${prefs.getString("nome") ?? ""}"),
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

  _showAlertConfig(BuildContext context) {
    Widget salvarConfigButton = SizedBox(
      width: 100,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
        child: const Text("Salvar"),
        onPressed: () {
          _storeSettings();
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
        "Configurações",
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
                  Icons.settings,
                  size: 120.0,
                  color: Colors.green,
                ),
                TextFormField(
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    labelText: "Nome",
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
                  controller: nomeController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Insira seu Nome!";
                    } else {
                      prefs.setString("nome", value);
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
                      prefs.setString("altura", value);
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
        salvarConfigButton,
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
                setState(() {
                  _showAlertIMC(context);
                });
              },
              child: const Text("Calcular IMC"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () {
                _showAlertConfig(context);
              },
              child: const Text("Configurações"),
            ),
            const SizedBox(
              height: 40,
            ),
            SizedBox(
              width: width,
              child: const SingleChildScrollView(
                child: GridIMC(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
