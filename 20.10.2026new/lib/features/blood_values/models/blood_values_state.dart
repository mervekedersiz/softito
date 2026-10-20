import '../../../../core/models/blood_measurement.dart';

class BloodValuesState {
  final MeasurementType selectedType;
  final List<BloodMeasurement> measurements;
  final BloodMeasurement? selectedMeasurement;
  final String? errorMessage;

  const BloodValuesState({
    required this.selectedType,
    required this.measurements,
    this.selectedMeasurement,
    this.errorMessage,
  });

  List<BloodMeasurement> get filteredSortedMeasurements {
    final list = measurements.where((m) => m.type == selectedType).toList();
    list.sort((a, b) => a.measuredAt.compareTo(b.measuredAt));
    return list;
  }

  BloodValuesState copyWith({
    MeasurementType? selectedType,
    List<BloodMeasurement>? measurements,
    BloodMeasurement? selectedMeasurement,
    bool clearSelectedMeasurement = false,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return BloodValuesState(
      selectedType: selectedType ?? this.selectedType,
      measurements: measurements ?? this.measurements,
      selectedMeasurement: clearSelectedMeasurement
          ? null
          : (selectedMeasurement ?? this.selectedMeasurement),
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }
}
