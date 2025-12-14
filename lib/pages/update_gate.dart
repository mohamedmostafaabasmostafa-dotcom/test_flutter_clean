import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/models.dart';
import '../services/update_service.dart';
import 'home_page.dart';

class UpdateGate extends StatefulWidget {
  final GameState state;
  const UpdateGate({super.key, required this.state});

  @override
  State<UpdateGate> createState() => _UpdateGateState();
}

class _UpdateGateState extends State<UpdateGate> with WidgetsBindingObserver {
  bool _ready = false;
  bool _checking = false;
  bool _sheetOpen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _check();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // لو المستخدم راح حدث ورجع للتطبيق: اعمل check تاني
    if (state == AppLifecycleState.resumed) {
      _check();
    }
  }

  Future<void> _check() async {
    if (_checking || _sheetOpen) return;
    _checking = true;

    try {
      final service = UpdateService(Supabase.instance.client);
      final decision = await service.checkUpdate(platform: 'all');

      if (!mounted) return;

      if (decision.hasUpdate) {
        _sheetOpen = true;
        await _showUpdateSheet(decision);
        _sheetOpen = false;
      }

      if (mounted) setState(() => _ready = true);
    } catch (_) {
      // لو حصل أي خطأ في الشبكة/سوبابيز، ما توقفش التطبيق
      if (mounted) setState(() => _ready = true);
    } finally {
      _checking = false;
    }
  }

  Future<void> _showUpdateSheet(UpdateDecision d) async {
    await showModalBottomSheet(
      context: context,
      isDismissible: !d.force,
      enableDrag: !d.force,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return WillPopScope(
          onWillPop: () async => !d.force,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: SafeArea(
              top: false,
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF7F2),
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 22,
                      offset: Offset(0, 10),
                      color: Color(0x33000000),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: d.force
                                ? const Color(0xFFFFE0E0)
                                : const Color(0xFFE7F0FF),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            Icons.system_update_alt_rounded,
                            color: d.force
                                ? const Color(0xFFC62828)
                                : const Color(0xFF1565C0),
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            d.force ? 'تحديث إجباري' : 'تحديث متاح',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Message
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        d.message,
                        style: const TextStyle(
                          fontSize: 15.5,
                          height: 1.4,
                          color: Color(0xFF333333),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Versions
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0x11000000)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _kv('نسختك الحالية', d.currentVersion),
                          const SizedBox(height: 6),
                          _kv('آخر نسخة', d.latestVersion),
                          const SizedBox(height: 6),
                          _kv('الحد الأدنى', d.minVersion),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Buttons
                    Row(
                      children: [
                        if (!d.force)
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.of(ctx).pop(),
                              style: OutlinedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 13),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: const Text(
                                'لاحقًا',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        if (!d.force) const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              final link = (d.url ?? '').trim();
                              if (link.isEmpty) return;

                              final uri = Uri.parse(link);
                              await launchUrl(
                                uri,
                                mode: LaunchMode.externalApplication,
                              );

                              if (!d.force && ctx.mounted) {
                                Navigator.of(ctx).pop();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              backgroundColor: d.force
                                  ? const Color(0xFFC62828)
                                  : const Color(0xFF1565C0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: Text(
                              d.force ? 'تحديث الآن (إجباري)' : 'تحديث الآن',
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _kv(String k, String v) {
    return Row(
      children: [
        Expanded(
          child: Text(
            k,
            style: const TextStyle(
              fontSize: 13.5,
              color: Color(0xFF666666),
            ),
          ),
        ),
        Text(
          v,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return HomePage(state: widget.state);
  }
}
