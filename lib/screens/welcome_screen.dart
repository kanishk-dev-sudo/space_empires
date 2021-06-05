import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '/utility/constants.dart';
import '/widgets/static_stars_bg.dart';
import 'character_selection_screen.dart';
import 'story/story_i.dart';

class WelcomeScreen extends StatelessWidget {
  static const route = '/welcome-screen';

  Widget get _animatedStars {
    return Lottie.asset('assets/animations/stars.json');
  }

  Widget get _spaceLights {
    return Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            opacityBlack(0.3),
            opacityIndigo(0.4),
          ]),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    _menu() {
      return Align(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'SPACE EMPIRE',
              style: Theme.of(context)
                  .textTheme
                  .headline4
                  .copyWith(fontFamily: 'Astral'),
            ),
            SizedBox(
              height: size.height / 6,
            ),
            TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, CharacterSelectionScreen.route);
                },
                child: Text(
                  'Play',
                  style: Theme.of(context)
                      .textTheme
                      .headline4
                      .copyWith(fontFamily: 'Italianno'),
                )),
            TextButton(
                onPressed: () {
                  final Orientation orientation =
                      MediaQuery.of(context).orientation;
                  Navigator.of(context).pushReplacementNamed(StoryScreenI.route,
                      arguments: orientation);
                },
                child: Text(
                  'Story',
                  style: Theme.of(context)
                      .textTheme
                      .headline4
                      .copyWith(fontFamily: 'Italianno'),
                )),
          ],
        ),
      );
    }

    _saturn() {
      return Positioned(
        right: -size.longestSide / 4,
        bottom: -size.longestSide / 8,
        child: Lottie.asset('assets/animations/saturn.json',
            height: size.longestSide / 2, width: size.longestSide / 2),
      );
    }

    _purplePlanet() {
      return Positioned(
        left: -size.longestSide / 4,
        bottom: 0,
        child: Lottie.asset('assets/animations/xeno.json',
            height: size.longestSide / 2, width: size.longestSide / 2),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          StaticStarsBackGround(),
          _animatedStars,
          _spaceLights,
          _saturn(),
          _purplePlanet(),
          _menu(),
        ],
      ),
    );
  }
}
