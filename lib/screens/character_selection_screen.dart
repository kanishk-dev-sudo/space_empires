import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:some_game/models/game_data.dart';
import 'package:some_game/screens/game_screen.dart';
import 'package:some_game/utility/constants.dart';
import 'package:some_game/widgets/static_stars_bg.dart';
import 'package:sizer/sizer.dart';

class CharacterSelectionScreen extends StatelessWidget {
  static const route = '/character-selection-screen';

  final Map<Ruler, String> _descriptionData = const {
    Ruler.NdNd:
        'The last standing heir from the Royal Family of Jupinot. Hates Everyone except himself .',
    Ruler.Nudar:
        'The Ruler of the strongest warrior race of this Universe. They socialize through fights .',
    Ruler.Zapp: 'Weak fragile Creatures, with limitless potential for growth',
    Ruler.Morbo:
        'The Master Tactician himself, the guy once held 6 planets in his prime',
  };

  _animatedStars() {
    return Lottie.asset('assets/animations/stars.json');
  }

  _spaceLights() {
    return Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            opacityBlack(0.3),
            opacityPrimaryColor(0.4),
          ]),
        ));
  }

  @override
  Widget build(BuildContext context) {
    _heading() {
      return Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: EdgeInsets.all(32.sp),
          child: Text('Choose Character',
              style: Theme.of(context)
                  .textTheme
                  .headline4
                  .copyWith(fontFamily: 'Italianno')),
        ),
      );
    }

    _description(Ruler ruler) {
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(16.sp),
        decoration: BoxDecoration(
            color: Colors.black26, borderRadius: BorderRadius.circular(16.sp)),
        child: SingleChildScrollView(
          child: Text(
            _descriptionData[ruler],
            style: TextStyle(fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    _continue(Ruler ruler) {
      return SizedBox(
        width: 360,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 4.sp),
          child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Color(0xFF120530))),
            onPressed: () {
              Provider.of<GameData>(context, listen: false)
                  .initCurrentPlayer(ruler);
              Navigator.pushReplacementNamed(context, GameScreen.route);
            },
            child: Text('Continue'),
          ),
        ),
      );
    }

    _rulerImage(Ruler ruler, int flex) {
      return Expanded(
        flex: flex,
        child: CircleAvatar(
          backgroundColor: Colors.black26,
          child: Padding(
            padding: EdgeInsets.all(8.sp),
            child: Image.asset(
              'assets/img/avatar/${describeEnum(ruler).toLowerCase()}.png',
            ),
          ),
          radius: double.maxFinite,
        ),
      );
    }

    _rulerName(Ruler ruler, int flex) {
      return Expanded(
        flex: flex,
        child: Container(
          alignment: flex == 1 ? Alignment.center : Alignment.centerRight,
          child: Text(describeEnum(ruler),
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  .copyWith(fontWeight: FontWeight.bold)),
        ),
      );
    }

    _characterCard(Ruler ruler, Orientation orientation) {
      return Container(
        padding: EdgeInsets.all(16.sp),
        margin: EdgeInsets.all(16.sp),
        decoration: BoxDecoration(
            color: Colors.white10, borderRadius: BorderRadius.circular(16.sp)),
        child: orientation == Orientation.landscape
            ? Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [_rulerImage(ruler, 2), _rulerName(ruler, 1)],
                    ),
                  ),
                  Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          Expanded(child: _description(ruler)),
                          _continue(ruler),
                        ],
                      )),
                ],
              )
            : Column(
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [_rulerImage(ruler, 1), _rulerName(ruler, 2)],
                    ),
                  ),
                  Expanded(flex: 2, child: _description(ruler)),
                  _continue(ruler),
                ],
              ),
      );
    }

    _characterMenu(Orientation orientation) {
      final Size size = MediaQuery.of(context).size;
      return Align(
        alignment: Alignment.center,
        child: CarouselSlider.builder(
          options: CarouselOptions(
              height: orientation == Orientation.landscape
                  ? size.height * 0.8
                  : size.height * 0.5),
          itemCount: Ruler.values.length,
          itemBuilder: (BuildContext context, int index, _) =>
              _characterCard(Ruler.values[index], orientation),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          StaticStarsBackGround(),
          _animatedStars(),
          _spaceLights(),
          _heading(),
          OrientationBuilder(
            builder: (context, orientation) {
              return _characterMenu(orientation);
            },
          ),
        ],
      ),
    );
  }
}
