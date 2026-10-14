import 'package:expense/models/expense_related/all_expense_response_model.dart';

class ClinicDetailsState {
  final bool isLoading;
  final int imageVersion;
  final int clinicId;
  final String clinicName;
  final num clinicTotalExp;
  final String clinicPlace;
  final String clinicPhoto;
  final String filter;

  final List<Expense> expenses;

  const ClinicDetailsState({
    this.filter = 'Latest',
    this.isLoading = false,
    this.clinicId = 0,
    this.imageVersion = 0,
    this.clinicName = '',
    this.clinicTotalExp = 0.0,
    this.clinicPlace = '',
    this.clinicPhoto = '',
    this.expenses = const [],
  });

  ClinicDetailsState copyWith({
    bool? isLoading,
    String? filter,
    int? clinicId,
    String? clinicName,
    num? clinicTotalExp,
    int? imageVersion,
    String? clinicPlace,
    String? clinicPhoto,
    List<Expense>? expenses,
  }) {
    return ClinicDetailsState(
      filter: filter ?? this.filter,
      isLoading: isLoading ?? this.isLoading,
      clinicId: clinicId ?? this.clinicId,
      clinicName: clinicName ?? this.clinicName,
      clinicTotalExp: clinicTotalExp ?? this.clinicTotalExp,
      clinicPlace: clinicPlace ?? this.clinicPlace,
      clinicPhoto: clinicPhoto ?? this.clinicPhoto,
      expenses: expenses ?? this.expenses,
      imageVersion: imageVersion ?? this.imageVersion,
    );
  }
}
