import '/core/export.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter('inventory_db');
  await Hive.openBox('userBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget { 
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'inventory',
      theme: AppTheme.light,
      home: Hive.box('userBox').get('uid') != null ? const MainHome() : const LoginPage(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegistPage(),
        '/home': (context) => const HomePage(),
        '/dashboard': (context) => const DashPage(),
        '/users': (context) => const UsersPage(),
        '/materials': (context) => const MaterialsPage(),
        '/main_home': (context) => const MainHome(),
        '/profile': (context) => const ProfilePage(),
      },
    );
  
  }
}