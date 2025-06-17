import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';
import '../models/activity.dart';
import '../services/firebase_service.dart';

class AddActivityScreen extends StatefulWidget {
  @override
  _AddActivityScreenState createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaKegiatanController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _tanggalController = TextEditingController();

  String _selectedKategori = 'Kuliah';
  final List<String> _kategoriList = ['Kuliah', 'Organisasi', 'Lainnya'];
  bool _isLoading = false;
  final DatabaseService _firebaseService = DatabaseService();

  String? _imagePath;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _tanggalController.text = DateFormat('dd MMM yyyy').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2C2C2C),
      appBar: AppBar(
        backgroundColor: Color(0xFF2C2C2C),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Tambah Data',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFormField(
                label: 'Nama Kegiatan :',
                child: TextFormField(
                  controller: _namaKegiatanController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xFF5A9EAD),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'Masukkan nama kegiatan',
                    hintStyle: TextStyle(color: Colors.white70),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Nama kegiatan harus diisi';
                    }
                    return null;
                  },
                ),
              ),
              _buildFormField(
                label: 'Kategori :',
                child: DropdownButtonFormField<String>(
                  value: _selectedKategori,
                  style: TextStyle(color: Colors.white),
                  dropdownColor: Color(0xFF5A9EAD),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xFF5A9EAD),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: _kategoriList.map((kategori) {
                    return DropdownMenuItem<String>(
                      value: kategori,
                      child: Text(
                        kategori,
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedKategori = value!;
                    });
                  },
                ),
              ),
              _buildFormField(
                label: 'Tanggal :',
                child: TextFormField(
                  controller: _tanggalController,
                  style: TextStyle(color: Colors.white),
                  readOnly: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xFF5A9EAD),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: Icon(Icons.calendar_today, color: Colors.white),
                  ),
                  onTap: _selectDate,
                ),
              ),
              _buildFormField(
                label: 'Deskripsi :',
                child: TextFormField(
                  controller: _deskripsiController,
                  style: TextStyle(color: Colors.white),
                  maxLines: 4,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xFF5A9EAD),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'Masukkan deskripsi kegiatan',
                    hintStyle: TextStyle(color: Colors.white70),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Deskripsi harus diisi';
                    }
                    return null;
                  },
                ),
              ),
              _buildFormField(
                label: 'Dokumentasi :',
                child: GestureDetector(
                  onTap: _showImageOptionsDialog,
                  child: Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color(0xFF5A9EAD),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: _imagePath == null
                        ? Center(
                            child: Icon(Icons.camera_alt, color: Colors.white, size: 48),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              fit: BoxFit.cover,
                              File(_imagePath!),
                            ),
                          ),
                  ),
                ),
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveActivity,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2C3E50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'Simpan',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormField({required String label, required Widget child}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: Color(0xFF5A9EAD),
              surface: Color(0xFF2C2C2C),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _tanggalController.text = DateFormat('dd MMM yyyy').format(picked);
      });
    }
  }

  Future<void> _showImageOptionsDialog() {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color(0xFF2C2C2C),
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.photo_library, color: Colors.white),
                title: Text("Pilih dari Galeri", style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _getImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Icon(Icons.camera, color: Colors.white),
                title: Text("Ambil dari Kamera", style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _getImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _getImage(ImageSource source) async {
    final permission = source == ImageSource.camera ? Permission.camera : Permission.storage;

    final status = await permission.request();

    if (status.isGranted) {
      final XFile? pickedFile = await _picker.pickImage(source: source);

      if (pickedFile != null) {
        setState(() {
          _imagePath = pickedFile.path;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Izin ditolak")),
      );
    }
  }

  Future<void> _saveActivity() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      String? imageUrl;

      try {
        if (_imagePath != null) {
          final ref = _storage.ref().child('activity_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
          await ref.putFile(File(_imagePath!));
          imageUrl = await ref.getDownloadURL();
        }

        final activity = Activity(
          id: Uuid().v4(),
          namaKegiatan: _namaKegiatanController.text,
          kategori: _selectedKategori,
          tanggal: _tanggalController.text,
          deskripsi: _deskripsiController.text,
          dokumentasi: imageUrl,
        );
        await _firebaseService.addActivity(activity);
        await DatabaseService().addActivity(activity);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Kegiatan berhasil disimpan'),
            backgroundColor: Color(0xFF5A9EAD),
          ),
        );

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyimpan kegiatan: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _namaKegiatanController.dispose();
    _deskripsiController.dispose();
    _tanggalController.dispose();
    super.dispose();
  }
}