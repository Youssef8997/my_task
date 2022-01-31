import 'package:flutter/material.dart';

class GamePointer extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          child: Column(
            children: [
              ExpansionTile(
                title: const Text("jokar",),
              ),
              ExpansionTile(
                title: Text("jokar"),
              ),
              ExpansionTile(
                title: Text("jokar"),
              ),
              ExpansionTile(
                title: Text("jokar"),
              ),
            ],
          ),

      ),
    );
  }
}
