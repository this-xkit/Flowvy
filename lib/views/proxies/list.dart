import 'dart:math';

import 'package:flowvy/common/common.dart';
import 'package:flowvy/enum/enum.dart';
import 'package:flowvy/models/models.dart';
import 'package:flowvy/providers/app.dart';
import 'package:flowvy/providers/config.dart';
import 'package:flowvy/providers/state.dart';
import 'package:flowvy/state.dart';
import 'package:flowvy/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'card.dart';
import 'common.dart';

typedef GroupNameProxiesMap = Map<String, List<Proxy>>;

class ProxiesListView extends StatefulWidget {
  const ProxiesListView({super.key});

  @override
  State<ProxiesListView> createState() => _ProxiesListViewState();
}

class _ProxiesListViewState extends State<ProxiesListView> {
  final _controller = ScrollController();
  final _headerStateNotifier = ValueNotifier<ProxiesListHeaderSelectorState>(
    const ProxiesListHeaderSelectorState(
      offset: 0,
      currentIndex: 0,
    ),
  );
  List<double> _headerOffset = [];
  GroupNameProxiesMap _lastGroupNameProxiesMap = {};

  @override
  void initState() {
    super.initState();
    _controller.addListener(_adjustHeader);
  }

  _adjustHeader() {
    final offset = _controller.offset;
    final index = _headerOffset.findInterval(offset);
    final currentIndex = index;
    double headerOffset = 0.0;
    if (index + 1 <= _headerOffset.length - 1) {
      final endOffset = _headerOffset[index + 1];
      final startOffset = endOffset - listHeaderHeight - 8;
      if (offset > startOffset && offset < endOffset) {
        headerOffset = offset - startOffset;
      }
    }
    _headerStateNotifier.value = _headerStateNotifier.value.copyWith(
      currentIndex: currentIndex,
      offset: max(headerOffset, 0),
    );
  }

  double _getListItemHeight(Type type, ProxyCardType proxyCardType) {
    return switch (type) {
      const (SizedBox) => 8,
      const (ListHeader) => listHeaderHeight,
      Type() => getItemHeight(proxyCardType),
    };
  }

  @override
  void dispose() {
    _headerStateNotifier.dispose();
    _controller.removeListener(_adjustHeader);
    _controller.dispose();
    super.dispose();
  }

