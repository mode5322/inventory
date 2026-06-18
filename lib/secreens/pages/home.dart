import '/core/export.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> _items = [];
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

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
              'img': (item['img']?.toString() ?? '').trim(),
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

  List<Map<String, dynamic>> get _filteredItems {
    final q = _searchCtrl.text.trim().toLowerCase();
    if (q.isEmpty) return _items;
    return _items
        .where((item) => (item['name'] as String).toLowerCase().contains(q))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('userBox').listenable(keys: ['name']),
      builder: (context, box, _) {
        final name = box.get('name') ?? '';
        return Scaffold(
          backgroundColor: AppColors.bg,
          appBar: AppBar(
            leading: Image.asset('lib/assets/logo.png', width: 56, height: 56),
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            title: Text(
              ' في المستودع $name مرحبا  ',
              style: const TextStyle(
                fontFamily: 'IBM Plex Sans Arabic',
                color: Colors.white,
                fontSize: AppTypography.lg,
              ),
            ),
          ),
          body: RefreshIndicator(
            onRefresh: fetchItems,
            color: AppColors.accent,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            _MiniStat(
                              label: 'إجمالي المواد',
                              value: '${_items.length}',
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _searchCtrl,
                          onChanged: (_) => setState(() {}),
                          textAlign: TextAlign.right,
                          decoration: InputDecoration(
                            hintText: '. . . البحث عن مادة',
                            hintStyle: const TextStyle(
                              fontFamily: 'IBM Plex Sans Arabic',
                              fontSize: AppTypography.sm,
                            ),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: AppColors.accent,
                              size: 26,
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
                                color: AppColors.accentDark,
                              ),
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
                ),
                if (_items.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Text(
                        'اسحب للأسفل لتحديث القائمة',
                        style: TextStyle(
                          fontFamily: 'IBM Plex Sans Arabic',
                          color: Color(0xFF757684),
                          fontSize: AppTypography.sm,
                        ),
                      ),
                    ),
                  )
                else if (_filteredItems.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Text(
                        'لا توجد نتائج للبحث',
                        style: TextStyle(
                          fontFamily: 'IBM Plex Sans Arabic',
                          color: Color(0xFF757684),
                          fontSize: AppTypography.sm,
                        ),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.68,
                          ),
                      delegate: SliverChildBuilderDelegate((_, i) {
                        final item = _filteredItems[i];
                        return Container(
                          key: ValueKey('${item['id']}-${item['img']}'),
                          decoration: BoxDecoration(
                          color: const Color.fromARGB(97, 247, 184, 66),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(
                                  alpha: 0.08,
                                ),
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
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 12,
                                ),
                                child: Text(
                                  item['name'] as String,
                                  textAlign: TextAlign.center,
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
                            ],
                          ),
                        );
                      }, childCount: _filteredItems.length),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _itemImage(String img) {
    if (img.isEmpty) {
      return ColoredBox(
        color: AppColors.primary.withValues(alpha: 0.1),
        child: const Center(
          child: Icon(Icons.inventory_2, color: AppColors.primary, size: 48),
        ),
      );
    }
    final url = db.imgUrl(img);
    return Image.network(
      url,
      key: ValueKey(url),
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      gaplessPlayback: true,
      errorBuilder: (_, _, _) => ColoredBox(
        color: AppColors.primary.withValues(alpha: 0.1),
        child: const Center(
          child: Icon(Icons.broken_image, color: Color(0xFF757684), size: 40),
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label, value;
  const _MiniStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 12),
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
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.accent,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'IBM Plex Sans Arabic',
                fontSize: AppTypography.xs,
                color: Color(0xFF444653),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
