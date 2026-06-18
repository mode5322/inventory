import '/core/export.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final List<Map<String, dynamic>> _users = [];
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      final result = await db.uids();
      debugPrint('⬅️ fetchUsers result: $result');
      if (result['success'] == true && result['message'] == '2') {
        setState(() => _users.clear());
        for (var u in result['users']) {
          _users.add({'name': u['name'], 'email': u['email'], 'role': u['role']});
        }
      } else {
        if (!mounted) return;
        FloatingSnackBar.error(
          context,
          'فشل في جلب المستخدمين',
          position: FloatingSnackBarPosition.top,
        );
      }
    } catch (e) {
      if (!mounted) return;
      FloatingSnackBar.error(
        context,
        'حدث خطأ أثناء جلب المستخدمين',
        position: FloatingSnackBarPosition.top,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text('إدارة المستخدمين'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchCtrl,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                hintText: 'بحث عن مستخدم...',
                hintStyle: const TextStyle(
                  fontFamily: 'IBM Plex Sans Arabic',
                  fontSize: AppTypography.sm,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Color(0xFF757684),
                  size: 26,
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFC4C5D5)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
              ),
              style: const TextStyle(
                fontFamily: 'IBM Plex Sans Arabic',
                fontSize: AppTypography.md,
              ),
            ),
          ),
          Expanded(
            child: _users.isEmpty
                ? const Center(
                    child: Text(
                      'لا يوجد مستخدمين',
                      style: TextStyle(
                        fontFamily: 'IBM Plex Sans Arabic',
                        color: Color(0xFF757684),
                        fontSize: AppTypography.sm,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _users.length,
                    itemBuilder: (_, i) {
                      final u = _users[i];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(99),
                              ),
                              child: Image.asset(
                                'lib/assets/user.png',
                                width: 40,
                                height: 40,
                                color: AppColors.accent,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    u['name'] as String,
                                    style: const TextStyle(
                                      fontFamily: 'IBM Plex Sans Arabic',
                                      fontWeight: FontWeight.w600,
                                      fontSize: AppTypography.md,
                                      color: Color(0xFF0D1C2E),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    u['email'] as String,
                                    style: const TextStyle(
                                      fontFamily: 'IBM Plex Sans Arabic',
                                      fontSize: AppTypography.md,
                                      color: Color(0xFF757684),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddUserDialog,
        backgroundColor: AppColors.accent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showAddUserDialog() {
    final newUserNameCtrl = TextEditingController();
    final newUserEmail = TextEditingController();
    final newUserPass = TextEditingController();
    String selectedRole = 'user'; // القيمة الافتراضية
    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: AlertDialog(
            backgroundColor: AppColors.bg,
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 40,
            ),
            contentPadding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: const Text(
              'إضافة مستخدم',
              style: TextStyle(
                fontFamily: 'IBM Plex Sans Arabic',
                fontWeight: FontWeight.w600,
                fontSize: AppTypography.lg,
              ),
            ),
            content: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
              child: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: newUserNameCtrl,
                      textAlign: TextAlign.right,
                      decoration: const InputDecoration(
                        prefixIcon: const Icon(
                          Icons.person,
                          color: AppColors.accent,
                          size: 26,
                        ),
                        labelText: 'الاسم',
                        labelStyle: TextStyle(
                          fontFamily: 'IBM Plex Sans Arabic',
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: AppTypography.md,
                        ),
                      ),
                      style: const TextStyle(
                        fontFamily: 'IBM Plex Sans Arabic',
                        fontSize: AppTypography.md,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    const SizedBox(height: 5),
                    TextField(
                      controller: newUserEmail,
                      textAlign: TextAlign.right,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.mail,
                          color: AppColors.accent,
                          size: 26,
                        ),
                        labelText: 'البريد',
                        labelStyle: TextStyle(
                          fontFamily: 'IBM Plex Sans Arabic',
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontSize: AppTypography.md,
                        ),
                      ),
                      style: const TextStyle(
                        fontFamily: 'IBM Plex Sans Arabic',
                        fontSize: AppTypography.md,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    const SizedBox(height: 5),
                    TextField(
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.done,
                      controller: newUserPass,
                      obscureText: true,
                      textAlign: TextAlign.right,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.lock,
                          color: AppColors.accent,
                          size: 26,
                        ),
                        labelText: 'كلمة المرور',
                        labelStyle: TextStyle(
                          fontFamily: 'IBM Plex Sans Arabic',
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontSize: AppTypography.md,
                        ),
                      ),
                      style: const TextStyle(
                        fontFamily: 'IBM Plex Sans Arabic',
                        fontSize: AppTypography.md,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('إلغاء'),
              ),
              TextButton(
                onPressed: () async {
                  if (newUserNameCtrl.text.trim().isEmpty ||
                      newUserEmail.text.trim().isEmpty ||
                      newUserPass.text.isEmpty) {
                    FloatingSnackBar.error(
                      context,
                      'يرجى تعبئة جميع الحقول',
                      position: FloatingSnackBarPosition.top,
                    );
                    return;
                  }
                  Navigator.pop(ctx);
                  final res = await db.register(
                    newUserEmail.text.trim(),
                    newUserPass.text,
                    newUserNameCtrl.text.trim(),
                    selectedRole,
                  );
                  if (res['success'] == true) {
                    fetchUsers();
                    FloatingSnackBar.success(
                      context,
                      'تمت الإضافة',
                      position: FloatingSnackBarPosition.top,
                    );
                  } else {
                    FloatingSnackBar.error(
                      context,
                      'فشل الإضافة',
                      position: FloatingSnackBarPosition.top,
                    );
                  }
                },
                child: const Text(
                  'انشاء الحساب ',
                  style: TextStyle(
                    fontFamily: 'IBM Plex Sans Arabic',
                    color: AppColors.accent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
