import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CustomImagePicker extends StatefulWidget {
  const CustomImagePicker({
    super.key,
    required this.maxImages,
    this.buttonText,
    this.buttonTextStyle,
    this.icon,
    this.iconStyle,
    this.imageHeight,
    this.imageWidth,
    this.onImagesChanged,
    this.initialImages,
    required this.allowMultipleSelection,
    this.showImageSize = true,
    this.borderRadius = 8.0,
  });

  final ButtonStyle? iconStyle;
  final int maxImages;
  final String? buttonText;
  final Icon? icon;
  final TextStyle? buttonTextStyle;
  final double? imageHeight;
  final double? imageWidth;
  final Function(List<XFile>)? onImagesChanged;
  final List<XFile>? initialImages;
  final bool allowMultipleSelection;
  final bool showImageSize;
  final double borderRadius;

  @override
  State<CustomImagePicker> createState() => _CustomImagePickerState();
}

class _CustomImagePickerState extends State<CustomImagePicker> {
  final ImagePicker _picker = ImagePicker();
  late List<XFile> _selectedImages;

  @override
  void initState() {
    super.initState();
    _selectedImages = widget.initialImages ?? [];
  }

  Future<void> _pickImage() async {
    if (_selectedImages.length >= widget.maxImages) {
      _showSnackBar(
        "Maximum ${widget.maxImages} images allowed.",
        Colors.black,
      );
      return;
    }

    final source = await showDialog<ImageSource>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Select image source"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, ImageSource.camera),
                child: const Text("Camera"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, ImageSource.gallery),
                child: const Text("Gallery"),
              ),
            ],
          ),
    );

    if (source == null) return;

    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );
      if (image != null) {
        setState(() {
          _selectedImages.add(image);
        });
        widget.onImagesChanged?.call(_selectedImages);
      }
    } catch (e) {
      _showSnackBar("Error picking image: $e", Colors.red);
    }
  }

  Future<void> _pickMultipleImages() async {
    if (!widget.allowMultipleSelection) return;

    final remainingSlots = widget.maxImages - _selectedImages.length;

    if (remainingSlots <= 0) {
      _showSnackBar(
        "Maximum ${widget.maxImages} images allowed.",
        Colors.orange,
      );
      return;
    }

    try {
      final List<XFile> images = await _picker.pickMultiImage(imageQuality: 80);

      if (images.isNotEmpty) {
        final imagesToAdd = images.take(remainingSlots).toList();

        setState(() {
          _selectedImages.addAll(imagesToAdd);
        });

        if (images.length > remainingSlots) {
          _showSnackBar(
            "Only ${imagesToAdd.length} images added. Maximum ${widget.maxImages} allowed.",
            Colors.orange,
          );
        }

        widget.onImagesChanged?.call(_selectedImages);
      }
    } catch (e) {
      _showSnackBar("Error picking images: $e", Colors.red);
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
    widget.onImagesChanged?.call(_selectedImages);
  }

  void _showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: backgroundColor),
    );
  }

  String _getFileName(String path) =>
      path.split("/").last.replaceFirst("scaled_", "");

  String _formatSize(int bytes) {
    if (bytes < 1024) return "$bytes B";
    if (bytes < 1024 * 1024) return "${(bytes / 1024).toStringAsFixed(1)} KB";
    return "${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Upload buttons
        if (!widget.allowMultipleSelection)
          TextButton.icon(
            icon: widget.icon ?? const Icon(Icons.photo),
            onPressed: _pickImage,
            style:
                widget.iconStyle ??
                TextButton.styleFrom(
                  foregroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
            label: Text(
              widget.buttonText ?? "Upload Image",
              style:
                  widget.buttonTextStyle ??
                  const TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
            ),
          ),

        if (widget.allowMultipleSelection)
          TextButton.icon(
            icon: const Icon(Icons.photo_library),
            onPressed: _pickMultipleImages,
            style:
                widget.iconStyle ??
                TextButton.styleFrom(
                  foregroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
            label: Text(
              widget.buttonText ?? "Upload  Images",
              style:
                  widget.buttonTextStyle ??
                  const TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
            ),
          ),

        Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: Text(
            "${_selectedImages.length}/${widget.maxImages} images selected",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        if (_selectedImages.isEmpty)
          Column(
            children: [
              const SizedBox(height: 10),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.photo_library_outlined,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "No images selected",
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _selectedImages.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final file = File(_selectedImages[index].path);
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 0,
                  vertical: 4,
                ),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  child: Image.file(
                    file,
                    height: widget.imageHeight ?? 50,
                    width: widget.imageWidth ?? 50,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (_, __, ___) => Container(
                          height: widget.imageHeight ?? 50,
                          width: widget.imageWidth ?? 50,
                          color: Colors.grey[300],
                          child: Icon(
                            Icons.error_outline,
                            color: Colors.grey[600],
                          ),
                        ),
                  ),
                ),
                title: Text(
                  _getFileName(file.path),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14),
                ),
                subtitle:
                    widget.showImageSize
                        ? FutureBuilder<int>(
                          future: file.length(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Text(
                                _formatSize(snapshot.data!),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        )
                        : null,
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => _removeImage(index),
                  tooltip: 'Remove image',
                ),
              );
            },
          ),
      ],
    );
  }
}




