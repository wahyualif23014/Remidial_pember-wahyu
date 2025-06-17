// services/database_service.dart
import 'package:firebase_database/firebase_database.dart';
import '../models/activity.dart';

class DatabaseService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  Future<void> addActivity(Activity activity) async {
    try {
      await _database.child('activities').push().set(activity.toJson());
    } catch (e) {
      throw Exception('Failed to add activity: $e');
    }
  }

  Stream<List<Activity>> getActivities() {
    return _database.child('activities').onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) return <Activity>[];

      return data.entries.map((entry) {
        final Map<String, dynamic> json = Map<String, dynamic>.from(entry.value);
        json['id'] = entry.key;
        return Activity.fromJson(json);
      }).toList();
    });
  }

  Future<void> updateActivity(Activity activity) async {
    try {
      await _database
          .child('activities')
          .child(activity.id!)
          .set(activity.toJson());
    } catch (e) {
      throw Exception('Failed to update activity: $e');
    }
  }

  Future<void> deleteActivity(String id) async {
    try {
      await _database.child('activities').child(id).remove();
    } catch (e) {
      throw Exception('Failed to delete activity: $e');
    }
  }
}