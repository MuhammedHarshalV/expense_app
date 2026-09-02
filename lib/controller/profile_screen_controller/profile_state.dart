class ProfileState {
  final String name;
  final String email;
  final String phone;
  final String profileImage;
  final String location;
  final String bio;
  final String dateOfBirth;
  final String gender;

  const ProfileState({
    this.name = 'No name',
    this.email = 'example@gmail.com',
    this.phone = '+91 3445423476',
    this.profileImage = '',
    this.location = 'Kerala, India',
    this.bio = 'No Description',
    this.dateOfBirth = '01 January 2000',
    this.gender = 'Male',
  });

  ProfileState copyWith({
    String? name,
    String? email,
    String? phone,
    String? profileImage,
    String? location,
    String? bio,
    String? dateOfBirth,
    String? gender,
  }) {
    return ProfileState(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
      location: location ?? this.location,
      bio: bio ?? this.bio,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
    );
  }
}