// / File: lib/widgets/custom_image_picker.dart

// class CustomImagePicker1 extends StatefulWidget {
//   const CustomImagePicker1({
//     super.key,
//     required this.maxImages,
//     this.buttonText,
//     this.buttonTextStyle,
//     this.icon,
//     this.iconStyle,
//     this.imageHeight,
//     this.imageWidth,
//     this.onImagesChanged,
//     this.initialImages,
//     this.allowMultipleSelection = true,
//     this.showImageSize = true,
//     this.borderRadius = 8.0,
//   });

//   final ButtonStyle? iconStyle;
//   final int maxImages;
//   final String? buttonText;
//   final Icon? icon;
//   final TextStyle? buttonTextStyle;
//   final double? imageHeight;
//   final double? imageWidth;
//   final Function(List<XFile>)? onImagesChanged;
//   final List<XFile>? initialImages;
//   final bool allowMultipleSelection;
//   final bool showImageSize;
//   final double borderRadius;

//   @override
//   State<CustomImagePicker1> createState() => _CustomImagePicker1State();
// }

// class _CustomImagePicker1State extends State<CustomImagePicker1> {
//   final ImagePicker _picker = ImagePicker();
//   late List<XFile> _selectedImages;

//   @override
//   void initState() {
//     super.initState();
//     _selectedImages = widget.initialImages ?? [];
//   }

//   Future<void> _pickImage() async {
//     if (_selectedImages.length >= widget.maxImages) {
//       _showSnackBar(
//         "Maximum ${widget.maxImages} images allowed.",
//         Colors.orange,
//       );
//       return;
//     }

//     try {
//       final XFile? image = await _picker.pickImage(
//         source: ImageSource.gallery,
//         imageQuality: 80,
//       );

//       if (image != null) {
//         setState(() {
//           _selectedImages.add(image);
//         });
//         widget.onImagesChanged?.call(_selectedImages);
//       }
//     } catch (e) {
//       _showSnackBar("Error picking image: $e", Colors.red);
//     }
//   }

//   Future<void> _pickMultipleImages() async {
//     if (!widget.allowMultipleSelection) return;

//     final remainingSlots = widget.maxImages - _selectedImages.length;

//     if (remainingSlots <= 0) {
//       _showSnackBar(
//         "Maximum ${widget.maxImages} images allowed.",
//         Colors.orange,
//       );
//       return;
//     }

//     try {
//       final List<XFile> images = await _picker.pickMultiImage(imageQuality: 80);

//       if (images.isNotEmpty) {
//         final imagesToAdd = images.take(remainingSlots).toList();

