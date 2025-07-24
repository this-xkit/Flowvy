import 'package:flowvy/common/common.dart';
import 'package:flowvy/models/clash_config.dart';
import 'package:flowvy/providers/config.dart' show patchClashConfigProvider;
import 'package:flowvy/state.dart';
import 'package:flowvy/views/config/dns.dart';
import 'package:flowvy/views/config/general.dart';
import 'package:flowvy/views/config/network.dart';
import 'package:flowvy/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConfigView extends StatefulWidget {
  const ConfigView({super.key});

  @override
  State<ConfigView> createState() => _ConfigViewState();
}

class _ConfigViewState extends State<ConfigView> {
  @override
  Widget build(BuildContext context) {
    List<Widget> items = [
      ListItem.open(
        title: Text(appLocalizations.general),
        subtitle: Text(appLocalizations.generalDesc),
        leading: const Icon(Icons.build),
        delegate: OpenDelegate(
          title: appLocalizations.general,
          widget: generateListView(
            generalItems,
          ),
          blur: false,
        ),
      ),
      ListItem.open(
        title: Text(appLocalizations.network),
        subtitle: Text(appLocalizations.networkDesc),
        leading: const Icon(Icons.vpn_key),
        delegate: OpenDelegate(
          title: appLocalizations.network,
          blur: false,
          widget: const NetworkListView(),
        ),
      ),
      ListItem.open(
        title: const Text("DNS"),
        subtitle: Text(appLocalizations.dnsDesc),
        leading: const Icon(Icons.dns),
        delegate: OpenDelegate(
          title: "DNS",
          action: Consumer(builder: (_, ref, __) {
            return IconButton(
              onPressed: () async {
                final res = await globalState.showMessage(
                  title: appLocalizations.reset,
                  message: TextSpan(
                    text: appLocalizations.resetTip,
                  ),
                );
                if (res != true) {
                  return;
                }
                ref.read(patchClashConfigProvider.notifier).updateState(
                      (state) => state.copyWith(
                        dns: defaultDns,
                      ),
                    );
              },
              tooltip: appLocalizations.reset,
              icon: const Icon(
                Icons.replay,
              ),
            );
          }),
          widget: const DnsListView(),
          blur: false,
        ),
      )
    ];
    return generateListView(
      items
          .separated(
            const Divider(
              height: 0,
            ),
          )
          .toList(),
    );
  }
}
