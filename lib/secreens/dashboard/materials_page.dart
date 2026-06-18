import 'dart:io';

import '/core/export.dart';
import 'package:image_picker/image_picker.dart';

class MaterialsPage extends StatefulWidget {
  const MaterialsPage({super.key});

  @override
  State<MaterialsPage> createState() => _MaterialsPageState();
}

class _MaterialsPageState extends State<MaterialsPage> {
  final List<Map<String, dynamic>> _items = [];
  final _searchCtrl = TextEditingController();
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    fetchItems();
  }

  Future<void> fetchItems() async {
    try {
      final result = await db.getItems();
      if (result['success'] == true && result['message'] == '2') {
        setState(() {
          _items.clear();
          for (var item in result['items']) {
            _items.add({
              'id': int.parse(item['id'].toString()),
              'name': item['name'],
              'img': item['img'] ?? '',
            });
          }
        });
      }
    } catch (e) {
      if (!mounted) return;
      FloatingSnackBar.error(
        context,
        'حدث خطأ أثناء جلب المواد',
        position: FloatingSnackBarPosition.top,
      );
    }
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
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
        title: const Text('إدارة المواد'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchCtrl,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                hintText: '. . . البحث عن مادة',
                hintStyle: const TextStyle(
                  fontFamily: 'IBM Plex Sans Arabic',
                  fontSize: AppTypography.sm,
                ),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF757684), size: 26),
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
              style: const TextStyle(fontFamily: 'IBM Plex Sans Arabic', fontSize: AppTypography.md),
            ),
          ),
          Expanded(
            child: _items.isEmpty
                ? Column(
                    children: [
                      const SizedBox(height: 200),

                      const Icon(
                        Icons.inventory_2,
                        color: AppColors.accent,
                        size: 100,
                      ),
                      const SizedBox(height: 20),
                      const Center(
                        child: Text(
                          '. . . لا توجد مواد',
                          style: TextStyle(
                            fontFamily: 'IBM Plex Sans Arabic',
                            color: Color(0xFF757684),
                            fontSize: AppTypography.sm,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                    ],
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.68,
                    ),
                    itemCount: _items.length,
                    itemBuilder: (_, i) {
                      final item = _items[i];
                      return Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(97, 247, 184, 66),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: _itemImage(item['img'] as String? ?? ''),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 8, 4, 8),
                              child: Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item['name'] as String,
                                        textAlign: TextAlign.left,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontFamily: 'IBM Plex Sans Arabic',
                                          fontWeight: FontWeight.w600,
                                          fontSize: AppTypography.md,
                                          color: Color(0xFF0D1C2E),
                                        ),
                                      ),
                                    ),
                                    Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () => _deleteItem(item['id'] as int),
                                        borderRadius: BorderRadius.circular(20),
                                        child: const Padding(
                                          padding: EdgeInsets.all(8),
                                          child: Icon(
                                            Icons.delete_outline,
                                            size: 24,
                                            color: Color(0xFFDC2626),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
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
        onPressed: _showAddDialog,
        backgroundColor: AppColors.accent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showAddDialog() {
    final nameCtrl = TextEditingController();
    XFile? pickedImage;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: AlertDialog(
                insetPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 40,
                ),
                contentPadding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                content: SizedBox(
                  width: double.maxFinite,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 16),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                  ),
                                  onPressed: () => Navigator.pop(ctx),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                                const Spacer(),
                                Image.asset('lib/assets/logo.png', width: 56, height: 56),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'إضافة مادة جديدة',
                              style: TextStyle(
                                fontFamily: 'IBM Plex Sans Arabic',
                                fontSize: AppTypography.xl,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              controller: nameCtrl,
                              textAlign: TextAlign.right,
                              decoration: InputDecoration(
                                labelText: 'اسم المادة',
                                labelStyle: const TextStyle(
                                  fontFamily: 'IBM Plex Sans Arabic',
                                  fontSize: AppTypography.sm,
                                  color: Color(0xFF444653),
                                ),
                                prefixIcon: const Icon(
                                  Icons.inventory,
                                  color: Color(0xFF757684),
                                  size: 24,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFC4C5D5),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: AppColors.accent,
                                  ),
                                ),
                              ),
                              style: const TextStyle(
                                fontFamily: 'IBM Plex Sans Arabic',
                                fontSize: AppTypography.md,
                              ),
                            ),
                            const SizedBox(height: 16),
                            InkWell(
                              onTap: () async {
                                try {
                                  final XFile? image = await picker.pickImage(
                                    source: ImageSource.gallery,
                                    imageQuality: 80,
                                  );
                                  if (image != null && mounted) {
                                    setDialogState(() => pickedImage = image);
                                  }
                                } catch (e) {
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'فشل في اختيار الصورة: $e',
                                        ),
                                      ),
                                    );
                                  }
                                }
                              },
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: pickedImage != null
                                        ? AppColors.accent
                                        : const Color(0xFFC4C5D5),
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: pickedImage != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.file(
                                          File(pickedImage!.path),
                                          height: 120,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : const Column(
                                        children: [
                                          Icon(
                                            Icons.add_a_photo,
                                            color: Color(0xFF757684),
                                            size: 48,
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            'اضغط لتحميل صورة ',
                                            style: TextStyle(
                                              fontFamily:
                                                  'IBM Plex Sans Arabic',
                                              fontSize: AppTypography.sm,
                                              color: Color(0xFF444653),
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              height: 54,
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  if (nameCtrl.text.trim().isEmpty) {
                                    FloatingSnackBar.error(
                                      context,
                                      'يرجى إدخال اسم المادة',
                                      position: FloatingSnackBarPosition.top,
                                    );
                                    return;
                                  }
                                  Navigator.pop(ctx);
                                  final result = await db.addItem(
                                    nameCtrl.text.trim(),
                                    pickedImage?.path,
                                  );
                                  if (result['success'] == true) {
                                    fetchItems();
                                    if (!mounted) return;
                                    FloatingSnackBar.success(
                                      context,
                                      'تمت إضافة المادة بنجاح',
                                      position: FloatingSnackBarPosition.top,
                                    );
                                  } else {
                                    if (!mounted) return;
                                    FloatingSnackBar.error(
                                      context,
                                      'حدث خطأ أثناء الإضافة',
                                      position: FloatingSnackBarPosition.top,
                                    );
                                  }
                                },
                                icon: const Icon(
                                  Icons.add_circle,
                                  color: Colors.white,
                                ),
                                label: const Text(
                                  'إضافة مادة',
                                  style: TextStyle(
                                    fontFamily: 'IBM Plex Sans Arabic',
                                    fontSize: AppTypography.md,
                                    color: Colors.white,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.accent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _deleteItem(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text(
            'حذف المادة',
            style: TextStyle(fontFamily: 'IBM Plex Sans Arabic', fontWeight: FontWeight.w600),
          ),
          content: const Text(
            'هل أنت متأكد من حذف هذه المادة؟',
            style: TextStyle(fontFamily: 'IBM Plex Sans Arabic'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('إلغاء', style: TextStyle(fontFamily: 'IBM Plex Sans Arabic')),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text(
                'حذف',
                style: TextStyle(fontFamily: 'IBM Plex Sans Arabic', color: Color(0xFFDC2626)),
              ),
            ),
          ],
        ),
      ),
    );
    if (confirm != true || !mounted) return;

    final result = await db.deleteItem(id);
    if (!mounted) return;
    if (result['success'] == true) {
      fetchItems();
      FloatingSnackBar.success(context, 'تم حذف المادة', position: FloatingSnackBarPosition.top);
    } else {
      FloatingSnackBar.error(context, 'فشل حذف المادة', position: FloatingSnackBarPosition.top);
    }
  }

  Widget _itemImage(String img) {
    if (img.isEmpty) {
      return ColoredBox(
        color: AppColors.primary.withValues(alpha: 0.1),
        child: const Center(
          child: Icon(Icons.inventory_2, color: AppColors.accent, size: 48),
        ),
      );
    }
    return Image.network(
      db.imgUrl(img),
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (_, _, _) => ColoredBox(
        color: AppColors.primary.withValues(alpha: 0.1),
        child: const Center(
          child: Icon(Icons.broken_image, color: Color(0xFF757684), size: 40),
        ),
      ),
    );
  }
}