//         setState(() {
//           _selectedImages.addAll(imagesToAdd);
//         });

//         if (images.length > remainingSlots) {
//           _showSnackBar(
//             "Only ${imagesToAdd.length} images added. Maximum ${widget.maxImages} allowed.",
//             Colors.orange,
//           );
//         }

//         widget.onImagesChanged?.call(_selectedImages);
//       }
//     } catch (e) {
//       _showSnackBar("Error picking images: $e", Colors.red);
//     }
//   }

//   void _removeImage(int index) {
//     setState(() {
//       _selectedImages.removeAt(index);
//     });
//     widget.onImagesChanged?.call(_selectedImages);
//   }

//   void _showSnackBar(String message, Color backgroundColor) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message), backgroundColor: backgroundColor),
//     );
//   }

//   String _getFileName(String path) {
//     return path.split("/").last;
//   }

//   // Public method to get selected images
//   List<XFile> getSelectedImages() {
//     return List.from(_selectedImages);
//   }

//   // Public method to clear all images
//   void clearImages() {
//     setState(() {
//       _selectedImages.clear();
//     });
//     widget.onImagesChanged?.call(_selectedImages);
//   }

//   // Public method to add images programmatically
//   void addImages(List<XFile> images) {
//     final remainingSlots = widget.maxImages - _selectedImages.length;
//     final imagesToAdd = images.take(remainingSlots).toList();

//     setState(() {
//       _selectedImages.addAll(imagesToAdd);
//     });
//     widget.onImagesChanged?.call(_selectedImages);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Button row
//         Row(
//           children: [
//             TextButton.icon(
//               icon: widget.icon ?? Icon(Icons.photo),
//               onPressed: _pickImage,
//               style:
//                   widget.iconStyle ??
//                   TextButton.styleFrom(
//                     foregroundColor: Colors.blue,
//                     padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                   ),
//               label: Text(
//                 widget.buttonText ?? "Upload Images",
//                 style:
//                     widget.buttonTextStyle ??
//                     TextStyle(
//                       color: Colors.blue,
//                       fontSize: 16,
//                       fontWeight: FontWeight.w400,
//                     ),
//               ),
//             ),
//             if (widget.allowMultipleSelection) ...[
//               SizedBox(width: 10),
//               TextButton.icon(
//                 icon: Icon(Icons.photo_library),
//                 onPressed: _pickMultipleImages,
//                 style:
//                     widget.iconStyle ??
//                     TextButton.styleFrom(
//                       foregroundColor: Colors.blue,
//                       padding: EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 12,
//                       ),
//                     ),
//                 label: Text(
//                   "Multiple",
//                   style:
//                       widget.buttonTextStyle ??
//                       TextStyle(
//                         color: Colors.blue,
//                         fontSize: 16,
//                         fontWeight: FontWeight.w400,
//                       ),
//                 ),
//               ),
//             ],
//           ],
//         ),

//         // Counter
//         Padding(
//           padding: const EdgeInsets.symmetric(vertical: 8.0),
//           child: Text(
//             "${_selectedImages.length}/${widget.maxImages} images selected",
//             style: TextStyle(
//               fontSize: 14,
//               color: Colors.grey[600],
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ),

