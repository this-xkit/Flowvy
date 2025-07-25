import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flowvy/common/common.dart';
import 'package:flowvy/enum/enum.dart';
import 'package:flowvy/providers/providers.dart';
import 'package:flowvy/state.dart';

class StartButton extends ConsumerStatefulWidget {
  const StartButton({super.key});

  @override
  ConsumerState<StartButton> createState() => _StartButtonState();
}

class _StartButtonState extends ConsumerState<StartButton> {
  bool isStart = false;

  @override
  void initState() {
    super.initState();
    isStart = globalState.appState.runTime != null;

    ref.listenManual(
      runTimeProvider.select((state) => state != null),
      (prev, next) {
        if (next != isStart && mounted) {
          setState(() {
            isStart = next;
          });
        }
      },
      fireImmediately: true,
    );
  }

  void handleSwitchStart() {
    setState(() {
      isStart = !isStart;
    });
    debouncer.call(
      FunctionTag.updateStatus,
      () {
        globalState.appController.updateStatus(isStart);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(startButtonSelectorStateProvider);
    if (!state.isInit || !state.hasProfile) {
      return const SizedBox.shrink();
    }

    const buttonIcon = Icons.power_settings_new_outlined;

    final textStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: context.colorScheme.onPrimaryContainer,
        );

    final connectText = Text(
      appLocalizations.connect,
      style: textStyle,
      softWrap: false,
      overflow: TextOverflow.clip,
    );

    final timerConsumer = Consumer(
      builder: (_, ref, __) {
        final runTime = ref.watch(runTimeProvider);
        final text = utils.getTimeText(runTime);
        return Text(
          text,
          style: textStyle,
          softWrap: false,
          overflow: TextOverflow.clip,
        );
      },
    );

    final connectTextWidth =
        globalState.measure.computeTextSize(connectText).width;
    final runTime = ref.watch(runTimeProvider);
    final timerTextString = utils.getTimeText(runTime);
    final timerTextWidth = globalState.measure
        .computeTextSize(
          Text(timerTextString, style: textStyle),
        )
        .width;

    final targetWidth = isStart ? timerTextWidth : connectTextWidth;

    return FloatingActionButton.extended(
      heroTag: null,
      onPressed: handleSwitchStart,
      label: Row(
        children: [
          const Icon(buttonIcon),
          const SizedBox(width: 8),
          Padding(
            padding: const EdgeInsets.only(bottom: 2.5),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              width: targetWidth,
              alignment: Alignment.center,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: isStart ? timerConsumer : connectText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}