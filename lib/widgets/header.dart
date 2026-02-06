import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SvgPicture.asset(
          "assets/icons/grad_cap.png",
          height: 70.0,
          colorFilter: ColorFilter.mode(Colors.blue, BlendMode.srcIn),
        ),
        Text("UnivTime",
            style: TextStyle(
                color: Colors.white,
                fontSize: 30.0,
                fontWeight: FontWeight.bold))
      ],
    );
  }
}
