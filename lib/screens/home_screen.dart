// screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/activity.dart';
import '../services/firebase_service.dart';
import 'add_screen.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseService _firebaseService = DatabaseService();
  String selectedCategory = 'Semua';
  final List<String> categories = ['Semua', 'Kuliah', 'Organisasi', 'Lainnya'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2C2C2C),
      appBar: AppBar(
        backgroundColor: Color(0xFF2C2C2C),
        elevation: 0,
        title: Text(
          'Daily Activity',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 16),
            child: DropdownButton<String>(
              value: selectedCategory,
              dropdownColor: Color(0xFF5A9EAD),
              style: TextStyle(color: Colors.white),
              underline: Container(),
              icon: Icon(Icons.arrow_drop_down, color: Colors.white),
              items:
                  categories.map((category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Text(
                          category,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                });
              },
            ),
          ),
        ],
      ),
      body: StreamBuilder<List<Activity>>(
        stream: _firebaseService.getActivities(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          List<Activity> activities = snapshot.data ?? [];

          if (selectedCategory != 'Semua') {
            activities =
                activities
                    .where((activity) => activity.kategori == selectedCategory)
                    .toList();
          }

          if (activities.isEmpty) {
            return Center(
              child: Text(
                'Belum ada kegiatan',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: activities.length,
            itemBuilder: (context, index) {
              final activity = activities[index];
              return _buildActivityCard(activity);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddActivityScreen()),
          );
        },
        backgroundColor: Color(0xFF5A9EAD),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildActivityCard(Activity activity) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailActivityScreen(activity: activity),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF5A9EAD), Color(0xFF7DB3C1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.all(16),
            leading: CircleAvatar(
              backgroundColor: Colors.white24,
              child: Icon(
                _getCategoryIcon(activity.kategori),
                color: Colors.white,
              ),
            ),
            title: Text(
              activity.namaKegiatan,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4),
                Text(
                  'Tanggal: ${activity.tanggal}',
                  style: TextStyle(color: Colors.white70),
                ),
                Text(
                  activity.kategori,
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: 16,
            ),
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Kuliah':
        return Icons.school;
      case 'Organisasi':
        return Icons.group;
      case 'Lainnya':
        return Icons.more_horiz;
      default:
        return Icons.event;
    }
  }
}