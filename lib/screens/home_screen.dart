import 'package:flutter/material.dart';


class HomeScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;

  const HomeScreen({super.key, required this.onToggleTheme});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String firstName = 'Jaffar';
  final String lastName = 'Raza';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSearching = false;

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
          child: IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {},
          ),
        ),
        actions: [
          IconButton(
            icon: isDark? Icon(Icons.light_mode_rounded) : Icon(Icons.dark_mode_rounded),
            onPressed: widget.onToggleTheme,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 12, 0),
            child: IconButton(
                onPressed: () {},
                icon: Icon(isSearching ? Icons.close : Icons.search)
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(12, 8, 0, 8),
                child: Text('What\'s up, $firstName!', style: TextStyle(fontSize: 30),),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(12, 8, 0, 8),
                child: Container(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text('Category ${index + 1}'),
                          selected: index == 0,
                          onSelected: (selected) {},
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          selectedColor: Theme.of(context).colorScheme.secondary,
                          side: BorderSide.none,
                        ),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}