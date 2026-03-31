import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../providers/players.dart';

class AddPlayer extends StatefulWidget {
  static const routeName = "/add-player";

  @override
  State<AddPlayer> createState() => _AddPlayerState();
}

class _AddPlayerState extends State<AddPlayer> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController positionController = TextEditingController();

  File? pickedImage;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        pickedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final players = Provider.of<Players>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ADD PLAYER",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF0075FC),
        actions: [
          IconButton(
            icon: Icon(Icons.save, color: Colors.white),
            onPressed: () async {
              if (pickedImage == null) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text("Pilih gambar dulu")));
                return;
              }

              final bytes = await pickedImage!.readAsBytes();
              final base64Image = base64Encode(bytes);

              await players.addPlayer(
                nameController.text,
                positionController.text,
                base64Image,
                context,
              );

              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("Berhasil ditambahkan")));

              Navigator.pop(context);
            },
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            SizedBox(height: 20),

            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: pickedImage != null
                        ? FileImage(pickedImage!)
                        : null,
                    child: pickedImage == null
                        ? Icon(Icons.person, size: 70, color: Colors.grey[700])
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: pickImage,
                      child: CircleAvatar(
                        radius: 22,
                        backgroundColor: Color(0xFF0075FC),
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 30),

            TextFormField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Nama"),
            ),

            SizedBox(height: 10),

            TextFormField(
              controller: positionController,
              decoration: InputDecoration(labelText: "Posisi"),
            ),

            SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (pickedImage == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Pilih gambar dulu")),
                    );
                    return;
                  }

                  final bytes = await pickedImage!.readAsBytes();
                  final base64Image = base64Encode(bytes);

                  await players.addPlayer(
                    nameController.text,
                    positionController.text,
                    base64Image,
                    context,
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Berhasil ditambahkan")),
                  );

                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF0075FC),
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text(
                  "Submit",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
