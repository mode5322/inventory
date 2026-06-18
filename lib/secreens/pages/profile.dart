import '/core/export.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String name;
  late String email;
  late String role;
  late int uid;

  @override
  void initState() {
    super.initState();
    final box = Hive.box('userBox');
    name = box.get('name') ?? '';
    email = box.get('email') ?? '';
    role = box.get('role') ?? 'user';
    uid = box.get('uid') ?? 0;
  }

  Future<void> updateProfile(String name, String email, int uid) async {
    if (!mounted) return;
    if (name.isEmpty || email.isEmpty || uid == 0) {
      FloatingSnackBar.error(
        context,
        'يرجى ملء جميع الحقول',
        position: FloatingSnackBarPosition.top,
      );
      return;
    }
    try {
      final result = await db.updateProfile(name, email, uid);
      if (result['success'] == true) {
        setState(() {
          this.name = name;
          this.email = email;
        });
        final box = Hive.box('userBox');
        await box.put('name', name);
        await box.put('email', email);
        Navigator.pop(context);
        FloatingSnackBar.success(
          context,
          'تم تحديث الملف الشخصي بنجاح',
          position: FloatingSnackBarPosition.top,
        );
      } else {
        FloatingSnackBar.error(
          context,
          'حدث خطأ أثناء تحديث الملف الشخصي',
          position: FloatingSnackBarPosition.top,
        );
      }
    } catch (e) {
      FloatingSnackBar.error(
        context,
        'حدث خطأ أثناء تحديث الملف الشخصي',
        position: FloatingSnackBarPosition.top,
      );
    }
  }

  void _showEditDialog() {
    final nameCtrl = TextEditingController(text: name);
    final emailCtrl = TextEditingController(text: email);
    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text(
            'تعديل الملف الشخصي',
            style: TextStyle(
              fontFamily: 'IBM Plex Sans Arabic',
              fontWeight: FontWeight.w600,
              fontSize: AppTypography.lg,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  textAlign: TextAlign.right,
                  decoration: const InputDecoration(
                    labelText: 'اسم المستخدم',
                    labelStyle: TextStyle(fontFamily: 'IBM Plex Sans Arabic'),
                    prefixIcon: Icon(
                      Icons.person_outline,
                      color: AppColors.textSecondary,
                    ),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primary),
                    ),
                  ),
                  style: const TextStyle(
                    fontFamily: 'IBM Plex Sans Arabic',
                    fontSize: AppTypography.md,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: emailCtrl,
                  textAlign: TextAlign.right,
                  decoration: const InputDecoration(
                    labelText: 'البريد الإلكتروني',
                    labelStyle: TextStyle(fontFamily: 'IBM Plex Sans Arabic'),
                    prefixIcon: Icon(
                      Icons.mail_outline,
                      color: AppColors.textSecondary,
                    ),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primary),
                    ),
                  ),
                  style: const TextStyle(
                    fontFamily: 'IBM Plex Sans Arabic',
                    fontSize: AppTypography.md,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text(
                'إلغاء',
                style: TextStyle(
                  fontFamily: 'IBM Plex Sans Arabic',
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => updateProfile(nameCtrl.text, emailCtrl.text, uid),
              child: const Text(
                'حفظ',
                style: TextStyle(
                  fontFamily: 'IBM Plex Sans Arabic',
                  color: AppColors.accent,
                  fontSize: AppTypography.sm,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _logout() {
    Hive.box('userBox').clear();
    FloatingSnackBar.success(
      context,
      'تم تسجيل الخروج بنجاح',
      position: FloatingSnackBarPosition.top,
    );
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: Image.asset('lib/assets/logo.png', width: 56, height: 56),

        title: 
          
            Text('الملف الشخصي', style: TextStyle(fontFamily: 'IBM Plex Sans Arabic', color: Colors.white, fontSize: AppTypography.xl),),
          
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 56,
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              child: Image.asset('lib/assets/user.png', width: 75, height: 75 , color: AppColors.accent),
            ),
            const SizedBox(height: 16),
            Text(
              name,
              style: const TextStyle(
                fontFamily: 'IBM Plex Sans Arabic',
                fontSize: AppTypography.xl,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              email,
              style: const TextStyle(
                fontFamily: 'IBM Plex Sans Arabic',
                fontSize: AppTypography.sm,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'معرّف المستخدم: $uid',
                style: const TextStyle(
                  fontFamily: 'IBM Plex Sans Arabic',
                  fontSize: AppTypography.sm,
                  color: AppColors.accentDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                role == 'admin' ? 'مدير' : 'مستخدم',
                style: const TextStyle(
                  fontFamily: 'IBM Plex Sans Arabic',
                  fontSize: AppTypography.sm,
                  color: AppColors.accentDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _showEditDialog,
                icon: const Icon(Icons.edit, size: 22),
                label: const Text(
                  'تعديل الملف الشخصي',
                  style: TextStyle(
                    fontFamily: 'IBM Plex Sans Arabic',
                    fontSize: AppTypography.md,
                  ),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _logout,
                icon: const Icon(Icons.logout, color: Colors.red, size: 22),
                label: const Text(
                  'تسجيل الخروج',
                  style: TextStyle(
                    fontFamily: 'IBM Plex Sans Arabic',
                    color: Colors.red,
                    fontSize: AppTypography.md,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
