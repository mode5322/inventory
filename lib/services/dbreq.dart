import '/core/export.dart';
import '../config/api_config.dart';
import 'package:http/http.dart' as http;

class db {
  static String get base => ApiConfig.baseUrl;
  static String get _base => base;
  static String imgUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    final p = path.replaceAll('\\', '/').trim();
    if (p.startsWith('http://') || p.startsWith('https://')) return p;
    final normalized = p.replaceFirst(RegExp(r'^/+'), '');
    return '$_base/$normalized';
  }

  static Future<Map<String, dynamic>> _post(
    String path, [
    Map<String, String>? body,
  ]) async {
    try {
      final response = await http.post(
        Uri.parse('$_base$path'),
        body: body,
      );
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        return Map<String, dynamic>.from(jsonDecode(response.body));
      }
      return {'success': false, 'message': 'server_error'};
    } catch (e) {
      debugPrint('❌ $path error: $e');
      return {'success': false, 'message': 'connection_error'};
    }
  }

  //  --------------------------register function--------------------------------
  static Future<Map<String, dynamic>> register(
    String email,
    String password,
    String name,
    String role,
  ) {
    return _post('/auth/regist.php', {
      'email': email,
      'password': password,
      'name': name,
      'role': role,
    });
  }

  //  --------------------------login function--------------------------------
    static Future<Map<String, dynamic>> login(String email, String password) {
    return _post('/auth/login.php', {'email': email, 'password': password});
  }


  //  --------------------------addItem function--------------------------------
  static Future<Map<String, dynamic>> addItem(
    String name,
    String? imagePath,
  ) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$_base/items/add_item.php'),
      );
      request.fields['name'] = name;
      if (imagePath != null && imagePath.isNotEmpty) {
        final fileName = imagePath.replaceAll('\\', '/').split('/').last;
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          imagePath,
          filename: fileName,
        ));
      }
      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        return Map<String, dynamic>.from(jsonDecode(response.body));
      }
      return {'success': false, 'message': 'server_error'};
    } catch (e) {
      debugPrint('addItem error: $e');
      return {'success': false, 'message': 'connection_error'};
    }
  }

  //  --------------------------getItems function--------------------------------
  static Future<Map<String, dynamic>> getItems() {
    return _post('/items/get_items.php');
  }

  //  --------------------------deleteItem function--------------------------------
  static Future<Map<String, dynamic>> deleteItem(int id) {
    return _post('/items/deleteitem.php', {'id': id.toString()});
  }

  //  --------------------------getUserID function--------------------------------
  static Future<Map<String, dynamic>> uid(String email) {
    return _post('/users/uid.php', {'email': email});
  }

  //  --------------------------getUsers function--------------------------------
  static Future<Map<String, dynamic>> uids() {
    return _post('/users/uids.php');
  }

  //  --------------------------logout function--------------------------------
  static Future<void> logout() async {
    final box = Hive.box('userBox');
    await box.clear();
    debugPrint('🔓 logout: userBox cleared');
  }

  //  --------------------------updateProfile function--------------------------------
  static Future<Map<String, dynamic>> updateProfile(
    String name,
    String email,
    int uid,
  ) {
    return _post('/auth/update_profile.php', {
      'name': name,
      'email': email,
      'uid': uid.toString(),
    });
  }
}
