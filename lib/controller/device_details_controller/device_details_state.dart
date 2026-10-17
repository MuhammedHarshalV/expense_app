import 'package:expense/models/devices/loged_device_details_response_model.dart';

class DeviceDetailsState {
  final bool isLoading;
  final String currentDeviceId;
  // Device request
  final bool isAccept;
  final bool isReject;
  final bool isRefresh;
  final bool isRequestFetch;
  final List<Datum> deviceList;

  const DeviceDetailsState({
    this.currentDeviceId = '',
    this.isRefresh = false,
    this.isLoading = false,
    this.isAccept = false,
    this.isReject = false,
    this.isRequestFetch = false,
    this.deviceList = const [],
  });

  DeviceDetailsState copyWith({
    String? currentDeviceId,
    bool? isLoading,
    bool? isAccept,
    bool? isReject,
    bool? isRequestFetch,
    List<Datum>? deviceList,
    bool? isRefresh,
  }) {
    return DeviceDetailsState(
      currentDeviceId: currentDeviceId ?? this.currentDeviceId,
      isLoading: isLoading ?? this.isLoading,
      isAccept: isAccept ?? this.isAccept,
      isReject: isReject ?? this.isReject,
      isRequestFetch: isRequestFetch ?? this.isRequestFetch,
      deviceList: deviceList ?? this.deviceList,
      isRefresh: isRefresh ?? this.isRefresh,
    );
  }
}
