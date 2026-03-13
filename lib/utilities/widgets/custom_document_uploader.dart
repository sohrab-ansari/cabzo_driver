// // import 'dart:io';
// // import 'dart:math' as math;
// // import 'package:nzcu_driver/utilities/app_buttons.dart';
// // import 'package:nzcu_driver/utilities/colors.dart';
// // import 'package:nzcu_driver/utilities/custom_font.dart';
// // import 'package:dotted_border/dotted_border.dart';
// // import 'package:flutter/material.dart';
// // import 'package:image_picker/image_picker.dart';

// // class CustomDocumentUploader extends StatefulWidget {
// //   final String? uploadText;
// //   final IconData uploadIcon;
// //   final double height;
// //   final double? width;
// //   final Color borderColor;
// //   final double borderWidth;
// //   final Color backgroundColor;
// //   final double borderRadius;
// //   final bool isCircular;

// //   const CustomDocumentUploader({
// //     super.key,
// //     this.uploadText,
// //     this.uploadIcon = Icons.upload,
// //     this.height = 200.0,
// //     this.width,
// //     this.borderColor = const Color(0xFF90A4AE),
// //     this.borderWidth = 2.0,
// //     this.backgroundColor = const Color(0xFFFAFAFA),
// //     this.borderRadius = 8.0,
// //     this.isCircular = false,
// //   });

// //   @override
// //   State<CustomDocumentUploader> createState() => _CustomDocumentUploaderState();
// // }

// // class _CustomDocumentUploaderState extends State<CustomDocumentUploader> {
// //   File? _selectedImage;
// //   final ImagePicker _picker = ImagePicker();

// //   Future<void> _pickImage() async {
// //     try {
// //       final XFile? picked = await _picker.pickImage(
// //         source: ImageSource.gallery, // or ImageSource.camera
// //         imageQuality: 80, // reduces file size, optional
// //       );

// //       if (picked != null) {
// //         setState(() {
// //           _selectedImage = File(picked.path);
// //         });
// //       }
// //     } catch (e) {
// //       debugPrint('Image picking failed: $e');
// //       ScaffoldMessenger.of(
// //         context,
// //       ).showSnackBar(SnackBar(content: Text('Failed to pick image')));
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     double w = MediaQuery.of(context).size.width;

// //     double effectiveWidth = widget.width ?? widget.height;
// //     double effectiveHeight = widget.height;
// //     double effectiveRadius = widget.borderRadius;

// //     if (widget.isCircular) {
// //       double side = math.min(effectiveWidth, effectiveHeight);
// //       effectiveWidth = side;
// //       effectiveHeight = side;
// //       effectiveRadius = side / 2;
// //     }

// //     return Padding(
// //       padding: EdgeInsets.symmetric(vertical: w * .03),
// //       child: SizedBox(
// //         width: effectiveWidth,
// //         height: effectiveHeight,
// //         child: DottedBorder(
// //           options: RoundedRectDottedBorderOptions(
// //             radius: Radius.circular(effectiveRadius),
// //             color: widget.borderColor,
// //             strokeWidth: widget.borderWidth,
// //             dashPattern: const [6, 2],
// //             padding: EdgeInsets.zero,
// //           ),
// //           child: Container(
// //             decoration: BoxDecoration(
// //               color: AppColors.lightGray,
// //               borderRadius: BorderRadius.circular(effectiveRadius),
// //             ),
// //             child: _selectedImage == null
// //                 ? Center(
// //                     child: AppButtons.solid(
// //                       context: context,
// //                       text: widget.uploadText ?? "Upload",
// //                       onClicked: _pickImage,
// //                       prefixIcon: Icon(
// //                         Icons.file_upload_outlined,
// //                         color: AppColors.white,
// //                         size: w * .05,
// //                       ),
// //                       width: w * .3,
// //                       height: w * .1,
// //                       backgroundColor: AppColors.black,
// //                       textColor: AppColors.white,
// //                       fontSize: w * .04,
// //                       radius: w * .1,
// //                       fontWeight: FontWeight.w500,
// //                       padding: EdgeInsets.zero,
// //                     ),
// //                   )
// //                 : Stack(
// //                     children: [
// //                       Center(
// //                         child: ClipRRect(
// //                           borderRadius: BorderRadius.circular(effectiveRadius),
// //                           child: Image.file(
// //                             _selectedImage!,
// //                             width: effectiveWidth,
// //                             height: effectiveHeight,
// //                             fit: BoxFit.cover,
// //                           ),
// //                         ),
// //                       ),
// //                       Positioned(
// //                         top: 8,
// //                         right: 8,
// //                         child: GestureDetector(
// //                           onTap: () {
// //                             setState(() {
// //                               _selectedImage = null;
// //                             });
// //                           },
// //                           child: Container(
// //                             padding: EdgeInsets.all(w * .01),
// //                             decoration: BoxDecoration(
// //                               color: Colors.black.withOpacity(0.6),
// //                               shape: BoxShape.circle,
// //                             ),
// //                             child: Icon(
// //                               Icons.close,
// //                               color: AppColors.white,
// //                               size: w * .04,
// //                             ),
// //                           ),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'dart:io';
// import 'dart:math' as math;
// import 'package:nzcu_driver/utilities/app_buttons.dart';
// import 'package:nzcu_driver/utilities/colors.dart';
// import 'package:nzcu_driver/utilities/custom_font.dart';
// import 'package:dotted_border/dotted_border.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// class CustomDocumentUploader extends StatefulWidget {
//   final String? uploadText;
//   final IconData uploadIcon;
//   final double height;
//   final double? width;
//   final Color borderColor;
//   final double borderWidth;
//   final Color backgroundColor;
//   final double borderRadius;
//   final bool isCircular;
//   final Function(File?)? onImageSelected; // Callback for selected image

