import 'package:flutter/material.dart';
import 'package:newsapp/login_signup/Authentication/login.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:newsapp/login_signup/user_repository.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
final UserRepository userRepository = UserRepository();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive and SharedPreferences
  await userRepository.init();

  // Inisialisasi plugin notifikasi
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(const MyApp());
}

// Fungsi untuk menampilkan notifikasi
Future<void> showLoginNotification() async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
        'login_channel', // id
        'Login Notification', // name
        channelDescription: 'Notification after login',
        importance: Importance.max,
        priority: Priority.high,
        styleInformation: BigTextStyleInformation(''),
      );
  const NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
  );
  await flutterLocalNotificationsPlugin.show(
    0,
    '🎉 Login Berhasil',
    'Welcome to NewsApp!',
    platformChannelSpecifics,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NewsApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: LoginScreen(),
    );
  }
}
