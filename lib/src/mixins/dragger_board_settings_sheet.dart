// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../blocs/draggable_item_bloc.dart';
// import '../widgets/dragger_board_form.dart';

// mixin ShowSettingsSheet {
//   showSettingsSheet(context) {
//     final DraggableItemBloc draggableBloc =
//         Provider.of<DraggableItemBloc>(context);

//     //
//     // === BOTTOM SHEET ===
//     //
//     return showBottomSheet(
//         backgroundColor: Color(0xff662d00),
//         elevation: 16.0,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(40), topRight: Radius.zero),
//         ),
//         builder: (context) {
//           return Padding(
//             padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
//             child: Container(
//               height: 500,
//               child: ListView(
//                 scrollDirection: Axis.vertical,
//                 children: <Widget>[
//                   //
//                   // === DRAGGER BOARD with FORM ===
//                   //
//                   Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(35.0),
//                       color: Colors.orange.shade100,
//                     ),
//                     // height: 44,
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(
//                           vertical: 12, horizontal: 20),
//                       child: Column(
//                         children: <Widget>[
//                           DraggerBoardForm(),
//                         ],
//                       ),
//                     ),
//                   ),

//                   //
//                   // === RESET BUTTON ===
//                   //
//                   SizedBox(
//                     width: double.infinity,
//                     child: FlatButton(
//                       splashColor: Colors.blue,
//                       textColor: Colors.orange.shade800,
//                       child: Text("Board zurücksetzen"),
//                       onPressed: () {
//                         draggableBloc.resetDraggableItemPositon();
//                         Navigator.pop(context);
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//         context: context);
//   }
// }
