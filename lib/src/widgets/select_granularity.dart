import 'package:dragger_survey/src/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dragger_survey/src/blocs/blocs.dart';

class SelectGranularity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MatrixGranularityBloc granularityBloc =
        Provider.of<MatrixGranularityBloc>(context);

    final _textStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Styles.drg_colorText,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text("Select granularity ", style: Styles.drg_selectButton),
        Container(
          width: 16,
        ),
        DropdownButton(
          style: _textStyle,
          value: granularityBloc.matrixGranularity,
          onChanged: (int newValue) {
            granularityBloc.setNewGranularity(granularity: newValue);
          },
          items: MatrixGranularityBloc.GRANULARITY
              .map<DropdownMenuItem<int>>((int value) {
            return DropdownMenuItem<int>(
              value: value,
              child: Text("$value"),
            );
          }).toList(),
        )
      ],
    );
  }
}
