import 'package:expense/models/clinic_related/search_clinic_response_model.dart';
import 'package:image_picker/image_picker.dart';

class CreateClinicState {
  final List<Datum> clinicDetails;
  final bool isLoading;
  final bool isSubmit;
  final String clinicName;
  final String clinicPlace;
  final bool isPaginationLoading;
  final int page;
  final int totalPages;
  final String? error;
  final XFile? selectedImage;
  final String? networkImageUrl;

  const CreateClinicState({
    this.clinicDetails = const [],
    this.isLoading = false,
    this.isPaginationLoading = false,
    this.isSubmit = false,
    this.page = 1,
    this.clinicName = '',
    this.clinicPlace = '',
    this.totalPages = 0,
    this.error,
    this.selectedImage,
    this.networkImageUrl,
  });

  CreateClinicState copyWith({
    List<Datum>? clinicDetails,
    bool? isLoading,
    bool? isPaginationLoading,
    int? page,
    int? totalPages,
    String? clinicName,
    String? clinicPlace,
    bool? isSubmit,
    String? error,
    XFile? selectedImage,
    String? networkImageUrl,
    bool clearSelectedImage = false,
    bool clearNetworkImageUrl = false,
  }) {
    return CreateClinicState(
      clinicDetails: clinicDetails ?? this.clinicDetails,
      isLoading: isLoading ?? this.isLoading,
      clinicName: clinicName ?? this.clinicName,
      clinicPlace: clinicPlace ?? this.clinicPlace,
      isPaginationLoading: isPaginationLoading ?? this.isPaginationLoading,
      page: page ?? this.page,
      totalPages: totalPages ?? this.totalPages,
      error: error,
      isSubmit: isSubmit ?? this.isSubmit,
      selectedImage: clearSelectedImage
          ? null
          : selectedImage ?? this.selectedImage,

      networkImageUrl: clearNetworkImageUrl
          ? null
          : networkImageUrl ?? this.networkImageUrl,
    );
  }
}
