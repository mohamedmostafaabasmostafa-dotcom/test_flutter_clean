import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:supabase_flutter/supabase_flutter.dart";
import "package:package_info_plus/package_info_plus.dart";
import "package:url_launcher/url_launcher.dart";

import "core/models.dart";
import "pages/home_page.dart";
import "pages/names_page.dart";
import "pages/reveal_roles_page.dart";
import "pages/discussion_page.dart";
import "pages/evidence_page.dart";
import "pages/voting_page.dart";
import "pages/end_page.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ يخلي السهم أبيض في كل الصفحات
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  // ✅ Supabase init
  await Supabase.initialize(
    url: "https://endlkynodzeiodysvkzs.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVuZGxreW5vZHplaW9keXN2a3pzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjU1NjE5MTUsImV4cCI6MjA4MTEzNzkxNX0.E9NV1Of26t_MQ0EhLa7fHtzPBl8j71LxWe87GbIp0OY",
  );

  runApp(const MafiosoApp());
}

class MafiosoApp extends StatelessWidget {
  const MafiosoApp({super.key});

  @override
  Widget build(BuildContext context) {
    final state = GameState();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "مافيوسو",
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: "Tajawal",
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
          ),
          foregroundColor: Colors.white,
          backgroundColor: Color(0xFF6B0E12),
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6B0E12),
          primary: const Color(0xFF6B0E12),
        ),
      ),
      initialRoute: "/",
      onGenerateRoute: (settings) {
        Widget page;
        switch (settings.name) {
          case "/":
            page = UpdateGate(state: state);
            break;
          case "/home":
            page = HomePage(state: settings.arguments as GameState);
            break;
          case "/names":
            page = NamesPage(state: settings.arguments as GameState);
            break;
          case "/reveal":
            page = RevealRolesPage(state: settings.arguments as GameState);
            break;
          case "/discussion":
            page = DiscussionPage(state: settings.arguments as GameState);
            break;
          case "/evidence":
            page = EvidencePage(state: settings.arguments as GameState);
            break;
          case "/voting":
            page = VotingPage(state: settings.arguments as GameState);
            break;
          case "/end":
            final map = settings.arguments as Map<String, dynamic>;
            page = EndPage(
              state: map["state"] as GameState,
              innocentsWin: map["innocentsWin"] as bool,
            );
            break;
          default:
            return null;
        }

        return MaterialPageRoute(
          builder: (_) => _CopyrightWrapper(child: page),
        );
      },
    );
  }
}

/// ✅ Wrapper widget يضيف حقوق الطبع والنشر في كل صفحة
class _CopyrightWrapper extends StatelessWidget {
  final Widget child;

  const _CopyrightWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // المحتوى الأصلي
          Positioned.fill(child: child),

          // حقوق الطبع والنشر في الأسفل
          Positioned(
            bottom: 4, // مسافة صغيرة جداً من الأسفل
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "جميع الحقوق محفوظة © محمد مصطفى عباس 2025",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 10,
                    fontFamily: "Tajawal",
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ✅ UpdateGate: يفحص الصيانة + التحديث قبل الدخول للتطبيق
class UpdateGate extends StatefulWidget {
  final GameState state;
  const UpdateGate({super.key, required this.state});

  @override
  State<UpdateGate> createState() => _UpdateGateState();
}

class _UpdateGateState extends State<UpdateGate> with WidgetsBindingObserver {
  bool _ready = false;
  bool _checking = false;
  bool _dialogOpen = false;

  // ✅ ألوان HomePage (أسود + ذهبي)
  static const Color blackPrimary = Color(0xFF000000);
  static const Color blackSoft = Color(0xFF050505);
  static const Color goldPrimary = Color(0xFFD4AF37);
  static const Color goldAccent = Color(0xFFFFD700);
  static const Color greyDark = Color(0xFF2F343A);
  static const Color greyLight = Color(0xFFB0B3B8);
  static const Color textPrimary = Color(0xFFFFFFFF);

  static const String supportUrl =
      "https://www.facebook.com/profile.php?id=61584912756614";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkAll();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkAll();
    }
  }

