import '/core/export.dart';

class DashPage extends StatefulWidget {
  const DashPage({super.key});

  @override
  State<DashPage> createState() => _DashPageState();
}

class _DashPageState extends State<DashPage> {
  final List<Map<String, dynamic>> _alerts = [];
  final name = Hive.box('userBox').get('name');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: Image.asset('lib/assets/logo.png', width: 56, height: 56),
        title: Text(
          'لوحة الإدارة',
          style: TextStyle(
            fontFamily: 'IBM Plex Sans Arabic',
            color: Colors.white,
            fontSize: AppTypography.xl,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'ادرة المواد والمستخدمين',
              style: TextStyle(
                fontFamily: 'IBM Plex Sans Arabic',
                fontSize: AppTypography.xl,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0D1C2E),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'مرحباً $name ، تتبع حالة المخزون والمستخدمين ',
              textDirection: TextDirection.rtl,
              style: const TextStyle(
                fontFamily: 'IBM Plex Sans Arabic',
                fontSize: AppTypography.md,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.group,
                    label: 'إدارة المستخدمين',
                    onTap: () => Navigator.pushNamed(context, '/users'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.inventory_2,
                    label: 'إدارة المواد',
                    onTap: () => Navigator.pushNamed(context, '/materials'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (_alerts.isNotEmpty)
              ...List.generate(_alerts.length, (i) {
                final a = _alerts[i];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _AlertCard(
                    title: a['name'] as String,
                    serial: a['sku'] as String,
                    status: a['status'] as String,
                    qty: a['qty'] as String,
                    statusColor: a['statusColor'] as Color,
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 28),
          decoration: BoxDecoration(
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
              Icon(icon, size: 36, color: AppColors.accent),
              const SizedBox(height: 10),
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'IBM Plex Sans Arabic',
                  fontSize: AppTypography.sm,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0D1C2E),
                ),
              ),
              const SizedBox(height: 6),
              const Icon(Icons.arrow_back, size: 20, color: AppColors.primary),
            ],
          ),
        ),
      ),
    );
  }
}

class _AlertCard extends StatelessWidget {
  final String title, serial, status, qty;
  final Color statusColor;

  const _AlertCard({
    required this.title,
    required this.serial,
    required this.status,
    required this.qty,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'IBM Plex Sans Arabic',
                    fontWeight: FontWeight.w600,
                    fontSize: AppTypography.md,
                    color: Color(0xFF0D1C2E),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  serial,
                  style: const TextStyle(
                    fontFamily: 'IBM Plex Sans Arabic',
                    fontSize: AppTypography.xs,
                    color: Color(0xFF757684),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontFamily: 'IBM Plex Sans Arabic',
                    fontSize: AppTypography.xs,
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                qty,
                style: const TextStyle(
                  fontFamily: 'IBM Plex Sans Arabic',
                  fontSize: AppTypography.sm,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0D1C2E),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
