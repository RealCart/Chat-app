import 'package:chat_app/service_locator.dart';
import 'package:firebase_database/firebase_database.dart' as fbRealBase;
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;

void setupPresence() {
  final userId = sl<fbAuth.FirebaseAuth>().currentUser!.uid;
  final fbRealBase.DatabaseReference statusRef =
      sl<fbRealBase.FirebaseDatabase>().ref('status/$userId');
  final fbRealBase.DatabaseReference connectedRef =
      sl<fbRealBase.FirebaseDatabase>().ref('.info/connected');

  connectedRef.onValue.listen((event) async {
    final connected = event.snapshot.value as bool?;
    if (connected != null && connected) {
      await statusRef.onDisconnect().set({
        'state': 'offline',
        'last_changed': fbRealBase.ServerValue.timestamp,
      });
      await statusRef.set({
        'state': 'online',
        'last_changed': fbRealBase.ServerValue.timestamp,
      });
    }
  });
}
