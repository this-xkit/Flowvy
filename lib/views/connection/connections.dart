import 'dart:async';

import 'package:flowvy/clash/clash.dart';
import 'package:flowvy/common/common.dart';
import 'package:flowvy/enum/enum.dart';
import 'package:flowvy/models/models.dart';
import 'package:flowvy/providers/providers.dart';
import 'package:flowvy/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'item.dart';

class ConnectionsView extends ConsumerStatefulWidget {
  const ConnectionsView({super.key});

  @override
  ConsumerState<ConnectionsView> createState() => _ConnectionsViewState();
}

class _ConnectionsViewState extends ConsumerState<ConnectionsView>
    with PageMixin {
  final _connectionsStateNotifier = ValueNotifier<ConnectionsState>(
    const ConnectionsState(),
  );
  final ScrollController _scrollController = ScrollController(
    keepScrollOffset: false,
  );

  Timer? timer;

  @override
  List<Widget> get actions => [
        IconButton(
          onPressed: () async {
            clashCore.closeConnections();
            _connectionsStateNotifier.value =
                _connectionsStateNotifier.value.copyWith(
              connections: await clashCore.getConnections(),
            );
          },
          icon: const Icon(Icons.delete_sweep_outlined),
          tooltip: appLocalizations.delete_connections,
        ),
      ];

  @override
  get onSearch => (value) {
        _connectionsStateNotifier.value =
            _connectionsStateNotifier.value.copyWith(
          query: value,
        );
      };

  @override
  get onKeywordsUpdate => (keywords) {
        _connectionsStateNotifier.value =
            _connectionsStateNotifier.value.copyWith(keywords: keywords);
      };

  _updateConnections() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        _connectionsStateNotifier.value =
            _connectionsStateNotifier.value.copyWith(
          connections: await clashCore.getConnections(),
        );
        timer = Timer(Duration(seconds: 1), () async {
          _updateConnections();
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    ref.listenManual(
      isCurrentPageProvider(
        PageLabel.connections,
        handler: (pageLabel, viewMode) =>
            pageLabel == PageLabel.tools && viewMode == ViewMode.mobile,
      ),
      (prev, next) {
        if (prev != next && next == true) {
          initPageState();
        }
      },
      fireImmediately: true,
    );
    _updateConnections();
  }

  _handleBlockConnection(String id) async {
    clashCore.closeConnection(id);
    _connectionsStateNotifier.value = _connectionsStateNotifier.value.copyWith(
      connections: await clashCore.getConnections(),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    _connectionsStateNotifier.dispose();
    _scrollController.dispose();
    timer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ConnectionsState>(
      valueListenable: _connectionsStateNotifier,
      builder: (_, state, __) {
        final connections = state.list;
        if (connections.isEmpty) {
          return NullStatus(
            label: appLocalizations.emptyStateMessage,
          );
        }
        return CommonScrollBar(
          controller: _scrollController,
          child: ListView.separated(
            controller: _scrollController,
            itemBuilder: (_, index) {
              final connection = connections[index];
              return ConnectionItem(
                key: Key(connection.id),
                connection: connection,
                onClickKeyword: (value) {
                  context.commonScaffoldState?.addKeyword(value);
                },
                trailing: IconButton(
                  icon: const Icon(Icons.block),
                  onPressed: () {
                    _handleBlockConnection(connection.id);
                  },
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const Divider(
                height: 0,
              );
            },
            itemCount: connections.length,
          ),
        );
      },
    );
  }
}
