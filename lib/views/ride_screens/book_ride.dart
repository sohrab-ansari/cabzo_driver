import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nzcu_driver/services/apiservices/places_api_service.dart';
import 'package:nzcu_driver/controllers/book_ride_controller/create_By_driver_controller.dart';
import 'package:nzcu_driver/modals/home_modals/place_prediction.dart';
import 'package:nzcu_driver/utilities/widgets/app_buttons.dart';
import 'package:nzcu_driver/utilities/colors/colors.dart';
import 'package:nzcu_driver/utilities/widgets/custom_font.dart';
import 'package:nzcu_driver/utilities/widgets/location_input_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nzcu_driver/views/ride_screens/accepted_screen.dart';
import 'package:nzcu_driver/views/ride_screens/map_location_picker.dart';

class BookRide extends StatefulWidget {
  const BookRide({super.key});

  @override
  State<BookRide> createState() => _BookRideState();
}

class _BookRideState extends State<BookRide> {
  // Controllers
  final CreateByDriverController createByDriverController =
      Get.find<CreateByDriverController>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController pickupController = TextEditingController();
  final TextEditingController dropController = TextEditingController();

  // Form key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Location data
  double? pickupLat;
  double? pickupLng;
  double? dropLat;
  double? dropLng;

  // UI States
  bool isLoadingLocation = true;
  bool isBooking = false;

  // Validation errors
  String? pickupError;
  String? dropError;

  @override
  void initState() {
    super.initState();
    _fetchCurrentLocation();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    pickupController.dispose();
    dropController.dispose();
    super.dispose();
  }

