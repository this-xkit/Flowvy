import 'dart:io';

import 'package:flowvy/common/common.dart';
import 'package:flowvy/state.dart';
import 'package:flutter/material.dart';
import 'package:screen_retriever/screen_retriever.dart';
import 'package:window_manager/window_manager.dart';

class Window {
  init(int version) async {
    final props = globalState.config.windowProps;
    final acquire = await singleInstanceLock.acquire();
    if (!acquire) {
      exit(0);
    }
    if (Platform.isWindows) {
      protocol.register("clash");
      protocol.register("clashmeta");
      protocol.register("flowvy");
    }
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = WindowOptions(
      size: Size(props.width, props.height),
      minimumSize: const Size(380, 400),
    );
    if (!Platform.isMacOS || version > 10) {
      await windowManager.setTitleBarStyle(TitleBarStyle.hidden);
    }
    if (!Platform.isMacOS) {
      final left = props.left ?? 0;
      final top = props.top ?? 0;
      final right = left + props.width;
      final bottom = top + props.height;
      if (left == 0 && top == 0) {
        await windowManager.setAlignment(Alignment.center);
      } else {
        final displays = await screenRetriever.getAllDisplays();
        final isPositionValid = displays.any(
          (display) {
            final displayBounds = Rect.fromLTWH(
              display.visiblePosition!.dx,
              display.visiblePosition!.dy,
              display.size.width,
              display.size.height,
            );
            return displayBounds.contains(Offset(left, top)) ||
                displayBounds.contains(Offset(right, bottom));
          },
        );
        if (isPositionValid) {
          await windowManager.setPosition(
            Offset(
              left,
              top,
            ),
          );
        }
      }
    }
    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.setPreventClose(true);
    });
  }

  show() async {
    render?.resume();
    await windowManager.show();
    await windowManager.focus();
    await windowManager.setSkipTaskbar(false);
  }

  Future<bool> get isVisible async {
    final value = await windowManager.isVisible();
    commonPrint.log("window visible check: $value");
    return value;
  }

  close() async {
    exit(0);
  }

  hide() async {
    render?.pause();
    await windowManager.hide();
    await windowManager.setSkipTaskbar(true);
  }
}

final window = system.isDesktop ? Window() : null;
