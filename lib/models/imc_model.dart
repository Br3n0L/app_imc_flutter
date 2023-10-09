import 'package:intl/intl.dart';

class ImcModel {
  int _id = 0;
  String _nome = "";
  double _peso = 0.0;
  double _altura = 0.0;
  double _imc = 0.0;
  String _dataCalculoIMC = "";

  void setId(int id) {
    _id = id;
  }

  int getId() {
    return _id;
  }

  void setNome(String nome) {
    _nome = nome;
  }

  String getNome() {
    return _nome;
  }

  void setPeso(double peso) {
    _peso = peso;
  }

  double getPeso() {
    return _peso;
  }

  void setAltura(double altura) {
    _altura = altura;
  }

  double getAltura() {
    return _altura;
  }

  void setIMC(double imc) {
    _imc = imc;
  }

  double getIMC() {
    return _imc;
  }

  void setDataCalculoIMC() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(now);
    _dataCalculoIMC = formattedDate;
  }

  void setDataCalculoIMCSqlite(String data) {
    _dataCalculoIMC = data;
  }

  String getDataCalculoIMC() {
    return _dataCalculoIMC;
  }
}