  /// Fetch current location and reverse geocode to get address
  Future<void> _fetchCurrentLocation() async {
    try {
      setState(() => isLoadingLocation = true);

      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        setState(() {
          isLoadingLocation = false;
          pickupError = "Location permission denied";
        });
        return;
      }

      // Get current position
      final Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      pickupLat = position.latitude;
      pickupLng = position.longitude;

      // Reverse geocode to get address
      final String? address = await PlacesApiService.getAddressFromCoordinates(
        position.latitude,
        position.longitude,
      );

      setState(() {
        if (address != null) {
          pickupController.text = address;
        } else {
          pickupController.text =
              "${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}";
        }
        isLoadingLocation = false;
        pickupError = null;
      });
    } catch (e) {
      print("❌ Error fetching location: $e");
      setState(() {
        isLoadingLocation = false;
        pickupError = "Could not fetch location";
      });
    }
  }

  /// Show bottom sheet for place autocomplete
  void _showPlaceSearchSheet({required bool isPickup}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _PlaceSearchSheet(
        isPickup: isPickup,
        onPlaceSelected: (PlaceDetails details) {
          setState(() {
            if (isPickup) {
              pickupController.text = details.address;
              pickupLat = details.lat;
              pickupLng = details.lng;
              pickupError = null;
            } else {
              dropController.text = details.address;
              dropLat = details.lat;
              dropLng = details.lng;
              dropError = null;
            }
          });
        },
        onPickOnMap: () async {
          // Close the search sheet first
          Navigator.pop(context);

          // Open the map picker and await the user's chosen location
          final PlaceDetails? result = await Get.to<PlaceDetails>(
            () => MapLocationPicker(
              isPickup: isPickup,
              initialLat: isPickup ? pickupLat : dropLat,
              initialLng: isPickup ? pickupLng : dropLng,
            ),
            transition: Transition.rightToLeft,
            duration: const Duration(milliseconds: 300),
          );

          if (result != null && mounted) {
            setState(() {
              if (isPickup) {
                pickupController.text = result.address;
                pickupLat = result.lat;
                pickupLng = result.lng;
                pickupError = null;
              } else {
                dropController.text = result.address;
                dropLat = result.lat;
                dropLng = result.lng;
                dropError = null;
              }
            });
          }
        },
      ),
    );
  }

  /// Clear pickup location
  void _clearPickup() {
    setState(() {
      pickupController.clear();
      pickupLat = null;
      pickupLng = null;
    });
  }

  /// Clear drop location
  void _clearDrop() {
    setState(() {
      dropController.clear();
      dropLat = null;
      dropLng = null;
    });
  }

  /// Validate form and submit
  Future<void> _onBookNow() async {
    // Validate locations
    bool isValid = true;

    if (pickupController.text.isEmpty ||
        pickupLat == null ||
        pickupLng == null) {
      setState(() => pickupError = "Please select pickup location");
      isValid = false;
    } else {
      setState(() => pickupError = null);
    }

    if (dropController.text.isEmpty || dropLat == null || dropLng == null) {
      setState(() => dropError = "Please select drop location");
      isValid = false;
    } else {
      setState(() => dropError = null);
    }

    // Validate form fields
    if (!(_formKey.currentState?.validate() ?? false)) {
      isValid = false;
    }

    if (!isValid) return;

    // All valid, make API call
    setState(() => isBooking = true);

    try {
      await createByDriverController.processCashPayment(
        startLat: pickupLat!,
        startLng: pickupLng!,
        startAddress: pickupController.text,
        endLat: dropLat!,
        endLng: dropLng!,
        endAddress: dropController.text,
        userName: nameController.text.trim(),
        phone: phoneController.text.trim(),
      );

      // Check if booking was successful
      if (createByDriverController.cashResponse.value?.success == true) {
        // Show success message using ScaffoldMessenger
        if (mounted) {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     content: Text('Ride booked successfully!'),
          //     backgroundColor: Colors.green,
          //     duration: const Duration(seconds: 2),
          //   ),
          // );



            Fluttertoast.showToast(
            msg: 'Ride booked successfully!',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP, // 👈 Top position
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }

        // Extract ride data from API response for navigation
        final apiResponse = createByDriverController.cashResponse.value;
        final rideData = apiResponse?.data?.toJson() ?? {};

        // Add orderId using the _id from response
        rideData['orderId'] =
            apiResponse?.data?.id ?? apiResponse?.data?.dataId;

        // Navigate to ArrivingClient screen with typeCheck:true for book ride flow
        await Get.to(
          () => ArrivingClient(rideData: rideData, typeCheck: true),
          transition: Transition.rightToLeft,
          duration: const Duration(milliseconds: 300),
        );
      } else {
        // Show error message using ScaffoldMessenger
        if (mounted) {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     content: Text(
          //       createByDriverController.errorMessage.value.isNotEmpty
          //           ? createByDriverController.errorMessage.value
          //           : 'Failed to book ride. Please try again.',
          //     ),
          //     backgroundColor: Colors.red,
          //     duration: const Duration(seconds: 3),
          //   ),
          // );

          Fluttertoast.showToast(
            msg: createByDriverController.errorMessage.value.isNotEmpty
                ? createByDriverController.errorMessage.value
                : 'Failed to book ride. Please try again.',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP, // 👈 Top position
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      }
    } catch (e) {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Something went wrong. Please try again.'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isBooking = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: Get.back,
        ),
        leadingWidth: w * 0.08,
        title: AppFonts.textPoppins(
          context,
          "Ride ready",
          w * 0.055,
          FontWeight.w600,
          AppColors.black,
          TextAlign.left,
          TextOverflow.visible,
        ).animateFadeScale(700),
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: w * 0.04),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Header Image
                Image.asset(
                  "assets/images/bookridemain.png",
                  height: h * 0.22,
                  width: w,
                  fit: BoxFit.contain,
                ).animateFadeScale(600),

                SizedBox(height: h * 0.02),

                /// Title
                AppFonts.textPoppins(
                  context,
                  "Set your route – pickup & drop.",
                  w * 0.045,
                  FontWeight.w600,
                  AppColors.black,
                  TextAlign.left,
                  TextOverflow.visible,
                ).animateFadeScale(700),

                SizedBox(height: h * 0.02),

                /// Pickup Location
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        LocationInputTextfield(
                          address: pickupController,
                          onPressed: () =>
                              _showPlaceSearchSheet(isPickup: true),
                          preffixImage: "assets/icons/greenDot.png",
                          preffixhorizontalPadding: w * 0.02,
                          hintText: isLoadingLocation
                              ? "Fetching your location..."
                              : "Your Current Location",
                          showClearButton: pickupController.text.isNotEmpty,
                          onClear: _clearPickup,
                        ),
                        if (isLoadingLocation)
                          Positioned(
                            right: w * 0.04,
                            top: 0,
                            bottom: 0,
                            child: Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (pickupError != null)
                      Padding(
                        padding: EdgeInsets.only(left: w * 0.04, top: 4),
                        child: Text(
                          pickupError!,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: w * 0.03,
                          ),
                        ),
                      ),
                  ],
                ),

                SizedBox(height: h * 0.015),

                /// Drop Location
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LocationInputTextfield(
                      address: dropController,
                      onPressed: () => _showPlaceSearchSheet(isPickup: false),
                      preffixImage: "assets/icons/redDot.png",
                      hintText: "Drop location",
                      showClearButton: dropController.text.isNotEmpty,
                      onClear: _clearDrop,
                    ),
                    if (dropError != null)
                      Padding(
                        padding: EdgeInsets.only(left: w * 0.04, top: 4),
                        child: Text(
                          dropError!,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: w * 0.03,
                          ),
                        ),
                      ),
                  ],
                ),

                SizedBox(height: h * 0.02),

                Divider(
                  thickness: 1.2,
                  color: AppColors.darkGray.withValues(alpha: 0.2),
                ),

                SizedBox(height: h * 0.02),

                /// Full Name
                _labelText(context, "Full Name", w),
                SizedBox(height: h * 0.01),
                TextFormField(
                  controller: nameController,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  style: TextStyle(
                    fontSize: w * 0.04,
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: InputDecoration(
                    hintText: "Enter passenger name",
                    hintStyle: TextStyle(
                      fontSize: w * 0.04,
                      fontWeight: FontWeight.w300,
                      color: Colors.grey,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(w * 0.03),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(w * 0.03),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(w * 0.03),
                      borderSide: BorderSide(color: Colors.green, width: 1.5),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: w * 0.04,
                      vertical: w * 0.035,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter passenger name";
                    }
                    return null;
                  },
                ).animateFadeScale(900),

                SizedBox(height: h * 0.02),

                /// Mobile Number
                _labelText(context, "Mobile Number", w),
                SizedBox(height: h * 0.01),
                TextFormField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  style: TextStyle(
                    fontSize: w * 0.04,
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: InputDecoration(
                    hintText: "Enter 10-digit mobile number",
                    hintStyle: TextStyle(
                      fontSize: w * 0.04,
                      fontWeight: FontWeight.w300,
                      color: Colors.grey,
                    ),
                    counterText: "",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(w * 0.03),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(w * 0.03),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(w * 0.03),
                      borderSide: BorderSide(color: Colors.green, width: 1.5),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: w * 0.04,
                      vertical: w * 0.035,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter mobile number";
                    }
                    if (value.trim().length != 10) {
                      return "Please enter valid 10-digit number";
                    }
                    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                      return "Please enter numbers only";
                    }
                    return null;
                  },
                ).animateFadeScale(900),

                SizedBox(height: h * 0.04),

                /// Book Button
                Obx(() {
                  final isLoading =
                      isBooking || createByDriverController.isLoading.value;
                  return AppButtons.solid(
                    context: context,
                    text: "Book Now",
                    onClicked: isLoading ? () {} : _onBookNow,
                    isFullWidth: true,
                    height: w * 0.13,
                    radius: 12,
                    fontSize: w * 0.045,
                    textColor: AppColors.black,
                    fontWeight: FontWeight.w600,
                    isLoading: isLoading,
                  );
                }).animateFadeScale(1200),

                SizedBox(height: h * 0.03),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _labelText(BuildContext context, String text, double w) {
    return AppFonts.textPoppins(
      context,
      text,
      w * 0.038,
      FontWeight.w500,
      AppColors.black.withValues(alpha: 0.8),
      TextAlign.left,
      TextOverflow.visible,
    );
  }
}

