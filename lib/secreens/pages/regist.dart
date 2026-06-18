import '../../core/export.dart';

class RegistPage extends StatefulWidget {
  const RegistPage({super.key});

  @override
  State<RegistPage> createState() => _RegistPageState();
}

class _RegistPageState extends State<RegistPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscurePass = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> register() async {
    if (!_formKey.currentState!.validate()) return;
    final res = await db.register(_emailCtrl.text, _passCtrl.text, _nameCtrl.text, 'user');
    debugPrint('⬅️ register result: $res');
    if (!mounted) return;
    if (res['success'] == true && res['message'] == '2') {
      FloatingSnackBar.success(context,'تم التسجيل بنجاح',position: FloatingSnackBarPosition.top,);
      Navigator.pop(context);
    } else if (res['message'] == '1') {
      FloatingSnackBar.error(context,'البريد الإلكتروني مستخدم من قبل',position: FloatingSnackBarPosition.top,);
    } else {
      FloatingSnackBar.error(context,'فشل في التسجيل',position: FloatingSnackBarPosition.top,);
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
                      Text('إنشاء حساب',
                          style: TextStyle(
                              fontFamily: 'IBM Plex Sans Arabic',
                              fontSize: AppTypography.xxl,
                              fontWeight: FontWeight.w700,
                              color: Colors.blue[900])),
                      const SizedBox(height: 28),
                      TextFormField(
                        controller: _nameCtrl,
                        textInputAction: TextInputAction.next,
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          labelText: 'اسم المستخدم',
                          prefixIcon: Icon(Icons.person_outline, color: Colors.amber[700], size: 26),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.amber[600]!),
                          ),
                        ),
                        style: const TextStyle(fontFamily: 'IBM Plex Sans Arabic', fontSize: AppTypography.md),
                        validator: (v) => v == null || v.isEmpty ? 'أدخل اسم المستخدم' : null,
                      ),
                      const SizedBox(height: 14),
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
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'أدخل البريد الإلكتروني';
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v)) return 'بريد غير صالح';
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _passCtrl,
                        obscureText: _obscurePass,
                        textInputAction: TextInputAction.next,
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
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'أدخل كلمة المرور';
                          if (v.length < 6) return '6 أحرف على الأقل';
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _confirmCtrl,
                        obscureText: _obscureConfirm,
                        textInputAction: TextInputAction.done,
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          labelText: 'تأكيد كلمة المرور',
                          prefixIcon: Icon(Icons.lock_reset, color: Colors.amber[700], size: 26),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.amber[600]!),
                          ),
                        ),
                        style: const TextStyle(fontFamily: 'IBM Plex Sans Arabic', fontSize: AppTypography.md),
                        validator: (v) => v != _passCtrl.text ? 'كلمة المرور غير متطابقة' : null,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: FilledButton.icon(
                          onPressed: register,
                          icon: const Icon(Icons.person_add, size: 26),
                          label: const Text('إنشاء حساب',
                              style: TextStyle(fontFamily: 'IBM Plex Sans Arabic', fontSize: AppTypography.md)),
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.blue[700],
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton.icon(
                            onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                            icon: Icon(Icons.login, color: Colors.blue[700], size: 26),
                            label: Text('تسجيل الدخول',
                                style: TextStyle(fontFamily: 'IBM Plex Sans Arabic', color: Colors.blue[700], fontSize: AppTypography.sm)),
                          ),
                          Text('لديك حساب بالفعل؟',
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
