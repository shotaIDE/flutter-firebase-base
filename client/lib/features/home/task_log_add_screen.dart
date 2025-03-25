import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:house_worker/models/task.dart';
import 'package:house_worker/repositories/task_repository.dart';
import 'package:house_worker/services/auth_service.dart';
import 'package:intl/intl.dart';

class TaskLogAddScreen extends ConsumerStatefulWidget {
  const TaskLogAddScreen({super.key});

  @override
  ConsumerState<TaskLogAddScreen> createState() => _TaskLogAddScreenState();
}

class _TaskLogAddScreenState extends ConsumerState<TaskLogAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _iconController = TextEditingController();

  DateTime _completedAt = DateTime.now();

  @override
  void dispose() {
    _titleController.dispose();
    _iconController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(authServiceProvider).currentUser;
    final dateFormat = DateFormat('yyyy/MM/dd HH:mm');

    return Scaffold(
      appBar: AppBar(title: const Text('家事ログ追加')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 家事ログの名前入力欄
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: '家事ログの名前',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '家事ログの名前を入力してください';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 家事ログのアイコン入力欄
              TextFormField(
                controller: _iconController,
                decoration: const InputDecoration(
                  labelText: '家事ログのアイコン',
                  border: OutlineInputBorder(),
                  hintText: 'アイコン名を入力',
                ),
              ),
              const SizedBox(height: 16),

              // 家事ログの完了時刻入力欄
              ListTile(
                title: const Text('完了時刻'),
                subtitle: Text(dateFormat.format(_completedAt)),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDateTime(context),
              ),
              const SizedBox(height: 16),

              // 家事ログの実行したユーザー表示
              ListTile(
                title: const Text('実行したユーザー'),
                subtitle: Text(currentUser?.displayName ?? 'ゲスト'),
                leading: const Icon(Icons.person),
              ),
              const SizedBox(height: 24),

              // 登録ボタン
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    '家事ログを登録する',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _completedAt,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_completedAt),
      );

      if (pickedTime != null) {
        setState(() {
          _completedAt = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final currentUser = ref.read(authServiceProvider).currentUser;

      if (currentUser == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('ユーザー情報が取得できませんでした')));
        return;
      }

      // 新しいタスクを作成
      final newTask = Task(
        id: '', // 新規タスクの場合は空文字列を指定し、Firestoreが自動的にIDを生成
        title: _titleController.text,
        description: null, // カテゴリー欄を削除したのでnullに設定
        createdAt: DateTime.now(),
        completedAt: _completedAt,
        createdBy: currentUser.uid,
        completedBy: currentUser.uid,
        isShared: true, // デフォルトで共有
        isRecurring: false, // 家事ログは繰り返しなし
        priority: 2, // デフォルト値として「中」を設定
        isCompleted: true, // 家事ログは完了済み
      );

      try {
        // タスクを保存
        await ref.read(taskRepositoryProvider).save(newTask);

        // 保存成功メッセージを表示
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('家事ログを登録しました')));

          // 一覧画面に戻る（更新フラグをtrueにして渡す）
          Navigator.of(context).pop(true);
        }
      } catch (e) {
        // エラーメッセージを表示
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('エラーが発生しました: $e')));
        }
      }
    }
  }
}
