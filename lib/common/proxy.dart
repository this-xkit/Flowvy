import 'package:flowvy/common/system.dart';
import 'package:proxy/proxy.dart';

final proxy = system.isDesktop ? Proxy() : null;
