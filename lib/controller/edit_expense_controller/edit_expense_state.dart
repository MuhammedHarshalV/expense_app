import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class EditExpenseState {
  final num amount;
  final String expenseCategory;
  final String expenseDate;
  final XFile? selectedImage;
  final String? networkImageUrl;
  final String description;
  final bool isLoading;

  EditExpenseState({
    this.amount = 0.0,
    this.expenseCategory = 'Food & Lunch',
    String? expenseDate,
    this.selectedImage,
    this.networkImageUrl,
    this.description = '',
    this.isLoading = false,
  }) : expenseDate =
           expenseDate ?? DateFormat('dd-MMM-yyyy').format(DateTime.now());

  EditExpenseState copyWith({
    num? amount,
    String? expenseCategory,
    String? expenseDate,

    String? description,
    bool? isLoading,
    XFile? selectedImage,
    String? networkImageUrl,
    bool clearSelectedImage = false,
    bool clearNetworkImageUrl = false,
  }) {
    return EditExpenseState(
      amount: amount ?? this.amount,
      expenseCategory: expenseCategory ?? this.expenseCategory,
      expenseDate: expenseDate ?? this.expenseDate,
      selectedImage: clearSelectedImage
          ? null
          : selectedImage ?? this.selectedImage,

      networkImageUrl: clearNetworkImageUrl
          ? null
          : networkImageUrl ?? this.networkImageUrl,
      description: description ?? this.description,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
