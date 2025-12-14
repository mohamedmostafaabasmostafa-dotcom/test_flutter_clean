import "package:flutter/material.dart";
import "../core/models.dart";
import "../core/storage.dart";

class NamesPage extends StatefulWidget {
  final GameState state;
  const NamesPage({super.key, required this.state});

  @override
  State<NamesPage> createState() => _NamesPageState();
}

class _NamesPageState extends State<NamesPage> {
  late final List<TextEditingController> _ctls;
  bool _loading = false;

  // تعريف الألوان الثابتة
  static const Color blackPrimary = Color(0xFF000000);
  static const Color blackSoft = Color(0xFF050505);
  static const Color goldPrimary = Color(0xFFD4AF37);
  static const Color goldAccent = Color(0xFFFFD700);
  static const Color greyDark = Color(0xFF2F343A);
  static const Color greyMedium = Color(0xFF808080);
  static const Color greyLight = Color(0xFFB0B3B8);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color warningColor = Color(0xFFFFA726);
  static const Color dangerColor = Color(0xFFF44336);

  @override
  void initState() {
    super.initState();
    _ctls = List.generate(widget.state.playerCount, (_) => TextEditingController());
  }

  @override
  void dispose() {
    for (final c in _ctls) { c.dispose(); }
    super.dispose();
  }

