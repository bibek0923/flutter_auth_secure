import 'package:flutter/material.dart';
import 'package:try_app/image_picker_widget.dart';

class Screen1 extends StatelessWidget {
  const Screen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text("Screen 1"),
          CustomImagePicker(maxImages: 10, allowMultipleSelection: true),
          // ElevatedButton(onPressed: () {}, child: Text("Next Button")),
          SizedBox(height: 10),
          Text("JJIiiijijikji"),
        ],
      ),
    );
  }
}
