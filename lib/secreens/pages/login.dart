import '/core/export.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscurePass = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    final result = await db.login(_emailCtrl.text, _passCtrl.text);
    if (!mounted) return;
    if (result['success'] == true && result['message'] == '2') {
      final box = Hive.box('userBox');
      await box.put('name', result['name'] ?? '');
      await box.put('email', result['email'] ?? '');
      await box.put('role', result['role'] ?? 'user');
      await box.put('uid', result['uid'] ?? '');
      FloatingSnackBar.success(context,'تم تسجيل الدخول بنجاح',position: FloatingSnackBarPosition.top,);
      Navigator.pushReplacementNamed(context, '/main_home');
    } else if (result['message'] == '1') {
      FloatingSnackBar.error(context,'البريد الإلكتروني غير موجود',position: FloatingSnackBarPosition.top,);
    } else if (result['message'] == '3') {
      FloatingSnackBar.error(context,'كلمة المرور غير صحيحة',position: FloatingSnackBarPosition.top,);
    } else {
      FloatingSnackBar.error(context,'فشل في تسجيل الدخول',position: FloatingSnackBarPosition.top,);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Card(
              elevation: 8,
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('lib/assets/logo.png', width: 120, height: 120),
                      const SizedBox(height: 12),
                      Text('تسجيل الدخول',
                          style: TextStyle(
                              fontFamily: 'IBM Plex Sans Arabic',
                              fontSize: AppTypography.xxl,
                              fontWeight: FontWeight.w700,
                              color: Colors.blue[900])),
                      const SizedBox(height: 28),
                      TextFormField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          labelText: 'البريد الإلكتروني',
                          prefixIcon: Icon(Icons.mail_outline, color: Colors.amber[700], size: 26),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.amber[600]!),
                          ),
                        ),
                        style: const TextStyle(fontFamily: 'IBM Plex Sans Arabic', fontSize: AppTypography.md),
                        validator: (v) => v == null || v.isEmpty ? 'أدخل البريد الإلكتروني' : null,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _passCtrl,
                        obscureText: _obscurePass,
                        textInputAction: TextInputAction.done,
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          labelText: 'كلمة المرور',
                          prefixIcon: Icon(Icons.lock_outline, color: Colors.amber[700], size: 26),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.amber[600]!),
                          ),
                        ),
                        style: const TextStyle(fontFamily: 'IBM Plex Sans Arabic', fontSize: AppTypography.md),
                        validator: (v) => v == null || v.isEmpty ? 'أدخل كلمة المرور' : null,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: FilledButton(
                          onPressed: _login,
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.blue[700],
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text('تسجيل الدخول',
                              style: TextStyle(fontFamily: 'IBM Plex Sans Arabic', fontSize: AppTypography.md)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton.icon(
                            onPressed: () => Navigator.push(
                                context, MaterialPageRoute(builder: (_) => const RegistPage())),
                            icon: Icon(Icons.person_add, color: Colors.blue[700], size: 26),
                            label: Text('إنشاء حساب جديد',
                                style: TextStyle(fontFamily: 'IBM Plex Sans Arabic', color: Colors.blue[700], fontSize: AppTypography.sm)),
                          ),
                          Text('ليس لديك حساب؟',
                              style: TextStyle(fontFamily: 'IBM Plex Sans Arabic', fontSize: AppTypography.sm,
                                  color: Colors.amber[800], fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
