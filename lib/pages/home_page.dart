import "package:flutter/material.dart";
import "../core/models.dart";

class HomePage extends StatefulWidget {
  final GameState state;
  const HomePage({super.key, required this.state});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _crew = TextEditingController();
  int _count = 4;

  // تعريف الألوان الثابتة للوصول إليها في جميع الوظائف
  static const Color blackPrimary = Color(0xFF000000);
  static const Color blackSoft = Color(0xFF050505);
  static const Color goldPrimary = Color(0xFFD4AF37);
  static const Color goldAccent = Color(0xFFFFD700);
  static const Color greyDark = Color(0xFF2F343A);
  static const Color greyMedium = Color(0xFF808080);
  static const Color greyLight = Color(0xFFB0B3B8);
  static const Color textPrimary = Color(0xFFFFFFFF);

  @override
  void dispose() {
    _crew.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    blackPrimary.withOpacity(0.3),
                    blackPrimary.withOpacity(0.5),
                    blackPrimary.withOpacity(0.7),
                  ],
                ),
              ),
            ),

            SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 50),

                  // الهيدر الرئيسي مع اللوجو
                  _buildHeader(context),
                  const SizedBox(height: 40),

                  // بطاقة الترحيب الرئيسية
                  _buildWelcomeCard(),
                  const SizedBox(height: 32),

                  // إعدادات الفريق
                  _buildTeamSettings(),
                  const SizedBox(height: 32),

                  // زر ابدأ اللعبة
                  _buildStartButton(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      child: Column(
        children: [
          // شعار اللعبة من الصورة
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: blackPrimary.withOpacity(0.6),
                  blurRadius: 25,
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
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2F343A), Color(0xFF050505)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.auto_awesome,
                      color: goldPrimary,
                      size: 50,
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "مافيوسو",
            style: TextStyle(
              fontFamily: "Tajawal",
              color: textPrimary,
              fontWeight: FontWeight.w900,
              fontSize: 36,
              letterSpacing: -1,
              shadows: [
                Shadow(
                  blurRadius: 15,
                  color: blackPrimary,
                  offset: const Offset(3, 3),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "لعبة المافيا والتحديات المسلية",
            style: TextStyle(
              fontFamily: "Tajawal",
              color: greyLight,
              fontWeight: FontWeight.w500,
              fontSize: 16,
              shadows: [
                Shadow(
                  blurRadius: 8,
                  color: blackPrimary,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      decoration: BoxDecoration(
        color: blackSoft.withOpacity(0.8),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: goldPrimary.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: blackPrimary.withOpacity(0.8),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: goldPrimary.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.celebration, color: goldPrimary, size: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text("أهلاً بك في مافيوسو!",
                    style: TextStyle(
                      fontFamily: "Tajawal",
                      color: textPrimary,
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                      height: 1.2,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text("ابدأ رحلة من المتعة والتحدي مع أصدقائك في لعبة المافيا الشهيرة",
              style: TextStyle(
                fontFamily: "Tajawal",
                color: greyLight,
                fontWeight: FontWeight.w500,
                fontSize: 16,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 20, right: 8),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: goldPrimary.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.settings, color: goldPrimary, size: 20),
              ),
              const SizedBox(width: 12),
              Text("إعدادات الفريق",
                style: TextStyle(
                  fontFamily: "Tajawal",
                  color: textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  shadows: [
                    Shadow(
                      blurRadius: 8,
                      color: blackPrimary,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        Container(
          decoration: BoxDecoration(
            color: blackSoft.withOpacity(0.8),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: goldPrimary.withOpacity(0.2),
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
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // حقل اسم الفريق
                _buildInputField(
                  icon: Icons.group,
                  label: "اسم الفريق",
                  hint: "أدخل اسم فريقك",
                ),
                const SizedBox(height: 20),

                // اختيار عدد اللاعبين
                _buildPlayerCountSelector(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required IconData icon,
    required String label,
    required String hint,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: blackSoft.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: goldPrimary.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: goldPrimary.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: goldPrimary, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                    style: TextStyle(
                      fontFamily: "Tajawal",
                      fontWeight: FontWeight.w600,
                      color: greyLight,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  TextField(
                    controller: _crew,
                    style: const TextStyle(
                      fontFamily: "Tajawal",
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      hintText: hint,
                      hintStyle: TextStyle(
                        fontFamily: "Tajawal",
                        color: greyMedium,
                        fontWeight: FontWeight.w400,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerCountSelector() {
    return Container(
      decoration: BoxDecoration(
        color: blackSoft.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: goldPrimary.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: goldPrimary.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.people, color: goldPrimary, size: 22),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("عدد اللاعبين",
                    style: TextStyle(
                      fontFamily: "Tajawal",
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFE0E0E0),
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text("اختر عدد اللاعبين المشاركين",
                    style: TextStyle(
                      fontFamily: "Tajawal",
                      color: Color(0xFF888888),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: greyDark.withOpacity(0.8),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: goldPrimary.withOpacity(0.3),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: DropdownButton<int>(
                  value: _count,
                  items: const [4,5,6].map((n) => DropdownMenuItem(
                    value: n,
                    child: Text("$n لاعبين",
                      style: TextStyle(
                        fontFamily: "Tajawal",
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  )).toList(),
                  onChanged: (v) => setState(() => _count = v ?? 4),
                  underline: const SizedBox(),
                  icon: Icon(Icons.arrow_drop_down, color: goldPrimary, size: 28),
                  dropdownColor: blackSoft,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStartButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: blackPrimary.withOpacity(0.8),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            widget.state.crewName = _crew.text.trim().isEmpty ? "شلة الأساطير" : _crew.text.trim();
            widget.state.playerCount = _count;
            Navigator.pushNamed(context, "/names", arguments: widget.state);
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [greyDark, blackSoft],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: goldPrimary.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.play_arrow, color: goldPrimary, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Text("ابدأ لعبة جديدة",
                        style: TextStyle(
                          fontFamily: "Tajawal",
                          color: textPrimary,
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                          letterSpacing: -0.3,
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
}