  Future<void> _checkAll() async {
    if (_checking || _dialogOpen) return;
    _checking = true;

    try {
      final client = Supabase.instance.client;

      // ✅ 1) صيانة
      final row = await client
          .from("app_config")
          .select()
          .eq("platform", "all")
          .single();

      final maintenanceMode = (row["maintenance_mode"] as bool?) ?? false;
      final maintenanceForce = (row["maintenance_force"] as bool?) ?? true;
      final maintenanceMsg = (row["maintenance_message"] as String?) ??
          "التطبيق تحت الصيانة الآن، هنرجع قريبًا";
      final maintenanceUrl = row["maintenance_url"] as String?;

      if (!mounted) return;

      if (maintenanceMode) {
        _dialogOpen = true;
        await _showMaintenanceDialog(
          message: maintenanceMsg,
          force: maintenanceForce,
          url: maintenanceUrl,
        );
        _dialogOpen = false;
      }

      // ✅ 2) تحديث
      final info = await PackageInfo.fromPlatform();
      final currentVersion = info.version.trim().split("+").first;

      final minV = (row["min_version"] as String).trim();
      final latestV = (row["latest_version"] as String).trim();
      final forceUpdate = (row["force_update"] as bool?) ?? false;
      final updateUrl = row["update_url"] as String?;
      final updateMsg = (row["message"] as String?) ?? "يوجد تحديث جديد للتطبيق";

      final mustUpdate = _compareSemver(currentVersion, minV) < 0;
      final hasUpdate = _compareSemver(currentVersion, latestV) < 0;

      if (!mounted) return;

      if (mustUpdate || hasUpdate) {
        _dialogOpen = true;
        await _showUpdateDialog(
          message: updateMsg,
          currentVersion: currentVersion,
          latestVersion: latestV,
          force: mustUpdate ? true : forceUpdate,
          url: updateUrl,
        );
        _dialogOpen = false;
      }
    } catch (_) {
      // ✅ لو النت فصل: يدخل عادي
    } finally {
      if (mounted) setState(() => _ready = true);
      _checking = false;
    }
  }