//   const CustomDocumentUploader({
//     super.key,
//     this.uploadText,
//     this.uploadIcon = Icons.upload,
//     this.height = 200.0,
//     this.width,
//     this.borderColor = const Color(0xFF90A4AE),
//     this.borderWidth = 2.0,
//     this.backgroundColor = const Color(0xFFFAFAFA),
//     this.borderRadius = 8.0,
//     this.isCircular = false,
//     this.onImageSelected,
//   });

//   @override
//   State<CustomDocumentUploader> createState() => _CustomDocumentUploaderState();
// }

// class _CustomDocumentUploaderState extends State<CustomDocumentUploader> {
//   File? _selectedImage;
//   final ImagePicker _picker = ImagePicker();

//   Future<void> _pickImage() async {
//     try {
//       final XFile? picked = await _picker.pickImage(
//         source: ImageSource.gallery,
//         imageQuality: 80,
//       );

//       if (picked != null) {
//         setState(() {
//           _selectedImage = File(picked.path);
//         });

//         // Notify parent widget about the selected image
//         if (widget.onImageSelected != null) {
//           widget.onImageSelected!(_selectedImage);
//         }
//       }
//     } catch (e) {
//       debugPrint('Image picking failed: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to pick image')),
//       );
//     }
//   }

//   void _clearImage() {
//     setState(() {
//       _selectedImage = null;
//     });

//     // Notify parent widget about the cleared image
//     if (widget.onImageSelected != null) {
//       widget.onImageSelected!(null);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     double w = MediaQuery.of(context).size.width;

//     double effectiveWidth = widget.width ?? widget.height;
//     double effectiveHeight = widget.height;
//     double effectiveRadius = widget.borderRadius;

//     if (widget.isCircular) {
//       double side = math.min(effectiveWidth, effectiveHeight);
//       effectiveWidth = side;
//       effectiveHeight = side;
//       effectiveRadius = side / 2;
//     }

//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: w * .03),
//       child: SizedBox(
//         width: effectiveWidth,
//         height: effectiveHeight,
//         child: DottedBorder(
//           options: RoundedRectDottedBorderOptions(
//             radius: Radius.circular(effectiveRadius),
//             color: widget.borderColor,
//             strokeWidth: widget.borderWidth,
//             dashPattern: const [6, 2],
//             padding: EdgeInsets.zero,
//           ),
//           child: Container(
//             decoration: BoxDecoration(
//               color: AppColors.lightGray,
//               borderRadius: BorderRadius.circular(effectiveRadius),
//             ),
//             child: _selectedImage == null
//                 ? Center(
//                     child: AppButtons.solid(
//                       context: context,
//                       text: widget.uploadText ?? "Upload",
//                       onClicked: _pickImage,
//                       prefixIcon: Icon(
//                         Icons.file_upload_outlined,
//                         color: AppColors.white,
//                         size: w * .05,
//                       ),
//                       width: w * .3,
//                       height: w * .1,
//                       backgroundColor: AppColors.black,
//                       textColor: AppColors.white,
//                       fontSize: w * .04,
//                       radius: w * .1,
//                       fontWeight: FontWeight.w500,
//                       padding: EdgeInsets.zero,
//                     ),
//                   )
//                 : Stack(
//                     children: [
//                       Center(
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(effectiveRadius),
//                           child: Image.file(
//                             _selectedImage!,
//                             width: effectiveWidth,
//                             height: effectiveHeight,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       ),
//                       Positioned(
//                         top: 8,
//                         right: 8,
//                         child: GestureDetector(
//                           onTap: _clearImage,
//                           child: Container(
//                             padding: EdgeInsets.all(w * .01),
//                             decoration: BoxDecoration(
//                               color: Colors.black.withOpacity(0.6),
//                               shape: BoxShape.circle,
//                             ),
//                             child: Icon(
//                               Icons.close,
//                               color: AppColors.white,
//                               size: w * .04,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'dart:math' as math;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nzcu_driver/utilities/widgets/app_buttons.dart';
import 'package:nzcu_driver/utilities/colors/colors.dart';
import 'package:nzcu_driver/utilities/widgets/custom_font.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nzcu_driver/utilities/widgets/custom_toast.dart';

