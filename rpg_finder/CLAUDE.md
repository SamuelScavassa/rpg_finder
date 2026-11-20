# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

RPG Finder is a Flutter app (Dart SDK `>=2.19.5 <3.0.0`) for finding tabletop RPG campaigns. Game masters ("mestres") post campaigns, players search them by tag, request to join, and chat. The backend is Firebase only (Auth and Cloud Firestore); there is no custom server. Code identifiers, Firestore fields and UI text are in Portuguese. A project spec PDF is at `../RPG-Finder.pdf`.

## Commands

```bash
flutter pub get          # install dependencies
flutter run -d chrome    # run (Firebase is initialised with web FirebaseOptions in lib/main.dart)
flutter analyze          # lint (flutter_lints, analysis_options.yaml)
flutter test             # no test/ directory exists yet
flutter test test/some_test.dart   # run a single test file
dart run flutter_native_splash:create   # regenerate the splash screen from the pubspec config
```

`firebase_core`, `cloud_firestore`, `firebase_auth` and `url_launcher` are listed under `dev_dependencies` in `pubspec.yaml` even though app code imports them. Keep that in mind if you change dependencies.

## Architecture

- `lib/main.dart` initialises Firebase with a hard-coded `FirebaseOptions`. Android also has `android/app/google-services.json`.
- `lib/app.dart` contains the `MaterialApp` with the named-route table. The initial route is `/login` when `FirebaseAuth.currentUser` is null and `/feed` otherwise.
- `lib/controllers/` holds top-level functions, not classes or state-management objects. Views call them directly. They do the Firestore/Auth writes, navigation (`navigationController.dart` wraps `popAndPushNamed`), and dialogs (`popUpsController.dart`). Each controller declares its own global `firestore` / `auth` instance.
- `lib/views/` has the screens (`user/`, `campanha/`, `chat/`). Reads are mostly `StreamBuilder`s on Firestore queries inside the views. Detail screens are pushed with `MaterialPageRoute` and get a Firestore document passed in, rather than going through named routes.
- `lib/app_theme.dart` holds the shared `ThemeData`.

## Firestore data model

All business logic depends on how these collections relate:

- **`campanha`** is a public campaign listing. Fields: `nome`, `descricao`, `discord`, `tags`, `user` (master's uid), `players`, `disable`.
  - **The `disable` flag is inverted.** `disable: true` means the campaign is *open* and appears in the feed and search (both filter `where('disable', isEqualTo: true)`). `disable: false` means it is full or finished.
  - `players` is the number of **open slots remaining**, not the number of players. Accepting a player decrements it, and the campaign is closed (`disable: false`) when it reaches 0.
- **`sessoes`** is the running session for a campaign. Each campaign gets one, created together with it in `salvarCampanha`. Fields: `campanha` (campaign id), `mestre`, `mestre-name`, `players-id`, `players-name`, `campanha-name`. The "ativas" (the master's own) and "participando" screens query this collection.
- **`invites`** holds join requests from a player to a campaign. Accepting one adds the player to the `sessoes` arrays, updates `campanha.players`/`disable`, and deletes the invite.
- **`chat`** holds messages tagged with `campanha`, ordered by the `order` field.
- **`finalizadas`** is the history. `finalizarCampanha` copies the session here, then deletes the `sessoes` doc and that campaign's `chat` docs.
- **`usuario`** stores user profiles, keyed by Auth uid. Note that `checkUserEmail` queries a different collection, `user`.

Multi-document updates (create, accept, leave, finalize, delete) run as sequential awaits, not batches or transactions. Make sure `campanha` and `sessoes` stay consistent when you change any of these flows.
