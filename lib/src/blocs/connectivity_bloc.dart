import 'dart:async';

import 'package:dragger_survey/src/enums/connectivity_status.dart';
import 'package:dragger_survey/src/services/services.dart';
import 'package:flutter/material.dart';

class ConnectivityBloc extends ChangeNotifier {

  StreamController<ConnectivityStatus> get connectivityStatus {
    return ConnectivityService().connectionStatusController;
  } 

}