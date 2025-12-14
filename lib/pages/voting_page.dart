import "package:flutter/material.dart";
import "../core/models.dart";

class VotingPage extends StatefulWidget {
  final GameState state;
  const VotingPage({super.key, required this.state});

  @override
  State<VotingPage> createState() => _VotingPageState();
}

class _VotingPageState extends State<VotingPage> {
  int? selectedId;

  // تعريف الألوان الثابتة
  static const Color blackPrimary = Color(0xFF000000);
  static const Color blackSoft = Color(0xFF050505);
  static const Color goldPrimary = Color(0xFFD4AF37);
  static const Color goldAccent = Color(0xFFFFD700);
  static const Color greyDark = Color(0xFF2F343A);
  static const Color greyMedium = Color(0xFF808080);
  static const Color greyLight = Color(0xFFB0B3B8);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color successColor = Color(0xFF4CAF50);
  static const Color dangerColor = Color(0xFFF44336);
  static const Color warningColor = Color(0xFFFFA726);

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

  void _showMafiaCaughtDialog(BuildContext context, String mafiaName, int remainingMafias) {
    showDialog(
      context: context,
      barrierDismissible: false,
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
                color: successColor.withOpacity(0.4),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: successColor.withOpacity(0.3),
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
                // أيقونة النجاح
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: successColor.withOpacity(0.15),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: successColor.withOpacity(0.4),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.celebration_rounded,
                    color: successColor,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 20),

                // عنوان الرسالة
                Text(
                  "تم اصطياد المافيوسو!",
                  style: TextStyle(
                    fontFamily: "Tajawal",
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: successColor,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),

                // اسم المافيوسو
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: blackSoft.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: successColor.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    mafiaName,
                    style: TextStyle(
                      fontFamily: "Tajawal",
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // رسالة المتبقي
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: warningColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: warningColor.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: warningColor,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "باقي $remainingMafias مافيوسو في اللعبة",
                        style: TextStyle(
                          fontFamily: "Tajawal",
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: warningColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // زر الاستمرار
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
                      onTap: () {
                        Navigator.of(context).pop();
                        setState(() => selectedId = null);

                        final st = widget.state;
                        if (st.hasMoreClues) {
                          st.clueIndex++;
                          Navigator.pushReplacementNamed(context, "/evidence", arguments: st);
                        } else {
                          Navigator.pushReplacementNamed(context, "/discussion", arguments: st);
                        }
                      },
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
                                Icons.arrow_forward_rounded,
                                color: textPrimary,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "استمرار في اللعبة",
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

  @override
  Widget build(BuildContext context) {
    final st = widget.state;
    final alive = st.alive;

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

                      // بطاقة الدليل
                      _buildClueCard(st),
                      const SizedBox(height: 20),

                      // بطاقة اختيار اللاعب
                      _buildVotingCard(st, alive),
                      const SizedBox(height: 20),

                      // زر التصويت
                      _buildVoteButton(context, st),
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
            "جلسة التصويت",
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

  Widget _buildClueCard(GameState st) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(
        maxWidth: 400,
      ),
      padding: const EdgeInsets.all(20),
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
                child: Icon(Icons.search_outlined, color: goldPrimary, size: 20),
              ),
              const SizedBox(width: 12),
              Text("الدليل ${st.clueIndex + 1}",
                style: TextStyle(
                  fontFamily: "Tajawal",
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: blackSoft.withOpacity(0.4),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: greyDark.withOpacity(0.3)),
            ),
            child: Text(
              st.currentClue,
              style: TextStyle(
                fontFamily: "Tajawal",
                fontSize: 15,
                height: 1.6,
                color: textPrimary,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVotingCard(GameState st, List<Player> alive) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(
        maxWidth: 400,
      ),
      padding: const EdgeInsets.all(20),
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
                child: Icon(Icons.how_to_vote_outlined, color: goldPrimary, size: 20),
              ),
              const SizedBox(width: 12),
              Text("اختر المشتبه به",
                style: TextStyle(
                  fontFamily: "Tajawal",
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "صوت على من تعتقد أنه المافيوسو:",
            style: TextStyle(
              fontFamily: "Tajawal",
              fontSize: 14,
              color: greyLight,
            ),
          ),
          const SizedBox(height: 16),

          Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.3,
            ),
            child: ListView(
              shrinkWrap: true,
              children: alive.map((p) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: selectedId == p.id ? goldPrimary.withOpacity(0.1) : blackSoft.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: selectedId == p.id ? goldPrimary : greyMedium.withOpacity(0.3),
                    width: selectedId == p.id ? 2 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: blackPrimary.withOpacity(0.5),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => setState(() => selectedId = p.id),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: selectedId == p.id ? goldPrimary : greyDark.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.person_outline,
                              color: selectedId == p.id ? textPrimary : greyLight,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  p.name,
                                  style: TextStyle(
                                    fontFamily: "Tajawal",
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: selectedId == p.id ? goldPrimary : textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  p.profession,
                                  style: TextStyle(
                                    fontFamily: "Tajawal",
                                    fontSize: 13,
                                    color: selectedId == p.id ? goldPrimary.withOpacity(0.8) : greyLight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (selectedId == p.id)
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: goldPrimary.withOpacity(0.2),
                                shape: BoxShape.circle,
                                border: Border.all(color: goldPrimary),
                              ),
                              child: Icon(
                                Icons.check,
                                color: goldPrimary,
                                size: 18,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVoteButton(BuildContext context, GameState st) {
    final bool isSelected = selectedId != null;

    return Container(
      height: 60,
      width: double.infinity,
      constraints: const BoxConstraints(
        maxWidth: 400,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: greyDark.withOpacity(isSelected ? 0.5 : 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
        gradient: LinearGradient(
          colors: isSelected
              ? [greyDark, blackSoft]
              : [greyMedium.withOpacity(0.6), greyMedium.withOpacity(0.4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: isSelected ? goldPrimary.withOpacity(0.3) : greyMedium.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: isSelected ? () {
            final picked = st.players.firstWhere((e) => e.id == selectedId);
            if (picked.role == Role.mafioso) {
              picked.eliminated = true;

              // التحقق من عدد المافيوسو المتبقين
              final remainingMafias = st.mafiasAliveCount;

              if (remainingMafias == 0) {
                // لو مافيش مافيوسو عايشين، الأبرياء كسبوا
                Navigator.pushReplacementNamed(context, "/end", arguments: {"state": st, "innocentsWin": true});
              } else {
                // لو في مافيوسو عايشين، نعرض الدايلوج الراقي
                _showMafiaCaughtDialog(context, picked.name, remainingMafias);
              }
            } else {
              // لو صوتوا على بريء
              picked.eliminated = true;
              if (st.hasMoreClues) {
                st.clueIndex++;
                Navigator.pushReplacementNamed(context, "/evidence", arguments: st);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: dangerColor.withOpacity(0.8),
                    content: Text(
                      "🚫 بريء — لا مزيد من الأدلة",
                      style: TextStyle(fontFamily: "Tajawal", color: textPrimary),
                    ),
                  ),
                );
                setState(() => selectedId = null);
                final innocentsAlive = st.alive.where((p) => p.role == Role.innocent).length;
                if (innocentsAlive == 0 && st.mafiasAlive) {
                  Navigator.pushReplacementNamed(context, "/end", arguments: {"state": st, "innocentsWin": false});
                }
              }
            }
          } : null,
          splashColor: Colors.white.withOpacity(0.3),
          highlightColor: greyDark.withOpacity(0.5),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(isSelected ? 0.2 : 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.how_to_vote_outlined,
                    color: textPrimary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  isSelected ? "تأكيد التصويت" : "اختر لاعباً للتصويت",
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
}