import 'package:expense/models/clinic_related/get_all_clinic_details_response_model.dart';

class HomeState {
  final bool isLoading;
  final bool isPaginationLoading;
  final List<Datum> clinicList;
  final int imageVersion;
  final int totalPages;
  final int page;

  const HomeState({
    this.isLoading = false,
    this.isPaginationLoading = false,
    this.clinicList = const [],
    this.totalPages = 0,
    this.page = 1,
    this.imageVersion = 0,
  });

  HomeState copyWith({
    bool? isLoading,
    bool? isPaginationLoading,
    List<Datum>? clinicList,
    int? totalPages,
    int? page,
    int? imageVersion,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      clinicList: clinicList ?? this.clinicList,
      totalPages: totalPages ?? this.totalPages,
      page: page ?? this.page,
      isPaginationLoading: isPaginationLoading ?? this.isPaginationLoading,
      imageVersion: imageVersion ?? this.imageVersion,
    );
  }
}
