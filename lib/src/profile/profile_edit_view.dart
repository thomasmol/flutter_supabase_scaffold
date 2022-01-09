import 'package:flutter/material.dart';
import 'profile_model.dart';
import '../utils/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileEditView extends StatefulWidget {
  const ProfileEditView({Key? key}) : super(key: key);
  static const String routeName = '/profile/edit';
  @override
  _ProfileEditViewState createState() => _ProfileEditViewState();
}

class _ProfileEditViewState extends State<ProfileEditView> {
  late Future<Profile> profile;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameTextController =
      TextEditingController();
  final TextEditingController _lastNameTextController = TextEditingController();

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

  Future<void> _saveProfile() async {
    setState(() {
      _isLoading = true;
    });
    final response = await supabase.from('profiles').upsert({
      'id': supabase.auth.user()!.id,
      'first_name': _firstNameTextController.text,
      'last_name': _lastNameTextController.text
    }).execute();
    final error = response.error;
    if (error != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.message)));
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  Future<void> _uploadAvatar() async {
    final _picker = ImagePicker();
    final imageFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 300,
      maxHeight: 300,
    );
    setState(() => _isLoading = true);
    if (imageFile == null) {
      setState(() => _isLoading = false);
      return;
    }

    final bytes = await imageFile.readAsBytes();
    final fileExt = imageFile.path.split('.').last;
    final fileName = '${DateTime.now().toIso8601String()}.$fileExt';
    final filePath = fileName;
    final response =
        await supabase.storage.from('avatars').uploadBinary(filePath, bytes);

    if (response.error != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response.error!.message)));
      return;
    }
    final imageUrlResponse =
        supabase.storage.from('avatars').getPublicUrl(filePath);

    final responseProfile = await supabase
        .from('profiles')
        .update({'avatar_url': imageUrlResponse.data}).execute();

    setState(() => _isLoading = false);
    if (response.error != null && responseProfile.status != 406) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response.error!.message)));
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context)!;
    final profileBuilder = FutureBuilder(
      future: profile,
      builder: (BuildContext context, AsyncSnapshot<Profile> snapshot) {
        if (snapshot.hasData) {
          String? imageUrl = snapshot.data!.avatarUrl;
          _firstNameTextController.text = snapshot.data!.firstName;
          _lastNameTextController.text = snapshot.data!.lastName;
          return Column(
            children: [
              Stack(alignment: Alignment.bottomRight, children: <Widget>[
                CircleAvatar(
                  radius: 60,
                  foregroundImage:
                      imageUrl != null ? NetworkImage(imageUrl) : null,
                  backgroundColor: Colors.grey.shade200,
                  child: Text(
                      '${snapshot.data!.firstName[0]}${snapshot.data!.lastName[0]}'),
                ),
                FloatingActionButton(
                  onPressed: _uploadAvatar,
                  child: const Icon(Icons.photo_camera, size: 20),
                  mini: true,
                )
              ]),
              AutofillGroup(
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 36.0, vertical: 10),
                          child: TextFormField(
                            autofocus: true,
                            controller: _firstNameTextController,
                            keyboardType: TextInputType.text,
                            autofillHints: const [AutofillHints.givenName],
                            textInputAction: TextInputAction.next,
                            decoration:
                                InputDecoration(labelText: t.authFirstName),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return t.authInvalidNameMessage;
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 36.0, vertical: 10),
                          child: TextFormField(
                            controller: _lastNameTextController,
                            keyboardType: TextInputType.text,
                            autofillHints: const [AutofillHints.familyName],
                            textInputAction: TextInputAction.next,
                            decoration:
                                InputDecoration(labelText: t.authLastName),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return t.authInvalidNameMessage;
                              }
                              return null;
                            },
                          ),
                        ),
                        !_isLoading
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 36.0, vertical: 20),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      minimumSize: const Size.fromHeight(50)),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      _saveProfile();
                                    }
                                  },
                                  child:  Text(
                                    t.profileSaveProfileButton,
                                  ),
                                ),
                              )
                            : const CircularProgressIndicator(),
                      ],
                    )),
              )
            ],
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit profile'),
      ),
      body: profileBuilder,
    );
  }
}
