import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:try_app/country_picker.dart';
import 'package:try_app/image_picker_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<XFile> licenseImages = [];
  List<XFile> citizenshipImages = [];
  void _submit() {
    for (var image in citizenshipImages) {
      print("Citizenship image: ${image.path}");
    }
    for (var image in licenseImages) {
      print("License image: ${image.path}");
    }
  }

  void _citizenshipImageChanged(List<XFile> images) {
    citizenshipImages = images;
  }

  void _licenseImageChanged(List<XFile> images) {
    licenseImages = images;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Title(color: Colors.blue, child: Text("image picker")),
      ),
      body: Column(
        children: [
          // Text("Homepage"),
          // CustomImagePicker(
          //   onImagesChanged: _citizenshipImageChanged,
          //   maxImages: 2,
          //   allowMultipleSelection: false,
          //   buttonText: "Upload your citizenship",
          // ),
          // SizedBox(height: 20),

          // SizedBox(height: 10),
          // CustomImagePicker(
          //   onImagesChanged: _licenseImageChanged,
          //   maxImages: 2,
          //   allowMultipleSelection: true,
          //   buttonText: "Upload License",
          // ),
          // ElevatedButton(onPressed: _submit, child: Text("Submit")),
          Row(
            children: [
              CountryPicker(),
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(hintText: "yooooo",border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black),borderRadius: BorderRadius.all(Radius.circular(5)))),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
