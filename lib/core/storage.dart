import "dart:convert";
import "package:flutter/services.dart" show rootBundle;
import "models.dart";
import "dart:math";
import "package:shared_preferences/shared_preferences.dart";

class Storage {
  static Future<Story> loadStoryForCount(int playerCount) async {
    try {
      final raw = await rootBundle.loadString("assets/data/stories.json");
      final map = json.decode(raw) as Map<String, dynamic>;
      
      if (!map.containsKey("stories") || map["stories"] is! Map) {
        throw "صيغة stories.json غير صحيحة (مفقود المفتاح stories).";
      }
      
      final stories = (map["stories"] as Map<String, dynamic>);
      final key = "$playerCount";
      
      if (!stories.containsKey(key) || stories[key] is! Map) {
        throw "لا توجد قصة لعدد اللاعبين $playerCount.";
      }
      
      final storyData = stories[key] as Map<String, dynamic>;
      
      // إذا كان هناك قائمة قصص، اختر واحدة عشوائياً
      if (storyData.containsKey("stories") && storyData["stories"] is List) {
        final storiesList = storyData["stories"] as List;
        if (storiesList.isEmpty) {
          throw "لا توجد قصص متاحة لعدد اللاعبين $playerCount.";
        }
        
        final random = Random();
        final selectedStory = storiesList[random.nextInt(storiesList.length)] as Map<String, dynamic>;
        
        return Story.fromMap(selectedStory);
      } else {
        // الهيكل العادي
        return Story.fromMap(storyData);
      }
      
    } catch (e) {
      if (e.toString().contains("Unable to load asset")) {
        throw "ملف القصص غير موجود في المسار: assets/data/stories.json";
      }
      rethrow;
    }
  }
}