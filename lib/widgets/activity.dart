import 'package:flutter/material.dart';
import '../models/activity.dart';

class ActivityCard extends StatelessWidget {
  final Activity activity;

  const ActivityCard({Key? key, required this.activity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: ListTile(
        leading: CircleAvatar(child: Text(activity.kategori[0])),
        title: Text(activity.namaKegiatan),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Tanggal: ${activity.tanggal}"),
            Text("Jenis: ${activity.kategori}"),
          ],
        ),
        onTap: () {
          Navigator.pushNamed(context, '/detail', arguments: activity);
        },
      ),
    );
  }
}