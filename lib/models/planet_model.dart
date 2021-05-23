import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:some_game/models/defense_ships_model.dart';
import 'package:some_game/models/upgrade_model.dart';

enum PlanetName {
  Miavis,
  Hounus,
  Drukunides,
  Eno,
  Musk,
  Jupinot,
  Ocorix,
  Arth,
}

const Map<PlanetName, String> kPlanetsDescriptionData = const {
  PlanetName.Miavis:
      'Part of an failed experiment\nThe Planet gets closer to doom every day',
  PlanetName.Hounus:
      'The hottest plan there is on the solar system,\nFull of Lava and gold',
  PlanetName.Drukunides:
      'Covered in vines and deep forest.\nHome to the most Toxic Snakes in universe',
  PlanetName.Eno:
      'Believed to be the home of the Ruler of Seas.\nThe harsh climate has made the inhabitants super durable',
  PlanetName.Musk:
      'Humans shifted here recently\nWhen they fucked up in their previous home',
  PlanetName.Jupinot:
      'Home to the little lunatic prince. The inhabitants have made no contacts yet with other species',
  PlanetName.Ocorix:
      'Dying core of the Star Ocorix. It\'s existence itself is an anomaly',
  PlanetName.Arth:
      'Original Home to the humans.\nIs believed to be the perfect place for lifeforms to exist',
};

class Planet with ChangeNotifier, Defense, PlanetUpgrade {
  PlanetName name;
  String description;
  int _morale;
  int _revenue;

  Planet(this.name) {
    this.description = kPlanetsDescriptionData[name];
    init();
  }

  init() {
    statsInit();
    upgradesInit();
    defenseInit();
  }

  statsInit() {
    _revenue = 2000;
    _morale = 600;
  }

  nextTurn() {
    morale = (_morale * planetMoraleBoost).round();
    revenue = (_revenue * planetIncomeBoost).round();
  }

  int get income {
    return (_revenue * (1 + (_morale - 400) / 1000)).round() -
        defenseExpenditure;
  }

  int get defense {
    return planetDefenseQuotient;
  }

  Map get stats {
    return {
      'morale': _morale,
      'income': income,
      'defense': defense,
    };
  }

  set morale(int value) {
    _morale = value;
  }

  set revenue(int value) {
    _revenue = value;
  }

  attack(List<int> positions) {
    List<int> damageOutput = List.generate(positions.length,
        (index) => 0); // What Damage will ship at pos[i] reciveve
    for (int i = 0; i < positions.length; i++) {
      damageOutput[positions[i]] +=
          defenseShipCount(List.from(allShips.keys)[i]) *
              kDefenseShipsData[List.from(allShips.keys)[i]].damage;
    }
    return damageOutput;
  }

  defend(List<int> damageOutputs) {
    for (int i = 0; i < damageOutputs.length; i++) {
      int shipsLost = (damageOutputs[i] /
              kDefenseShipsData[List.from(allShips.keys)[i]].health)
          .ceil();
      defenseRemoveShip(List.from(allShips.keys)[i], shipsLost);
    }
    notifyListeners();
    int shipsLeft = 0;
    for (var ship in List.from(allShips.keys)) {
      shipsLeft += defenseShipCount(ship);
    }
    return shipsLeft;
  }
}

mixin PlanetUpgrade {
  Map<UpgradeType, bool> _planetUpgrade = {};

  void upgradesInit() {
    for (var upgrade in UpgradeType.values) {
      _planetUpgrade[upgrade] = false;
    }
  }

  upgradePresent(UpgradeType type) {
    return _planetUpgrade[type];
  }

  upgradeAdd(UpgradeType type) {
    _planetUpgrade[type] = true;
  }

  int get planetDefenseQuotient {
    int turret = upgradePresent(UpgradeType.Turret) ? 1 : 0;
    int watchTower = upgradePresent(UpgradeType.WatchTower) ? 2 : 0;
    return turret + watchTower;
  }

  double get planetMoraleBoost {
    double townCenter = upgradePresent(UpgradeType.TownCenter) ? 0.1 : 0;
    double moske = upgradePresent(UpgradeType.Moske) ? 0.15 : 0;
    return 1 + moske + townCenter;
  }

  double get planetIncomeBoost {
    double boost = upgradePresent(UpgradeType.Industry) ? 1.15 : 1;
    return boost;
  }

  int get planetTradeBoost {
    int boost = upgradePresent(UpgradeType.TradeCenter) ? 1 : 0;
    return boost;
  }
}

mixin Defense {
  Map<DefenseShipType, int> _ownedShips = {};

  void defenseInit() {
    _ownedShips[DefenseShipType.Battleship] = 3;
    _ownedShips[DefenseShipType.Artillery] = 3;
    _ownedShips[DefenseShipType.Rover] = 5;
  }

  int get defenseExpenditure {
    int expense = 0;
    for (var type in List.from(_ownedShips.keys)) {
      expense += _ownedShips[type] * kDefenseShipsData[type].maintainance;
    }
    return expense;
  }

  get allShips {
    return _ownedShips;
  }

  int defenseShipCount(DefenseShipType type) {
    return _ownedShips[type];
  }

  defenseAddShip(DefenseShipType type, int value) {
    _ownedShips[type] += value;
  }

  defenseRemoveShip(DefenseShipType type, int value) {
    if (_ownedShips[type] > value) {
      _ownedShips[type] -= value;
    } else {
      _ownedShips[type] = 0;
    }
  }
}
