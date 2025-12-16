// Flutter
import 'package:flutter/material.dart';

// External dependencies
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Internal dependencies
import 'package:electrivel_app/services/services.dart';
import 'package:electrivel_app/presentation/presentation.dart';


class AssistanceManagementDetailScreen extends HookConsumerWidget {
  const AssistanceManagementDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assistanceDetail = ref.watch(assistanceDetailProvider);

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: StreamBuilder(
          stream: DatabaseDatasource().read(path: assistanceDetail.username),
          builder: (context, asyncSnapshot) {

            if (asyncSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator.adaptive());
            }

            if (!asyncSnapshot.hasData) {
              return SizedBox.shrink();
            }

            if (!asyncSnapshot.hasData || asyncSnapshot.data!.value == null) {
              return const Center(child: Text('Sin datos'));
            }

            final raw = asyncSnapshot.data!.value;
            if (raw is! Map) {
              return const Center(child: Text('Formato inesperado'));
            }

            final values = Map<String, dynamic>.from(raw);
            final model = LocationModel.fromMap(values);
            return _MapView(model);
          }
        ),
      ),
    );
  }
}


class _MapView extends StatefulWidget {
  final LocationModel locationModel;
  const _MapView(this.locationModel);

  @override
  State<_MapView> createState() => _MapViewState();
}

class _MapViewState extends State<_MapView> {
  GoogleMapController? _controller;
  LatLng? _currentPosition;

  @override
  void initState() {
    super.initState();
    _currentPosition = LatLng(widget.locationModel.lat, widget.locationModel.lng);
  }

  @override
  void didUpdateWidget(covariant _MapView oldWidget) {
    super.didUpdateWidget(oldWidget);

    final newPosition = LatLng(widget.locationModel.lat, widget.locationModel.lng);

    if (_controller != null && _currentPosition != newPosition) {
      _controller!.animateCamera(
        CameraUpdate.newLatLng(newPosition),
      );
      _currentPosition = newPosition;
    }
  }

  @override
  Widget build(BuildContext context) {
    final target = LatLng(widget.locationModel.lat, widget.locationModel.lng);
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(
          target: target,
          zoom: 16
      ),
      markers: {
        Marker(
          markerId: const MarkerId('current'),
          position: target,
        ),
      },
      onMapCreated: (GoogleMapController controller) {
        _controller = controller;
      },
    );
  }
}
