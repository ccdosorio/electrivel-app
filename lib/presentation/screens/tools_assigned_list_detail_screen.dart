import 'package:electrivel_app/presentation/presentation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ToolsAssignedListDetail extends HookConsumerWidget {
  const ToolsAssignedListDetail({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final toolsAssigned = ref.watch(toolsAssignedSelected);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text('Detalle del Kit #${toolsAssigned.id}')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                'Herramientas',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            // -------------------
            const SizedBox(height: 15),
            Expanded(
              child: ListView.builder(
                itemCount: toolsAssigned.tools.length,
                itemBuilder: (context, index) {
                  final tool = toolsAssigned.tools[index];
                  return ToolItemCard(tool: tool);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
