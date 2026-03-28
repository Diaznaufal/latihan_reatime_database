import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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

    // 🔥 load pertama
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

              // 🔥 refresh setelah kembali dari add page
              Provider.of<Players>(context, listen: false).initialData();
            },
          ),
        ],
      ),

      // 🔥 SWIPE TO REFRESH
      body: RefreshIndicator(
        onRefresh: () async {
          await Provider.of<Players>(context, listen: false).initialData();
        },
        child: ListView.builder(
          physics:
              const AlwaysScrollableScrollPhysics(), // 🔥 WAJIB biar bisa swipe walau kosong
          itemCount: allPlayerProvider.jumlahPlayer == 0
              ? 5
              : allPlayerProvider.jumlahPlayer,
          itemBuilder: (context, index) {
            // 🔥 skeleton loading
            if (allPlayerProvider.jumlahPlayer == 0) {
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
            }

            var player = allPlayerProvider.allPlayer[index];
            var id = player.id;

            return ListTile(
              onTap: () async {
                await Navigator.pushNamed(
                  context,
                  DetailPlayer.routeName,
                  arguments: id,
                );

                // 🔥 refresh setelah edit
                Provider.of<Players>(context, listen: false).initialData();
              },
              leading: CircleAvatar(
                backgroundImage: NetworkImage(player.imageUrl),
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
        ),
      ),
    );
  }
}