  _handleChange(Set<String> currentUnfoldSet, String groupName) {
    final tempUnfoldSet = Set<String>.from(currentUnfoldSet);
    if (tempUnfoldSet.contains(groupName)) {
      tempUnfoldSet.remove(groupName);
    } else {
      tempUnfoldSet.add(groupName);
    }
    globalState.appController.updateCurrentUnfoldSet(
      tempUnfoldSet,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _adjustHeader();
    });
  }

  List<double> _getItemHeightList(
    List<Widget> items,
    ProxyCardType proxyCardType,
  ) {
    final itemHeightList = <double>[];
    List<double> headerOffset = [];
    double currentHeight = 0;
    for (final item in items) {
      if (item.runtimeType == ListHeader) {
        headerOffset.add(currentHeight);
      }
      final itemHeight = _getListItemHeight(item.runtimeType, proxyCardType);
      itemHeightList.add(itemHeight);
      currentHeight = currentHeight + itemHeight;
    }
    _headerOffset = headerOffset;
    return itemHeightList;
  }

  List<Widget> _buildItems(
    WidgetRef ref, {
    required List<String> groupNames,
    required int columns,
    required Set<String> currentUnfoldSet,
    required ProxyCardType type,
    required String query,
  }) {
    final items = <Widget>[];
    final GroupNameProxiesMap groupNameProxiesMap = {};
    for (final groupName in groupNames) {
      final group = ref.read(
        groupsProvider.select(
          (state) => state.getGroup(groupName),
        ),
      );
      if (group == null) {
        continue;
      }
      final isExpand = currentUnfoldSet.contains(groupName);
      items.addAll([
        ListHeader(
          onScrollToSelected: _scrollToGroupSelected,
          key: Key(groupName),
          isExpand: isExpand,
          group: group,
          onChange: (String groupName) {
            _handleChange(currentUnfoldSet, groupName);
          },
        ),
        const SizedBox(
          height: 8,
        ),
      ]);
      if (isExpand) {
        final sortedProxies = globalState.appController.getSortProxies(
          group.all
              .where((item) => item.name.toLowerCase().contains(query))
              .toList(),
          group.testUrl,
        );
        groupNameProxiesMap[groupName] = sortedProxies;
        final chunks = sortedProxies.chunks(columns);
        final rows = chunks.map<Widget>((proxies) {
          final children = proxies
              .map<Widget>(
                (proxy) => Flexible(
                  child: ProxyCard(
                    testUrl: group.testUrl,
                    type: type,
                    groupType: group.type,
                    key: ValueKey('$groupName.${proxy.name}'),
                    proxy: proxy,
                    groupName: groupName,
                  ),
                ),
              )
              .fill(
                columns,
                filler: (_) => const Flexible(
                  child: SizedBox(),
                ),
              )
              .separated(
                const SizedBox(
                  width: 8,
                ),
              );

          return Row(
            children: children.toList(),
          );
        }).separated(
          const SizedBox(
            height: 8,
          ),
        );
        items.addAll(
          [
            ...rows,
            const SizedBox(
              height: 8,
            ),
          ],
        );
      }
    }
    _lastGroupNameProxiesMap = groupNameProxiesMap;
    return items;
  }

  _buildHeader(
    WidgetRef ref, {
    required String groupName,
    required Set<String> currentUnfoldSet,
  }) {
    final group =
        ref.read(groupsProvider.select((state) => state.getGroup(groupName)));
    if (group == null) {
      return SizedBox();
    }
    final isExpand = currentUnfoldSet.contains(groupName);
    return SizedBox(
      height: listHeaderHeight,
      child: ListHeader(
        enterAnimated: false,
        onScrollToSelected: _scrollToGroupSelected,
        key: Key(groupName),
        isExpand: isExpand,
        group: group,
        onChange: (String groupName) {
          _handleChange(currentUnfoldSet, groupName);
        },
      ),
    );
  }

  _scrollToGroupSelected(String groupName) {
    if (_controller.position.maxScrollExtent == 0) {
      return;
    }
    final appController = globalState.appController;
    final currentGroups = appController.getCurrentGroups();
    final groupNames = currentGroups.map((e) => e.name).toList();
    final findIndex = groupNames.indexWhere((item) => item == groupName);
    final index = findIndex != -1 ? findIndex : 0;
    final currentInitOffset = _headerOffset[index];
    final proxies = _lastGroupNameProxiesMap[groupName];
    _controller.animateTo(
      min(
        currentInitOffset +
            8 +
            getScrollToSelectedOffset(
              groupName: groupName,
              proxies: proxies ?? [],
            ),
        _controller.position.maxScrollExtent,
      ),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, ref, __) {
        final state = ref.watch(proxiesListSelectorStateProvider);
        ref.watch(themeSettingProvider.select((state) => state.textScale));
        if (state.groupNames.isEmpty) {
          return NullStatus(
            label: appLocalizations.emptyStateMessage,
          );
        }
        final items = _buildItems(
          ref,
          groupNames: state.groupNames,
          currentUnfoldSet: state.currentUnfoldSet,
          columns: state.columns,
          type: state.proxyCardType,
          query: state.query,
        );
        final itemsOffset = _getItemHeightList(items, state.proxyCardType);
        return CommonScrollBar(
          controller: _controller,
          child: Stack(
            children: [
              Positioned.fill(
                child: ScrollConfiguration(
                  behavior: HiddenBarScrollBehavior(),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    controller: _controller,
                    itemExtentBuilder: (index, __) {
                      return itemsOffset[index];
                    },
                    itemCount: items.length,
                    itemBuilder: (_, index) {
                      return items[index];
                    },
                  ),
                ),
              ),
              LayoutBuilder(builder: (_, container) {
                return ValueListenableBuilder(
                  valueListenable: _headerStateNotifier,
                  builder: (_, headerState, ___) {
                    final index =
                        headerState.currentIndex > state.groupNames.length - 1
                            ? 0
                            : headerState.currentIndex;
                    if (index < 0 || state.groupNames.isEmpty) {
                      return Container();
                    }
                    return Stack(
                      children: [
                        Positioned(
                          top: -headerState.offset,
                          child: Container(
                            width: container.maxWidth,
                            color: context.colorScheme.surface,
                            padding: const EdgeInsets.only(
                              top: 16,
                              left: 16,
                              right: 16,
                              bottom: 8,
                            ),
                            child: _buildHeader(
                              ref,
                              groupName: state.groupNames[index],
                              currentUnfoldSet: state.currentUnfoldSet,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }
}

class ListHeader extends StatefulWidget {
  final Group group;

  final Function(String groupName) onChange;
  final Function(String groupName) onScrollToSelected;
  final bool isExpand;

  final bool enterAnimated;

  const ListHeader({
    super.key,
    this.enterAnimated = true,
    required this.group,
    required this.onChange,
    required this.onScrollToSelected,
    required this.isExpand,
  });

  @override
  State<ListHeader> createState() => _ListHeaderState();
}

class _ListHeaderState extends State<ListHeader> {
  var isLock = false;

  String get icon => widget.group.icon;

  String get groupName => widget.group.name;

  String get groupType => widget.group.type.name;

  bool get isExpand => widget.isExpand;

  _delayTest() async {
    if (isLock) return;
    isLock = true;
    await delayTest(
      widget.group.all,
      widget.group.testUrl,
    );
    isLock = false;
  }

  _handleChange(String groupName) {
    widget.onChange(groupName);
  }

  Widget _buildIcon() {
    return Consumer(
      builder: (_, ref, child) {
        final iconStyle = ref.watch(
          proxiesStyleSettingProvider.select(
            (state) => state.iconStyle,
          ),
        );
        final icon = ref.watch(proxiesStyleSettingProvider.select((state) {
          final iconMapEntryList = state.iconMap.entries.toList();
          final index = iconMapEntryList.indexWhere((item) {
            try {
              return RegExp(item.key).hasMatch(groupName);
            } catch (_) {
              return false;
            }
          });
          if (index != -1) {
            return iconMapEntryList[index].value;
          }
          return this.icon;
        }));
        return switch (iconStyle) {
          ProxiesIconStyle.standard => LayoutBuilder(
              builder: (_, constraints) {
                return Container(
                  margin: const EdgeInsets.only(
                    right: 16,
                  ),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      height: constraints.maxHeight,
                      width: constraints.maxWidth,
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(6.ap),
                      decoration: ShapeDecoration(
                        shape: RoundedSuperellipseBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        color: context.colorScheme.secondaryContainer,
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: CommonTargetIcon(
                        src: icon,
                        size: constraints.maxHeight - 12.ap,
                      ),
                    ),
                  ),
                );
              },
            ),
          ProxiesIconStyle.icon => Container(
              margin: const EdgeInsets.only(
                right: 16,
              ),
              child: LayoutBuilder(
                builder: (_, constraints) {
                  return CommonTargetIcon(
                    src: icon,
                    size: constraints.maxHeight - 8,
                  );
                },
              ),
            ),
          ProxiesIconStyle.none => Container(),
        };
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonCard(
      enterAnimated: widget.enterAnimated,
      key: widget.key,
      radius: 16.ap,
      type: CommonCardType.filled,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Row(
                children: [
                  _buildIcon(),
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          groupName,
                          style: context.textTheme.titleMedium,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Flexible(
                          flex: 1,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                groupType,
                                style: context.textTheme.labelMedium?.toLight,
                              ),
                              Flexible(
                                flex: 1,
                                child: Consumer(
                                  builder: (_, ref, __) {
                                    final proxyName = ref
                                        .watch(getSelectedProxyNameProvider(
                                          groupName,
                                        ))
                                        .getSafeValue("");
                                    return Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        if (proxyName.isNotEmpty) ...[
                                          Flexible(
                                            flex: 1,
                                            child: EmojiText(
                                              overflow: TextOverflow.ellipsis,
                                              " · $proxyName",
                                              style: context.textTheme
                                                  .labelMedium?.toLight,
                                            ),
                                          ),
                                        ]
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Row(
              children: [
                if (isExpand) ...[
                  IconButton(
                    visualDensity: VisualDensity.standard,
                    onPressed: () {
                      widget.onScrollToSelected(groupName);
                    },
                    icon: const Icon(
                      Icons.adjust,
                    ),
                  ),
                  IconButton(
                    onPressed: _delayTest,
                    visualDensity: VisualDensity.standard,
                    icon: const Icon(
                      Icons.network_ping,
                    ),
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                ] else
                  SizedBox(
                    width: 4,
                  ),
                IconButton.filledTonal(
                  onPressed: () {
                    _handleChange(groupName);
                  },
                  icon: CommonExpandIcon(
                    expand: isExpand,
                  ),
                )
              ],
            )
          ],
        ),
      ),
      onPressed: () {
        _handleChange(groupName);
      },
    );
  }
}
