// SPDX-FileCopyrightText: 2026 Akihiko Komada <aki1770@gmail.com>
// SPDX-License-Identifier: Apache-2.0

/// Client-side VSS wildcard matching, for [KuksaClient.expand].
///
/// `kuksa.val.v2` takes **exact leaf paths** in `Subscribe`, `GetValue` and
/// `GetValues`. Measured against databroker 0.7.1: `Vehicle.ADAS.*`,
/// `Vehicle.**` and the plain branch `Vehicle.ADAS` all answer `NOT_FOUND`.
/// The one place the databroker still understands a wildcard is the `root`
/// field of `ListMetadata`, and its own proto comment says that support *"may
/// be removed in a future release"*. So a pattern is never sent to the broker:
/// [KuksaClient.expand] lists the metadata under [literalPrefix] and matches
/// each path here.
///
/// The semantics are pinned to the databroker's `wildcard_matching.md` and to
/// the redesigned Python client's `patterns.py`, so an edge developer moving
/// between the two SDKs meets one contract:
///
/// - `*` matches exactly one path segment;
/// - `**` matches zero or more segments;
/// - both may appear anywhere in the pattern;
/// - a pattern with no wildcard matches that path **and everything below it**
///   (`Vehicle.ADAS.ESC` expands to every leaf under the branch);
/// - the empty pattern matches every path;
/// - `**` combined with two consecutive `*` segments is refused.
///
/// A segment that merely *contains* `*` (`Is*`) is refused too. The Python
/// matcher compares such a segment literally, so it can never match a VSS
/// path and silently expands to nothing; a silent nothing is the failure this
/// package exists to make loud, so here it is an [ArgumentError] at the call.
library;

/// A compiled VSS path pattern. See the library comment for the semantics.
class SignalPattern {
  /// The pattern as given, e.g. `Vehicle.**.Pressure`.
  final String pattern;

  /// [pattern] split on `.`; empty for the empty pattern.
  final List<String> segments;

  /// Compiles [pattern]. Throws [ArgumentError] for an unsupported pattern.
  SignalPattern(this.pattern)
      : segments = pattern.isEmpty
            ? const <String>[]
            : List.unmodifiable(pattern.split('.')) {
    for (final s in segments) {
      if (s.contains('*') && s != '*' && s != '**') {
        throw ArgumentError.value(
          pattern,
          'pattern',
          'a wildcard must be a whole segment: use "*" for one segment or '
              '"**" for any number of segments ("$s" is neither)',
        );
      }
      if (s.isEmpty) {
        throw ArgumentError.value(
            pattern, 'pattern', 'contains an empty path segment');
      }
    }
    var consecutiveStars = false;
    for (var i = 1; i < segments.length; i++) {
      if (segments[i] == '*' && segments[i - 1] == '*') consecutiveStars = true;
    }
    if (consecutiveStars && segments.contains('**')) {
      throw ArgumentError.value(
        pattern,
        'pattern',
        'combining "**" with consecutive "*" segments is not supported',
      );
    }
  }

  /// True when the pattern carries no wildcard at all.
  bool get isLiteral => segments.isNotEmpty && !segments.any(_isWildcard);

  /// True for the empty pattern, which matches every path.
  bool get matchesAll => pattern.isEmpty;

  /// The segments before the first wildcard, joined — the branch that bounds
  /// the `ListMetadata(root: …)` call. Empty when the pattern starts with a
  /// wildcard, which lists the whole tree.
  String get literalPrefix {
    final out = <String>[];
    for (final s in segments) {
      if (_isWildcard(s)) break;
      out.add(s);
    }
    return out.join('.');
  }

  /// Whether the concrete signal [path] matches this pattern.
  bool matches(String path) {
    if (matchesAll) return true;
    if (isLiteral) return path == pattern || path.startsWith('$pattern.');
    return _match(0, path.split('.'), 0);
  }

  bool _match(int si, List<String> path, int pi) {
    if (si == segments.length) return pi == path.length;
    final segment = segments[si];
    if (segment == '**') {
      // Match zero segments, or consume one path segment and stay on '**'.
      return _match(si + 1, path, pi) ||
          (pi < path.length && _match(si, path, pi + 1));
    }
    if (pi >= path.length) return false;
    if (segment == '*') return _match(si + 1, path, pi + 1);
    return segment == path[pi] && _match(si + 1, path, pi + 1);
  }

  static bool _isWildcard(String s) => s == '*' || s == '**';

  @override
  String toString() => 'SignalPattern($pattern)';
}
