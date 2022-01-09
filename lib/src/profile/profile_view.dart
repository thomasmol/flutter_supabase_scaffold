import 'package:flutter/material.dart';
import 'profile_edit_view.dart';
import 'profile_model.dart';
import '../settings/settings_view.dart';
import '../utils/auth_required_state.dart';
import '../utils/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);
  static const routeName = '/profile';
  static const title = 'Profile';

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends AuthRequiredState<ProfileView>
    with AutomaticKeepAliveClientMixin {
  late Future<Profile> profile;

  @override
  void initState() {
    super.initState();
    profile = _fetchProfile();
  }

  Future<Profile> _fetchProfile() async {
    final response = await supabase
        .from('profiles')
        .select()
        .eq('id', supabase.auth.user()!.id)
        .limit(1)
        .single()
        .execute();
    final error = response.error;
    if (error != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.message)));
    }
    return Profile.fromJson(response.data);
  }

  Future<void> _refresh() async {
    setState(() {
      profile = _fetchProfile();
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context)!;
    super.build(context);
    final profileBuilder = FutureBuilder(
      future: profile,
      builder: (BuildContext context, AsyncSnapshot<Profile> snapshot) {
        if (snapshot.hasData) {
          String? imageUrl = snapshot.data!.avatarUrl;
          return Column(
            children: [
              CircleAvatar(
                radius: 50,
                foregroundImage:
                    imageUrl != null ? NetworkImage(imageUrl) : null,
                child: Text(
                    '${snapshot.data!.firstName[0]}${snapshot.data!.lastName[0]}'),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                    '${snapshot.data!.firstName} ${snapshot.data!.lastName}',
                    style: const TextStyle(fontSize: 22)),
              ),
            ],
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );

    return Column(
      children: [
        profileBuilder,
        const Divider(),
        ListTile(
          leading: const Icon(Icons.edit),
          title: Text(t.profileEditProfileButton),
          onTap: () async {
            Navigator.of(context, rootNavigator: true)
                .push<void>(MaterialPageRoute(
              fullscreenDialog: true,
              builder: (context) => const ProfileEditView(),
            ))
                .then((value) {
              _refresh();
            });
          },
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: Text(t.settingsButton),
          onTap: () async {
            Navigator.pushNamed(context, SettingsView.routeName);
          },
        ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: Text(t.authLogoutButton),
          onTap: () async {
            final response = await supabase.auth.signOut();
            final error = response.error;
            if (error != null) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(error.message)));
            }
          },
        ),
      ],
    );
  }
}
