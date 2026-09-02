import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/features/shopping/domain/entities/lat_lng_point.dart';
import 'package:flower_app/features/shopping/presentation/view_models/buyer_map_cubit/buyer_map_cubit.dart';
import 'package:flower_app/features/shopping/presentation/view_models/buyer_map_cubit/buyer_map_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class BuyerLiveMapSheet extends StatelessWidget {
  final String orderId;
  final LatLngPoint? destination;

  const BuyerLiveMapSheet({
    super.key,
    required this.orderId,
    this.destination,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<BuyerMapCubit>(),
      child: _BuyerLiveMapView(orderId: orderId, destination: destination),
    );
  }
}

class _BuyerLiveMapView extends StatefulWidget {
  final String orderId;
  final LatLngPoint? destination;

  const _BuyerLiveMapView({required this.orderId, required this.destination});

  @override
  State<_BuyerLiveMapView> createState() => _BuyerLiveMapViewState();
}

class _BuyerLiveMapViewState extends State<_BuyerLiveMapView> {
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    context.read<BuyerMapCubit>().init(
      orderId: widget.orderId,
      destination: widget.destination,
    );
  }

  List<LatLng> _polylinePoints(BuyerMapState state) {
    final waypoints = state.route?.waypoints;
    if (waypoints != null && waypoints.isNotEmpty) {
      return waypoints.map((p) => LatLng(p.lat, p.lng)).toList();
    }
    final driver = state.driverLocation;
    final dest = state.destination;
    if (driver != null && dest != null) {
      return [LatLng(driver.lat, driver.lng), LatLng(dest.lat, dest.lng)];
    }
    return [];
  }

  void _fitCamera(BuyerMapState state) {
    final points = <LatLng>[];
    final driver = state.driverLocation;
    final dest = state.destination;
    if (driver != null) points.add(LatLng(driver.lat, driver.lng));
    if (dest != null) points.add(LatLng(dest.lat, dest.lng));
    final waypoints = state.route?.waypoints;
    if (waypoints != null) {
      points.addAll(waypoints.map((p) => LatLng(p.lat, p.lng)));
    }
    if (points.length < 2) return;
    final bounds = LatLngBounds.fromPoints(points);
    if (bounds.northEast.latitude == bounds.southWest.latitude &&
        bounds.northEast.longitude == bounds.southWest.longitude) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      try {
        _mapController.fitCamera(
          CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(48)),
        );
      } catch (_) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 4,
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        Expanded(
          child: BlocConsumer<BuyerMapCubit, BuyerMapState>(
            listener: (context, state) => _fitCamera(state),
            builder: (context, state) {
              if (state.phase == BuyerMapPhase.loading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state.phase == BuyerMapPhase.timeout) {
                return const Center(
                  child: Text('Driver location unavailable. Please try again.'),
                );
              }
              return _buildMap(state);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMap(BuyerMapState state) {
    final driver = state.driverLocation;
    final dest = state.destination;
    final polylinePoints = _polylinePoints(state);
    final center = driver != null
        ? LatLng(driver.lat, driver.lng)
        : (dest != null
            ? LatLng(dest.lat, dest.lng)
            : const LatLng(30.0444, 31.2357));
    final size = MediaQuery.sizeOf(context);

    return SizedBox(
      width: size.width,
      height: size.height * 0.75,
      child: FlutterMap(
        mapController: _mapController,
        options: MapOptions(initialCenter: center, initialZoom: 13),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.flower_app',
          ),
          if (polylinePoints.isNotEmpty)
            PolylineLayer(
              polylines: [
                Polyline(
                  points: polylinePoints,
                  strokeWidth: 4,
                  color: Colors.blue,
                ),
              ],
            ),
          MarkerLayer(
            markers: [
              if (driver != null)
                Marker(
                  point: LatLng(driver.lat, driver.lng),
                  width: 40,
                  height: 40,
                  child: const Icon(
                    Icons.delivery_dining,
                    color: Colors.blue,
                    size: 36,
                  ),
                ),
              if (dest != null)
                Marker(
                  point: LatLng(dest.lat, dest.lng),
                  width: 40,
                  height: 40,
                  child: const Icon(
                    Icons.location_pin,
                    color: Colors.red,
                    size: 36,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