//         // Images list
//         Expanded(
//           child:
//               _selectedImages.isEmpty
//                   ? Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(
//                           Icons.photo_library_outlined,
//                           size: 64,
//                           color: Colors.grey[400],
//                         ),
//                         SizedBox(height: 16),
//                         Text(
//                           "No images selected",
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: Colors.grey[600],
//                           ),
//                         ),
//                       ],
//                     ),
//                   )
//                   : ListView.separated(
//                     itemCount: _selectedImages.length,
//                     separatorBuilder: (context, index) => Divider(height: 1),
//                     itemBuilder: (context, index) {
//                       return ListTile(
//                         contentPadding: EdgeInsets.symmetric(
//                           horizontal: 0,
//                           vertical: 4,
//                         ),
//                         leading: ClipRRect(
//                           borderRadius: BorderRadius.circular(
//                             widget.borderRadius,
//                           ),
//                           child: Image.file(
//                             File(_selectedImages[index].path),
//                             height: widget.imageHeight ?? 50,
//                             width: widget.imageWidth ?? 50,
//                             fit: BoxFit.cover,
//                             errorBuilder: (context, error, stackTrace) {
//                               return Container(
//                                 height: widget.imageHeight ?? 50,
//                                 width: widget.imageWidth ?? 50,
//                                 color: Colors.grey[300],
//                                 child: Icon(
//                                   Icons.error_outline,
//                                   color: Colors.grey[600],
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                         title: Text(
//                           _getFileName(_selectedImages[index].path),
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                           style: TextStyle(fontSize: 14),
//                         ),
//                         subtitle:
//                             widget.showImageSize
//                                 ? FutureBuilder<int>(
//                                   future:
//                                       File(
//                                         _selectedImages[index].path,
//                                       ).length(),
//                                   builder: (context, snapshot) {
//                                     if (snapshot.hasData) {
//                                       final sizeInKB =
//                                           (snapshot.data! / 1024).round();
//                                       return Text(
//                                         "${sizeInKB}KB",
//                                         style: TextStyle(
//                                           fontSize: 12,
//                                           color: Colors.grey[600],
//                                         ),
//                                       );
//                                     }
//                                     return SizedBox.shrink();
//                                   },
//                                 )
//                                 : null,
//                         trailing: IconButton(
//                           icon: Icon(Icons.delete_outline, color: Colors.red),
//                           onPressed: () => _removeImage(index),
//                           tooltip: 'Remove image',
//                         ),
//                       );
//                     },
//                   ),
//         ),
//       ],
//     );
//   }
// }

///chaiyeko
// class CustomImagePicker extends StatefulWidget {
//   const CustomImagePicker({
//     super.key,
//     required this.maxImages,
//     this.buttonText,
//     this.buttonTextStyle,
//     this.icon,
//     this.iconStyle,
//     this.imageHeight,
//     this.imageWidth,
//   });
//   final ButtonStyle? iconStyle;
//   final int maxImages;
//   final String? buttonText;
//   final Icon? icon;
//   final TextStyle? buttonTextStyle;
//   final double? imageHeight;
//   final double? imageWidth;
//   @override
//   State<CustomImagePicker1> createState() => _CustomImagePicker1State();
// }

// class _CustomImagePickerState extends State<CustomImagePicker1> {
//   final ImagePicker _picker = ImagePicker();
//   final List<XFile> _selectedImages = [];
//   Future<void> _pickImage() async {
//     if (_selectedImages.length >= widget.maxImages) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Maximum ${widget.maxImages} images allowed.")),
//       );
//       return;
//     }
//     try {
//       final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
//       if (image != null) {
//         setState(() {
//           _selectedImages.add(image);
//         });
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Error Picking image $e")));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         TextButton.icon(
//           icon: widget.icon ?? Icon(Icons.photo),
//           onPressed: _pickImage,
//           style:
//               widget.iconStyle ??
//               ElevatedButton.styleFrom(
//                 iconColor: Colors.blue,
//                 padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
//               ),
//           label: Text(
//             widget.buttonText ?? "Upload Images",
//             style:
//                 widget.buttonTextStyle ??
//                 TextStyle(
//                   color: Colors.blue,
//                   fontSize: 20,
//                   fontWeight: FontWeight.w400,
//                 ),
//           ),
//         ),
//         SizedBox(height: 20),
//         Expanded(
//           child: ListView.builder(
//             itemCount: _selectedImages.length,
//             itemBuilder: (context, index) {
//               return Column(
//                 children: [
//                   ListTile(
//                     leading: Image.file(
//                       File(_selectedImages[index].path),
//                       height: widget.imageHeight ?? 40,
//                       width: widget.imageWidth ?? 40,
//                       fit: BoxFit.cover,
//                     ),
//                     title: Flexible(
//                       child: Text(
//                         _selectedImages[index].path.split("/").last.toString(),
//                         maxLines: 2,
//                       ),
//                     ),
//                     trailing: IconButton(
//                       icon: Icon(Icons.delete),
//                       onPressed: () {
//                         setState(() {
//                           _selectedImages.removeAt(index);
//                         });
//                       },
//                     ),
//                   ),
//                   if (index < _selectedImages.length - 1) Divider(),
//                 ],
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }

