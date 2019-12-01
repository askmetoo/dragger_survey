import 'dart:developer';

import 'package:dragger_survey/src/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:dragger_survey/src/styles.dart';
import 'package:provider/provider.dart';

class BuildFurtherFormFieldsCollapse extends StatefulWidget {
  final FocusNode fourthFocus, fifthFocus, sixthFocus;

  BuildFurtherFormFieldsCollapse(
    this.fourthFocus,
    this.fifthFocus,
    this.sixthFocus,
  ) : super();

  @override
  _BuildFurtherFormFieldsCollapseState createState() =>
      _BuildFurtherFormFieldsCollapseState();
}

class _BuildFurtherFormFieldsCollapseState
    extends State<BuildFurtherFormFieldsCollapse> with TickerProviderStateMixin {
  double _animatedHeight = 40;
  bool _resized = false;
  double _angle = 0;

  @override
  Widget build(BuildContext context) {
    final PrismSurveySetBloc prismSurveySetBloc =
        Provider.of<PrismSurveySetBloc>(context);

    return GestureDetector(
      onTap: () {
        onTapAnimatedSizeAction();
      },
      child: Container(
        margin: EdgeInsetsDirectional.only(top: 8),
        child: AnimatedSize(
          alignment: Alignment.topLeft,
          child: Container(
            height: _animatedHeight,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 2),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Flexible(
                            flex: 2,
                            child: Transform.rotate(
                              angle: _angle,
                              child: Icon(
                                Icons.keyboard_arrow_right,
                                color: Styles.color_Text,
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 18,
                            child: Text(
                              "Add further descriptions",
                              style: TextStyle(
                                fontSize: Styles.fontSize_FloatingLabel,
                                fontWeight: FontWeight.w600,
                                color: Styles.color_Primary,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: TextFormField(
                      minLines: 1,
                      maxLines: 4,
                      maxLength: 180,
                      focusNode: widget.fourthFocus,
                      onEditingComplete: () => FocusScope.of(context)
                          .requestFocus(widget.fifthFocus),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        isDense: true,
                        labelStyle: TextStyle(
                          fontSize: Styles.fontSize_FloatingLabel,
                          color: Styles.color_Primary,
                          fontWeight: FontWeight.w700,
                        ),
                        labelText: "Survey set description",
                        hintText: "The description of the prism survey",
                      ),
                      onChanged: (value) {
                        prismSurveySetBloc.setDescription(value);
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: TextFormField(
                      focusNode: widget.fifthFocus,
                      onEditingComplete: () => FocusScope.of(context)
                          .requestFocus(widget.sixthFocus),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                          fontSize: Styles.fontSize_FloatingLabel,
                          color: Styles.color_Primary,
                          fontWeight: FontWeight.w700,
                        ),
                        isDense: true,
                        labelText: "X-axis desciption",
                        hintText: "What does the x-axis stand for",
                      ),
                      // initialValue: attribute,
                      onChanged: (value) {
                        prismSurveySetBloc.setXDescription(value);
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: TextFormField(
                      focusNode: widget.sixthFocus,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                            fontSize: Styles.fontSize_FloatingLabel,
                            color: Styles.color_Primary,
                            fontWeight: FontWeight.w700),
                        isDense: true,
                        labelText: "Y-axis desciption",
                        hintText: "What does the y-axis stand for",
                      ),
                      onChanged: (value) =>
                          prismSurveySetBloc.setYDescription(value),
                    ),
                  ),
                ],
              ),
            ),
          ),
          vsync: this,
          duration: Duration(milliseconds: 400),
        ),
      ),
    );
  }

  void onTapAnimatedSizeAction() {
    if (_resized) {
      log("Animated box tapped in _resized");
      setState(() {
        _resized = false;
        _animatedHeight = 40;
        _angle = 0;
      });
    } else {
      log("Animated box tapped in NOT _resized");
      setState(() {
        _resized = true;
        _animatedHeight = 240;
        _angle = 1.5;
      });
    }
  }
}