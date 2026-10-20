import 'package:flutter/foundation.dart';
import '../../../../core/data/demo_store.dart';
import '../../../../core/models/blood_measurement.dart';
import '../models/blood_values_state.dart';

class BloodValuesController extends ValueNotifier<BloodValuesState> {
  final DemoStore _store;
  late VoidCallback _storeListener;

  BloodValuesController(this._store)
    : super(
        BloodValuesState(
          selectedType: MeasurementType.hemoglobin,
          measurements: _store.measurements.toList(),
        ),
      ) {
    _storeListener = () {
      value = value.copyWith(measurements: _store.measurements.toList());
    };
    _store.addListener(_storeListener);
  }

  void selectType(MeasurementType type) {
    value = value.copyWith(
      selectedType: type,
      clearSelectedMeasurement: true,
      clearErrorMessage: true,
    );
  }

  void selectMeasurement(BloodMeasurement? measurement) {
    value = value.copyWith(
      selectedMeasurement: measurement,
      clearSelectedMeasurement: measurement == null,
    );
  }

  bool addMeasurement({
    required MeasurementType type,
    required String rawValue,
    required DateTime measuredAt,
    required String source,
    String? rawMin,
    String? rawMax,
  }) {
    // Validate and parse comma or dot decimal numbers
    final normalized = rawValue.replaceAll(',', '.').trim();
    final parsedValue = double.tryParse(normalized);

    if (parsedValue == null ||
        parsedValue <= 0 ||
        parsedValue.isNaN ||
        parsedValue.isInfinite) {
      value = value.copyWith(
        errorMessage: 'Lütfen geçerli, pozitif bir sayısal değer giriniz.',
      );
      return false;
    }

    double? refMin;
    if (rawMin != null && rawMin.trim().isNotEmpty) {
      refMin = double.tryParse(rawMin.replaceAll(',', '.').trim());
    }

    double? refMax;
    if (rawMax != null && rawMax.trim().isNotEmpty) {
      refMax = double.tryParse(rawMax.replaceAll(',', '.').trim());
    }

    final newMeasurement = BloodMeasurement(
      id: 'meas_${DateTime.now().millisecondsSinceEpoch}',
      type: type,
      value: parsedValue,
      unit: type.standardUnit,
      measuredAt: measuredAt,
      source: source.trim().isEmpty
          ? 'Kişisel Laboratuvar Kaydı'
          : source.trim(),
      referenceMin: refMin,
      referenceMax: refMax,
    );

    _store.addMeasurement(newMeasurement);
    value = value.copyWith(
      clearErrorMessage: true,
      selectedMeasurement: newMeasurement,
    );
    return true;
  }

  bool deleteMeasurement(String id) {
    final success = _store.deleteMeasurement(id);
    if (success && value.selectedMeasurement?.id == id) {
      value = value.copyWith(clearSelectedMeasurement: true);
    }
    return success;
  }

  @override
  void dispose() {
    _store.removeListener(_storeListener);
    super.dispose();
  }
}
