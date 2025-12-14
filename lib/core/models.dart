enum Role { mafioso, innocent }

class Story {
  final String title;
  final String description;
  final List<String> rolesRaw; // قد تحتوي "(انت المافيوسو)"
  final List<String> clues;
  final String crimeDetails; // حقل جديد

  Story({
    required this.title,
    required this.description,
    required this.rolesRaw,
    required this.clues,
    required this.crimeDetails, // حقل جديد
  });

  factory Story.fromMap(Map<String, dynamic> m) {
    return Story(
      title: (m["title"] ?? "قصة غامضة").toString(),
      description: (m["description"] ?? "").toString(),
      rolesRaw: List<String>.from(m["roles"] ?? const []),
      clues: List<String>.from(m["clues"] ?? const []),
      crimeDetails: (m["crime_details"] ?? "").toString(), // قراءة الحقل الجديد
    );
  }

  /// (المهنة بدون وسم, هل هو مافيا)
  List<(String, bool)> parsedRoles() {
    return rolesRaw.map<(String, bool)>((r) {
      final isM = r.contains("(انت المافيوسو)");
      final clean = r.replaceAll("(انت المافيوسو)", "").trim();
      return (clean, isM);
    }).toList();
  }
}

class Player {
  final int id;
  final String name;
  final String profession; // بدون الوسم
  final Role role;
  bool eliminated;

  Player({
    required this.id,
    required this.name,
    required this.profession,
    required this.role,
    this.eliminated = false,
  });
}

class GameState {
  String crewName = "";
  int playerCount = 4;
  Story? story;

  List<Player> players = [];
  int revealIndex = 0;
  int clueIndex = 0;

  List<Player> get alive => players.where((p) => !p.eliminated).toList();
  bool get hasMoreClues => story != null && clueIndex < (story!.clues.length - 1);
  String get currentClue => story!.clues[clueIndex];

  // دالة جديدة للتحقق من وجود تفاصيل الجريمة
  bool get hasCrimeDetails => story != null && story!.crimeDetails.isNotEmpty;

  bool get mafiasAlive => alive.any((p) => p.role == Role.mafioso);
  int  get mafiasAliveCount => alive.where((p) => p.role == Role.mafioso).length;

  void resetRound() {
    revealIndex = 0;
    clueIndex = 0;
    for (final p in players) { p.eliminated = false; }
  }
}