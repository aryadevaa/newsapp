import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:newsapp/conversion/conversion_page.dart';
import 'package:newsapp/login_signup/Authentication/login.dart';
import 'package:newsapp/main.dart';
import 'package:newsapp/login_signup/user_repository.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late StreamSubscription<AccelerometerEvent> _accelerometerSubscription;
  double _x = 0.0, _y = 0.0, _z = 0.0;
  String? _currentUsername;
  String? _currentNama;
  final TextEditingController _namaController = TextEditingController();
  bool _isEditing = false;
  String? _profileImagePath;
  final ImagePicker _picker = ImagePicker();
  final String _nim = "123220186";

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _accelerometerSubscription = accelerometerEventStream().listen((AccelerometerEvent event) {
      setState(() {
        _x = event.x;
        _y = event.y;
        _z = event.z;
      });
    });
  }

  Future<void> _loadUserData() async {
    String? username = await userRepository.getCurrentUser();
    if (username != null) {
      var user = await userRepository.getUser(username);
      String? imagePath = await userRepository.getProfileImagePath(username);
      setState(() {
        _currentUsername = username;
        _currentNama = user?.nama;
        _namaController.text = user?.nama ?? username;
        _profileImagePath = imagePath;
      });
    }
  }

  Future<void> _updateProfile() async {
    if (_currentUsername != null) {
      bool success = await userRepository.updateProfile(
        _currentUsername!,
        _namaController.text,
      );
      if (success) {
        setState(() {
          _currentNama = _namaController.text;
          _isEditing = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profil berhasil diperbarui')),
        );
      }
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null && _currentUsername != null) {
        await userRepository.saveProfileImage(_currentUsername!, pickedFile.path);
        setState(() {
          _profileImagePath = pickedFile.path;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memilih gambar: $e')),
      );
    }
  }

  void _showImagePickerModal() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Pilih dari Galeri'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Ambil Foto'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _accelerometerSubscription.cancel();
    _namaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 16),
              // Centered Profile Image, Name, NIM
              Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _showImagePickerModal,
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: _profileImagePath != null
                                ? FileImage(File(_profileImagePath!))
                                : AssetImage('assets/img/profile.jpg') as ImageProvider,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      _currentNama ?? 'Loading...',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 4),
                    Text(
                      _nim,
                      style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              // Edit Profil Button
              Center(
                child: !_isEditing
                    ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          backgroundColor: Colors.white,
                          elevation: 2,
                        ),
                        onPressed: () {
                          setState(() {
                            _isEditing = true;
                          });
                        },
                        child: Text('Edit Profil', style: TextStyle(color: Colors.deepPurple)),
                      )
                    : Column(
                        children: [
                          TextField(
                            controller: _namaController,
                            decoration: InputDecoration(
                              labelText: 'Nama',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _isEditing = false;
                                    _namaController.text = _currentNama ?? '';
                                  });
                                },
                                child: Text('Batal'),
                              ),
                              SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: _updateProfile,
                                child: Text('Simpan'),
                              ),
                            ],
                          ),
                        ],
                      ),
              ),
              SizedBox(height: 16),
              // Card Kesan dan Saran
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info, color: Colors.grey[800]),
                          SizedBox(width: 8),
                          Text(
                            'Kesan dan Saran Mata Kuliah',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Kesan saya selama mengikuti mata kuliah Teknologi & Pemrograman Mobile yaitu Mata kuliah Teknologi dan Pemrograman Mobile memberikan pemahaman yang mendalam tentang pengembangan aplikasi mobile. Pembelajaran yang berbasis proyek membuat saya lebih memahami implementasi konsep-konsep pemrograman dalam aplikasi nyata.\n\nDan untuk Saran saya selama mengikuti mata kuliah Teknologi & Pemrograman Mobile yaitu jangan kasi banyak tugas pak, mahasiswanya pusing semua gara-gara projek akhir numpuk hehe',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              // Data Accelerometer
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text('Data Accelerometer:'),
                      Text('X: ${_x.toStringAsFixed(2)}'),
                      Text('Y: ${_y.toStringAsFixed(2)}'),
                      Text('Z: ${_z.toStringAsFixed(2)}'),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Tombol konversi mata uang dan waktu
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ConversionScreen()),
                  );
                },
                child: Text('Menu Tambahan'),
              ),
              SizedBox(height: 10),
              // Tombol Logout
              ElevatedButton(
                onPressed: () async {
                  await userRepository.logout();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                child: Text('LOGOUT'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
