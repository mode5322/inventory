import '/core/export.dart';

class MainHome extends StatefulWidget {
  const MainHome({super.key});

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  int _currentIndex = 0;
  late final bool _isAdmin;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _isAdmin = Hive.box('userBox').get('role') == 'admin';
    _pages = _isAdmin
        ? const [HomePage(), DashPage(), ProfilePage()]
        : const [HomePage(), ProfilePage()];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: Padding(
        padding: _isAdmin ? const EdgeInsets.fromLTRB(75, 0, 75, 16) : const EdgeInsets.fromLTRB(130, 0, 130, 16),
        child: SafeArea(
          top: false,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: GNav(
              selectedIndex: _currentIndex,
              onTabChange: (i) => setState(() => _currentIndex = i),
              color: Colors.grey.shade600,
              activeColor: Colors.black,
              tabBackgroundColor: Colors.grey.shade100,
              tabBorderRadius: 50,
              haptic: true,
              gap: 8,
              iconSize: 22,
              curve: Curves.linear,
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              tabs: _isAdmin
                  ? const [
                      GButton(icon: Icons.home_outlined, text: 'الرئيسية'),
                      GButton(icon: Icons.dashboard_outlined, text: 'الإدارة'),
                      GButton(icon: Icons.person_outline, text: 'الملف'),
                    ]
                  : const [
                      GButton(icon: Icons.home_outlined, text: 'الرئيسية'),
                      GButton(icon: Icons.person_outline, text: 'الملف'),
                    ],
            ),
          ),
        ),
      ),
    );
  }
}