/// Bottom sheet for place search with autocomplete
class _PlaceSearchSheet extends StatefulWidget {
  final bool isPickup;
  final Function(PlaceDetails) onPlaceSelected;

  /// Called when user wants to pick location via map pin
  final VoidCallback onPickOnMap;

  const _PlaceSearchSheet({
    required this.isPickup,
    required this.onPlaceSelected,
    required this.onPickOnMap,
  });

  @override
  State<_PlaceSearchSheet> createState() => _PlaceSearchSheetState();
}

class _PlaceSearchSheetState extends State<_PlaceSearchSheet> {
  final TextEditingController _searchController = TextEditingController();
  List<PlacePrediction> _predictions = [];
  bool _isLoading = false;
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    // Debounce search requests
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 400), () async {
      if (query.length < 2) {
        setState(() => _predictions = []);
        return;
      }

      setState(() => _isLoading = true);

      final predictions = await PlacesApiService.getPlacePredictions(query);

      if (mounted) {
        setState(() {
          _predictions = predictions;
          _isLoading = false;
        });
      }
    });
  }

  Future<void> _onPlaceSelected(PlacePrediction prediction) async {
    setState(() => _isLoading = true);

    final details = await PlacesApiService.getPlaceDetails(prediction.placeId);

    if (details != null) {
      widget.onPlaceSelected(details);
      if (mounted) Navigator.pop(context);
    } else {
      setState(() => _isLoading = false);
      Get.snackbar(
        'Error',
        'Could not get place details',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Container(
      height: h * 0.75,
      padding: EdgeInsets.symmetric(horizontal: w * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: h * 0.015),

          // Handle bar
          Center(
            child: Container(
              width: w * 0.12,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          SizedBox(height: h * 0.02),

          // Title
          Text(
            widget.isPickup ? "Select Pickup Location" : "Select Drop Location",
            style: TextStyle(fontSize: w * 0.05, fontWeight: FontWeight.w600),
          ),

          SizedBox(height: h * 0.02),

          // Search field
          TextField(
            controller: _searchController,
            autofocus: true,
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              hintText: "Search location...",
              prefixIcon: Icon(Icons.search, color: Colors.grey),
              suffixIcon: _isLoading
                  ? Container(
                      padding: EdgeInsets.all(12),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.close, color: Colors.grey),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _predictions = []);
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: widget.isPickup ? Colors.green : Colors.red,
                  width: 1.5,
                ),
              ),
            ),
          ),

          SizedBox(height: h * 0.015),

          // ── Pick on map option ─────────────────────────────────────────
          GestureDetector(
            onTap: widget.onPickOnMap,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: w * 0.04,
                vertical: w * 0.03,
              ),
              decoration: BoxDecoration(
                color: AppColors.lightGray,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primaryblue.withValues(alpha: 0.35),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.primaryblue.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.map_outlined,
                      color: AppColors.primaryblue,
                      size: 18,
                    ),
                  ),
                  SizedBox(width: w * 0.03),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pick location on map',
                        style: GoogleFonts.poppins(
                          fontSize: w * 0.038,
                          fontWeight: FontWeight.w600,
                          color: AppColors.black,
                        ),
                      ),
                      Text(
                        'Drag map & place pin exactly',
                        style: GoogleFonts.poppins(
                          fontSize: w * 0.03,
                          fontWeight: FontWeight.w400,
                          color: AppColors.mediumGray,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.chevron_right,
                    color: AppColors.mediumGray,
                    size: 22,
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: h * 0.015),

          // Divider between map option and search results
          Row(
            children: [
              Expanded(child: Divider(color: Colors.grey.shade200, height: 1)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.03),
                child: Text(
                  'or search below',
                  style: GoogleFonts.poppins(
                    fontSize: w * 0.028,
                    color: AppColors.mediumGray,
                  ),
                ),
              ),
              Expanded(child: Divider(color: Colors.grey.shade200, height: 1)),
            ],
          ),

          SizedBox(height: h * 0.015),

          // Predictions list
          Expanded(
            child: _predictions.isEmpty
                ? Center(
                    child: Text(
                      _searchController.text.isEmpty
                          ? "Start typing to search..."
                          : "No places found",
                      style: TextStyle(color: Colors.grey, fontSize: w * 0.04),
                    ),
                  )
                : ListView.separated(
                    itemCount: _predictions.length,
                    separatorBuilder: (_, __) => Divider(height: 1),
                    itemBuilder: (context, index) {
                      final prediction = _predictions[index];
                      return ListTile(
                        leading: Icon(
                          Icons.location_on_outlined,
                          color: widget.isPickup ? Colors.green : Colors.red,
                        ),
                        title: Text(
                          prediction.mainText ?? prediction.description,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: w * 0.038,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: prediction.secondaryText != null
                            ? Text(
                                prediction.secondaryText!,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: w * 0.032,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )
                            : null,
                        onTap: () => _onPlaceSelected(prediction),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

/// Animation Extension
extension AnimateHelper on Widget {
  Widget animateFadeScale(int durationMs) {
    return animate()
        .fade(duration: durationMs.ms, curve: Curves.easeInOut)
        .scale(begin: const Offset(0.96, 0.96), end: const Offset(1, 1));
  }
}
