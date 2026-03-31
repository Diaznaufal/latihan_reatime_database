import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/players.dart';

class DetailPlayer extends StatelessWidget {
  static const routeName = "/detail-player";

  @override
  Widget build(BuildContext context) {
    final players = Provider.of<Players>(context, listen: false);
    final playerId = ModalRoute.of(context)!.settings.arguments as String;
    final selectPLayer = players.selectById(playerId);

    final nameController = TextEditingController(text: selectPLayer.name);
    final positionController = TextEditingController(
      text: selectPLayer.position,
    );
    final imageController = TextEditingController(text: selectPLayer.imageUrl);

    return Scaffold(
      appBar: AppBar(title: Text("DETAIL PLAYER")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: MemoryImage(base64Decode(selectPLayer.imageUrl)),
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),

            TextFormField(controller: nameController),
            TextFormField(controller: positionController),
            TextFormField(controller: imageController),

            SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {
                players.editPlayer(
                  playerId,
                  nameController.text,
                  positionController.text,
                  imageController.text,
                  context,
                );
                Navigator.pop(context);
              },
              child: Text("Edit"),
            ),
          ],
        ),
      ),
    );
  }
}
