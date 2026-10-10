import 'dart:math';

import 'package:flutter_kaiyaletz/features/measure/model/measure_state.dart';
import 'package:flutter_kaiyaletz/features/measure/model/room_scan.dart';
import 'package:flutter_kaiyaletz/features/measure/utils/room_geometry.dart';
import 'package:flutter_test/flutter_test.dart';

/// Maps room coords (mm, y up in plan) + height (mm) into an arbitrary AR
/// world frame: rotated about Y, shifted, and with an odd floor level, so the
/// tests prove the conversion does not rely on the world axes.
MeasurePoint world(
  double xMm,
  double yMm,
  double hMm, {
  double rot = 0.7,
  bool mirror = false,
}) {
  final px = xMm / 1000, pz = (mirror ? -yMm : yMm) / 1000;
  final x = px * cos(rot) - pz * sin(rot) + 4.2;
  final z = px * sin(rot) + pz * cos(rot) - 1.3;
  return MeasurePoint(x, -0.35 + hMm / 1000, z);
}

void main() {
  // 3000 x 2400 room from the sample JSON.
  List<MeasurePoint> floor({bool mirror = false, bool reverse = false}) {
    final pts = [
      world(0, 0, 0, mirror: mirror),
      world(3000, 0, 0, mirror: mirror),
      world(3000, 2400, 0, mirror: mirror),
      world(0, 2400, 0, mirror: mirror),
    ];
    return reverse ? [pts[0], ...pts.sublist(1).reversed] : pts;
  }

  test('corners come back in room coordinates', () {
    final g = RoomGeometry(floor());
    expect(g.cornersMm, [
      [0, 0],
      [3000, 0],
      [3000, 2400],
      [0, 2400],
    ]);
  });

  test('clockwise and counter-clockwise walking give the same room', () {
    // Walking the other way: corner 1 is now the (0, 2400) one.
    final g = RoomGeometry(floor(reverse: true));
    expect(g.cornersMm, [
      [0, 0],
      [2400, 0],
      [2400, 3000],
      [0, 3000],
    ]);
  });

  test('ceiling height uses the floor level', () {
    final g = RoomGeometry(floor());
    expect(g.ceilingHeightMm(world(100, 100, 2850)), 2850);
  });

  test('door on wall 3 matches the sample JSON', () {
    final g = RoomGeometry(floor());
    // Wall 3 runs (0,2400) -> (0,0); door is 800 wide from offset 200.
    final door = g.opening(
      OpeningType.door,
      world(0, 2400 - 200, 0),
      world(0, 2400 - 1000, 2100),
    );
    expect(door.toJson(), {
      'type': 'door',
      'wall': 3,
      'offset': 200,
      'width': 800,
      'height': 2100,
    });
  });

  test('window on wall 1 has sill height', () {
    final g = RoomGeometry(floor());
    // Wall 1 runs (3000,0) -> (3000,2400).
    final w = g.opening(
      OpeningType.window,
      world(3000, 900, 1050),
      world(3000, 2100, 2050),
    );
    expect(w.toJson(), {
      'type': 'window',
      'wall': 1,
      'offset': 900,
      'width': 1200,
      'height': 1000,
      'sill_height': 1050,
    });
  });

  test('services get wall, offset and height', () {
    final g = RoomGeometry(floor());
    final gas = g.service(ServiceType.gasLine, world(1800, 0, 600));
    expect(gas.toJson(), {
      'type': 'gas_line',
      'wall': 0,
      'offset': 1800,
      'height': 600,
    });
  });

  test('beam drop and depth', () {
    final g = RoomGeometry(floor());
    final beam = g.beam(
      lowerEdgeAtWall: world(1000, 0, 2550),
      outerEdge: world(1000, 250, 2550),
      ceilingHeight: 2850,
    );
    expect(beam.toJson(), {'wall': 0, 'drop': 300, 'depth': 250});
  });

  test('small AR noise does not change the result by more than 10 mm', () {
    final g = RoomGeometry(floor());
    final noisy = MeasurePoint(
      world(1800, 0, 600).x + 0.004,
      world(1800, 0, 600).y,
      world(1800, 0, 600).z - 0.004,
    );
    final s = g.service(ServiceType.gasLine, noisy);
    expect((s.offset - 1800).abs() <= 10, isTrue);
  });

  test('mirrored walking direction gives a valid room', () {
    final g = RoomGeometry(floor(mirror: true));
    expect(g.cornersMm, [
      [0, 0],
      [3000, 0],
      [3000, 2400],
      [0, 2400],
    ]);
  });

  test('full scan serializes to the schema keys', () {
    final g = RoomGeometry(floor());
    final json = g
        .scan(ceilingPin: world(10, 10, 2850))
        .copyWith(cabinetWalls: [0, 1])
        .toJson();
    expect(json['unit'], 'mm');
    expect((json['room'] as Map)['ceiling_height'], 2850);
    expect((json['room'] as Map)['cabinet_walls'], [0, 1]);
  });
}
