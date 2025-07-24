import 'dart:io';

import 'package:flowvy/plugins/app.dart';
import 'package:flowvy/state.dart';

class Android {
  init() async {
    app?.onExit = () async {
      await globalState.appController.savePreferences();
    };
  }
}

final android = Platform.isAndroid ? Android() : null;
