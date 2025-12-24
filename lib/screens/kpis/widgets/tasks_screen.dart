import 'package:company_portal/utils/export_import.dart';
import 'package:flutter/material.dart';

class TimelineScreen extends StatelessWidget {
  final List<TimelineItem> items;
  final VoidCallback onItemChanged;

  const TimelineScreen(
      {required this.items, required this.onItemChanged, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Your Tasks",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 5,
          ),
          Expanded(
            child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Column(
                    children: [
                      // _TimelineDot(
                      //     isCompleted: item.isCompleted,
                      //     isLast: index == items.length - 1),
                      _TimelineCard(
                        item: item,
                        onItemChanged: onItemChanged,
                      ),
                      const SizedBox(height: 8)
                    ],
                  );
                }),
          ),
        ],
      ),
    );
  }
}

class _TimelineDot extends StatelessWidget {
  final bool isCompleted;
  final bool isLast;

  const _TimelineDot({
    required this.isCompleted,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 5, right: 5),
          padding: const EdgeInsets.all(5),
          // decoration: const BoxDecoration(
          //   color: Color(0xFFFF8A00),
          //   // shape: BoxShape.circle,
          // ),
          child: const Icon(
            Icons.circle_outlined,
            size: 13,
            color: Color(0xFFFF8A00),
          ),
        ),
        if (!isLast)
          Container(
            width: 2,
            height: 100,
            color: const Color(0xFFFF8A00),
          ),
      ],
    );
  }
}

class _TimelineCard extends StatefulWidget {
  final TimelineItem item;
  final VoidCallback onItemChanged;

  const _TimelineCard({required this.item, required this.onItemChanged});

  @override
  State<_TimelineCard> createState() => _TimelineCardState();
}

class _TimelineCardState extends State<_TimelineCard> {
  var expanded = false;
  final GlobalKey _descriptionKey = GlobalKey();
  double _descriptionHeight = 0;
  late bool isCompleted;

  static const double _baseHeight = 90;

  @override
  void initState() {
    super.initState();
    isCompleted = widget.item.isCompleted;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _measureDescription();
    });
  }

  void _measureDescription() {
    final context = _descriptionKey.currentContext;
    if (context == null) return;

    final box = context.findRenderObject() as RenderBox;
    setState(() {
      _descriptionHeight = box.size.height;
      print("Description Height: $_descriptionHeight");
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 450),
      curve: Curves.fastEaseInToSlowEaseOut,
      height: expanded ? _baseHeight + _descriptionHeight + 16 : _baseHeight,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.navigationBarTheme.backgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.35),
            blurRadius: 4,
          ),
        ],
      ),
      child: Stack(
        children: [
          /// ---------- HEADER ----------
          Align(
            alignment: Alignment.topCenter,
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      isCompleted = !isCompleted;
                      widget.item.isCompleted = isCompleted;
                    });
                    widget.onItemChanged();
                  },
                  icon: isCompleted
                      ? Icon(Icons.check_circle)
                      : Icon(Icons.radio_button_unchecked),
                  color:
                      isCompleted ? theme.colorScheme.secondary : Colors.grey,
                ),
                // Checkbox(
                //   value: isCompleted,
                //   onChanged: (bool? value) {
                //     setState(() {
                //       isCompleted = value ?? false;
                //       widget.item.isCompleted = isCompleted; // update original object if needed
                //     });
                //   },
                //   activeColor: theme.colorScheme.secondary,
                //   shape: const CircleBorder(),
                // ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.item.title,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.item.date,
                        style: TextStyle(
                          color: theme.colorScheme.secondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      expanded = !expanded;
                    });
                  },
                  icon: AnimatedRotation(
                    turns: expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: const Icon(Icons.keyboard_arrow_down),
                  ),
                ),
              ],
            ),
          ),

          /// DESCRIPTION (for measuring)
          Positioned(
            top: _baseHeight - 30,
            left: 0,
            right: 0,
            child: Opacity(
              opacity: 0,
              child: Container(
                key: _descriptionKey,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  widget.item.description,
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),

          /// DESCRIPTION (visible)
          Positioned(
            top: _baseHeight - 30,
            left: 0,
            right: 0,
            child: ClipRect(
              child: AnimatedOpacity(
                opacity: expanded ? 1 : 0,
                duration: const Duration(milliseconds: 250),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.item.description,
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TimelineItem {
  final String title;
  final String date;
  bool isCompleted;
  final String description;

  TimelineItem(
      {required this.title,
      required this.date,
      this.isCompleted = false,
      required this.description});
}
