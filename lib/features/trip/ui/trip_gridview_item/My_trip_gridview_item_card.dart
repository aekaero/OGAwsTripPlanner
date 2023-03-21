import 'package:amplify_trips_planner/models/ModelProvider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:amplify_trips_planner/common/utils/colors.dart' as constants;

//TEMPORARY IMPORTS TO SUPPORT DEBUGGING BELOW
//import 'package:amplify_trips_planner/features/trip/controller/trip_controller.dart';
//import 'package:flutter_riverpod/flutter_riverpod.dart';
//Get access to tripStreamProvider
//import 'package:amplify_trips_planner/features/trip/data/trips_repository.dart';

//class TripGridViewItemCard extends ConsumerWidget {
class TripGridViewItemCard extends StatelessWidget {
// There was a const before the TripGridViewItemCard, I had
// to remove it in order to track isRefreshed.

  const TripGridViewItemCard({
    //TripGridViewItemCard({
    required this.trip,
    super.key,
  });

//TripGridViewItemCard is called under the TripsStreamProvider, and edits
//Should be updated and this class recalled through that.

  final Trip trip;

  //final test = debugPrint('TripGridViewItemCard Enstanciated');
//  var isRefreshed = false;

  // Get a freshly signed url for this Image Key
  // Future<void> refreshImageUrl({
  //   required WidgetRef ref,
  //   required Trip trip,
  // }) async {
  //   if (isRefreshed) {
  //     debugPrint('skipped');
  //     return;
  //   }
  //   isRefreshed = true;
  //   final oldUrl = trip.tripImageUrl;
  //   await ref
  //       .read(tripControllerProvider)
  //       .getSignedUrl(trip, trip.tripImageKey);
  //   //DEBUG
  //   //// I am trying the next line to see if I can get this to refresh more quickly
  //   ///  THE PROBLEM RESOLVED BEFORE I EVER HAD A CHANCE TO TRY
  //   //ref.refresh(tripProvider(trip.id));
  //   //
  //   //final isSame = oldUrl == trip.tripImageUrl;
  //   //debugPrint('Is Same: $isSame');
  //   //debugPrint('OLD Url: $oldUrl');
  //   //debugPrint('NEW Url: ${trip.tripImageUrl}');
  //   debugPrint('Url Refreshed for key: ${trip.tripImageKey}');
  // }

  @override
  Widget build(BuildContext context) {
    //Widget build(BuildContext context, WidgetRef ref) {
    // Setup a watch provider for this trip so that if the
    // trip.ImageUrl needs to be resigned, the code will
    // paint the image upon datastore update

    // Just defining this watch causes the widget tree to rebuild 3x instead of 1x
    //final tripValue = ref.watch(tripProvider(trip.id));

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
                        ? Stack(
                            children: [
                              const Center(child: CircularProgressIndicator()),
//
                              // use Provider above to reload the image if a new signed URL is required
                              // to be fetched
                              // tripValue.when(
                              //   data: (trip) {
                              //     debugPrint(
                              //         'Running CNI: ${trip!.tripImageUrl}');
                              //     debugPrint('Done');
                              //     return
//
                              CachedNetworkImage(
                                errorWidget: (context, url, dynamic error) {
                                  debugPrint(
                                    'Error on CashedNetworkImage: ${error.toString().substring(0, 50)} for Key: ${trip.tripImageKey}',
                                  );
// //                                // if statusCode: 403 refresh the signed URL
//                                   if (error
//                                       .toString()
//                                       .contains('statusCode: 403')) {
//                                     refreshImageUrl(
//                                       ref: ref,
//                                       trip: trip,
//                                     );
//                                   }
                                  return const Icon(
                                    Icons.error_outline_outlined,
                                  );
                                },
                                imageUrl: trip.tripImageUrl!,
                                cacheKey: trip.tripImageKey,
                                width: double.maxFinite,
                                height: 500,
                                alignment: Alignment.topCenter,
                                fit: BoxFit.fill,
                              ),
                              //  ),
                              //     );
                              //   },
                              //   error: (e, st) => const Placeholder(),
                              //   loading: () => const Placeholder(),
                              // )
                            ],
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
