class MessageRepository {
  Future<String> getMessage() async {
    await Future.delayed(const Duration(seconds: 2));
    return 'Hello from Repository';
  }
}