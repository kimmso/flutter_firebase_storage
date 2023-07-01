import 'package:flutter/material.dart';
import 'package:flutter_firebase_storage/src/controller/app_controller.dart';
import 'package:get/get.dart';

class App extends GetView<AppController> {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: controller.pickImage, icon: const Icon(Icons.image)),
          IconButton(
              onPressed: controller.upload, icon: const Icon(Icons.send)),
        ],
      ),
      body: Obx(
        () => Column(
          children: [
            _pickImage(),
            _showImages(),
          ],
        ),
      ),
    );
  }

  Widget _pickImage() {
    return Container(
        width: Get.size.width,
        height: Get.size.width,
        color: Colors.grey,
        child: (controller.pickedImage == null)
            ? const Icon(
                Icons.image_not_supported,
                size: 70,
                color: Colors.white,
              )
            : Image.file(controller.pickedImage!, fit: BoxFit.cover));
  }

  Widget _showImages() {
    return Expanded(
      child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
          ),
          itemCount: controller.images.length,
          itemBuilder: (context, index) {
            final url = controller.images[index];
            return Image.network(url, fit: BoxFit.cover);
          }),
    );
  }
}
