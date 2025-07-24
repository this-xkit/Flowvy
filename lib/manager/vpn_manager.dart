import 'package:flowvy/common/common.dart';
import 'package:flowvy/enum/enum.dart';
import 'package:flowvy/providers/app.dart';
import 'package:flowvy/providers/state.dart';
import 'package:flowvy/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VpnManager extends ConsumerStatefulWidget {
  final Widget child;

  const VpnManager({
    super.key,
    required this.child,
  });

  @override
  ConsumerState<VpnManager> createState() => _VpnContainerState();
}

class _VpnContainerState extends ConsumerState<VpnManager> {
  @override
  void initState() {
    super.initState();
    ref.listenManual(vpnStateProvider, (prev, next) {
      showTip();
    });
  }

  showTip() {
    debouncer.call(
      FunctionTag.vpnTip,
      () {
        if (ref.read(runTimeProvider.notifier).isStart) {
          globalState.showNotifier(
            appLocalizations.vpnTip,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
