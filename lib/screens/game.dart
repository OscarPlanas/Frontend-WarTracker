import 'package:flutter/material.dart';
import 'package:frontend/models/usersplaceholder.dart';
import 'package:frontend/utils.dart';
import 'package:frontend/components/scrollable_widget.dart';
import 'package:frontend/components/text_dialog_widget.dart';
import 'package:frontend/sidebar.dart';
import 'package:frontend/constants.dart';

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late List<UserPlace> users;
  //var users;
  @override
  void initState() {
    super.initState();

    this.users = List.of(userList);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        drawer: Sidebar(),
        appBar: AppBar(
          iconTheme: IconThemeData(color: ButtonBlack),
          title: const Text(('Game'), style: TextStyle(color: ButtonBlack)),
          backgroundColor: Background,
        ),
        body: ScrollableWidget(child: buildDataTable()),
      );

  Widget buildDataTable() {
    final columns = ['Username', 'Alliance', 'Result'];

    return DataTable(
      columns: getColumns(columns),
      rows: getRows(users),
    );
  }

  List<DataColumn> getColumns(List<String> columns) {
    return columns.map((String column) {
      return DataColumn(label: Text(column));
    }).toList();
  }

  List<DataRow> getRows(List<UserPlace> users) => users.map((UserPlace user) {
        final cells = [user.username, user.name, user.email];

        return DataRow(
          cells: Utils.modelBuilder(cells, (index, cell) {
            final showEditIcon = index == 0 || index == 1 || index == 2;
            return DataCell(
              Text('$cell'),
              showEditIcon: showEditIcon,
              onTap: () {
                switch (index) {
                  case 0:
                    editFirstName(user);
                    break;
                }
              },
            );
          }),
        );
      }).toList();

  Future editFirstName(UserPlace editUser) async {
    final firstName = await showTextDialog(
      context,
      title: 'Change First Name',
      value: editUser.username,
    );
    /*setState(() => users = users.map((user) {
      final isEditedUser = user == editUser;

      return isEditedUser ? user.copy(firstName: firstName) : user;

    }).toList());*/
  }
}
