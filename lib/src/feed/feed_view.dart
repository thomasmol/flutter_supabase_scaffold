import 'package:flutter/material.dart';
import 'package:flutter_supabase_scaffold/src/utils/auth_required_state.dart';

class FeedView extends StatefulWidget {
  const FeedView({Key? key}) : super(key: key);
  static const String routeName = '/feed';
  static const String title = 'Feed';

  @override
  _FeedViewState createState() => _FeedViewState();
}

class _FeedViewState extends AuthRequiredState<FeedView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const Text('Feed view');
  }
}
