import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../gobal/drawerbar_nisit.dart';

class HistoryNisit extends StatefulWidget {
  const HistoryNisit({super.key});

  @override
  State<HistoryNisit> createState() => _HistoryNisitState();
}

class _HistoryNisitState extends State<HistoryNisit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('History_class_nisit_Screen'),
        ),
        drawer: const DrawerBarNisit());
  }
}
