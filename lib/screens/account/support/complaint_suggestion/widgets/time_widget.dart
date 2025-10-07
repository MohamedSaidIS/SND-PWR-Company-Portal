import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeWidget extends StatelessWidget {
   final IconData icon;
   final String label;
   final String value;
  const TimeWidget({super.key, required this.icon, required this.label, required this.value});


   String formatDateTime(DateTime? dt) {
     if (dt == null) return "-";
     return DateFormat('yyyy-MM-dd HH:mm').format(dt.toLocal());
   }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
               style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    )),
                Text(
                  formatDateTime(
                    DateTime.parse(
                      value,
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
