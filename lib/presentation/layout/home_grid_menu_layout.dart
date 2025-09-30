import 'package:flutter/material.dart';

class HomeGridMenuLayout<T extends Object> extends StatelessWidget {
  final List<T> items;
  final void Function(T item) onTap;
  final Widget Function(T item) itemBuilderChild;
  const HomeGridMenuLayout({super.key, required this.items, required this.onTap, required this.itemBuilderChild});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return GestureDetector(onTap: () => onTap.call(item), child: itemBuilderChild.call(item));
      },
    );
  }
}
