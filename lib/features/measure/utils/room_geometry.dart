import 'dart:math';

import '../model/measure_state.dart';
import '../model/room_scan.dart';

/// Where a pinned point sits relative to the room's walls.
class WallHit {
  const WallHit({
    required this.wall,
    required this.offsetMm,
    required this.distanceMm,
  });

  final int wall;

  /// Distance in mm along [wall] from its start corner.
  final double offsetMm;

  /// How far the point is from the wall line (large = not really on a wall).
  final double distanceMm;
}

/// Turns AR world-space pins (meters, Y up) into room coordinates (mm).
///
/// The room frame puts the first floor corner at the origin and the first
/// wall along +x, with the room on the +y side, matching the JSON schema.
class RoomGeometry {
  RoomGeometry(List<MeasurePoint> floorCorners)
    : _c0 = floorCorners.first {
    if (floorCorners.length < 3) {
      throw ArgumentError('A room needs at least 3 corners');
    }
    final dx = floorCorners[1].x - _c0.x, dz = floorCorners[1].z - _c0.z;
    final len = sqrt(dx * dx + dz * dz);
    if (len < 0.01) {
      throw ArgumentError('First two corners are too close together');
    }
    _ux = dx / len;
    _uz = dz / len;
    _floorY =
        floorCorners.map((c) => c.y).reduce((a, b) => a + b) /
        floorCorners.length;

    // Counter-clockwise (positive area) means the room is on the +y side.
    final raw = [for (final c in floorCorners) _plan(c, flip: false)];
    _flip = _signedArea(raw) < 0;
    _planCorners = [for (final c in floorCorners) _plan(c)];
  }

  final MeasurePoint _c0;
  late final double _ux, _uz, _floorY;
  late final bool _flip;
  late final List<Point<double>> _planCorners;

  /// Floor corners in mm, rounded to 10 mm (AR is not more precise than that).
  List<List<int>> get cornersMm => [
    for (final p in _planCorners) [_mm(p.x), _mm(p.y)],
  ];

  int get wallCount => _planCorners.length;

  /// Height in mm of [p] above the floor.
  int heightMm(MeasurePoint p) => _mm(p.y - _floorY);

  /// Finds the wall nearest to [p] and the offset along it.
  WallHit locate(MeasurePoint p) {
    final q = _plan(p);
    WallHit? best;
    for (var i = 0; i < _planCorners.length; i++) {
      final a = _planCorners[i], b = _planCorners[(i + 1) % _planCorners.length];
      final abx = b.x - a.x, aby = b.y - a.y;
      final len2 = abx * abx + aby * aby;
      final t = (((q.x - a.x) * abx + (q.y - a.y) * aby) / len2).clamp(0.0, 1.0);
      final cx = a.x + abx * t, cy = a.y + aby * t;
      final dist = sqrt(pow(q.x - cx, 2) + pow(q.y - cy, 2)) * 1000;
      if (best == null || dist < best.distanceMm) {
        best = WallHit(
          wall: i,
          offsetMm: t * sqrt(len2) * 1000,
          distanceMm: dist,
        );
      }
    }
    return best!;
  }

  /// Ceiling height from one pin on the ceiling.
  int ceilingHeightMm(MeasurePoint ceilingPin) => heightMm(ceilingPin);

  /// A door/window from two diagonal corner pins (in any order).
  Opening opening(OpeningType type, MeasurePoint a, MeasurePoint b) {
    final mid = MeasurePoint(
      (a.x + b.x) / 2,
      (a.y + b.y) / 2,
      (a.z + b.z) / 2,
    );
    final wall = locate(mid).wall;
    // Use each pin's offset on the shared wall, not on its own nearest wall.
    final oa = _offsetOnWall(a, wall), ob = _offsetOnWall(b, wall);
    final bottom = min(heightMm(a), heightMm(b));
    final top = max(heightMm(a), heightMm(b));
    return Opening(
      type: type,
      wall: wall,
      offset: _round10(min(oa, ob)),
      width: _round10((oa - ob).abs()),
      height: top - (type == OpeningType.window ? bottom : 0),
      sillHeight: type == OpeningType.window ? bottom : 0,
    );
  }

  Service service(ServiceType type, MeasurePoint p) {
    final hit = locate(p);
    return Service(
      type: type,
      wall: hit.wall,
      offset: _round10(hit.offsetMm),
      height: heightMm(p),
    );
  }

  /// A beam from a pin on its lower edge at the wall and a pin on its
  /// outer lower edge (gives how far it projects from the wall).
  Beam beam({
    required MeasurePoint lowerEdgeAtWall,
    required MeasurePoint outerEdge,
    required int ceilingHeight,
  }) {
    final hit = locate(lowerEdgeAtWall);
    return Beam(
      wall: hit.wall,
      drop: ceilingHeight - heightMm(lowerEdgeAtWall),
      depth: _round10(_distanceToWallMm(outerEdge, hit.wall)),
    );
  }

  /// Everything pinned so far, ready to serialize.
  RoomScan scan({required MeasurePoint ceilingPin}) =>
      RoomScan(corners: cornersMm, ceilingHeight: ceilingHeightMm(ceilingPin));

  // --- internals ---------------------------------------------------------

  Point<double> _plan(MeasurePoint p, {bool? flip}) {
    final dx = p.x - _c0.x, dz = p.z - _c0.z;
    final x = dx * _ux + dz * _uz;
    final y = -dx * _uz + dz * _ux;
    return Point(x, (flip ?? _flip) ? -y : y);
  }

  double _offsetOnWall(MeasurePoint p, int wall) {
    final q = _plan(p);
    final a = _planCorners[wall], b = _planCorners[(wall + 1) % wallCount];
    final abx = b.x - a.x, aby = b.y - a.y;
    final len = sqrt(abx * abx + aby * aby);
    final t = ((q.x - a.x) * abx + (q.y - a.y) * aby) / len;
    return t.clamp(0.0, len) * 1000;
  }

  double _distanceToWallMm(MeasurePoint p, int wall) {
    final q = _plan(p);
    final a = _planCorners[wall], b = _planCorners[(wall + 1) % wallCount];
    final abx = b.x - a.x, aby = b.y - a.y;
    final len = sqrt(abx * abx + aby * aby);
    return ((q.x - a.x) * -aby + (q.y - a.y) * abx).abs() / len * 1000;
  }

  static double _signedArea(List<Point<double>> pts) {
    var s = 0.0;
    for (var i = 0; i < pts.length; i++) {
      final a = pts[i], b = pts[(i + 1) % pts.length];
      s += a.x * b.y - b.x * a.y;
    }
    return s / 2;
  }

  static int _mm(double meters) => _round10(meters * 1000);
  static int _round10(double mm) => (mm / 10).round() * 10;
}
