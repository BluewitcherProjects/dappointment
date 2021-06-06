import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';

class DetailsRow extends StatelessWidget {
  final String title, value;
  DetailsRow({Key key, this.title, this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style:
                  GoogleFonts.ubuntu(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Text(
              value ?? '-',
              style:
                  GoogleFonts.ubuntu(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        Divider()
      ],
    );
  }
}
