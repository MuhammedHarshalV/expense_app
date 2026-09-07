import 'package:expense/models/get_profile_details_response_model.dart';

class ProfileState {
  final ProfileDetails? profileDetails;
  final int imageVersion;
  final bool isUpdate;
  final bool isLoading;

  const ProfileState({
    this.imageVersion = 0,
    this.isLoading = false,
    this.isUpdate = false,
    this.profileDetails,
  });

  ProfileState copyWith({
    bool? isLoading,
    bool? isUpdate,
    int? imageVersion,
    ProfileDetails? profileDetails,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      imageVersion: imageVersion ?? this.imageVersion,
      profileDetails: profileDetails ?? this.profileDetails,

      isUpdate: isUpdate ?? this.isUpdate,
    );
  }
}
