import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/services/slot_service.dart';

void main() {
  test('slot service exposes deleteSlot for admin slot removal', () {
    expect(SlotService.deleteSlot, isA<Function>());
  });
}