  void _showIncompleteNamesDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: blackPrimary.withOpacity(0.8),
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(20),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: blackSoft.withOpacity(0.95),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: warningColor.withOpacity(0.4),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: warningColor.withOpacity(0.3),
                  blurRadius: 30,
                  spreadRadius: 2,
                  offset: const Offset(0, 10),
                ),
                BoxShadow(
                  color: blackPrimary.withOpacity(0.8),
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // أيقونة التحذير
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: warningColor.withOpacity(0.15),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: warningColor.withOpacity(0.4),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.warning_amber_rounded,
                    color: warningColor,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 20),

                // عنوان الرسالة
                Text(
                  "يرجى إكمال جميع الأسماء",
                  style: TextStyle(
                    fontFamily: "Tajawal",
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: warningColor,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),

                // نص الرسالة
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: blackSoft.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: warningColor.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    "يجب عليك ملء جميع أسماء اللاعبين قبل البدء في اللعبة",
                    style: TextStyle(
                      fontFamily: "Tajawal",
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: greyLight,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),

                // زر الموافقة
                Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [greyDark, blackSoft],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: blackPrimary.withOpacity(0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(
                      color: goldPrimary.withOpacity(0.3),
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => Navigator.of(context).pop(),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.check_circle_outline,
                                color: textPrimary,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "حسناً",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: textPrimary,
                                fontFamily: "Tajawal",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _startReveal() async {
    final names = _ctls.map((c)=> c.text.trim()).toList();
    if (names.any((n) => n.isEmpty)) {
      _showIncompleteNamesDialog(context);
      return;
    }
    setState(()=> _loading = true);
    try {
      // 1) حمّل القصة من الأصول
      final st = widget.state;
      st.story = await Storage.loadStoryForCount(st.playerCount);

      // 2) حلّل المهن (مع وسم المافيوسو) واخلطها
      final parsed = st.story!.parsedRoles(); // List<(String,bool)>
      parsed.shuffle();

      // 3) وزّع مهنة/دور لكل لاعب بنفس ترتيب الأسماء
      st.players = List.generate(names.length, (i) {
        final (prof, isM) = parsed[i];
        return Player(
          id: i,
          name: names[i],
          profession: prof,
          role: isM ? Role.mafioso : Role.innocent,
        );
      });

      // 4) صفّر الحالة للمرحلة الجاية
      st.revealIndex = 0;
      st.clueIndex = 0;

      if (!mounted) return;
      Navigator.pushNamed(context, "/reveal", arguments: st);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: dangerColor.withOpacity(0.8),
            content: Text("فشل تحميل القصة: $e\nتأكد من وجود ملف القصص في assets/data/stories.json",
              style: TextStyle(fontFamily: "Tajawal", color: textPrimary),
            ),
            duration: const Duration(seconds: 5),
          )
      );
    } finally {
      if (mounted) setState(()=> _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final st = widget.state;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Stack(
          children: [
            // الخلفية السوداء
            Container(
              width: double.infinity,
              height: double.infinity,
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

            // طبقة تظليل فوق الخلفية لتحسين قراءة النص
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    blackPrimary.withOpacity(0.4),
                    blackPrimary.withOpacity(0.6),
                    blackPrimary.withOpacity(0.8),
                  ],
                ),
              ),
            ),

            // المحتوى الرئيسي
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    // الهيدر مع اللوجو
                    _buildHeader(context),
                    const SizedBox(height: 30),

                    // بطاقة الترحيب
                    _buildWelcomeCard(st),
                    const SizedBox(height: 24),

                    // قائمة حقول الأسماء
                    _buildNamesList(st),
                    const SizedBox(height: 24),

                    // زر البدء
                    _buildStartButton(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      child: Column(
        children: [
          // شعار اللعبة من الصورة
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: blackPrimary.withOpacity(0.6),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
              border: Border.all(
                color: goldPrimary,
                width: 2,
              ),
            ),
            child: ClipOval(
              child: Image.asset(
                "assets/logo/logo.png",
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [greyDark, blackSoft],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.auto_awesome,
                      color: goldPrimary,
                      size: 35,
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "مافيوسو",
            style: TextStyle(
              fontFamily: "Tajawal",
              color: textPrimary,
              fontWeight: FontWeight.w900,
              fontSize: 28,
              letterSpacing: -1,
              shadows: [
                Shadow(
                  blurRadius: 15,
                  color: blackPrimary,
                  offset: Offset(3, 3),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "إدخال أسماء اللاعبين",
            style: TextStyle(
              fontFamily: "Tajawal",
              color: greyLight,
              fontWeight: FontWeight.w500,
              fontSize: 16,
              shadows: [
                Shadow(
                  blurRadius: 8,
                  color: blackPrimary,
                  offset: Offset(2, 2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard(GameState st) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: blackSoft.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: goldPrimary.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: blackPrimary.withOpacity(0.9),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: goldPrimary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: goldPrimary.withOpacity(0.4),
                width: 2,
              ),
            ),
            child: Icon(
              Icons.person_add_outlined,
              color: goldPrimary,
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "أدخل أسماء اللاعبين",
            style: TextStyle(
              fontFamily: "Tajawal",
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "مجموعة: ${st.crewName}",
            style: TextStyle(
              fontFamily: "Tajawal",
              fontSize: 16,
              color: greyLight,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "عدد اللاعبين: ${st.playerCount}",
            style: TextStyle(
              fontFamily: "Tajawal",
              fontSize: 14,
              color: greyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNamesList(GameState st) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: blackSoft.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: goldPrimary.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: blackPrimary.withOpacity(0.8),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: goldPrimary.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.list_alt, color: goldPrimary, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                "أدخل اسم كل لاعب:",
                style: TextStyle(
                  fontFamily: "Tajawal",
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // استبدلنا Expanded بـ Container مع ارتفاع محدد
          Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.4, // ارتفاع أقصى
            ),
            child: ListView(
              shrinkWrap: true,
              children: [
                ...List.generate(st.playerCount, (i)=> Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: blackSoft.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: goldPrimary.withOpacity(0.3)),
                    ),
                    child: TextField(
                      controller: _ctls[i],
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontFamily: "Tajawal",
                        fontSize: 16,
                        color: textPrimary,
                      ),
                      decoration: InputDecoration(
                        labelText: "اللاعب رقم ${i+1}",
                        labelStyle: TextStyle(
                          fontFamily: "Tajawal",
                          color: greyLight,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: goldPrimary,
                            width: 2,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: goldPrimary.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStartButton() {
    return Container(
      height: 65,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: greyDark.withOpacity(0.5),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
        gradient: LinearGradient(
          colors: [greyDark, blackSoft],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: goldPrimary.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: _loading ? null : _startReveal,
          splashColor: Colors.white.withOpacity(0.3),
          highlightColor: greyDark.withOpacity(0.5),
          child: Center(
            child: _loading
                ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: Colors.white,
              ),
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.play_arrow_outlined,
                    color: textPrimary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  "ابدأ كشف المهن",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: textPrimary,
                    fontFamily: "Tajawal",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}