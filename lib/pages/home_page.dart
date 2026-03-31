import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:convert'; // 🔥 TAMBAHAN INI

import '../pages/detail_player_page.dart';
import '../pages/add_player_page.dart';
import '../providers/players.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      Provider.of<Players>(context, listen: false).initialData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final allPlayerProvider = Provider.of<Players>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ALL PLAYERS",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF0075FC),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () async {
              await Navigator.pushNamed(context, AddPlayer.routeName);
              Provider.of<Players>(context, listen: false).initialData();
            },
          ),
        ],
      ),

      body: RefreshIndicator(
        onRefresh: () {
          return Provider.of<Players>(context, listen: false).initialData();
        },
        child: Builder(
          builder: (context) {
            if (allPlayerProvider.isLoading) {
              return ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(backgroundColor: Colors.grey[300]),
                    title: Container(
                      height: 12,
                      width: double.infinity,
                      color: Colors.grey[300],
                    ),
                    subtitle: Container(
                      height: 10,
                      width: 150,
                      margin: EdgeInsets.only(top: 8),
                      color: Colors.grey[200],
                    ),
                  );
                },
              );
            }

            if (allPlayerProvider.allPlayer.isEmpty) {
              return ListView(
                physics: AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(height: 150),
                  Icon(Icons.people, size: 80, color: Colors.grey),
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      "Belum ada data",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        await Navigator.pushNamed(context, AddPlayer.routeName);
                        Provider.of<Players>(
                          context,
                          listen: false,
                        ).initialData();
                      },
                      child: Text("Tambah Player"),
                    ),
                  ),
                ],
              );
            }

            return ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: allPlayerProvider.jumlahPlayer,
              itemBuilder: (context, index) {
                var player = allPlayerProvider.allPlayer[index];
                var id = player.id;

                return ListTile(
                  onTap: () async {
                    await Navigator.pushNamed(
                      context,
                      DetailPlayer.routeName,
                      arguments: id,
                    );

                    Provider.of<Players>(context, listen: false).initialData();
                  },

                  // 🔥 HANYA INI YANG DIUBAH
                  leading: CircleAvatar(
                    backgroundImage:
                        MemoryImage(base64Decode(player.imageUrl))
                            as ImageProvider,
                  ),

                  title: Text(player.name),
                  subtitle: Text(DateFormat.yMMMMd().format(player.createdAt)),

                  trailing: IconButton(
                    onPressed: () {
                      allPlayerProvider.deletePlayer(id).then((value) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Berhasil dihapus"),
                            duration: Duration(milliseconds: 500),
                          ),
                        );
                      });
                    },
                    icon: Icon(Icons.delete),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