// class ImagePickerScreen extends StatelessWidget {
//   const ImagePickerScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Image Picker')),
//       body: CustomImagePicker(maxImages: 5, buttonText: "upload image"),
//     );
//   }
// }

// class CustomImagePicker extends StatefulWidget {
//   const CustomImagePicker({super.key,required this.maxImages, required this.buttonText});
//   final maxImages;
//   final buttonText;
//   @override
//   State<CustomImagePicker> createState() => _CustomImagePickerState();
// }

// class _CustomImagePickerState extends State<CustomImagePicker> {
  

//   @override
//   Widget build(BuildContext context) {
//     return 
//   }
// }
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Image Picker Demo',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: ImagePickerScreen(),
//     );
//   }
// }

// class ImagePickerScreen extends StatefulWidget {
//   const ImagePickerScreen({super.key});

//   @override
//   State<ImagePickerScreen> createState() => _ImagePickerScreenState();
// }

// class _ImagePickerScreenState extends State<ImagePickerScreen> {
//   final ImagePicker _picker = ImagePicker();
//   final List<XFile> _selectedImages = [];

//   Future<void> _pickImage(ImageSource source) async {
//     try {
//       final XFile? image = await _picker.pickImage(source: source);
//       if (image != null) {
//         setState(() {
//           _selectedImages.add(image);
//         });
//       }
//     } catch (e) {
//       print("Error picking image: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Image Picker')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             // Upload Buttons
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 ElevatedButton.icon(
//                   onPressed: () => _pickImage(ImageSource.camera),
//                   icon: Icon(Icons.camera_alt),
//                   label: Text('Camera'),
//                 ),
//                 ElevatedButton.icon(
//                   onPressed: () => _pickImage(ImageSource.gallery),
//                   icon: Icon(Icons.photo_library),
//                   label: Text('Gallery'),
//                 ),
//               ],
//             ),
//             SizedBox(height: 20),

//             // Display selected images
//             Expanded(
//               child: ListView.builder(
//                 itemCount: _selectedImages.length,
//                 itemBuilder: (context, index) {
//                   return Column(
//                     children: [
//                       ListTile(
//                         title: Text(
//                           _selectedImages[index].path.split('/').last,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         leading: Image.file(
//                           File(_selectedImages[index].path),
//                           width: 50,
//                           height: 50,
//                           fit: BoxFit.cover,
//                         ),
//                         trailing: IconButton(
//                           icon: Icon(Icons.delete),
//                           onPressed: () {
//                             setState(() {
//                               _selectedImages.removeAt(index);
//                             });
//                           },
//                         ),
//                       ),
//                       if (index < _selectedImages.length - 1) Divider(),
//                     ],
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

//for both camera and gallery options.
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Image Picker Demo',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: ImagePickerScreen(),
//     );
//   }
// }

// class ImagePickerScreen extends StatefulWidget {
//   const ImagePickerScreen({super.key});

//   @override
//   State<ImagePickerScreen> createState() => _ImagePickerScreenState();
// }

// class _ImagePickerScreenState extends State<ImagePickerScreen> {
//   final ImagePicker _picker = ImagePicker();
//   final List<XFile> _selectedImages = [];

//   Future<void> _pickImage(ImageSource source) async {
//     try {
//       final XFile? image = await _picker.pickImage(source: source);
//       if (image != null) {
//         setState(() {
//           _selectedImages.add(image);
//         });
//       }
//     } catch (e) {
//       print("Error picking image: $e");
//     }
//   }

//   void _showImageSourceActionSheet() {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return SafeArea(
//           child: Wrap(
//             children: [
//               ListTile(
//                 leading: Icon(Icons.camera_alt),
//                 title: Text('Camera'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _pickImage(ImageSource.camera);
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.photo_library),
//                 title: Text('Gallery'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _pickImage(ImageSource.gallery);
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Image Picker')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             // Upload Button
//             TextButton.icon(
//               icon: Icon(Icons.photo),
//               onPressed: _showImageSourceActionSheet,
//               style: TextButton.styleFrom(
//                 padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
//                 backgroundColor: Colors.blue.shade50,
//               ),
//               label: Text('Upload Image'),
//             ),
//             SizedBox(height: 20),

