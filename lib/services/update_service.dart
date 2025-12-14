import 'package:package_info_plus/package_info_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UpdateDecision {
  final bool hasUpdate;
  final bool force;
  final String currentVersion; // مثل: 1.0.0+1
  final String minVersion;
  final String latestVersion;
  final String? url;
  final String message;

  UpdateDecision({
    required this.hasUpdate,
    required this.force,
    required this.currentVersion,
    required this.minVersion,
    required this.latestVersion,
    required this.url,
    required this.message,
  });
}

class UpdateService {
  final SupabaseClient client;
  UpdateService(this.client);

  Future<UpdateDecision> checkUpdate({String platform = 'all'}) async {
    final info = await PackageInfo.fromPlatform();

    // ✅ استخدم version + buildNumber
    final current = '${info.version.trim()}+${info.buildNumber.trim()}';

    // حاول يجيب صف المنصة لو موجود، وإلا يرجع لـ all
    Map<String, dynamic>? row = await client
        .from('app_config')
        .select()
        .eq('platform', platform)
        .maybeSingle();

    row ??= await client.from('app_config').select().eq('platform', 'all').single();

    final minV = (row['min_version'] as String).trim();
    final latestV = (row['latest_version'] as String).trim();
    final force = (row['force_update'] as bool?) ?? false;
    final url = row['update_url'] as String?;
    final msg = (row['message'] as String?) ?? 'يوجد تحديث جديد للتطبيق';

    final mustUpdate = _compareVersion(current, minV) < 0;
    final hasUpdate = _compareVersion(current, latestV) < 0;

    return UpdateDecision(
      hasUpdate: mustUpdate || hasUpdate,
      force: mustUpdate ? true : force,
      currentVersion: current,
      minVersion: minV,
      latestVersion: latestV,
      url: url,
      message: msg,
    );
  }

  // ✅ يقارن x.y.z+build
  int _compareVersion(String a, String b) {
    final pa = _parse(a);
    final pb = _parse(b);

    // قارن major/minor/patch/build
    for (int i = 0; i < 4; i++) {
      if (pa[i] < pb[i]) return -1;
      if (pa[i] > pb[i]) return 1;
    }
    return 0;
  }

  // ✅ يرجع [major, minor, patch, build]
  List<int> _parse(String v) {
    final parts = v.split('+');
    final core = parts[0]; // 1.0.0
    final build = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;

    final nums = core.split('.');
    final major = nums.isNotEmpty ? int.tryParse(nums[0]) ?? 0 : 0;
    final minor = nums.length > 1 ? int.tryParse(nums[1]) ?? 0 : 0;
    final patch = nums.length > 2 ? int.tryParse(nums[2]) ?? 0 : 0;

    return [major, minor, patch, build];
  }
}
