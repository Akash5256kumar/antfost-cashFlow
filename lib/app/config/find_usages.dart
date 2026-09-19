import 'dart:io';

void main() {
  final assetsFile = File('lib/app/config/app_assets.dart');
  final lines = assetsFile.readAsLinesSync();
  final assetNames = <String>[];
  
  for (final line in lines) {
    if (line.contains('static const String') && line.contains('=')) {
      final match = RegExp(r'static const String (\w+)').firstMatch(line);
      if (match != null) {
        assetNames.add(match.group(1)!);
      }
    }
  }

  final out = File('asset_usages.md');
  var md = '# AppAssets Local Usages & API Mapping\n\n';
  md += '| Asset Constant | Where Used | Corresponding API Key |\n';
  md += '| :--- | :--- | :--- |\n';

  for (final name in assetNames) {
    final result = Process.runSync('grep', ['-r', 'AppAssets.$name', 'lib/']);
    final output = result.stdout.toString().trim();
    
    if (output.isEmpty) {
      md += '| `$name` | *Unused* | ? |\n';
    } else {
      final files = output.split('\n').map((line) {
        final parts = line.split(':');
        if (parts.isNotEmpty) {
          final file = parts[0].replaceAll('lib/', '').replaceAll('.dart', '');
          return '`$file`';
        }
        return '';
      }).where((s) => s.isNotEmpty).toSet().toList();
      
      md += '| `$name` | ${files.join('<br>')} | ? |\n';
    }
  }
  
  out.writeAsStringSync(md);
  print('Done.');
}
