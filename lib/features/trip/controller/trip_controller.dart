import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:amplify_trips_planner/common/services/storage_service.dart';

import 'package:amplify_trips_planner/models/Trip.dart';
import 'package:amplify_trips_planner/features/trip/data/trips_repository.dart';

final tripControllerProvider = Provider<TripController>((ref) {
  return TripController(ref);
});

class TripController {
  TripController(this.ref);
  final Ref ref;

  Future<void> uploadFile(File file, Trip trip) async {
    // Download the attached file to Storage and get a file key in return
    final fileKey = await ref.read(storageServiceProvider).uploadFile(file);
    // File has been uploaded now request a signed URL to access it.
    final result = await getSignedUrl(trip, fileKey);
    if (result != null) ref.read(storageServiceProvider).resetUploadProgress();
  }

// Refresh a Signed Image URL that whoes signiture has expired.
  Future<String?> getSignedUrl(Trip trip, String? fileKey) async {
    if (fileKey == null) return null;
    final ssp = ref.read(storageServiceProvider);
    final imageUrl = await ssp.getImageUrl(fileKey);
    final updatedTrip =
        trip.copyWith(tripImageKey: fileKey, tripImageUrl: imageUrl);
    final trp = ref.read(tripsRepositoryProvider);
    await trp.update(updatedTrip);
    return imageUrl;
  }

  ValueNotifier<double> uploadProgress() {
    return ref.read(storageServiceProvider).getUploadProgress();
  }

  Future<void> edit(Trip updatedTrip) async {
    final tripsRepository = ref.read(tripsRepositoryProvider);
    await tripsRepository.update(updatedTrip);
  }

  Future<void> delete(Trip deletedTrip) async {
    final tripsRepository = ref.read(tripsRepositoryProvider);
    await tripsRepository.delete(deletedTrip);
  }
}
