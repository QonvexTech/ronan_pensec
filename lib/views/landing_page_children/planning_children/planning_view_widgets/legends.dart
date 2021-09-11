import 'package:flutter/material.dart';

class Legends extends StatelessWidget {
  const Legends({Key? key}) : super(key: key);
  Widget _buildLegend(Size size,
      {required Color color, required String label}) {
    final Text child = Text(
      "$label",
      style: TextStyle(
        fontSize: 14,
        color: Colors.black45,
      ),
      overflow: TextOverflow.ellipsis,
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Container(
            width: 15,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Expanded(
            child: size.width > 900
                ? child
                : ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: 17,
                    ),
                    child: FittedBox(
                      fit: BoxFit.fitHeight,
                      child: child,
                    ),
                  ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: _buildLegend(
            size,
            color: Colors.blue,
            label: "Travaillé",
          ),
        ),
        Expanded(
          flex: 1,
          child: _buildLegend(
            size,
            color: Colors.red,
            label: "Absence",
          ),
        ),
        Expanded(
          flex: 1,
          child: _buildLegend(
            size,
            color: Colors.purple.shade800,
            label: "Conflit",
          ),
        ),
        Expanded(
          flex: 1,
          child: _buildLegend(
            size,
            color: Colors.green,
            label: "Vacances",
          ),
        ),
        Expanded(
          flex: 1,
          child: _buildLegend(
            size,
            color: Colors.yellow,
            label: "RTT",
          ),
        ),
        Expanded(
          flex: 1,
          child: _buildLegend(
            size,
            color: Colors.grey.shade600,
            label: "Dimanche",
          ),
        ),
        Expanded(
          flex: 1,
          child: _buildLegend(
            size,
            color: Colors.orange,
            label: "Jour férié",
          ),
        ),
      ],
    );
  }
}
