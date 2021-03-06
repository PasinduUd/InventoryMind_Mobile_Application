import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:inventory_mind/others/common_methods.dart';
import 'package:inventory_mind/others/urls.dart';
import 'package:inventory_mind/others/user_provider.dart';
import 'package:inventory_mind/widgets/loading.dart';
import 'package:inventory_mind/widgets/widget_methods.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class RequestDetails extends StatefulWidget {
  final String reqId;
  const RequestDetails({Key? key, required this.reqId}) : super(key: key);

  @override
  _RequestDetailsState createState() => _RequestDetailsState();
}

class _RequestDetailsState extends State<RequestDetails> {
  Map? _data;
  bool _loading = false;

  Future<Map> _loadData(BuildContext context) async {
    Map resBody = await getReq(context, Client(), lecViewReqURL + widget.reqId);
    return resBody["msg"];
  }

  Future<void> _respond(String url) async {
    setState(() => _loading = true);
    try {
      await postReqWithoutBody(Client(), url + widget.reqId);
      Fluttertoast.showToast(
        msg: "Successfully Responded",
        gravity: ToastGravity.BOTTOM,
      );
    } catch (e) {
      throw Exception("Loading Failed");
    } finally {
      setState(() => _loading = false);
      Navigator.pop(context);
    }
  }

  Widget _detailedCard(IconData icon, String title, String subtitle) {
    return Card(
      child: ListTile(
        leading: IconButton(icon: Icon(icon), onPressed: () {}),
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }

  Widget _tableHeaderText(String text) {
    return Center(
      child: Text(
        text,
        style: TextStyle(
          color: Colors.grey[500],
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _eqTable(Map _types) {
    List<TableRow> _rows = [
      TableRow(
        children: [
          TableCell(child: _tableHeaderText("Type")),
          TableCell(child: _tableHeaderText("Brand")),
          TableCell(child: _tableHeaderText("Total")),
        ],
      )
    ];
    _types.forEach((key, value) {
      _rows.add(
        TableRow(
          children: [
            TableCell(child: Center(child: Text(value["type"]))),
            TableCell(child: Center(child: Text(value["brand"]))),
            TableCell(child: Center(child: Text(value["count"].toString()))),
          ],
        ),
      );
    });
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Table(
        border: TableBorder.all(color: Colors.grey),
        children: _rows,
        columnWidths: const <int, TableColumnWidth>{2: FixedColumnWidth(60)},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context, "Request Details"),
      body: _loading
          ? Loading()
          : FutureBuilder(
              future: _loadData(context),
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return Loading();
                } else {
                  _data = snapshot.data as Map;
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: ListView(
                      children: <Widget>[
                        _detailedCard(
                            Icons.code, _data!["request_id"], "Request ID"),
                        _detailedCard(
                            Icons.person, _data!["student"], "Student's Name"),
                        _detailedCard(Icons.account_circle_outlined,
                            _data!["student_id"], "Index No."),
                        _detailedCard(Icons.next_plan,
                            _data!["date_of_borrowing"], "Date of Borrowing"),
                        _detailedCard(Icons.keyboard_return,
                            _data!["date_of_returning"], "Date of Returning"),
                        _detailedCard(
                            Icons.comment, _data!["reason"], "Reason"),
                        Card(
                          child: ListTile(
                            leading: IconButton(
                                icon: Icon(Icons.format_list_bulleted),
                                onPressed: () {}),
                            title: _eqTable(_data!["types"]),
                            subtitle: Container(
                              child: Text("Equipment Details"),
                              margin: EdgeInsets.only(bottom: 10),
                            ),
                          ),
                        ),
                        Consumer<UserProvider>(
                          builder: (context, userProvider, _) => ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton.icon(
                                  icon: Icon(Icons.check_circle_outline),
                                  label: Text("Approve"),
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.green),
                                  onPressed: () {
                                    _respond(approveReqURL);
                                    userProvider.approve(widget.reqId);
                                  },
                                ),
                                ElevatedButton.icon(
                                  icon: Icon(Icons.block),
                                  label: Text("Reject"),
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.red),
                                  onPressed: () {
                                    _respond(rejectReqURL);
                                    userProvider.reject(widget.reqId);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              }),
    );
  }
}
