// SPDX-FileCopyrightText: 2026 Akihiko Komada <aki1770@gmail.com>
// SPDX-License-Identifier: Apache-2.0

/// Runs every shell command this package's documentation tells a stranger to
/// run, against the real thing it names.
///
/// Two looms in this repository already guard the README's *truth*:
/// `tool/gen_signal_table.dart --check` regenerates the signal table from the
/// vendored VSS spec, and `tool/vss_sync.sh` diffs that spec against COVESA
/// upstream. A third — the L35 snippet oracle — compiles every ```dart block
/// against this package's own API. **None of them looks at a shell command.**
///
/// Founding defect (2026-09-12): README.md said
///
///     # Start databroker in mock mode (no real vehicle required)
///     docker run ... kuksa-databroker:latest --mock-datapoints
///
/// The databroker has no mock mode and has never had that flag; the command
/// answers `error: unexpected argument '--mock-datapoints' found` and exits 2.
/// It is in **all 12 published versions**, 0.1.0 (2026-04-12) through
/// 0.2.9 (2026-09-11) — measured by reading each archive off pub.dev, not git
/// history, which does not contain the published trees. Every check was green
/// throughout, under the heading **Prerequisites**, the first command a
/// stranger runs. `--self-test`
/// reconstructs that exact line and asserts this checker rejects it, so the
/// proof is re-runnable and cannot be quietly lost.
///
/// Usage:
///   dart run tool/doc_commands_check.dart            # verify
///   dart run tool/doc_commands_check.dart --list      # verify, show every command
///   dart run tool/doc_commands_check.dart --self-test # prove it fails on the defect
///
/// Exit 0 = every documented command verified or delegated. Non-zero = a
/// command in our documentation is false, or could not be verified. A command
/// whose shape this checker does not recognise is a FAILURE, never a pass:
/// an absent verdict reads exactly like a clean one.
library;

import 'dart:io';

/// Fences whose contents a reader is invited to paste into a shell.
const shellFences = {'bash', 'sh', 'shell', 'console'};

/// Verbs delegated to a toolchain this package does not own. Their *file*
/// arguments are still checked; their flags are the toolchain's contract.
const delegatedVerbs = {
  'dart',
  'flutter',
  'git',
  'cd',
  'sed',
  'sort',
  'python3',
  'curl',
  'nc',
};

class Finding {
  Finding(this.file, this.line, this.command, this.status, this.detail);

  final String file;
  final int line;
  final String command;

  /// `ok` verified here · `delegated` toolchain's contract · `FAIL`.
  final String status;
  final String detail;

  bool get failed => status == 'FAIL';

  @override
  String toString() => '  ${status.padRight(9)} $file:$line  $command\n'
      '            $detail';
}

