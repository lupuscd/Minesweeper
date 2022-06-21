import 'package:flutter/material.dart';

class GridBox extends StatelessWidget {
  final params;
  bool revealed;
  final function;

  GridBox({
    this.params,
    required this.revealed,
    this.function,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      //onLongPress: ,
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Container(
          color: revealed ? Colors.teal[50] : Colors.teal[700],
          child: Center(
            child: Text(
              revealed ? (params == 0 ? '' : params.toString()) : '',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: params == 1
                      ? Colors.blue[900]
                      : (params == 2
                          ? Colors.green[700]
                          : (params == 3
                              ? Colors.red[900]
                              : Colors.grey[900]))),
            ),
          ),
        ),
      ),
    );
  }
}
