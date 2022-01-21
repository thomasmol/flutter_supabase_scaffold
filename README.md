# Flutter + Supabase Scaffold

This is is a scaffold/template for your Flutter project that uses Supabase as a backend.
[Supabase](https://supabase.com/) is an open-source Backend-as-a-Service, an alternative to Firebase. 

This scaffold is made to get you started quickly with your Flutter app that uses Supabase as a backend. Stop wasting time setting up authentication pages, profile pages and localization by using this template! 

## ⚡️ Features
* User accounts with password-based authentication
* Logging in and registration of new users in app
* Password recovery in app
* User profiles with first name, last name and avatar
* Localization out of the box
* Splash page, welcome page and home page to start your app
* Protected pages with built-in redirect
* Based on the official [Flutter skeleton template](https://github.com/flutter/flutter/tree/master/packages/flutter_tools/templates/skeleton)
* Adheres to [community best practices](https://medium.com/flutter-community/flutter-best-practices-and-tips-7c2782c9ebb5) for Flutter apps 


## 🛠 How to use
### Setting up Supabase project
1. Create a new Supabase project on https://app.supabase.io

2. Run these SQL commands to setup the database:

You can run and save these SQL scripts in the SQL editor in your Supabase project.

#### 👤 Set up the profile table, add columns any columns you need
```sql
CREATE TABLE public.profiles (
    id uuid REFERENCES auth.users NOT NULL,
    first_name varchar(255),
    last_name varchar(255),
    avatar_url varchar(255),    
    created_at timestamp(0) with time zone DEFAULT now() NOT NULL,
    updated_at timestamp(0) with time zone DEFAULT now() NOT NULL,
    primary key (id)
);
```

#### 🪣 Set up a storage bucket for the profile avatar/picture
```sql 
insert into storage.buckets (id, name, public)
values ('avatars', 'avatars', true);

create policy "Anyone can upload an avatar."
  on storage.objects for insert
  with check ( bucket_id = 'avatars' );
```

#### 🔒 Set up Row Level Security (RLS) for the profiles table
```sql
ALTER TABLE
  public.profiles ENABLE ROW LEVEL SECURITY;

create policy "Public profiles are viewable by every authenticated user." on profiles for
select
  using (auth.role() = 'authenticated');

create policy "Users can insert their own profile." on profiles for
insert
  with check (auth.uid() = id);

create policy "Users can update own profile." on profiles for
update
  using (auth.uid() = id);
```

#### 🔁 Set up realtime
```sql
begin;
  drop publication if exists supabase_realtime;
  create publication supabase_realtime;
commit;
alter publication supabase_realtime add table profiles;
```

3. Clone/download this project to your machine
4. Run 
```bash 
flutter pub get
```

4. Setup your .env file

Change the filename of ```.env.example``` to ```.env```.
In your Supabase project go to ```settings > API ```, and copy the ```anon public``` key and paste it in the ```.env``` file as the `SUPABASE_ANON_KEY` environment variable. Copy your Supabase ```URL``` and paste it in the ```.env``` file as well, as the `SUPASBASE_URL` environment variable.

5. Run your Flutter app

## ⚙️ Configuration
Be sure to change the name of your project in the `pubspec.yaml`, Android `AndroidManifest.xml` file and the iOS `Info.plist` file.

You can easily generate app icons for all screensizes and platforms by replacing the `icon.png` image with your own in the `assets/images` directory and running the command:
```bash
flutter pub run flutter_launcher_icons:main
```
Be sure to change the `icon.svg` as well.

Add different locales in the `assets/localization` directory by creating `.arb` files. Use the `app_en.arb` as a template.

## 📦 Package dependencies

This template depends on several third party packages:

* [intl](https://pub.dev/packages/intl)
  * For localization
* [flutter_svg](https://pub.dev/packages/flutter_svg)
  * To display svg images in the app
* [supabase_flutter](https://pub.dev/packages/supabase_flutter)
  * For Supabase support
* [image_picker](https://pub.dev/packages/image_picker)
  * So users can pick an image from their photo gallery/library as a avatar
* [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons)
  * To easily generate app icons for both Android and iOS devices
* [flutter_dotenv](https://pub.dev/packages/flutter_dotenv)
  * To enable the use of `.env` files and use environment variables
* [email_validator](https://pub.dev/packages/email_validator)
  * A simple class to validate email addresses

## 👨‍💻 About author

My personal [website](https://thomasmol.com)

My [Twitter](https://twitter.com/thomas_a_mol)