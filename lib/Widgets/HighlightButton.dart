import "package:flutter/material.dart";

class HighlightListItem extends StatefulWidget {
  final String text;
  final Color highlightColor;
  final VoidCallback onTap;

  HighlightListItem({
    required this.text,
    required this.highlightColor,
    required this.onTap,
  });

  @override
  _HighlightListItemState createState() => _HighlightListItemState();
}

class _HighlightListItemState extends State<HighlightListItem> {
  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          isTapped = true;
        });
        widget.onTap();
      },
      onTapUp: (_) {
        setState(() {
          isTapped = false;
        });
      },
      onTapCancel: () {
        setState(() {
          isTapped = false;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300), // Duração da animação
        color: isTapped ? widget.highlightColor : Colors.transparent,
        child: ListTile(
          title: Text(widget.text, style: TextStyle(
              fontSize: 17
          ),),
          subtitle: Text(
              "Ultima vez treinado: 27/08/2003"),
          // Outros widgets de conteúdo do item da lista
        ),
      ),
    );
  }
}