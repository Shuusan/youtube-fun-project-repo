import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class LedStripController extends GetxController {
  DatabaseReference dbRealtime = FirebaseDatabase.instance.reference();

  final RxString _chosenMode = 'Moving Rainbow'.obs;
  set chosenMode(String value) => this._chosenMode.value = value;
  String get chosenMode => this._chosenMode.value;

  final RxDouble _brightnessLed = 0.0.obs;
  set brightnessLed(double value) => this._brightnessLed.value = value;
  double get brightnessLed => this._brightnessLed.value;

  final RxDouble _framePerSecond = 0.0.obs;
  set framePerSecond(double value) => this._framePerSecond.value = value;
  double get framePerSecond => this._framePerSecond.value;

  void changeMode(String mode) async {
    chosenMode = mode;
    dbRealtime.child("LedStrips").update({"mode": mode});
  }
}
