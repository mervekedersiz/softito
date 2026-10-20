import 'package:flutter/foundation.dart';
import '../../../../core/data/demo_store.dart';
import '../../../../core/models/blood_group.dart';
import '../models/blood_groups_state.dart';

class BloodGroupsController extends ValueNotifier<BloodGroupsState> {
  final DemoStore _store;
  late VoidCallback _storeListener;

  BloodGroupsController(this._store)
    : super(BloodGroupsState(selectedGroup: _store.profile.bloodGroup)) {
    _storeListener = () {
      if (value.selectedGroup != _store.profile.bloodGroup) {
        value = value.copyWith(selectedGroup: _store.profile.bloodGroup);
      }
    };
    _store.addListener(_storeListener);
  }

  void selectBloodGroup(BloodGroup group) {
    _store.updateBloodGroup(group);
    value = value.copyWith(
      selectedGroup: group,
      message: '${group.label} kan grubu profille eşleştirildi.',
    );
  }

  void clearMessage() {
    value = value.copyWith(clearMessage: true);
  }

  @override
  void dispose() {
    _store.removeListener(_storeListener);
    super.dispose();
  }
}
