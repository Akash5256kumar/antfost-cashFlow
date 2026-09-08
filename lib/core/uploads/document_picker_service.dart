import 'package:file_picker/file_picker.dart';

class SelectedDocument {
  const SelectedDocument({
    required this.name,
    required this.path,
    required this.sizeBytes,
    required this.mimeType,
  });

  final String name;
  final String? path;
  final int sizeBytes;
  final String mimeType;
}

class DocumentPickerException implements Exception {
  const DocumentPickerException(this.message);

  final String message;
}

/// Selects a customer document before it is uploaded through a backend-issued
/// upload URL. It does not persist files or send them to Firebase.
class DocumentPickerService {
  const DocumentPickerService._();

  static const maxFileSizeBytes = 15 * 1024 * 1024;
  static const _allowedExtensions = ['pdf', 'jpg', 'jpeg', 'png'];

  static Future<SelectedDocument?> pickDocument({
    int maxSizeBytes = maxFileSizeBytes,
  }) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: _allowedExtensions,
    );
    if (result == null) return null;

    final file = result.files.single;
    final extension = file.extension?.toLowerCase();
    if (extension == null || !_allowedExtensions.contains(extension)) {
      throw const DocumentPickerException(
        'Choose a PDF, JPG, or PNG document.',
      );
    }
    if (file.size <= 0) {
      throw const DocumentPickerException('The selected file is empty.');
    }
    if (file.size > maxSizeBytes) {
      final maxMegabytes = maxSizeBytes ~/ (1024 * 1024);
      throw DocumentPickerException(
        'The selected file exceeds the $maxMegabytes MB limit.',
      );
    }

    return SelectedDocument(
      name: file.name,
      path: file.path,
      sizeBytes: file.size,
      mimeType: _mimeTypeFor(extension),
    );
  }

  static String _mimeTypeFor(String extension) {
    switch (extension) {
      case 'pdf':
        return 'application/pdf';
      case 'png':
        return 'image/png';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      default:
        throw ArgumentError.value(extension, 'extension');
    }
  }
}