/// Every shell command in [path], with the line it sits on.
List<({int line, String command})> extractCommands(String path) {
  final text = File(path).readAsStringSync();
  final lines = text.split('\n');
  final out = <({int line, String command})>[];
  var inFence = false;
  var buffer = <String>[];
  var bufferLine = 0;

  void flush() {
    if (buffer.isEmpty) return;
    final joined = buffer.join(' ').replaceAll(RegExp(r'\s+'), ' ').trim();
    if (joined.isNotEmpty) out.add((line: bufferLine, command: joined));
    buffer = <String>[];
  }

  for (var i = 0; i < lines.length; i++) {
    final raw = lines[i];
    final trimmed = raw.trim();
    if (trimmed.startsWith('```')) {
      if (inFence) {
        flush();
        inFence = false;
      } else {
        inFence = shellFences.contains(trimmed.substring(3).trim());
      }
      continue;
    }
    if (!inFence) continue;
    if (trimmed.isEmpty || trimmed.startsWith('#')) {
      flush();
      continue;
    }
    if (buffer.isEmpty) bufferLine = i + 1;
    if (trimmed.endsWith(r'\')) {
      buffer.add(trimmed.substring(0, trimmed.length - 1).trim());
    } else {
      buffer.add(trimmed);
      flush();
    }
  }
  flush();
  return out;
}

/// Splits a command line on the shell operators that start a new program —
/// ignoring any that sit inside quotes.
///
/// `sed -n 's|^- \(x\)|y|p'` is one command, not four. Splitting it blindly is
/// how a checker invents defects that are not there, which costs a reader's
/// trust exactly as a missed defect does.
List<String> splitStages(String command) {
  final stages = <String>[];
  final buf = StringBuffer();
  String? quote;
  for (var i = 0; i < command.length; i++) {
    final c = command[i];
    if (quote != null) {
      buf.write(c);
      if (c == quote) quote = null;
      continue;
    }
    if (c == "'" || c == '"') {
      quote = c;
      buf.write(c);
      continue;
    }
    if (c == '|' ||
        c == ';' ||
        (c == '&' && i + 1 < command.length && command[i + 1] == '&')) {
      if (c == '&') i++;
      if (c == '|' && i + 1 < command.length && command[i + 1] == '|') i++;
      stages.add(buf.toString().trim());
      buf.clear();
      continue;
    }
    buf.write(c);
  }
  stages.add(buf.toString().trim());
  return stages.where((s) => s.isNotEmpty).toList();
}

/// Splits a stage into tokens, keeping quoted runs whole.
List<String> tokens(String stage) {
  final out = <String>[];
  final buf = StringBuffer();
  String? quote;
  for (var i = 0; i < stage.length; i++) {
    final c = stage[i];
    if (quote != null) {
      if (c == quote) {
        quote = null;
      } else {
        buf.write(c);
      }
      continue;
    }
    if (c == "'" || c == '"') {
      quote = c;
      continue;
    }
    if (c == ' ') {
      if (buf.isNotEmpty) {
        out.add(buf.toString());
        buf.clear();
      }
      continue;
    }
    buf.write(c);
  }
  if (buf.isNotEmpty) out.add(buf.toString());
  return out;
}

/// Every long option the image's own `--help` declares.
///
/// Throws when the image cannot be asked — a flag we could not check is never
/// reported as a flag we checked.
Set<String> imageOptions(String image) {
  final r = Process.runSync('docker', ['run', '--rm', image, '--help']);
  final text = '${r.stdout}${r.stderr}';
  if (r.exitCode != 0) {
    throw StateError('`docker run --rm $image --help` exited ${r.exitCode}. '
        'The flags documented for this image cannot be verified.\n$text');
  }
  final opts = RegExp(r'--[A-Za-z][A-Za-z0-9-]*')
      .allMatches(text)
      .map((m) => m.group(0)!)
      .toSet();
  if (opts.isEmpty) {
    throw StateError('`$image --help` declared no options; refusing to treat '
        'its documented flags as verified.');
  }
  return opts;
}

/// Checks a `docker run ... IMAGE ARGS` command: the flags a reader passes to
/// the containerised program must exist in that program's own `--help`.
Finding checkDockerRun(
    String file, int line, String stage, List<String> tok, String full) {
  // Walk past docker's own options to the image reference. Options that take a
  // separate value are skipped with their value.
  const valued = {'-p', '-v', '-e', '--name', '--network', '--entrypoint'};
  var i = 2;
  while (i < tok.length) {
    final t = tok[i];
    if (!t.startsWith('-')) break;
    if (valued.contains(t)) {
      i += 2;
    } else {
      i += 1;
    }
  }
  if (i >= tok.length) {
    return Finding(file, line, stage, 'FAIL', 'no image reference found.');
  }
  final image = tok[i];
  final args = tok.sublist(i + 1);
  final flags = args.where((a) => a.startsWith('--')).toList();
  if (flags.isEmpty) {
    return Finding(
        file, line, stage, 'ok', 'image `$image`, no flags to check.');
  }
  final Set<String> known;
  try {
    known = imageOptions(image);
  } on StateError catch (e) {
    return Finding(file, line, stage, 'FAIL', e.message);
  } on ProcessException catch (e) {
    return Finding(file, line, stage, 'FAIL',
        'docker is required to verify `$image` and is not usable: ${e.message}');
  }
  final bogus = flags.where((f) => !known.contains(f)).toList();
  if (bogus.isNotEmpty) {
    return Finding(
        file,
        line,
        stage,
        'FAIL',
        '$image does not accept ${bogus.join(', ')}. Its --help declares: '
            '${(known.toList()..sort()).join(' ')}');
  }
  return Finding(file, line, stage, 'ok',
      '$image accepts ${flags.join(', ')} (checked against its own --help).');
}

/// Checks a command whose program is a file inside this repository.
Finding checkRepoScript(
    String file, int line, String stage, List<String> tok, String root) {
  final prog = tok.first;
  final f = File('$root/$prog');
  if (!f.existsSync()) {
    return Finding(file, line, stage, 'FAIL', '$prog does not exist.');
  }
  final mode = f.statSync().mode;
  if (mode & 0x49 == 0) {
    return Finding(file, line, stage, 'FAIL', '$prog is not executable.');
  }
  final source = f.readAsStringSync();
  final flags = tok.skip(1).where((t) => t.startsWith('--')).toList();
  final bogus = flags.where((t) => !source.contains(t)).toList();
  if (bogus.isNotEmpty) {
    return Finding(
        file, line, stage, 'FAIL', '$prog never mentions ${bogus.join(', ')}.');
  }
  return Finding(
      file,
      line,
      stage,
      'ok',
      flags.isEmpty
          ? '$prog exists and is executable.'
          : '$prog handles ${flags.join(', ')}.');
}

/// Any argument that looks like a path into this repository must exist.
Finding checkDelegated(
    String file, int line, String stage, List<String> tok, String root) {
  final missing = <String>[];
  for (final t in tok.skip(1)) {
    if (t.startsWith('-')) continue;
    if (!t.contains('/') || t.contains('://')) continue;
    if (t.startsWith('/')) continue;
    // Only a plain relative path is checked. A `sed` script or a shell
    // expression is not a path, and reporting it as a missing file would be
    // this checker inventing a defect — which costs a reader's trust exactly
    // as a missed one does.
    if (!RegExp(r'^[A-Za-z0-9_.][A-Za-z0-9_./-]*$').hasMatch(t)) continue;
    if (!File('$root/$t').existsSync() && !Directory('$root/$t').existsSync()) {
      missing.add(t);
    }
  }
  if (missing.isNotEmpty) {
    return Finding(file, line, stage, 'FAIL',
        '${missing.join(', ')} — documented path does not exist in this repository.');
  }
  return Finding(file, line, stage, 'delegated',
      '`${tok.first}` is the toolchain\'s contract; its file arguments exist.');
}

List<Finding> checkFile(String root, String relative) {
  final findings = <Finding>[];
  for (final c in extractCommands('$root/$relative')) {
    for (final stage in splitStages(c.command)) {
      final tok = tokens(stage);
      if (tok.isEmpty) continue;
      final prog = tok.first;
      if (prog == 'docker' && tok.length > 1 && tok[1] == 'run') {
        findings.add(checkDockerRun(relative, c.line, stage, tok, c.command));
      } else if (prog.contains('/') && !prog.contains('://')) {
        findings.add(checkRepoScript(relative, c.line, stage, tok, root));
      } else if (delegatedVerbs.contains(prog)) {
        findings.add(checkDelegated(relative, c.line, stage, tok, root));
      } else {
        findings.add(Finding(
            relative,
            c.line,
            stage,
            'FAIL',
            'this checker does not know how to verify `$prog`. Teach it, or '
                'remove the command. An unchecked command is not a checked one.'));
      }
    }
  }
  return findings;
}

List<String> docFiles(String root) {
  final out = <String>[];
  void walk(Directory d, String prefix) {
    for (final e in d.listSync()) {
      final name = e.uri.pathSegments.where((s) => s.isNotEmpty).last;
      if (e is Directory) {
        if (name.startsWith('.') || name == 'build' || name == 'spec') continue;
        walk(e, prefix.isEmpty ? name : '$prefix/$name');
      } else if (name == 'README.md') {
        out.add(prefix.isEmpty ? name : '$prefix/$name');
      }
    }
  }

  walk(Directory(root), '');
  out.sort();
  return out;
}

int run(String root, {bool list = false}) {
  final all = <Finding>[];
  for (final f in docFiles(root)) {
    all.addAll(checkFile(root, f));
  }
  if (all.isEmpty) {
    stderr.writeln('DOC COMMANDS: found no shell commands at all in $root — '
        'the extractor is broken, or the docs moved.');
    return 1;
  }
  final failed = all.where((f) => f.failed).toList();
  if (list || failed.isNotEmpty) {
    for (final f in all) {
      if (list || f.failed) stdout.writeln(f);
    }
  }
  final ok = all.where((f) => f.status == 'ok').length;
  final delegated = all.where((f) => f.status == 'delegated').length;
  if (failed.isNotEmpty) {
    stderr.writeln('\nDOC COMMANDS: HALT — ${failed.length} of ${all.length} '
        'documented command(s) are false or unverifiable.');
    stderr.writeln(
        'A stranger who pastes these gets an error, not a databroker.');
    return 1;
  }
  stdout.writeln('DOC COMMANDS: PASS — $ok verified against the real thing, '
      '$delegated delegated to the toolchain (${all.length} total).');
  return 0;
}

/// Rebuilds the 2026-09-12 defect and asserts this checker rejects it.
int selfTest() {
  final dir = Directory.systemTemp.createTempSync('doc_cmd_selftest');
  try {
    const image = 'ghcr.io/eclipse-kuksa/kuksa-databroker:latest';
    File('${dir.path}/README.md').writeAsStringSync('''
# fixture

```bash
# Start databroker in mock mode (no real vehicle required)
docker run --rm -p 55555:55555 $image --mock-datapoints
```
''');
    final broken = checkFile(dir.path, 'README.md');
    final failures = <String>[];
    if (broken.length != 1) {
      failures.add('expected 1 command, extracted ${broken.length}');
    } else if (!broken.first.failed) {
      failures.add('the shipped --mock-datapoints line was NOT rejected: '
          '${broken.first.status} / ${broken.first.detail}');
    } else if (!broken.first.detail.contains('--mock-datapoints')) {
      failures.add('rejected, but without naming --mock-datapoints: '
          '${broken.first.detail}');
    }

    File('${dir.path}/README.md').writeAsStringSync('''
# fixture

```bash
docker run --rm -p 55555:55555 $image --insecure
```
''');
    final fixed = checkFile(dir.path, 'README.md');
    if (fixed.length != 1 || fixed.first.failed) {
      failures.add('the repaired --insecure line was rejected: '
          '${fixed.map((f) => f.detail).join(' | ')}');
    }

    File('${dir.path}/README.md').writeAsStringSync('''
# fixture

```bash
frobnicate --wizard
```
''');
    final unknown = checkFile(dir.path, 'README.md');
    if (unknown.length != 1 || !unknown.first.failed) {
      failures.add('an unrecognised command was not treated as a failure');
    }

    if (failures.isNotEmpty) {
      stderr.writeln('DOC COMMANDS SELF-TEST: FAIL');
      for (final f in failures) {
        stderr.writeln('  - $f');
      }
      return 1;
    }
    stdout.writeln('DOC COMMANDS SELF-TEST: PASS —');
    stdout.writeln('   (i)   the shipped `--mock-datapoints` line is rejected, '
        'by name, against the image\'s own --help');
    stdout.writeln('   (ii)  the repaired `--insecure` line is clean');
    stdout.writeln('   (iii) a command shape this checker cannot verify FAILS '
        'rather than passing silently');
    return 0;
  } finally {
    dir.deleteSync(recursive: true);
  }
}

void main(List<String> args) {
  if (args.contains('--self-test')) {
    exit(selfTest());
  }
  exit(run(Directory.current.path, list: args.contains('--list')));
}
