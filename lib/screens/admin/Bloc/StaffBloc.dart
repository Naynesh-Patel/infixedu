// Package imports:
import 'package:Saksham/screens/admin/Repository/StaffRepository.dart';
import 'package:Saksham/utils/model/LibraryCategoryMember.dart';
import 'package:rxdart/rxdart.dart';

// Project imports:


class StaffBloc {
  final _repository = StaffRepository();

  final _subject = BehaviorSubject<LibraryMemberList>();

  getStaff() async {
    LibraryMemberList members = await _repository.getStaff();
    _subject.sink.add(members);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<LibraryMemberList> get subject => _subject;
}

final bloc = StaffBloc();
