import 'package:amplify_trips_planner/models/ModelProvider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:amplify_trips_planner/common/utils/colors.dart' as constants;

// Added for refreshImageUrl
import 'package:amplify_trips_planner/features/trip/controller/trip_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:amplify_trips_planner/features/trip/data/trips_repository.dart';

class TripGridViewItemCard extends StatelessWidget {
  const TripGridViewItemCard({
    required this.trip,
    required this.ref,
    required this.listStreamProvider,
    super.key,
  });

  final Trip trip;
  final WidgetRef ref;
  final AutoDisposeStreamProvider<List<Trip?>> listStreamProvider;

  Future<void> refreshImageUrl() async {
    //Grab a newly signed Url for the s3 image being displayed
    final tripController = ref.read(tripControllerProvider);
    await tripController.getSignedUrl(trip, trip.tripImageKey);
    //immediately update the stream
    ref.refresh(listStreamProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5.0,
      child: Column(
        children: [
          Expanded(
            child: Container(
              height: 500,
              alignment: Alignment.center,
              color: const Color(constants.primaryColorDark),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: trip.tripImageUrl != null
                        ? CachedNetworkImage(
                            errorWidget: (context, url, dynamic error) {
                              debugPrint(
                                'Error on CashedNetworkImage: ${error.toString().substring(0, 50)} for Key: ${trip.tripImageKey}',
                              );
                              // if statusCode: 403 refresh the signed URL
                              if (error
                                  .toString()
                                  .contains('statusCode: 403')) {
                                refreshImageUrl();
                              }
                              return const Icon(Icons.error_outline_outlined);
                            },
                            imageUrl: trip.tripImageUrl!,
                            cacheKey: trip.tripImageKey,
                            width: double.maxFinite,
                            height: 500,
                            alignment: Alignment.topCenter,
                            fit: BoxFit.fill,
                          )
                        : Image.asset(
                            'images/amplify.png',
                            fit: BoxFit.contain,
                          ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        trip.destination,
                        style: Theme.of(context)
                            .textTheme
                            .headline5!
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(2, 8, 8, 4),
            child: DefaultTextStyle(
              softWrap: false,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.subtitle1!,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      trip.tripName,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1!
                          .copyWith(color: Colors.black54),
                    ),
                  ),
                  Text(
                    DateFormat('MMMM dd, yyyy')
                        .format(trip.startDate.getDateTime()),
                    style: const TextStyle(fontSize: 12),
                  ),
                  Text(
                      DateFormat('MMMM dd, yyyy')
                          .format(trip.endDate.getDateTime()),
                      style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
