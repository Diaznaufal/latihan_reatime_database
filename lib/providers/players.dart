import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/player.dart';
import 'package:http/http.dart' as http;

class Players with ChangeNotifier {
  List<Player> _allPlayer = [];
  bool isLoading = false; // ✅ tambahan

  List<Player> get allPlayer => _allPlayer;

  int get jumlahPlayer => _allPlayer.length;

  Player selectById(String id) =>
      _allPlayer.firstWhere((element) => element.id == id);

  // ✅ ADD PLAYER
  Future<void> addPlayer(
    String name,
    String position,
    String image,
    BuildContext context,
  ) {
    DateTime datetimeNow = DateTime.now();

    Uri url = Uri.parse(
      "https://latihan-realtime-databas-ddb21-default-rtdb.firebaseio.com/karyawan.json",
    );

    return http
        .post(
          url,
          body: jsonEncode({
            "name": name,
            "position": position,
            "imageUrl": image,
            "createdAt": datetimeNow.toString(),
          }),
        )
        .then((response) {
          _allPlayer.add(
            Player(
              id: jsonDecode(response.body)["name"].toString(),
              name: name,
              position: position,
              imageUrl: image,
              createdAt: datetimeNow,
            ),
          );

          notifyListeners();
        });
  }

  // ✅ EDIT PLAYER
  Future<void> editPlayer(
    String id,
    String name,
    String position,
    String image,
    BuildContext context,
  ) {
    Uri url = Uri.parse(
      "https://latihan-realtime-databas-ddb21-default-rtdb.firebaseio.com/karyawan/$id.json",
    );

    return http
        .patch(
          url,
          body: jsonEncode({
            "name": name,
            "position": position,
            "imageUrl": image,
          }),
        )
        .then((response) {
          Player selectPlayer = _allPlayer.firstWhere(
            (element) => element.id == id,
          );

          selectPlayer.name = name;
          selectPlayer.position = position;
          selectPlayer.imageUrl = image;

          notifyListeners();
        });
  }

  // ✅ DELETE PLAYER
  Future<void> deletePlayer(String id) {
    Uri url = Uri.parse(
      "https://latihan-realtime-databas-ddb21-default-rtdb.firebaseio.com/karyawan/$id.json",
    );

    return http.delete(url).then((response) {
      _allPlayer.removeWhere((element) => element.id == id);
      notifyListeners();
    });
  }

  // ✅ INITIAL LOAD DATA (FIXED + LOADING)
  Future<void> initialData() async {
    isLoading = true;
    notifyListeners();

    Uri url = Uri.parse(
      "https://latihan-realtime-databas-ddb21-default-rtdb.firebaseio.com/karyawan.json",
    );

    _allPlayer.clear();

    var hasilData = await http.get(url);

    if (hasilData.body != "null") {
      var dataRespon = jsonDecode(hasilData.body) as Map<String, dynamic>;

      dataRespon.forEach((key, value) {
        _allPlayer.add(
          Player(
            position: value["position"],
            id: key,
            imageUrl: value["imageUrl"],
            name: value["name"],
            createdAt: DateFormat(
              "yyyy-MM-dd HH:mm:ss",
            ).parse(value["createdAt"]),
          ),
        );
      });
    }

    isLoading = false;
    notifyListeners();
  }
}
