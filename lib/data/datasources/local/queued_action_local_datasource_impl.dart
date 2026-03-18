import 'dart:convert';
import 'dart:io';

import '../../../core/common/result.dart';
import '../../models/queued_action_model.dart';
import '../interfaces/queued_action_datasource.dart';

/// Simple file-backed queued action store for offline mode.
/// Stores queued actions as a JSON array in `queued_actions.json` in
/// the current working directory. This avoids adding new Drift tables
/// during the offline refactor and keeps the implementation simple.
class QueuedActionLocalDatasourceImpl extends QueuedActionDatasource {
  final File _file = File('queued_actions.json');

  Future<List<Map<String, dynamic>>> _readAll() async {
    if (!await _file.exists()) return [];
    final text = await _file.readAsString();
    if (text.trim().isEmpty) return [];
    final list = json.decode(text) as List<dynamic>;
    return list.cast<Map<String, dynamic>>();
  }

  Future<void> _writeAll(List<Map<String, dynamic>> list) async {
    await _file.writeAsString(json.encode(list));
  }

  @override
  Future<Result<int>> createQueuedAction(QueuedActionModel queue) async {
    try {
      final all = await _readAll();
      all.add(queue.toJson());
      await _writeAll(all);
      return Result.success(data: queue.id);
    } catch (e) {
      return Result.failure(error: e);
    }
  }

  @override
  Future<Result<void>> deleteQueuedAction(int id) async {
    try {
      final all = await _readAll();
      all.removeWhere((e) => e['id'] == id);
      await _writeAll(all);
      return Result.success(data: null);
    } catch (e) {
      return Result.failure(error: e);
    }
  }

  @override
  Future<Result<QueuedActionModel?>> getQueuedAction(int id) async {
    try {
      final all = await _readAll();
      final found = all.firstWhere((e) => e['id'] == id, orElse: () => {});
      if (found.isEmpty) return Result.success(data: null);
      return Result.success(data: QueuedActionModel.fromJson(found));
    } catch (e) {
      return Result.failure(error: e);
    }
  }

  @override
  Future<Result<List<QueuedActionModel>>> getAllUserQueuedAction() async {
    try {
      final all = await _readAll();
      final list = all.map((e) => QueuedActionModel.fromJson(e)).toList();
      return Result.success(data: list);
    } catch (e) {
      return Result.failure(error: e);
    }
  }
}
