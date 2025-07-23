import '../../data/repositories/message_repository.dart';

class GetMessageUseCase {
  final MessageRepository _repo = MessageRepository();

  Future<String> call() async {
    return _repo.getMessage();
  }
}