class CustomDocumentUploader extends StatefulWidget {
  final String? uploadText;
  final IconData uploadIcon;
  final double height;
  final double? width;
  final Color borderColor;
  final double borderWidth;
  final Color backgroundColor;
  final double borderRadius;
  final bool isCircular;
  final Function(File?)? onImageSelected; // Callback for selected image
  final bool isImageUploaded; // Add this parameter
  final Function()? onClearImage; // Add this callback
  final String? errorText; // Validation error text

  const CustomDocumentUploader({
    super.key,
    this.uploadText,
    this.uploadIcon = Icons.upload,
    this.height = 200.0,
    this.width,
    this.borderColor = const Color(0xFF90A4AE),
    this.borderWidth = 2.0,
    this.backgroundColor = const Color(0xFFFAFAFA),
    this.borderRadius = 8.0,
    this.isCircular = false,
    this.onImageSelected,
    this.isImageUploaded = false, // Default value
    this.onClearImage, // Add this parameter
    this.errorText,
  });

  @override
  State<CustomDocumentUploader> createState() => _CustomDocumentUploaderState();
}

class _CustomDocumentUploaderState extends State<CustomDocumentUploader> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  // This method is called when the widget is first created
  @override
  void initState() {
    super.initState();
    // Initialize with external image state if provided
    _selectedImage = widget.isImageUploaded ? _selectedImage : null;
  }

  // This method is called when the widget is updated
  @override
  void didUpdateWidget(covariant CustomDocumentUploader oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Clear local image if external state says it should be cleared
    if (!widget.isImageUploaded && _selectedImage != null) {
      _selectedImage = null;
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (picked != null) {
        setState(() {
          _selectedImage = File(picked.path);
        });

        // Notify parent widget about the selected image
        if (widget.onImageSelected != null) {
          widget.onImageSelected!(_selectedImage);
        }
      }
    } catch (e) {
      debugPrint('Image picking failed: $e');
      CustomToast.showWarning("Failed to pick image");
    }
  }

  void _clearImage() {
    setState(() {
      _selectedImage = null;
    });

    // Notify parent widget about the cleared image
    if (widget.onImageSelected != null) {
      widget.onImageSelected!(null);
    }

    // Also call the onClearImage callback if provided
    if (widget.onClearImage != null) {
      widget.onClearImage!();
    }
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;

    double effectiveWidth = widget.width ?? widget.height;
    double effectiveHeight = widget.height;
    double effectiveRadius = widget.borderRadius;

    if (widget.isCircular) {
      double side = math.min(effectiveWidth, effectiveHeight);
      effectiveWidth = side;
      effectiveHeight = side;
      effectiveRadius = side / 2;
    }

    // Determine if we should show an image
    bool showImage = _selectedImage != null || widget.isImageUploaded;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: w * .03),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: effectiveWidth,
            height: effectiveHeight,
            child: DottedBorder(
              options: RoundedRectDottedBorderOptions(
                radius: Radius.circular(effectiveRadius),
                color: widget.borderColor,
                strokeWidth: widget.borderWidth,
                dashPattern: const [6, 2],
                padding: EdgeInsets.zero,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.lightGray,
                  borderRadius: BorderRadius.circular(effectiveRadius),
                ),
                child: !showImage
                    ? Center(
                        child: AppButtons.solid(
                          context: context,
                          text: widget.uploadText ?? "Upload",
                          onClicked: _pickImage,
                          prefixIcon: Icon(
                            Icons.file_upload_outlined,
                            color: AppColors.white,
                            size: w * .05,
                          ),
                          width: w * .3,
                          height: w * .1,
                          backgroundColor: AppColors.black,
                          textColor: AppColors.white,
                          fontSize: w * .04,
                          radius: w * .1,
                          fontWeight: FontWeight.w500,
                          padding: EdgeInsets.zero,
                        ),
                      )
                    : Stack(
                        children: [
                          Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                effectiveRadius,
                              ),
                              child: _selectedImage != null
                                  ? Image.file(
                                      _selectedImage!,
                                      width: effectiveWidth,
                                      height: effectiveHeight,
                                      fit: BoxFit.fill,
                                    )
                                  : Container(
                                      width: effectiveWidth,
                                      height: effectiveHeight,
                                      color: AppColors.lightGray,
                                      child: Center(
                                        child: Icon(
                                          Icons.image,
                                          size: w * .1,
                                          color: AppColors.mediumGray,
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: _clearImage,
                              child: Container(
                                padding: EdgeInsets.all(w * .01),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.6),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.close,
                                  color: AppColors.white,
                                  size: w * .04,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
          if (widget.errorText != null && widget.errorText!.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: 8.0, left: 4.0),
              child: Text(
                widget.errorText!,
                style: TextStyle(
                  color: Colors
                      .red, // Or AppColors.primaryRed if available in context
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
