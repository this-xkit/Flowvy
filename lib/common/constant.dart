import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flowvy/common/common.dart';
import 'package:flowvy/enum/enum.dart';
import 'package:flowvy/models/models.dart';
import 'package:flutter/material.dart';

const appName = "Flowvy";
const appHelperService = "FlowvyHelperService";
const coreName = "clash.meta";
const browserUa =
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36";
const packageName = "com.follow.clash";
final unixSocketPath = "/tmp/FlowvySocket_${Random().nextInt(10000)}.sock";
const helperPort = 47890;
const maxTextScale = 1.4;
const minTextScale = 0.8;
final baseInfoEdgeInsets = EdgeInsets.symmetric(
  vertical: 16.ap,
  horizontal: 16.ap,
);

final defaultTextScaleFactor =
    WidgetsBinding.instance.platformDispatcher.textScaleFactor;
const httpTimeoutDuration = Duration(milliseconds: 5000);
const moreDuration = Duration(milliseconds: 100);
const animateDuration = Duration(milliseconds: 100);
const midDuration = Duration(milliseconds: 200);
const commonDuration = Duration(milliseconds: 300);
const defaultUpdateDuration = Duration(days: 1);
const mmdbFileName = "geoip.metadb";
const asnFileName = "ASN.mmdb";
const geoIpFileName = "GeoIP.dat";
const geoSiteFileName = "GeoSite.dat";
final double kHeaderHeight = system.isDesktop
    ? !Platform.isMacOS
        ? 40
        : 28
    : 0;
const profilesDirectoryName = "profiles";
const localhost = "127.0.0.1";
const clashConfigKey = "clash_config";
const configKey = "config";
const double dialogCommonWidth = 300;
const repository = "chen08209/FlClash";
const defaultExternalController = "127.0.0.1:9090";
const maxMobileWidth = 600;
const maxLaptopWidth = 840;
const defaultTestUrl = "https://www.gstatic.com/generate_204";
final commonFilter = ImageFilter.blur(
  sigmaX: 5,
  sigmaY: 5,
  tileMode: TileMode.mirror,
);

const navigationItemListEquality = ListEquality<NavigationItem>();
const connectionListEquality = ListEquality<Connection>();
const stringListEquality = ListEquality<String>();
const intListEquality = ListEquality<int>();
const logListEquality = ListEquality<Log>();
const groupListEquality = ListEquality<Group>();
const externalProviderListEquality = ListEquality<ExternalProvider>();
const packageListEquality = ListEquality<Package>();
const hotKeyActionListEquality = ListEquality<HotKeyAction>();
const stringAndStringMapEquality = MapEquality<String, String>();
const stringAndStringMapEntryIterableEquality =
    IterableEquality<MapEntry<String, String>>();
const delayMapEquality = MapEquality<String, Map<String, int?>>();
const stringSetEquality = SetEquality<String>();
const keyboardModifierListEquality = SetEquality<KeyboardModifier>();

const viewModeColumnsMap = {
  ViewMode.mobile: [2, 1],
  ViewMode.laptop: [3, 2],
  ViewMode.desktop: [4, 3],
};

// const proxiesStoreKey = PageStorageKey<String>('proxies');
// const toolsStoreKey = PageStorageKey<String>('tools');
// const profilesStoreKey = PageStorageKey<String>('profiles');

const defaultPrimaryColor = 0XFFD8C0C3;

double getWidgetHeight(num lines) {
  return max(lines * 84 + (lines - 1) * 16, 0).ap;
}

const maxLength = 150;

final mainIsolate = "FlowvyMainIsolate";

final serviceIsolate = "FlowvyServiceIsolate";

const defaultPrimaryColors = [
  0xFF795548,
  0xFF03A9F4,
  0xFFFFFF00,
  0XFFBBC9CC,
  0XFFABD397,
  defaultPrimaryColor,
  0XFF665390,
];

const scriptTemplate = """
const main = (config) => {
  return config;
}""";
