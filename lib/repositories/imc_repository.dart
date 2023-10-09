import 'package:app_imc_flutter/models/imc_model.dart';
import 'package:app_imc_flutter/repositories/sqlite/sqlitedatabase.dart';

class ImcRepository {
  Future<List<ImcModel>> obterDados() async {
    List<ImcModel> listImcModel = [];
    var db = await SqliteDataBase().getDatabase();
    var result = await db.rawQuery(
        'SELECT id, nome, peso, altura, imc, datacalculoimc from imc');
    for (var element in result) {
      var imc = ImcModel();
      imc.setId(int.parse(element["id"].toString()));
      imc.setNome(element["nome"].toString());
      imc.setPeso(double.parse(element["peso"].toString()));
      imc.setAltura(double.parse(element["altura"].toString()));
      imc.setIMC(double.parse(element["imc"].toString()));
      imc.setDataCalculoIMCSqlite(element["datacalculoimc"].toString());

      listImcModel.add(imc);
    }
    return listImcModel;
  }

  Future<void> salvar(ImcModel model) async {
    var db = await SqliteDataBase().getDatabase();
    await db.rawInsert(
      'INSERT INTO imc (nome, peso, altura, imc, datacalculoimc) values(?,?,?,?,?)',
      [
        model.getNome(),
        model.getPeso(),
        model.getAltura(),
        model.getIMC(),
        model.getDataCalculoIMC()
      ],
    );
  }

  Future<void> alterar(ImcModel model) async {
    var db = await SqliteDataBase().getDatabase();
    await db.rawInsert(
      'UPDATE imc SET nome = ?, peso = ?, altura = ?, imc = ?, datacalculoimc = ? WHERE id = ?',
      [
        model.getNome(),
        model.getPeso(),
        model.getAltura(),
        model.getIMC(),
        model.getDataCalculoIMC(),
        model.getId()
      ],
    );
  }

  Future<void> deletar(int id) async {
    var db = await SqliteDataBase().getDatabase();
    await db.rawInsert(
      'DELETE from imc WHERE id = ?',
      [id],
    );
  }
}
