import 'package:flutter/material.dart';
import 'package:inventory_mind/lecturer/responded_details.dart';
import 'package:inventory_mind/widgets/widget_methods.dart';

import 'lecturer_widgets/lecturer_navigation_drawer.dart';

class AcceptedRequests extends StatelessWidget {
  const AcceptedRequests({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: LecturerNavigationDrawer(),
      appBar: getAppBar(context, "Accepted Requests"),
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            margin: EdgeInsets.all(10),
            elevation: 5,
            child: ListTile(
              leading: TextButton(
                child: Text(index.toString()),
                onPressed: () {},
              ),
              title: Text("Borrowing : 2021/10/10"),
              subtitle: Text("Returning : 2021/10/15"),
              trailing:
                  lecturerRequestsListTieIcon(context, RespondedDetails()),
            ),
          );
        },
      ),
    );
  }
}
