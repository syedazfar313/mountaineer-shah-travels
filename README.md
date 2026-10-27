# Mountaineer Shah Travels - Flutter Web (Phase 1)

Frontend only. Local mock data; no Firebase, real authentication, payments, or booking submission.

## Set up (first time)

Flutter source files are provided without platform scaffolding. Generate it, then merge:

```bash
flutter create mountaineer_shah_travels --platforms=web
# Copy this project's lib/, test/, pubspec.yaml, analysis_options.yaml, and .gitignore
# over the generated project (replace its default lib/ and test/).
cd mountaineer_shah_travels
flutter pub get
dart format .
flutter analyze
flutter test
flutter run -d chrome
```

## Configuration (optional)

```bash
flutter run -d chrome --dart-define=WHATSAPP_URL=https://wa.me/YOUR_NUMBER
```

Also supported: `FACEBOOK_URL`, `INSTAGRAM_URL`, `YOUTUBE_URL`, `TIKTOK_URL`.

## Progress

- [x] Milestone 2: Foundation (theme, tokens, routing, responsive helpers, logo, tests)
- [ ] 3 Shared components
- [ ] 4 Homepage
- [ ] 5 Destinations
- [ ] 6 Tour packages
- [ ] 7 Booking UI
- [ ] 8 Auth UI
- [ ] 9 Customer dashboard
- [ ] 10 Admin dashboard
- [ ] 11 Remaining pages
- [ ] 12 Polish and QA