//             // Display selected image thumbnails and filenames
//             Expanded(
//               child: ListView.builder(
//                 itemCount: _selectedImages.length,
//                 itemBuilder: (context, index) {
//                   return Column(
//                     children: [
//                       ListTile(
//                         leading: Image.file(
//                           File(_selectedImages[index].path),
//                           width: 50,
//                           height: 50,
//                           fit: BoxFit.cover,
//                         ),
//                         title: Text(
//                           _selectedImages[index].path.split('/').last,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         trailing: IconButton(
//                           icon: Icon(Icons.delete),
//                           onPressed: () {
//                             setState(() {
//                               _selectedImages.removeAt(index);
//                             });
//                           },
//                         ),
//                       ),
//                       if (index < _selectedImages.length - 1) Divider(),
//                     ],
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }





// class CustomImagePicker extends StatefulWidget {
//   final Function(List<XFile>)? onImagesChanged;
//   final String buttonText;
//   final int? maxImages;

//   const CustomImagePicker({
//     super.key,
//      this.onImagesChanged,
//     this.buttonText = 'Upload Image',
//     this.maxImages,
//   });

//   @override
//   State<CustomImagePicker> createState() => _CustomImagePickerState();
// }

// class _CustomImagePickerState extends State<CustomImagePicker> {
//   final ImagePicker _picker = ImagePicker();
//   final List<XFile> _selectedImages = [];


//   Future<void> _pickImage() async {
//     try {
//       final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
//       if (image != null) {
//         if (widget.maxImages != null && _selectedImages.length >= widget.maxImages!) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text("Maximum ${widget.maxImages} images allowed.")),
//           );
//           return;
//         }
//         setState(() {
//           _selectedImages.add(image);
//         });
//         widget.onImagesChanged(_selectedImages);
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error picking image: $e")),
//       );
//     }
//   }

//   void _removeImage(int index) {
//     setState(() {
//       _selectedImages.removeAt(index);
//     });
//     widget.onImagesChanged(_selectedImages);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         TextButton.icon(
//           icon: Icon(Icons.photo),
//           onPressed: _pickImage,
//           style: TextButton.styleFrom(
//             padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
//           ),
//           label: Text(widget.buttonText),
//         ),
//         SizedBox(height: 16),
//         if (_selectedImages.isNotEmpty)
//           Expanded(
//             child: ListView.builder(
//               itemCount: _selectedImages.length,
//               itemBuilder: (context, index) {
//                 return Column(
//                   children: [
//                     ListTile(
//                       leading: Image.file(
//                         File(_selectedImages[index].path),
//                         height: 40,
//                         width: 40,
//                         fit: BoxFit.cover,
//                       ),
//                       title: Flexible(
//                         child: Text(
//                           _selectedImages[index].path.split("/").last,
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                       trailing: IconButton(
//                         icon: Icon(Icons.delete),
//                         onPressed: () => _removeImage(index),
//                       ),
//                     ),
//                     if (index < _selectedImages.length - 1) Divider(),
//                   ],
//                 );
//               },
//             ),
//           ),
//       ],
//     );
//   }
// }
