import "package:flutter/material.dart";
import "../core/models.dart";

class EndPage extends StatefulWidget {
  final GameState state;
  final bool innocentsWin;
  const EndPage({super.key, required this.state, required this.innocentsWin});

  @override
  State<EndPage> createState() => _EndPageState();
}

class _EndPageState extends State<EndPage> {
  bool _showCelebration = true;
  bool _showCrimeModal = false;

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
  static const Color infoColor = Color(0xFF2196F3);

  @override
  void initState() {
    super.initState();
    // عرض رسالة التهنئة عند فتح الصفحة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showCelebrationMessage();
    });
  }

  void _showCelebrationMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Directionality(
          textDirection: TextDirection.rtl,
          child: Row(
            children: [
              Icon(Icons.celebration, color: goldPrimary, size: 24),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "تهانينا! الجولة انتهت",
                      style: TextStyle(
                        fontFamily: "Tajawal",
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: textPrimary,
                      ),
                    ),
                    Text(
                      widget.innocentsWin
                          ? "الأبرياء فازوا بكشف الحقيقة!"
                          : "المافيوسو تمكن من الفوز!",
                      style: TextStyle(
                        fontFamily: "Tajawal",
                        fontSize: 12,
                        color: greyLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        backgroundColor: widget.innocentsWin
            ? successColor.withOpacity(0.9)
            : dangerColor.withOpacity(0.9),
        duration: Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.all(20),
      ),
    );
  }

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

                  Row(
                    children: [
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
    final maf = widget.state.players.firstWhere(
          (p) => p.role == Role.mafioso,
      orElse: () => widget.state.players.first,
    );

    return Directionality(
      textDirection: TextDirection.rtl,
      child: WillPopScope(
        onWillPop: () => _onWillPop(context),
        child: Scaffold(
          body: Stack(
            children: [
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

              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      _buildHeader(context),
                      const SizedBox(height: 30),

                      // البطاقة الرئيسية مع النتيجة
                      _buildMainResultCard(context, maf),
                      const SizedBox(height: 24),

                      // زر عرض قصة الجريمة الكاملة - هيتعرض دائمًا
                      _buildCrimeStoryButton(context),

                      const SizedBox(height: 24),
                      _buildPlayersCard(context),
                      const SizedBox(height: 24),
                      _buildNewGameButton(context),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              // مودال عرض قصة الجريمة
              if (_showCrimeModal)
                _buildCrimeModal(context, maf),
            ],
          ),
        ),
      ),
    );
  }

  // دالة لعرض مودال قصة الجريمة
  Widget _buildCrimeModal(BuildContext context, Player maf) {
    final crimeDetails = widget.state.story?.crimeDetails ?? "تفاصيل الجريمة غير متوفرة";

    // استبدال المتغيرات في النص
    String formattedDetails = crimeDetails
        .replaceAll('{mafiaName}', maf.name)
        .replaceAll('{mafiaProfession}', maf.profession)
        .replaceAll('{MAFIA_NAME}', maf.name)
        .replaceAll('{MAFIA_PROFESSION}', maf.profession);

    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: () => setState(() => _showCrimeModal = false),
        child: Container(
          color: Colors.black.withOpacity(0.85),
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: GestureDetector(
              onTap: () {}, // لمنع الإغلاق عند النقر داخل البطاقة
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.8,
                constraints: BoxConstraints(maxWidth: 500, maxHeight: 700),
                padding: const EdgeInsets.all(24),
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: blackSoft.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: goldPrimary.withOpacity(0.4),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.6),
                      blurRadius: 40,
                      offset: const Offset(0, 15),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // رأس البطاقة
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: dangerColor.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.crisis_alert,
                                  color: dangerColor,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                "القصة الكاملة للجريمة",
                                style: TextStyle(
                                  fontFamily: "Tajawal",
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  color: textPrimary,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: () => setState(() => _showCrimeModal = false),
                            icon: Icon(
                              Icons.close,
                              color: greyLight,
                              size: 28,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // معلومات المافيوسو
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: dangerColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: dangerColor.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: dangerColor.withOpacity(0.2),
                              child: Icon(
                                Icons.person,
                                color: dangerColor,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "المافيوسو:",
                                    style: TextStyle(
                                      fontFamily: "Tajawal",
                                      fontSize: 14,
                                      color: greyLight,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "${maf.name} - ${maf.profession}",
                                    style: TextStyle(
                                      fontFamily: "Tajawal",
                                      fontSize: 18,
                                      color: dangerColor,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.psychology_alt_outlined,
                              color: dangerColor,
                              size: 32,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // تفاصيل القصة
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: blackSoft.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: greyDark.withOpacity(0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: goldPrimary.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    Icons.details,
                                    color: goldPrimary,
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  "كيف ارتكبت الجريمة؟",
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

                            // النص الكامل للقصة
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: blackSoft.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: greyDark.withOpacity(0.2)),
                              ),
                              child: Text(
                                formattedDetails,
                                style: TextStyle(
                                  fontFamily: "Tajawal",
                                  fontSize: 16,
                                  height: 1.7,
                                  color: textPrimary,
                                  letterSpacing: 0.3,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // قسم الأدلة
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: infoColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: infoColor.withOpacity(0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: infoColor.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    Icons.search,
                                    color: infoColor,
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  "الأدلة التي كانت متاحة:",
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
                            Column(
                              children: (widget.state.story?.clues ?? []).map((clue) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 6),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.circle,
                                      size: 8,
                                      color: goldPrimary,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        clue,
                                        style: TextStyle(
                                          fontFamily: "Tajawal",
                                          fontSize: 14,
                                          color: greyLight,
                                          height: 1.5,
                                        ),
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ],
                                ),
                              )).toList(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // زر إغلاق
                      Container(
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [greyDark, blackSoft],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: goldPrimary.withOpacity(0.3),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.4),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () => setState(() => _showCrimeModal = false),
                            splashColor: goldPrimary.withOpacity(0.3),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.check_circle_outline,
                                    color: textPrimary,
                                    size: 22,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    "فهمت القصة",
                                    style: TextStyle(
                                      fontFamily: "Tajawal",
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: textPrimary,
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
          ),
        ),
      ),
    );
  }

  // زر جديد لعرض قصة الجريمة
  Widget _buildCrimeStoryButton(BuildContext context) {
    final hasStory = widget.state.story != null;
    final hasCrimeDetails = hasStory &&
        widget.state.story!.crimeDetails.isNotEmpty &&
        widget.state.story!.crimeDetails != "null";

    return Container(
      height: 65,
      width: double.infinity,
      constraints: BoxConstraints(maxWidth: 400),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: hasCrimeDetails
              ? [
            goldPrimary.withOpacity(0.9),
            goldAccent.withOpacity(0.8),
          ]
              : [
            greyDark.withOpacity(0.7),
            greyMedium.withOpacity(0.5),
          ],
        ),
        border: Border.all(
          color: hasCrimeDetails
              ? Colors.white.withOpacity(0.3)
              : greyLight.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: hasCrimeDetails
                ? goldPrimary.withOpacity(0.4)
                : Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: hasCrimeDetails
              ? () => setState(() => _showCrimeModal = true)
              : null,
          splashColor: hasCrimeDetails
              ? Colors.white.withOpacity(0.4)
              : Colors.transparent,
          highlightColor: hasCrimeDetails
              ? goldPrimary.withOpacity(0.5)
              : Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: hasCrimeDetails
                      ? Colors.white.withOpacity(0.25)
                      : Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  hasCrimeDetails
                      ? Icons.menu_book_outlined
                      : Icons.book_outlined,
                  color: hasCrimeDetails ? textPrimary : greyLight,
                  size: 26,
                ),
              ),
              const SizedBox(width: 15),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hasCrimeDetails
                        ? "عرض القصة الكاملة للجريمة"
                        : "تفاصيل الجريمة غير متاحة",
                    style: TextStyle(
                      fontFamily: "Tajawal",
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: hasCrimeDetails ? textPrimary : greyLight,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Text(
                    hasCrimeDetails
                        ? "اكتشف كيف حدثت الجريمة خطوة بخطوة"
                        : "القصة غير متوفرة في هذا السيناريو",
                    style: TextStyle(
                      fontFamily: "Tajawal",
                      fontSize: 12,
                      color: hasCrimeDetails
                          ? Colors.white.withOpacity(0.9)
                          : greyMedium,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              if (hasCrimeDetails)
                Icon(
                  Icons.arrow_back_ios_new,
                  color: textPrimary,
                  size: 20,
                  textDirection: TextDirection.ltr,
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
            "نهاية الجولة",
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

  Widget _buildMainResultCard(BuildContext context, Player maf) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(maxWidth: 400),
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
              color: widget.innocentsWin ? successColor.withOpacity(0.15) : dangerColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(40),
              border: Border.all(
                color: widget.innocentsWin ? successColor.withOpacity(0.4) : dangerColor.withOpacity(0.4),
                width: 2,
              ),
            ),
            child: Icon(
              widget.innocentsWin ? Icons.celebration_outlined : Icons.warning_amber_outlined,
              color: widget.innocentsWin ? successColor : dangerColor,
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            widget.innocentsWin ? " فوز الأبرياء" : " فوز المافيوسو",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: widget.innocentsWin ? successColor : dangerColor,
              fontFamily: "Tajawal",
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            widget.innocentsWin ? "تمكن الأبرياء من كشف الحقيقة وإنقاذ المدينة!" : "المافيوسو تمكن من التسلل والهروب!",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: textPrimary,
              fontFamily: "Tajawal",
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: dangerColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: dangerColor.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: dangerColor.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.psychology_alt_outlined, color: dangerColor, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "المافيوسو كان:",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: greyLight,
                          fontFamily: "Tajawal",
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${maf.name} — ${maf.profession}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: dangerColor,
                          fontFamily: "Tajawal",
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.auto_awesome, color: dangerColor, size: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayersCard(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(maxWidth: 400),
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
                child: Icon(Icons.people_outline, color: goldPrimary, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                "تفاصيل اللاعبين:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                  fontFamily: "Tajawal",
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...widget.state.players.map((p) => Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: blackSoft.withOpacity(0.4),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: p.role == Role.mafioso ? dangerColor.withOpacity(0.4) : greyMedium.withOpacity(0.3),
                width: p.role == Role.mafioso ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: p.role == Role.mafioso ? dangerColor.withOpacity(0.2) : goldPrimary.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    p.role == Role.mafioso ? Icons.psychology_alt_outlined :
                    p.eliminated ? Icons.person_off_outlined : Icons.person_outlined,
                    color: p.role == Role.mafioso ? dangerColor :
                    p.eliminated ? greyMedium : goldPrimary,
                    size: 18,
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
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: p.role == Role.mafioso ? dangerColor : textPrimary,
                          fontFamily: "Tajawal",
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "${p.profession}${p.role == Role.mafioso ? " " : ""}${p.eliminated ? " (خارج)" : ""}",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: p.eliminated ? greyMedium : greyLight,
                          fontFamily: "Tajawal",
                        ),
                      ),
                    ],
                  ),
                ),
                if (p.role == Role.mafioso)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: dangerColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: dangerColor.withOpacity(0.4)),
                    ),
                    child: Text(
                      "مافيوسو",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: dangerColor,
                        fontFamily: "Tajawal",
                      ),
                    ),
                  ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildNewGameButton(BuildContext context) {
    return Container(
      height: 60,
      width: double.infinity,
      constraints: BoxConstraints(maxWidth: 400),
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
          onTap: () => Navigator.popUntil(context, (r)=> r.isFirst),
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
                    Icons.refresh_outlined,
                    color: textPrimary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  "بدء جولة جديدة",
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