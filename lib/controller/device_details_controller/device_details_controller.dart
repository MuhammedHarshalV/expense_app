import 'dart:developer';

import 'package:expense/apis/device_related_api/device_accept_api.dart';
import 'package:expense/apis/device_related_api/device_details_api.dart';
import 'package:expense/apis/device_related_api/device_logout_api.dart';
import 'package:expense/apis/device_related_api/device_reject_api.dart';
import 'package:expense/apis/device_related_api/device_request.dart';
import 'package:expense/controller/device_details_controller/device_details_state.dart';
import 'package:expense/core/services/device_details/device_details_picking.dart';
import 'package:expense/models/devices/loged_device_details_response_model.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/legacy.dart';

class DeviceDetailsController extends StateNotifier<DeviceDetailsState> {
  DeviceDetailsController() : super(const DeviceDetailsState()) {
    init();
  }

  /// Initial API calls
  Future<void> init() async {
    state = state.copyWith(isLoading: true);

    try {
      await Future.wait([
        getDeviceDetails(),
        checkDeviceRequest(),
        getCurrentDeviceId(),
      ]);
    } catch (e) {
      log('Device init error: $e');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  /// Get logged device list
  Future<void> getDeviceDetails() async {
    try {
      state = state.copyWith(isLoading: true);
      final LogedDeviceDetailsResponseModel response =
          await DeviceDetailsApi.deviceDetailsApi(context: null);

      if (response.success == true) {
        state = state.copyWith(deviceList: response.data ?? []);
      }
    } catch (e) {
      log('Get device details error: $e');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  /// Get logged device list refersh
  Future<void> getDeviceDetailsRefresh() async {
    try {
      state = state.copyWith(isRefresh: true);
      final LogedDeviceDetailsResponseModel response =
          await DeviceDetailsApi.deviceDetailsApi(context: null);

      if (response.success == true) {
        state = state.copyWith(deviceList: response.data ?? []);
      }
    } catch (e) {
      log('Get device details error: $e');
    } finally {
      state = state.copyWith(isRefresh: false);
    }
  }

  //logout
  Future<bool> logoutApi({
    required BuildContext context,
    required String deviceId,
  }) async {
    try {
      final dynamic response = await LogoutApi.logoutApi(
        context: context,
        body: {"deviceId": deviceId},
      );
      if (response == true) {
        getDeviceDetails();
        return true;
      }
    } catch (e) {
      log(e.toString());
      return false;
    } finally {
      //  state = state.copyWith(isLogOut: false);
    }
    return false;
  }

  /// Check whether another device requested login
  Future<void> checkDeviceRequest() async {
    try {
      final dynamic request = await DeviceRequest.deviceRequest(context: null);
      if (request == true) {
        state = state.copyWith(isRequestFetch: true);
      } else {
        state = state.copyWith(isRequestFetch: false);
      }
    } catch (e) {
      log('Device request error: $e');
      state = state.copyWith(isRequestFetch: false);
    }
  }

  Future<void> getCurrentDeviceId() async {
    try {
      final deviceId = await DeviceIdPicking.getDeviceId();

      state = state.copyWith(currentDeviceId: deviceId);
    } catch (e) {
      log(e.toString());
    }
  }

  // reject request
  Future<void> rejectRequest() async {
    try {
      state = state.copyWith(isReject: true);
      final response = await DeviceRejectApi.deviceRejectApi(context: null);
      if (response == true) {
        await checkDeviceRequest();
      }
    } catch (e) {
      log(e.toString());
    } finally {
      state = state.copyWith(isReject: false);
    }
  }

  // accept request
  Future<void> acceptRequest() async {
    try {
      state = state.copyWith(isAccept: true);
      final response = await DeviceAcceptApi.deviceAcceptApi(context: null);
      if (response == true) {
        await checkDeviceRequest();
      }
    } catch (e) {
      log(e.toString());
    } finally {
      state = state.copyWith(isAccept: false);
    }
  }

  @override
  void dispose() {
    log("====== devcie details screen disposed ======");
    super.dispose();
  }
}

final deviceDetailsProvider =
    StateNotifierProvider.autoDispose<
      DeviceDetailsController,
      DeviceDetailsState
    >((ref) => DeviceDetailsController());
