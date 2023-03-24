import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'dart:io';

import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as p;

class StorageService {
  StorageService({
    required Ref ref,
  });

  ValueNotifier<double> uploadProgress = ValueNotifier<double>(0);

// Fetch a signed URL for the S3 bucket for the passed key
  Future<String> getImageUrl(String key) async {
    final result = await Amplify.Storage.getUrl(
      key: key,
      options: S3GetUrlOptions(expires: 60000),
    );
    return result.url;
  }

  ValueNotifier<double> getUploadProgress() {
    return uploadProgress;
  }

  Future<String?> uploadFile(File file) async {
    try {
      final extension = p.extension(file.path);
      final key = const Uuid().v1() + extension;
      await Amplify.Storage.uploadFile(
          local: file,
          key: key,
          onProgress: (progress) {
            uploadProgress.value = progress.getFractionCompleted();
          });

      return key;
    } on Exception catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  void resetUploadProgress() {
    uploadProgress.value = 0;
  }
}

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService(ref: ref);
});

// This is an interesting code snipet from the AWS example.  It is not used anywhere
// in the application.  I wonder if this was an attempt to deal with the resigning
// of a failed cashenetworkimage from an expired URL and they never implemented it.
// I wrote my own work around... might this be more elegant?  I'm not exactly sure
// how it was intended to be used, but left it in here for contemplation
// final imageUrlProvider =
//     FutureProvider.autoDispose.family<String, String>((ref, key) {
//   final storageService = ref.watch(storageServiceProvider);
//   return storageService.getImageUrl(key);
//});
