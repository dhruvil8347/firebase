import 'package:flutter/material.dart';

class Listcompany extends StatefulWidget {
  const Listcompany({Key? key}) : super(key: key);

  @override
  State<Listcompany> createState() => _ListcompanyState();
}

class _ListcompanyState extends State<Listcompany> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Table(
        border: TableBorder.all(),
        columnWidths: const <int, TableColumnWidth>{1: FixedColumnWidth(140)},
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          TableRow(
              children: [
            TableCell(
                child: Container(
                    color: Colors.lightGreenAccent,
                    child: const Center(
                        child: Text(
                      "Name",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    )))),
            TableCell(
                child: Container(
                    color: Colors.lightGreenAccent,
                    child: const Center(
                        child: Text(
                          "Email",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        )
                    )
                )
            ),
            TableCell(
                child: Container(
                    color: Colors.lightGreenAccent,
                    child: const Center(
                        child: Text(
                          "Action",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        )))),
          ]),
          const TableRow(
              children: [
                TableCell(
                    child:Center(
                        child: Text(
                          "dhruvil"
                        ))),
                TableCell(
                    child: Center(
                        child: Text(
                          "dhruv@gmail.com"
                        )
                    )
                ),
                TableCell(
                    child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.edit),
                            Icon(Icons.delete),
                          ],
                        )
                    )),
              ])
        ],
      ),
    );
  }
}
