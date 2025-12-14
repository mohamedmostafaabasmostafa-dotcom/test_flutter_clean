import "package:flutter/material.dart";
import "../core/models.dart";

class EvidencePage extends StatelessWidget {
  final GameState state;
  const EvidencePage({super.key, required this.state});

  // متغير لتتبع حالة إظهار/إخفاء المافيوسو (في الأساس مخفي)
  static bool _showMafiaProfession = false;

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

  @override
  Widget build(BuildContext context) {
    final st = state;

    // حارس: لو القصة مش متحمّلة لأي سبب، اعرض رسالة بدل كراش
    if (st.story == null) {
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
                      const SizedBox(height: 40),

                      // بطاقة الخطأ
                      _buildErrorCard(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final story = st.story!;
    final mafiaProfessions = st.players
        .where((p) => p.role == Role.mafioso)
        .map((p) => p.profession)
        .toSet()
        .toList();

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

              // المحتوى الرئيسي مع قابلية التمرير
              SafeArea(
                child: Column(
                  children: [
                    // زر إظهار/إخفاء المافيوسو (في الأعلى خارج التمرير)
                    _buildMafiaToggleButton(context),
                    const SizedBox(height: 10),

                    // المحتوى القابل للتمرير
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            // الهيدر مع اللوجو
                            _buildHeader(context),
                            const SizedBox(height: 20),

                            // بطاقة القصة
                            _buildStoryCard(story),
                            const SizedBox(height: 15),

                            // بطاقة المهن واللاعبين
                            _buildProfessionsCard(st, context),
                            const SizedBox(height: 15),

                            // بطاقة المافيوسو (فقط لو ظاهر)
                            if (_showMafiaProfession)
                              _buildMafiaCard(mafiaProfessions),
                            if (_showMafiaProfession)
                              const SizedBox(height: 15),

                            // بطاقة الدليل
                            _buildClueCard(st),
                            const SizedBox(height: 20),

                            // زر التصويت
                            _buildVoteButton(context, st),
                            const SizedBox(height: 30), // مساحة إضافية في الأسفل
                          ],
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
  }

  Widget _buildMafiaToggleButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: blackSoft.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _showMafiaProfession ? warningColor.withOpacity(0.5) : goldPrimary.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: blackPrimary.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _showMafiaProfession
                      ? warningColor.withOpacity(0.2)
                      : goldPrimary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  _showMafiaProfession ? Icons.warning_amber_rounded : Icons.security,
                  color: _showMafiaProfession ? warningColor : goldPrimary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "معلومة سرية",
                    style: TextStyle(
                      fontFamily: "Tajawal",
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _showMafiaProfession ? "مهنة المافيوسو ظاهرة" : "مهنة المافيوسو مخفية",
                    style: TextStyle(
                      fontFamily: "Tajawal",
                      fontSize: 13,
                      color: _showMafiaProfession ? warningColor : greyLight,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // زر التبديل
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: _showMafiaProfession
                  ? warningColor.withOpacity(0.15)
                  : greyDark.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _showMafiaProfession
                    ? warningColor.withOpacity(0.4)
                    : greyDark.withOpacity(0.4),
                width: 1.5,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  _showMafiaProfession = !_showMafiaProfession;
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => EvidencePage(state: state),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Icon(
                      _showMafiaProfession ? Icons.visibility_off : Icons.visibility,
                      color: _showMafiaProfession ? warningColor : textPrimary,
                      size: 20,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _showMafiaProfession ? "إخفاء" : "إظهار",
                      style: TextStyle(
                        fontFamily: "Tajawal",
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: _showMafiaProfession ? warningColor : textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          // شعار اللعبة من الصورة
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: blackPrimary.withOpacity(0.6),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
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
                      size: 30,
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "مافيوسو",
            style: TextStyle(
              fontFamily: "Tajawal",
              color: textPrimary,
              fontWeight: FontWeight.w900,
              fontSize: 24,
              letterSpacing: -1,
              shadows: [
                Shadow(
                  blurRadius: 12,
                  color: blackPrimary,
                  offset: Offset(2, 2),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "الأدلة والتحقيق",
            style: TextStyle(
              fontFamily: "Tajawal",
              color: greyLight,
              fontWeight: FontWeight.w500,
              fontSize: 14,
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

  Widget _buildErrorCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: dangerColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(40),
              border: Border.all(
                color: dangerColor.withOpacity(0.4),
                width: 2,
              ),
            ),
            child: Icon(Icons.warning_amber_rounded, color: dangerColor, size: 30),
          ),
          const SizedBox(height: 12),
          Text("⚠️ القصة غير محمّلة",
            style: TextStyle(
              fontFamily: "Tajawal",
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text("ارجع خطوة وابدأ من إدخال الأسماء",
            style: TextStyle(
              fontFamily: "Tajawal",
              fontSize: 13,
              color: greyLight,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStoryCard(Story story) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: blackSoft.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: goldPrimary.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: blackPrimary.withOpacity(0.8),
            blurRadius: 15,
            offset: const Offset(0, 8),
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
                child: Icon(Icons.menu_book_rounded, color: goldPrimary, size: 18),
              ),
              const SizedBox(width: 10),
              Text("القصة",
                style: TextStyle(
                  fontFamily: "Tajawal",
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: blackSoft.withOpacity(0.4),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: greyMedium.withOpacity(0.3)),
            ),
            child: Text(story.description,
              style: TextStyle(
                fontFamily: "Tajawal",
                fontSize: 13,
                height: 1.5,
                color: textPrimary,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfessionsCard(GameState st, BuildContext context) {
    final players = st.players;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: blackSoft.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: goldPrimary.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: blackPrimary.withOpacity(0.8),
            blurRadius: 15,
            offset: const Offset(0, 8),
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
                child: Icon(Icons.people_alt_rounded, color: goldPrimary, size: 18),
              ),
              const SizedBox(width: 10),
              Text("المهن واللاعبين",
                style: TextStyle(
                  fontFamily: "Tajawal",
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: greyDark.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: greyDark.withOpacity(0.3)),
                ),
                child: Text(
                  "${players.length} لاعب",
                  style: TextStyle(
                    fontFamily: "Tajawal",
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // عرض المهن في GridView منظمة
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = isSmallScreen ? 1 : 2;
              final itemWidth = constraints.maxWidth / crossAxisCount - 8;

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: isSmallScreen ? 3.2 : 2.5,
                ),
                itemCount: players.length,
                itemBuilder: (context, index) {
                  final player = players[index];
                  return _buildPlayerCard(player, itemWidth);
                },
              );
            },
          ),

          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: greyDark.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: greyDark.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline_rounded, color: goldPrimary, size: 16),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    "كل لاعب لديه مهنة مختلفة. المافيوسو يختبئ بين هذه المهن",
                    style: TextStyle(
                      fontFamily: "Tajawal",
                      fontSize: 12,
                      color: greyLight,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerCard(Player player, double? cardWidth) {
    return Container(
      constraints: cardWidth != null ? BoxConstraints(maxWidth: cardWidth) : null,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: blackSoft.withOpacity(0.4),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: goldPrimary.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: blackPrimary.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // اسم اللاعب في سطر
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: goldPrimary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: goldPrimary.withOpacity(0.3)),
                  ),
                  child: Text(
                    player.name,
                    style: TextStyle(
                      fontFamily: "Tajawal",
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: goldPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Icon(
                Icons.person_outline_rounded,
                color: greyLight,
                size: 14,
              ),
            ],
          ),
          const SizedBox(height: 6),

          // المهنة في سطر
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  decoration: BoxDecoration(
                    color: greyDark.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: greyDark.withOpacity(0.3)),
                  ),
                  child: Text(
                    player.profession,
                    style: TextStyle(
                      fontFamily: "Tajawal",
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Icon(
                Icons.work_outline_rounded,
                color: greyLight,
                size: 14,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMafiaCard(List<String> mafiaProfessions) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: blackSoft.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: dangerColor.withOpacity(0.4)),
        boxShadow: [
          BoxShadow(
            color: blackPrimary.withOpacity(0.9),
            blurRadius: 15,
            offset: const Offset(0, 8),
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
                  color: dangerColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.psychology_alt_rounded, color: dangerColor, size: 18),
              ),
              const SizedBox(width: 10),
              Text("مهنة المافيوسو",
                style: TextStyle(
                  fontFamily: "Tajawal",
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: blackSoft.withOpacity(0.4),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: dangerColor.withOpacity(0.4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.warning_amber_rounded, color: dangerColor, size: 20),
                    const SizedBox(width: 6),
                    Text(
                      "تحذير: معلومة سرية",
                      style: TextStyle(
                        fontFamily: "Tajawal",
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: dangerColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: blackSoft.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: dangerColor.withOpacity(0.3)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "مهنة المافيوسو هي:",
                        style: TextStyle(
                          fontFamily: "Tajawal",
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: greyLight,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        mafiaProfessions.join(' • '),
                        style: TextStyle(
                          fontFamily: "Tajawal",
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: dangerColor,
                          height: 1.3,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: dangerColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline_rounded, color: dangerColor, size: 14),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          "هذه المعلومة للتحقق فقط. يرجى إخفاؤها إذا كنت تلعب بدون حكم",
                          style: TextStyle(
                            fontFamily: "Tajawal",
                            fontSize: 12,
                            color: greyLight,
                          ),
                          textAlign: TextAlign.right,
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
    );
  }

  Widget _buildClueCard(GameState st) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: blackSoft.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: goldPrimary.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: blackPrimary.withOpacity(0.8),
            blurRadius: 15,
            offset: const Offset(0, 8),
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
                child: Icon(Icons.search_rounded, color: goldPrimary, size: 18),
              ),
              const SizedBox(width: 10),
              Text("الدليل ${st.clueIndex + 1}",
                style: TextStyle(
                  fontFamily: "Tajawal",
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: blackSoft.withOpacity(0.4),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: greyMedium.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: blackSoft.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: greyDark.withOpacity(0.2)),
                  ),
                  child: Text(st.currentClue,
                    style: TextStyle(
                      fontFamily: "Tajawal",
                      fontSize: 13,
                      height: 1.5,
                      color: textPrimary,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: greyDark.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: greyDark.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.lightbulb_outline_rounded, color: goldPrimary, size: 16),
                      const SizedBox(width: 6),
                      Text("أنت تشاهد الدليل رقم ${st.clueIndex + 1}",
                        style: TextStyle(
                          fontFamily: "Tajawal",
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: goldPrimary,
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
    );
  }

  Widget _buildVoteButton(BuildContext context, GameState st) {
    return Container(
      height: 50,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: greyDark.withOpacity(0.5),
            blurRadius: 12,
            offset: const Offset(0, 6),
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
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => Navigator.pushReplacementNamed(context, "/voting", arguments: st),
          splashColor: Colors.white.withOpacity(0.3),
          highlightColor: greyDark.withOpacity(0.5),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.how_to_vote_rounded,
                    color: textPrimary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "ابدأ التصويت الآن",
                  style: TextStyle(
                    fontSize: 15,
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