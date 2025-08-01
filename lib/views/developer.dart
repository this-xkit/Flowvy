import 'package:flowvy/clash/core.dart';
import 'package:flowvy/common/common.dart';
import 'package:flowvy/enum/enum.dart';
import 'package:flowvy/models/common.dart';
import 'package:flowvy/providers/config.dart';
import 'package:flowvy/state.dart';
import 'package:flowvy/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/app.dart';

class DeveloperView extends ConsumerWidget {
  const DeveloperView({super.key});

  Widget _getDeveloperList(BuildContext context, WidgetRef ref) {
    return generateSectionV2(
      title: appLocalizations.options,
      items: [
        ListItem(
          title: Text(appLocalizations.messageTest),
          onTap: () {
            context.showNotifier(
              appLocalizations.messageTestTip,
            );
          },
        ),
        ListItem(
          title: Text(appLocalizations.logsTest),
          onTap: () {
            for (int i = 0; i < 1000; i++) {
              ref.read(requestsProvider.notifier).addRequest(Connection(
                    id: utils.id,
                    start: DateTime.now(),
                    metadata: Metadata(
                      uid: i * i,
                      network: utils.generateRandomString(
                        maxLength: 1000,
                        minLength: 20,
                      ),
                      sourceIP: '',
                      sourcePort: '',
                      destinationIP: '',
                      destinationPort: '',
                      host: '',
                      process: '',
                      remoteDestination: "",
                    ),
                    chains: ["chains"],
                  ));
              globalState.appController.addLog(
                Log.app(
                  utils.generateRandomString(
                    maxLength: 200,
                    minLength: 20,
                  ),
                ),
              );
            }
          },
        ),
        ListItem(
          title: Text(appLocalizations.crashTest),
          onTap: () {
            clashCore.clashInterface.crash();
          },
        ),
        ListItem(
          title: Text(appLocalizations.clearData),
          onTap: () async {
            await globalState.appController.handleClear();
          },
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context, ref) {
    final enable = ref.watch(
      appSettingProvider.select(
        (state) => state.developerMode,
      ),
    );
    return SingleChildScrollView(
      padding: baseInfoEdgeInsets,
      child: Column(
        children: [
          CommonCard(
            type: CommonCardType.filled,
            radius: 18,
            child: ListItem.switchItem(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
              ),
              title: Text(appLocalizations.developerMode),
              delegate: SwitchDelegate(
                value: enable,
                onChanged: (value) {
                  ref.read(appSettingProvider.notifier).updateState(
                        (state) => state.copyWith(
                          developerMode: value,
                        ),
                      );
                },
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          _getDeveloperList(context, ref)
        ],
      ),
    );
  }
}
