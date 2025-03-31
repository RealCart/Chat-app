import 'dart:typed_data';

abstract interface class DataRepository {
  Future<Uint8List> getLocalData(String key);
}
