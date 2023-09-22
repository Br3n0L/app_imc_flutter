import 'package:flutter/material.dart';

import '../models/imc_model.dart';

class GridIMC extends StatefulWidget {
  final List<ImcModel> listImc;
  const GridIMC({super.key, required this.listImc});

  @override
  State<GridIMC> createState() => _GridIMCState();
}

class _GridIMCState extends State<GridIMC> {
  late double width = MediaQuery.of(context).size.width;

  int _sortColumnIndex = 0;
  bool _sortAscending = true;
  // List<ImcModel> listIMC = [];

  void updateSort(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;

      _sortAscending = ascending;
    });
  }

  List<DataColumn> _createColumns(List<ImcModel> items) {
    return [
      const DataColumn(
        label: Text("Ação"),
        numeric: false,
        tooltip: 'Ação',
      ),
      DataColumn(
        label: const SizedBox(
          width: 100,
          child: Text(
            'Data',
            textAlign: TextAlign.center,
          ),
        ),
        numeric: false, // Deliberately set to false to avoid right alignment.
        tooltip: 'Data',
        onSort: (int columnIndex, bool ascending) {
          if (ascending) {
            items.sort((item2, item1) =>
                item1.getDataCalculoIMC().compareTo(item2.getDataCalculoIMC()));
          } else {
            items.sort((item2, item1) =>
                item2.getDataCalculoIMC().compareTo(item1.getDataCalculoIMC()));
          }

          updateSort(columnIndex, ascending);
        },
      ),
      DataColumn(
        label: const SizedBox(
            width: 100, child: Text('Peso', textAlign: TextAlign.center)),
        numeric: false, // Deliberately set to false to avoid right alignment.
        tooltip: 'Peso',
        onSort: (int columnIndex, bool ascending) {
          if (ascending) {
            items.sort(
                (item1, item2) => item1.getPeso().compareTo(item2.getPeso()));
          } else {
            items.sort(
                (item1, item2) => item2.getPeso().compareTo(item1.getPeso()));
          }

          updateSort(columnIndex, ascending);
        },
      ),
      DataColumn(
        label: const SizedBox(
          width: 100,
          child: Text('Altura', textAlign: TextAlign.center),
        ),
        numeric: false,
        tooltip: 'Altura',
        onSort: (int columnIndex, bool ascending) {
          if (ascending) {
            items.sort((item1, item2) =>
                item1.getAltura().compareTo(item2.getAltura()));
          } else {
            items.sort((item1, item2) =>
                item2.getAltura().compareTo(item1.getAltura()));
          }

          updateSort(columnIndex, ascending);
        },
      ),
      DataColumn(
        label: const SizedBox(
          width: 100,
          child: Text('IMC', textAlign: TextAlign.center),
        ),
        numeric: false,
        tooltip: 'IMC',
        onSort: (int columnIndex, bool ascending) {
          if (ascending) {
            items.sort(
                (item1, item2) => item1.getIMC().compareTo(item2.getIMC()));
          } else {
            items.sort(
                (item1, item2) => item2.getIMC().compareTo(item1.getIMC()));
          }

          updateSort(columnIndex, ascending);
        },
      ),
    ];
  }

  DataRow _createRow(ImcModel item) {
    return DataRow(
      key: ValueKey(item.getId()),
      cells: [
        DataCell(
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: Colors.redAccent,
                ),
                onPressed: () {
                  _showAlertDelete(context, item.getId());
                },
                tooltip: "Deletar",
              )
            ],
          ),
        ),
        DataCell(
          SizedBox(
            width: 100, //SET width
            child: Text(item.getDataCalculoIMC().toString(),
                textAlign: TextAlign.center),
          ),
        ),
        DataCell(
          SizedBox(
            width: 100, //SET width
            child: Text(item.getPeso().toString(), textAlign: TextAlign.center),
          ),
        ),
        DataCell(
          SizedBox(
            width: 100, //SET width
            child:
                Text(item.getAltura().toString(), textAlign: TextAlign.center),
          ),
        ),
        DataCell(
          SizedBox(
            width: 100, //SET width
            child: Text(item.getIMC().toStringAsFixed(2),
                textAlign: TextAlign.center),
          ),
        ),
      ],
    );
  }

  Future<void> _deleteIMC(int data) async {
    setState(() {
      widget.listImc.removeWhere((element) => element.getId() == data);
    });
  }

  _showAlertDelete(BuildContext context, int data) {
    Widget excluirButton = SizedBox(
      width: 100.0,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
        child: const Text("Excluir"),
        onPressed: () {
          _deleteIMC(data);
          Navigator.of(context).pop();
        },
      ),
    );

    Widget cancelarButton = SizedBox(
      width: 100.0,
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
        "Deseja excluir o calculo do IMC?",
        style: TextStyle(fontSize: 18.0),
      ),
      content: const Text("Excluindo o calculo não será possível recuperá-lo."),
      actions: [
        excluirButton,
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

  Future<List<ImcModel>> _getListIMC() {
    return Future.delayed(const Duration(milliseconds: 10))
        .then((value) => value = widget.listImc);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ImcModel>>(
      future: _getListIMC(),
      builder: ((context, AsyncSnapshot<List<ImcModel>> snapshot) {
        final data = snapshot.data;
        if (snapshot.hasData ||
            data != null ||
            snapshot.connectionState == ConnectionState.done) {
          return SizedBox(
            width: width,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minWidth: width),
                      child: DataTable(
                        sortColumnIndex: _sortColumnIndex,
                        sortAscending: _sortAscending,
                        columnSpacing: 0,
                        dividerThickness: 5,
                        dataRowMaxHeight: 80,
                        dataTextStyle: const TextStyle(
                          fontStyle: FontStyle.normal,
                          color: Colors.black,
                        ),
                        headingRowColor: MaterialStateColor.resolveWith(
                            (states) => Colors.green),
                        headingRowHeight: 50,
                        headingTextStyle: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                        horizontalMargin: 10,
                        showBottomBorder: true,
                        showCheckboxColumn: false,
                        columns: _createColumns(data!),
                        rows: data.map((item) => _createRow(item)).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const SizedBox();
        }
      }),
    );
  }
}
