import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapLocationView extends StatefulWidget {
  final double? latitude;
  final double? longitude;
  final double zoom;

  const MapLocationView({
    super.key,
    this.latitude,
    this.longitude,
    this.zoom = 15,
  });

  @override
  State<MapLocationView> createState() => _MapLocationViewState();
}

class _MapLocationViewState extends State<MapLocationView> {
  late GoogleMapController _mapController;
  late CameraPosition _initialCameraPosition;
  MapType _currentMapType = MapType.normal;
  late LatLng _currentLocation;

  @override
  void initState() {
    super.initState();

    _currentLocation = widget.latitude != null && widget.longitude != null
        ? LatLng(widget.latitude!, widget.longitude!)
        : LatLng(23.7783572, 90.4066369);

    _initialCameraPosition = CameraPosition(
      target: _currentLocation,
      zoom: widget.zoom,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          mapType: _currentMapType,
          initialCameraPosition: _initialCameraPosition,
          onMapCreated: (GoogleMapController controller) {
            _mapController = controller;
          },
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          zoomGesturesEnabled: true,
          scrollGesturesEnabled: true,
          rotateGesturesEnabled: true,
          tiltGesturesEnabled: true,
          markers: {
            Marker(
              markerId: MarkerId('selected_location'),
              position: _currentLocation,
              draggable: true,
              onDragEnd: (newPosition) {
                setState(() {
                  _currentLocation = newPosition;
                });
                print('New position: ${newPosition.latitude}, ${newPosition.longitude}');
              },
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            ),
          },
          onTap: (tappedPosition) {
            setState(() {
              _currentLocation = tappedPosition;
            });
          },
        ),
        // Controls overlay
        Positioned(
          top: 10,
          right: 10,
          child: Column(
            children: [
              // Fullscreen button
              Container(
                margin: EdgeInsets.only(bottom: 8),
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to fullscreen map
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => FullScreenMapView(
                          latitude: _currentLocation.latitude,
                          longitude: _currentLocation.longitude,
                          zoom: widget.zoom,
                         // mapType: _currentMapType,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.all(8),
                    shape: CircleBorder(),
                  ),
                  child: Icon(
                    Icons.fullscreen,
                    color: Colors.black,
                  ),
                ),
              ),
              // Map type button
              Container(
                margin: EdgeInsets.only(bottom: 8),
                child: ElevatedButton(
                  onPressed: _changeMapType,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.all(8),
                    shape: CircleBorder(),
                  ),
                  child: Icon(
                    Icons.layers,
                    color: Colors.black,
                  ),
                ),
              ),
              // Zoom in button
              Container(
                margin: EdgeInsets.only(bottom: 8),
                child: ElevatedButton(
                  onPressed: _zoomIn,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.all(8),
                    shape: CircleBorder(),
                  ),
                  child: Icon(
                    Icons.add,
                    color: Colors.black,
                  ),
                ),
              ),
              // Zoom out button
              Container(
                margin: EdgeInsets.only(bottom: 8),
                child: ElevatedButton(
                  onPressed: _zoomOut,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.all(8),
                    shape: CircleBorder(),
                  ),
                  child: Icon(
                    Icons.remove,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _zoomIn() {
    _mapController.animateCamera(
      CameraUpdate.zoomIn(),
    );
  }

  void _zoomOut() {
    _mapController.animateCamera(
      CameraUpdate.zoomOut(),
    );
  }

  void _changeMapType() {
    setState(() {
      _currentMapType = MapType.values[(_currentMapType.index + 1) % MapType.values.length];
    });
  }
}

// Separate fullscreen map widget
class FullScreenMapView extends StatefulWidget {
  final double latitude;
  final double longitude;
  final double zoom;
  final MapType initialMapType;

  const FullScreenMapView({
    super.key,
    required this.latitude,
    required this.longitude,
    this.zoom = 15,
    this.initialMapType = MapType.normal,
  });

  @override
  State<FullScreenMapView> createState() => _FullScreenMapViewState();
}

class _FullScreenMapViewState extends State<FullScreenMapView> {
  late GoogleMapController _mapController;
  late CameraPosition _initialCameraPosition;
  late MapType _currentMapType;
  late LatLng _currentLocation;

  @override
  void initState() {
    super.initState();

    _currentLocation = LatLng(widget.latitude, widget.longitude);
    _currentMapType = widget.initialMapType;

    _initialCameraPosition = CameraPosition(
      target: _currentLocation,
      zoom: widget.zoom,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: _currentMapType,
            initialCameraPosition: _initialCameraPosition,
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            zoomGesturesEnabled: true,
            scrollGesturesEnabled: true,
            rotateGesturesEnabled: true,
            tiltGesturesEnabled: true,
            compassEnabled: false,
            markers: {
              Marker(
                markerId: MarkerId('selected_location'),
                position: _currentLocation,
                draggable: true,
                onDragEnd: (newPosition) {
                  setState(() {
                    _currentLocation = newPosition;
                  });
                  print('New position: ${newPosition.latitude}, ${newPosition.longitude}');
                },
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
              ),
            },
            onTap: (tappedPosition) {
              setState(() {
                _currentLocation = tappedPosition;
              });
            },
          ),
          // Close button
          Positioned(
            top: 40,
            left: 10,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: EdgeInsets.all(8),
                shape: CircleBorder(),
              ),
              child: Icon(
                Icons.close,
                color: Colors.black,
              ),
            ),
          ),
          // Controls overlay
          Positioned(
            top: 40,
            right: 10,
            child: Column(
              children: [
                // Map type button
                Container(
                  margin: EdgeInsets.only(bottom: 8),
                  child: ElevatedButton(
                    onPressed: _changeMapType,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.all(8),
                      shape: CircleBorder(),
                    ),
                    child: Icon(
                      Icons.layers,
                      color: Colors.black,
                    ),
                  ),
                ),
                // Zoom in button
                Container(
                  margin: EdgeInsets.only(bottom: 8),
                  child: ElevatedButton(
                    onPressed: _zoomIn,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.all(8),
                      shape: CircleBorder(),
                    ),
                    child: Icon(
                      Icons.add,
                      color: Colors.black,
                    ),
                  ),
                ),
                // Zoom out button
                Container(
                  margin: EdgeInsets.only(bottom: 8),
                  child: ElevatedButton(
                    onPressed: _zoomOut,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.all(8),
                      shape: CircleBorder(),
                    ),
                    child: Icon(
                      Icons.remove,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _zoomIn() {
    _mapController.animateCamera(
      CameraUpdate.zoomIn(),
    );
  }

  void _zoomOut() {
    _mapController.animateCamera(
      CameraUpdate.zoomOut(),
    );
  }

  void _changeMapType() {
    setState(() {
      _currentMapType = MapType.values[(_currentMapType.index + 1) % MapType.values.length];
    });
  }
}