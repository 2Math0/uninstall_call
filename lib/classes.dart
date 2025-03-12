import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

Future<void> updateUninstallInfo(String userId) async {
  FirebaseDatabase database = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL:
        "https://test-a22b3-default-rtdb.europe-west1.firebasedatabase.app/",
  );
  final databaseRef = database.ref("uninstall_logs/$userId");

  // Get current UTC time
  String timestamp = DateTime.now().toUtc().toIso8601String();

  // Get device details
  final deviceInfo = DeviceInfoPlugin();
  Map<String, dynamic> deviceData = {};

  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    deviceData = {
      "model": androidInfo.model,
      "brand": androidInfo.brand,
      "androidVersion": androidInfo.version.release,
      "device": androidInfo.device,
    };
  } else if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    deviceData = {
      "model": iosInfo.model,
      "systemName": iosInfo.systemName,
      "systemVersion": iosInfo.systemVersion,
      "device": iosInfo.utsname.machine,
    };
  }

  // Update Firebase Realtime Database
  await databaseRef.set({"timestamp": timestamp, "device_info": deviceData});

  print("Uninstall info updated successfully.");
}

Future<void> uploadNumberToRealtimeDB(int number) async {
  try {
    FirebaseDatabase database = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL:
          "https://test-a22b3-default-rtdb.europe-west1.firebasedatabase.app/",
    );
    DatabaseReference ref = database.ref("numbers");

    await ref.push().set({
      'value': number,
      // 'timestamp': ServerValue.timestamp,
    });

    print("Uninstall info updated successfully.");

    print(ref.path);

    print("✅ Number uploaded successfully: $number");
  } catch (e) {
    print("❌ Error uploading number: $e");
  }
}
