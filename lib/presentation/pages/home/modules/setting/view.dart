import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:money_pilot/core/route/config.dart';

class HomeSetting extends StatelessWidget {
  const HomeSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.category_rounded),
            ),
            title: const Text('Category'),
            subtitle:
                const Text('Create, update, delete transaction category.'),
            onTap: () => context.push(Routes.categoryManage),
          ),
          const Divider(),

          // debug,
          ListTile(
            title: Text('Delete all categories'),
            onTap: () => {},
          ),
        ],
      ),
    );
  }
}
