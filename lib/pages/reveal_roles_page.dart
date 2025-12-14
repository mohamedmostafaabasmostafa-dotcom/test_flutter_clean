import "package:flutter/material.dart";
import "../core/models.dart";

class RevealRolesPage extends StatefulWidget {
  final GameState state;
  const RevealRolesPage({super.key, required this.state});

  @override
  State<RevealRolesPage> createState() => _RevealRolesPageState();
}

class _RevealRolesPageState extends State<RevealRolesPage> {
  bool show = false;

  // تعريف الألوان الثابتة
  static const Color blackPrimary = Color(0xFF000000);
  static const Color blackSoft = Color(0xFF050505);
  static const Color goldPrimary = Color(0xFFD4AF37);
  static const Color goldAccent = Color(0xFFFFD700);
  static const Color greyDark = Color(0xFF2F343A);
  static const Color greyMedium = Color(0xFF808080);
  static const Color greyLight = Color(0xFFB0B3B8);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color dangerColor = Color(0xFFF44336);
  static const Color successColor = Color(0xFF4CAF50);

  Future<bool> _onWillPop(BuildContext context) async {
    final shouldExit = await showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: blackSoft.withOpacity(0.95),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: goldPrimary.withOpacity(0.4),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: blackPrimary.withOpacity(0.8),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
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
                      color: goldPrimary.withOpacity(0.15),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: goldPrimary.withOpacity(0.4),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.warning_amber_rounded,
                      color: goldPrimary,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // عنوان الرسالة
                  Text(
                    "هل أنت متأكد من الخروج؟",
                    style: TextStyle(
                      fontFamily: "Tajawal",
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),

                  // نص الرسالة
                  Text(
                    "سيتم فقدان تقدم الجولة الحالية والعودة إلى الصفحة الرئيسية",
                    style: TextStyle(
                      fontFamily: "Tajawal",
                      fontSize: 14,
                      color: greyLight,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  // أزرار التأكيد
                  Row(
                    children: [
                      // زر الإلغاء
                      Expanded(
                        child: Container(
                          height: 50,
                          margin: const EdgeInsets.only(left: 6),
                          decoration: BoxDecoration(
                            color: greyDark.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: greyMedium.withOpacity(0.4),
                            ),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () => Navigator.of(context).pop(false),
                              child: Center(
                                child: Text(
                                  "إلغاء",
                                  style: TextStyle(
                                    fontFamily: "Tajawal",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: textPrimary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // زر التأكيد
                      Expanded(
                        child: Container(
                          height: 50,
                          margin: const EdgeInsets.only(right: 6),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [greyDark, blackSoft],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: goldPrimary.withOpacity(0.3),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: blackPrimary.withOpacity(0.4),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () => Navigator.of(context).pop(true),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.exit_to_app,
                                      color: textPrimary,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      "تأكيد",
                                      style: TextStyle(
                                        fontFamily: "Tajawal",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    if (shouldExit == true) {
      Navigator.popUntil(context, (r) => r.isFirst);
      return false;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final st = widget.state;
    final p  = st.players[st.revealIndex];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: WillPopScope(
        onWillPop: () => _onWillPop(context),
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

                      // البطاقة الرئيسية
                      _buildMainCard(context, st, p),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
            "كشف المهنة (سرّي)",
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

  Widget _buildMainCard(BuildContext context, GameState st, Player p) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        maxWidth: 400,
      ),
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
        mainAxisSize: MainAxisSize.min,
        children: [
          // تقدم الكشف
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: greyDark.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: greyDark.withOpacity(0.4)),
            ),
            child: Text(
              "${st.revealIndex + 1} / ${st.players.length}",
              style: TextStyle(
                fontFamily: "Tajawal",
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // أيقونة حسب الحالة
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: show
                  ? (p.role == Role.mafioso ? dangerColor.withOpacity(0.15) : successColor.withOpacity(0.15))
                  : greyDark.withOpacity(0.15),
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: show
                    ? (p.role == Role.mafioso ? dangerColor.withOpacity(0.4) : successColor.withOpacity(0.4))
                    : greyDark.withOpacity(0.4),
                width: 2,
              ),
            ),
            child: Icon(
              show
                  ? (p.role == Role.mafioso ? Icons.psychology_alt_outlined : Icons.verified_outlined)
                  : Icons.lock_outline,
              color: show
                  ? (p.role == Role.mafioso ? dangerColor : successColor)
                  : greyDark,
              size: 45,
            ),
          ),
          const SizedBox(height: 24),

          // اسم اللاعب
          Text(
            p.name,
            style: TextStyle(
              fontFamily: "Tajawal",
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),

          if (!show)
            Column(
              children: [
                Text(
                  "اضغط على الزر لكشف مهنتك السرية",
                  style: TextStyle(
                    fontFamily: "Tajawal",
                    fontSize: 15,
                    color: greyLight,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  "هذه المعلومة سرية لك فقط",
                  style: TextStyle(
                    fontFamily: "Tajawal",
                    fontSize: 13,
                    color: greyMedium,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),

          if (show)
            Column(
              children: [
                // المهنة
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: blackSoft.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: greyDark.withOpacity(0.3)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "مهنتك:",
                        style: TextStyle(
                          fontFamily: "Tajawal",
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: greyLight,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        p.profession,
                        style: TextStyle(
                          fontFamily: "Tajawal",
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // تحذير المافيوسو
                if (p.role == Role.mafioso)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: dangerColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: dangerColor.withOpacity(0.4)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: dangerColor.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.warning_amber_outlined, color: dangerColor, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "أنت المافيوسو!",
                                style: TextStyle(
                                  fontFamily: "Tajawal",
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: dangerColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "خليك متخفي وحاول ما تتعرفش",
                                style: TextStyle(
                                  fontFamily: "Tajawal",
                                  fontSize: 13,
                                  color: greyLight,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),

          const SizedBox(height: 32),

          // الأزرار
          if (!show)
            _buildRevealButton(),

          if (show)
            _buildNextButton(context, st),
        ],
      ),
    );
  }

  Widget _buildRevealButton() {
    return Container(
      height: 60,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
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
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => setState(() => show = true),
          splashColor: Colors.white.withOpacity(0.3),
          highlightColor: greyDark.withOpacity(0.5),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.lock_open_outlined,
                    color: textPrimary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  "كشف المهنة",
                  style: TextStyle(
                    fontSize: 16,
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

  Widget _buildNextButton(BuildContext context, GameState st) {
    return Column(
      children: [
        Container(
          height: 60,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
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
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                setState(() => show = false);
                if (st.revealIndex < st.players.length - 1) {
                  setState(() => st.revealIndex++);
                } else {
                  Navigator.pushReplacementNamed(context, "/discussion", arguments: st);
                }
              },
              splashColor: Colors.white.withOpacity(0.3),
              highlightColor: greyDark.withOpacity(0.5),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        st.revealIndex < st.players.length - 1
                            ? Icons.arrow_back_ios_new_outlined
                            : Icons.forum_outlined,
                        color: textPrimary,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      st.revealIndex < st.players.length - 1 ? "اللاعب التالي" : "اذهب للنقاش",
                      style: TextStyle(
                        fontSize: 16,
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
        ),
        const SizedBox(height: 12),
        Text(
          "سلم الجهاز للاعب الذي يليه",
          style: TextStyle(
            fontFamily: "Tajawal",
            fontSize: 11,
            color: greyMedium,
          ),
        ),
      ],
    );
  }
}