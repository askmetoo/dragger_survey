import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../blocs/draggable_item_bloc.dart';
import '../mixins/dragger_board_settings_sheet.dart';

class DraggerBoardButtonRow extends StatelessWidget {
  const DraggerBoardButtonRow({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          SizedBox(
            width: double.infinity,
            child: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              color: Colors.orangeAccent,
              textColor: Color(0xff662d00),
              child: Text("Ergebnis speichern"),
              onPressed: () {},
            ),
          ),
          Container(
            height: 30,
          ),
        ],
      ),
    );
  }
}
