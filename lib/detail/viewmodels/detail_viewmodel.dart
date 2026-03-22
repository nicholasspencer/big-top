import 'package:state_notifier/state_notifier.dart';

import 'package:big_top/detail/interactors/issue_detail_selector.dart';

class DetailViewModel extends StateNotifier<IssueDetailState> {
  final IssueDetailSelector _selector;
  late final void Function() _removeListener;

  DetailViewModel({
    required IssueDetailSelector selector,
  })  : _selector = selector,
        super(selector.state) {
    _removeListener = _selector.addListener((s) => state = s);
  }

  @override
  void dispose() {
    _removeListener();
    _selector.dispose();
    super.dispose();
  }
}
