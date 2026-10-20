import '../../../../core/models/blood_group.dart';

class BloodGroupsState {
  final BloodGroup selectedGroup;
  final String? message;

  const BloodGroupsState({required this.selectedGroup, this.message});

  BloodGroupsState copyWith({
    BloodGroup? selectedGroup,
    String? message,
    bool clearMessage = false,
  }) {
    return BloodGroupsState(
      selectedGroup: selectedGroup ?? this.selectedGroup,
      message: clearMessage ? null : (message ?? this.message),
    );
  }
}
