import 'package:freezed_annotation/freezed_annotation.dart';

part 'connection_info.freezed.dart';

@freezed
class ConnectionInfo with _$ConnectionInfo {
  const factory ConnectionInfo.connected(DataSignalStrength? signalStrength, ConnectionType connectionType) = Connected;

  const factory ConnectionInfo.disconnected() = Disconnected;
}

enum DataSignalStrength { great, good, moderate, poor, none }

enum ConnectionType { roaming, data2G, data3G, data4G, data5G, wifi }
