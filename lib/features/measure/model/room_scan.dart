import 'dart:math';

/// Kitchen room data captured by AR pins, serialized to the room-survey JSON
/// (all lengths in millimeters). Index of a wall `i` is the segment from
/// `corners[i]` to `corners[(i + 1) % corners.length]`.
class RoomScan {
  const RoomScan({
    required this.corners,
    required this.ceilingHeight,
    this.cabinetWalls = const [],
    this.beams = const [],
    this.openings = const [],
    this.services = const [],
  });

  /// Floor corners as [x, y] in mm, first corner at [0, 0].
  final List<List<int>> corners;
  final int ceilingHeight;

  /// Indexes of the walls that get cabinets. Chosen by the user, not scanned.
  final List<int> cabinetWalls;
  final List<Beam> beams;
  final List<Opening> openings;
  final List<Service> services;

  int get wallCount => corners.length;

  /// Length in mm of wall [i].
  double wallLength(int i) {
    final a = corners[i], b = corners[(i + 1) % corners.length];
    final dx = (b[0] - a[0]).toDouble(), dy = (b[1] - a[1]).toDouble();
    return sqrt(dx * dx + dy * dy);
  }

  RoomScan copyWith({
    List<int>? cabinetWalls,
    List<Beam>? beams,
    List<Opening>? openings,
    List<Service>? services,
  }) => RoomScan(
    corners: corners,
    ceilingHeight: ceilingHeight,
    cabinetWalls: cabinetWalls ?? this.cabinetWalls,
    beams: beams ?? this.beams,
    openings: openings ?? this.openings,
    services: services ?? this.services,
  );

  Map<String, dynamic> toJson() => {
    'unit': 'mm',
    'room': {
      'corners': corners,
      'ceiling_height': ceilingHeight,
      'cabinet_walls': cabinetWalls,
      'beams': [for (final b in beams) b.toJson()],
    },
    'openings': [for (final o in openings) o.toJson()],
    'services': [for (final s in services) s.toJson()],
  };
}

enum OpeningType { door, window }

/// A door or window on [wall]; [offset] is the distance from the wall's
/// start corner to the opening's near edge.
class Opening {
  const Opening({
    required this.type,
    required this.wall,
    required this.offset,
    required this.width,
    required this.height,
    this.sillHeight = 0,
  });

  final OpeningType type;
  final int wall, offset, width, height, sillHeight;

  Map<String, dynamic> toJson() => {
    'type': type.name,
    'wall': wall,
    'offset': offset,
    'width': width,
    'height': height,
    if (type == OpeningType.window) 'sill_height': sillHeight,
  };
}

enum ServiceType {
  waterInlet('water_inlet'),
  drain('drain'),
  gasLine('gas_line'),
  exhaustOutlet('exhaust_outlet'),
  socket('socket');

  const ServiceType(this.key);
  final String key;
}

/// A utility point (water, gas, socket...) at [height] mm above the floor.
class Service {
  const Service({
    required this.type,
    required this.wall,
    required this.offset,
    required this.height,
  });

  final ServiceType type;
  final int wall, offset, height;

  Map<String, dynamic> toJson() => {
    'type': type.key,
    'wall': wall,
    'offset': offset,
    'height': height,
  };
}

/// A ceiling beam along [wall] hanging [drop] mm and projecting [depth] mm.
class Beam {
  const Beam({required this.wall, required this.drop, required this.depth});

  final int wall, drop, depth;

  Map<String, dynamic> toJson() => {
    'wall': wall,
    'drop': drop,
    'depth': depth,
  };
}