  // =========================
  // ✅ Dialog الصيانة (نفس تصميم التحديث الإجباري)
  // =========================
  Future<void> _showMaintenanceDialog({
    required String message,
    required bool force,
    required String? url,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: !force,
      builder: (ctx) {
        return WillPopScope(
          onWillPop: () async => !force,
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Container(
                decoration: BoxDecoration(
                  color: blackSoft.withOpacity(0.92),
                  borderRadius: BorderRadius.circular(26),
                  border:
                      Border.all(color: goldPrimary.withOpacity(0.35), width: 1),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 26,
                      offset: const Offset(0, 14),
                      color: blackPrimary.withOpacity(0.75),
                    ),
                  ],
                ),
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: goldPrimary.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                                color: goldPrimary.withOpacity(0.35), width: 1),
                          ),
                          child: Icon(Icons.build_rounded,
                              color: goldPrimary, size: 26),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            "وضع الصيانة",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: textPrimary,
                            ),
                          ),
                        ),
                        if (force)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: goldAccent.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(999),
                              border:
                                  Border.all(color: goldAccent.withOpacity(0.35)),
                            ),
                            child: const Text(
                              "إجباري",
                              style: TextStyle(
                                color: goldAccent,
                                fontWeight: FontWeight.w900,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      message,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.35,
                        fontWeight: FontWeight.w600,
                        color: greyLight,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: goldPrimary,
                              side: BorderSide(color: goldPrimary.withOpacity(0.45)),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            onPressed: () async {
                              final uri = Uri.parse(supportUrl);
                              await launchUrl(uri,
                                  mode: LaunchMode.externalApplication);
                            },
                            child: const Text(
                              "تواصل مع الدعم",
                              style: TextStyle(fontWeight: FontWeight.w900),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: goldPrimary,
                              foregroundColor: blackPrimary,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            onPressed: () async {
                              final link = (url ?? "").trim();
                              if (link.isNotEmpty && link != "#") {
                                final uri = Uri.parse(link);
                                await launchUrl(uri,
                                    mode: LaunchMode.externalApplication);
                              }
                              await SystemNavigator.pop(); // ✅ خروج للهوم
                            },
                            child: const Text(
                              "خروج",
                              style: TextStyle(fontWeight: FontWeight.w900),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // حقوق الطبع والنشر في الـ Dialog
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "جميع الحقوق محفوظة © محمد مصطفى عباس 2025",
                        style: TextStyle(
                          color: greyLight.withOpacity(0.6),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // =========================
  // ✅ Dialog التحديث
  // =========================
  Future<void> _showUpdateDialog({
    required String message,
    required String currentVersion,
    required String latestVersion,
    required bool force,
    required String? url,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: !force,
      builder: (ctx) {
        return WillPopScope(
          onWillPop: () async => !force,
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Container(
                decoration: BoxDecoration(
                  color: blackSoft.withOpacity(0.92),
                  borderRadius: BorderRadius.circular(26),
                  border:
                      Border.all(color: goldPrimary.withOpacity(0.35), width: 1),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 26,
                      offset: const Offset(0, 14),
                      color: blackPrimary.withOpacity(0.75),
                    ),
                  ],
                ),
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: goldPrimary.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                                color: goldPrimary.withOpacity(0.35), width: 1),
                          ),
                          child: Icon(Icons.system_update,
                              color: goldPrimary, size: 26),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            force ? "تحديث إجباري" : "تحديث جديد",
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: textPrimary,
                            ),
                          ),
                        ),
                        if (force)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: goldAccent.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(999),
                              border:
                                  Border.all(color: goldAccent.withOpacity(0.35)),
                            ),
                            child: const Text(
                              "لازم",
                              style: TextStyle(
                                color: goldAccent,
                                fontWeight: FontWeight.w900,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      message,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.35,
                        fontWeight: FontWeight.w600,
                        color: greyLight,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: greyDark.withOpacity(0.55),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: goldPrimary.withOpacity(0.22)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _kv("نسختك الحالية", currentVersion),
                          const SizedBox(height: 6),
                          _kv("آخر نسخة", latestVersion),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        if (!force)
                          Expanded(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: goldPrimary,
                                side: BorderSide(
                                    color: goldPrimary.withOpacity(0.45)),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              onPressed: () => Navigator.of(ctx).pop(),
                              child: const Text(
                                "لاحقًا",
                                style: TextStyle(fontWeight: FontWeight.w900),
                              ),
                            ),
                          ),
                        if (!force) const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: goldPrimary,
                              foregroundColor: blackPrimary,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            onPressed: () async {
                              if (url == null || url.trim().isEmpty) return;
                              final uri = Uri.parse(url);
                              await launchUrl(uri,
                                  mode: LaunchMode.externalApplication);

                              if (!force && ctx.mounted) Navigator.of(ctx).pop();
                            },
                            child: Text(
                              force ? "تحديث الآن (إجباري)" : "تحديث الآن",
                              style: const TextStyle(fontWeight: FontWeight.w900),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // حقوق الطبع والنشر في الـ Dialog
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "جميع الحقوق محفوظة © محمد مصطفى عباس 2025",
                        style: TextStyle(
                          color: greyLight.withOpacity(0.6),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
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
            style: TextStyle(
              fontSize: 13,
              color: greyLight.withOpacity(0.85),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Text(
          v,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }

  int _compareSemver(String a, String b) {
    final pa = _parse(a);
    final pb = _parse(b);
    for (int i = 0; i < 3; i++) {
      if (pa[i] < pb[i]) return -1;
      if (pa[i] > pb[i]) return 1;
    }
    return 0;
  }

  List<int> _parse(String v) {
    final clean = v.split("+").first.trim();
    final parts = clean.split(".");
    final p0 = parts.isNotEmpty ? int.tryParse(parts[0]) ?? 0 : 0;
    final p1 = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
    final p2 = parts.length > 2 ? int.tryParse(parts[2]) ?? 0 : 0;
    return [p0, p1, p2];
  }

  @override
  Widget build(BuildContext context) {
    // ✅ شاشة التحقق بخلفية الصورة بدل الـ loading
    if (!_ready) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: Stack(
            children: [
              // ✅ الخلفية الصورة
              Positioned.fill(
                child: Container(
                  color: blackPrimary,
                  child: Image.asset(
                    "assets/photos/الخلفية.jpeg",
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF000000), Color(0xFF050505)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // ✅ تظليل فوق الصورة
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        blackPrimary.withOpacity(0.25),
                        blackPrimary.withOpacity(0.55),
                        blackPrimary.withOpacity(0.80),
                      ],
                    ),
                  ),
                ),
              ),

              // ✅ بدل دائرة التحميل: نص فقط
              Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  decoration: BoxDecoration(
                    color: blackSoft.withOpacity(0.72),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: goldPrimary.withOpacity(0.28)),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 18,
                        offset: const Offset(0, 10),
                        color: blackPrimary.withOpacity(0.7),
                      ),
                    ],
                  ),
                  child: Text(
                    "جاري التحقق...",
                    style: TextStyle(
                      color: greyLight,
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),

              // حقوق الطبع والنشر في شاشة التحقق
              Positioned(
                bottom: 4,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "جميع الحقوق محفوظة © محمد مصطفى عباس 2025",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 10,
                        fontFamily: "Tajawal",
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return _CopyrightWrapper(child: HomePage(state: widget.state));
  }
}