# Women's Workout App: Development Plan

2026-10-07

## Summary and settled decisions

This is an iOS 17+ workout assistant for women, built in SwiftUI with Firebase email/password login and a user profile. Workout logs stay on the device. The app serves two goals: the course rubric and an App Store release.

| Area | Decision |
| --- | --- |
| Platform | Xcode, Swift, SwiftUI, iOS 17+ |
| Auth | Firebase Auth, email and password, with password reset |
| Profile | Firestore `users/{uid}` text fields plus a photo stored on the device (camera or library) |
| Workout data | Local SwiftData, scoped per user, with UUID and `updatedAt` on every record so cloud sync can be added later |
| Cycle data | Local only. Period start and end logging, light-intensity tip for the first days |
| Exercise list | Bundled JSON: name, muscles, default sets, default reps, default weight. Users can edit defaults |
| Body art | Front and back full-body image with one transparent layer per muscle, highlighted by tint |
| Units | lb and kg toggle in Settings, default lb |
| Exercise types | Sets, reps, weight, plus duration and distance for cardio and bodyweight |
| Reminders | Local notifications. Days (Monday to Sunday) and time chosen when creating the profile |
| Frameworks for the rubric | Animation (muscle layer transitions) and Local Notifications |
| HealthKit | Not in v1 |
| Release | App Store, so a privacy policy, privacy labels and in-app account deletion are required |
| Deferred | Friends and activity feed (Firestore), cloud sync of workout logs |

## Rubric compliance

The plan covers three of the five major elements (the rubric needs two) and every minor element. Core Data and multithreading are not claimed.

| Requirement | How the app meets it |
| --- | --- |
| Custom fonts, colors, styles | `Theme` file with color tokens, two bundled fonts, shared components. Only the nav bar and Settings form stay default. |
| Edit and delete everything created | Profile (edit, delete account), workout sessions and sets, custom exercises, custom workouts, body metric entries, cycle entries, exercise default overrides (edit and reset). |
| No crashes, no missing features | No force unwraps, permission-denied states, empty states, device testing. See the crash-proofing section. |
| Swift Coding Standard | Checklist section below, applied in every file. |
| Settings screen, 2+ behaviors with defaults | Units (default lb), appearance (default system), accent theme (default preset), cycle tips (default on). Stored with `@AppStorage`. |
| Major: Firebase email/password | Register, login, forgot password, sign out, re-authenticate before delete. |
| Major: user profile | Create after register, camera or library photo, edit, delete. |
| Major: SwiftUI | Entire UI. |
| Major: Core Data, multithreading | Not claimed. SwiftData is used for storage, and it is unconfirmed whether the instructor counts it as Core Data. |
| Minor: two other view types | `DatePicker` (cycle, reminder time), `Stepper` (sets, reps), segmented `Picker` (front or back, units), `Toggle` (settings), `.searchable` (Explore). |
| Minor: Table, Collection, Tab or Page VC | `TabView` with five tabs, `LazyVGrid` calendar, `List` logs. Assumes the SwiftUI equivalents count. |
| Minor: alerts, scroll views, haptics or User Defaults | Delete confirmations, `ScrollView`, haptic on set completion, `@AppStorage`. |
| Minor: one listed framework | Animation (muscle layer transitions) and Local Notifications (workout reminder). |

## Architecture

Firebase holds identity and profile text; logs and cycle data stay on the device.

```
SwiftUI views: Auth, Today, Calendar, Trends, Explore, Me, Settings
   |                |                 |                 |
Auth service    Profile service    Data service      Reminders
sign in,        profile, photo     logs, cycle,      schedules alerts
register              |            JSON                    |
   |             +----+----+           |                  |
Firebase Auth  Firestore  Device     SwiftData        Notifications
(cloud)        (cloud)    photo      logs and cycle   iOS, on device
                          (device)   (device)         (device)
```

The views call four services. Only sign-in and profile text reach Firebase. Workout logs, body metrics and cycle data are read from and written to the device.

- Each service is an observable class injected through the SwiftUI environment, so views hold no storage logic. If the course requires a specific pattern, this layer adapts to it (open question 9).
- Every SwiftData query filters by the signed-in user's `ownerUID`.
- Each type lives in its own file, grouped in folders: `Views`, `Services`, `Models`, `Theme`, `Resources`.

## Data model

Every user-created record carries `id` (UUID), `ownerUID` and `updatedAt`, so two accounts on one phone never mix data and cloud sync can be added later. Weights are stored in kilograms and converted for display.

| Entity | Stored in | Fields |
| --- | --- | --- |
| `UserProfile` | Firestore `users/{uid}` plus a local photo file | displayName, optional goal, reminderEnabled, reminderWeekdays (1 to 7), reminderTime, createdAt, updatedAt |
| `Muscle` | Code (enum) | One case per body region. Raw values equal the layer asset names. |
| `ExerciseDefinition` | Bundled JSON, read only | id, name, type (strength, bodyweight, cardio), primaryMuscles, secondaryMuscles, defaultSets, defaultReps, defaultWeight, defaultDurationMinutes, defaultDistance |
| `ExerciseOverride` | SwiftData | ownerUID, exerciseID, sets, reps, weightKg. Read first, then fall back to the JSON default. |
| `CustomExercise` | SwiftData | Same fields as `ExerciseDefinition`, ownerUID, local only |
| `PrebuiltWorkout` | Bundled JSON, read only | id, name, ordered exercise ids |
| `WorkoutTemplate` | SwiftData | ownerUID, name, ordered exercise ids. The user's own workouts, local only. |
| `WorkoutSession` | SwiftData | ownerUID, date, template name, notes |
| `SetEntry` | SwiftData | sessionID, exerciseID, order, weightKg, reps, durationSeconds, distanceMeters |
| `BodyMetric` | SwiftData | ownerUID, date, weightKg, bodyFatPercent (at least one required) |
| `CycleEntry` | SwiftData | ownerUID, periodStart, periodEnd |
| `CycleSettings` | SwiftData | ownerUID, averageCycleLength, periodLength, easyDays |

The JSON fields beyond your list (`id`, `type`, duration, distance) support cardio and stable references. The `PrebuiltWorkout` file is new: your plan says users can choose prebuilt workouts, and those need a source.

## Screens and navigation

A signed-out user sees the auth flow. A signed-in user sees five tabs. The root view switches on the Firebase auth state listener.

| Area | Screen | What it does | Edit and delete |
| --- | --- | --- | --- |
| Auth | Welcome, Register, Login, Forgot password | Email and password with validation and readable error messages | Not applicable |
| Auth | Profile setup | Display name, optional goal, photo (camera or library), reminder days (Monday to Sunday) and time | Edited later in Me |
| Tab 1 | Today | Pick a prebuilt or own workout, log sets, live body diagram, weight and body fat entry, cycle tip banner | Edit or delete any set or session, edit or delete today's metric |
| Tab 2 | Calendar | Month grid with stickers on workout days, period days marked, heat map toggle | Tap a day to open, edit or delete its sessions |
| Tab 3 | Trends | Weight and body fat chart, per-exercise estimated 1RM chart, PR list | Metric entries editable from a list below the chart |
| Tab 4 | Explore | Searchable exercise list, filter by muscle and type, tap to add to today, edit defaults | Edit defaults and reset to default. Create, edit, delete custom exercises and own workouts |
| Tab 5 | Me | Profile, cycle log and settings, Settings entry, sign out | Edit profile, delete profile and account, edit or delete cycle entries |
| Settings | Settings | Units, appearance, accent theme, cycle tips | Not applicable |

Deleting an account removes the Firestore profile, the local data and the Firebase user, and asks the user to sign in again first if the session is old.

## Feature specs

### Body diagram and animation

The diagram is one base body image (front and back) with one transparent layer per muscle on an identical canvas size, stacked in a `ZStack`. Each layer's tint and opacity come from an activation value between 0 and 1. A segmented control switches front and back.

- Logging a set fades the worked muscles in with `withAnimation(.easeInOut)`, followed by a short pulse on the muscles just hit.
- Deleting a set fades them back out.
- Switching to the heat map re-tints every layer. Switching front and back cross-fades the two stacks.
- With Reduce Motion on, the pulse is skipped and only a plain fade runs.

### Exercise JSON

The bundled file is read only. User edits to sets, reps and weight are saved as `ExerciseOverride` records, and a Reset button deletes the override. Weight is in kilograms. The values below are an example of the format only.

```json
{
  "id": "leg-extension",
  "name": "Leg Extension",
  "type": "strength",
  "primaryMuscles": ["quads"],
  "secondaryMuscles": [],
  "defaultSets": 3,
  "defaultReps": 12,
  "defaultWeight": 30
}
```

### Heat map

For each muscle, count sets logged in a rolling window (default 14 days) and weight primary muscles above secondary ones (starting at 1.0 and 0.5, both tunable). Divide by the largest muscle total to get the activation, and guard against a zero total. Muscles with no sets show as neglected.

### Trends

Weight and body fat use Swift Charts. Strength progress uses estimated one-rep max per exercise, so changes in reps count, with a PR flag when it reaches a new high.

```
1RM = w * (1 + r / 30)
```

Here w is the weight lifted and r is the reps in the set (the Epley formula).

### Cycle tracking

The user logs a period start and end. Day of cycle is days since the last period start plus one. While that day is within the "easy days" setting, Today shows a gentle banner suggesting lighter intensity. The next start is predicted as the last start plus the average cycle length and shown on the calendar. The tip is informational, not medical advice, and can be turned off in Settings. Cycle data never leaves the device.

### Workout reminders

- During profile setup the user picks any of Monday to Sunday and a time. Reminders are off until at least one day is selected.
- Notification permission is requested at that moment. If it is denied, the profile still saves with reminders off, and an alert explains how to enable them in iOS Settings.
- Each selected day becomes one repeating `UNCalendarNotificationTrigger` with a fixed identifier per weekday. Editing the profile cancels and replaces them.
- Signing in on a device reschedules them from the profile. Signing out or deleting the account removes all pending requests.
- A `UNUserNotificationCenterDelegate` shows the reminder when the app is open.
- The text stays generic and never mentions the cycle, because notifications show on the lock screen.

## Design system

Every screen draws its colors, fonts and shapes from one `Theme`, so the whole app stays custom and consistent. The fonts and palette are chosen (see Visual style below).

- **Colors:** semantic tokens (background, surface, textPrimary, textSecondary, accent, muscle highlight scale, period marker) with light and dark variants in the asset catalog. The accent token changes with the accent theme setting.
- **Fonts:** two bundled open-license fonts, one for display and one for body, registered in Info.plist under `UIAppFonts`. Styles (title, heading, body, caption, number) use `Font.custom(_:size:relativeTo:)` so Dynamic Type still works. A startup check confirms each font name resolves, so a typo cannot silently fall back to the system font.
- **Components:** `AppCard`, `PrimaryButton`, `SecondaryButton`, `AppTextField`, `StickerView`, `EmptyStateView`, each in its own file.
- **Default styling:** limited to the nav bar and the Settings form, which the rubric allows.

## Swift Coding Standard checklist

Every rule in the course's Coding Standard for Swift Programs maps to a concrete habit, checked in a final audit pass over all files.

| Rule in the standard | How the app follows it |
| --- | --- |
| Match the default Xcode format | Xcode's default layout and spacing throughout. This means `name: Type`, even though the standard's example shows `name:Type`, because its first rule says to follow Xcode's default. |
| Added code matches existing code | One style for the whole project. |
| Error checking and input validation | Empty fields (name, email, password, weight), wrong data types in numeric fields, division by zero (heat map totals, averages, 1RM), array index out of range (safe element access, never raw indexing on user data). |
| Variable, property and method names | camelCase starting lowercase, for example `speedOfCar`, `speedUp`. |
| Class names | Starting uppercase, for example `WorkoutSession`. |
| Blank lines | Never more than one in a row. |
| Comments | Every comment line starts with `//`. No `/* */` blocks. End-of-line comments are allowed. |
| Assignment spacing | Exactly one space on each side of `=`. |
| Indentation | A new level for every scope. |
| Braces | Opening brace on the same line as the statement (Xcode's default), everywhere. Closing brace on its own line, aligned with the statement. |
| Spaces | No more than one space between any two characters. |
| Declarations | One variable or property per declaration. No `var a: Int, b: Int`. |
| Class definitions | One type per `.swift` file. This is applied to every struct, enum and class, including each SwiftUI view. |

The audit pass searches for `/*`, double blank lines, comma-joined declarations, files with more than one type, and force unwraps.

## Build order

Logging comes before the visuals, because the diagram, calendar, heat map and trends all read from logged data. The rubric-critical Firebase and profile work comes first so it is never left to the end.

1. Project setup: Xcode project, Firebase through Swift Package Manager, `GoogleService-Info.plist`, `Theme`, bundled fonts.
2. Auth flow: register, login, forgot password, sign out, auth state listener.
3. Profile: setup after register, camera and library photo, edit, delete account with re-authentication, reminder days and time, and the notification scheduling service.
4. Models, bundled JSON seeding, and the Explore tab with default editing and reset.
5. Today: choose a prebuilt or own workout, log sets, edit and delete sets and sessions.
6. Body diagram layers wired to Today, with the animation.
7. Body metric logging with edit and delete.
8. Calendar with stickers.
9. Heat map.
10. Trends.
11. Cycle tracking, calendar overlay and the Today banner.
12. Settings: units, appearance, accent theme, cycle tips.
13. Crash-proofing pass and Coding Standard audit.
14. TestFlight, then App Store submission.

## Crash-proofing and release checklist

The rubric penalizes crashes during grading, so these checks run before anything is submitted.

### Before grading

- [ ] No force unwraps and no `try!` in app code.
- [ ] Camera button hidden when no camera exists (the simulator has none), and `NSCameraUsageDescription` set.
- [ ] Denied camera or notification permission shows an alert that points to iOS Settings.
- [ ] Firebase errors (wrong password, email in use, weak password, no network) show readable messages.
- [ ] Account deletion handles an expired session by asking the user to sign in again.
- [ ] Every numeric field rejects empty, non-numeric and negative input.
- [ ] Array access and divisions are guarded.
- [ ] Every screen has an empty state, tested with a brand-new account.
- [ ] Deleting a session also deletes its sets.
- [ ] Tested on a real device in light and dark mode, at small and large phone sizes, and in airplane mode.

### Before App Store submission

- [ ] Apple Developer Program membership active.
- [ ] Privacy policy URL published, and App Privacy answers completed in App Store Connect.
- [ ] In-app account deletion works end to end (Apple requires it for apps with accounts).
- [ ] Licenses for the exercise list and body art confirmed to allow bundling in a released app.
- [ ] "Not medical advice" note on the cycle tip and workout guidance.
- [ ] App icon, screenshots and description prepared.

## Open questions

Nine items are still open. The plan does not guess at any of them.

1. **Body art:** what format are the files, and are they already split into one layer per muscle, or is it one flattened front image and one back image? If flattened, the layers must be cut before step 6.
2. **Exercise list:** which source and license, and is it already in the JSON shape above?
3. **Prebuilt workouts:** who writes the content of the prebuilt workout list (names and exercises)? Today's workout view needs it.
4. **Easy days:** should the default for the cycle tip be days 1 to 3 of the period, editable by the user?
5. **Fonts and palette:** decided. Soft pastel palette, Quicksand and DM Sans. See Visual style below. Dark-mode values are still to be proposed and approved.
6. **Apple and Firebase:** is the Apple Developer Program membership active, and is the Firebase project already created?
7. **Instructor check:** does SwiftData count as Core Data, and do `TabView` and a custom calendar grid count as Tab VC and Calendar? The plan does not depend on the answers.
8. **Deadline:** what is the due date for the graded version? The build order needs it.
9. **Required architecture:** does the course require a specific pattern such as MVVM?

## Visual style (chosen: soft pastel)

Titles and numbers use Quicksand (Medium, SemiBold, Bold). Body text uses DM Sans (Regular, Medium, Bold). Both are open-license fonts, bundled as static files. Read each file's PostScript name before writing the `Font` extension. Only the navigation bar and the Settings form keep default iOS styling.

| Token | Light value | Used for |
| --- | --- | --- |
| Background | `#FFF9F7` | Screen background |
| Surface | `#FFFFFF` | Cards and sheets |
| Blush | `#F4A7B9` | Main accent: buttons, selected tab, today marker |
| Rose | `#E0607E` | Strong highlight: most-trained muscles, period days, destructive actions |
| Lavender | `#D9CCF2` | Chips, lightly trained muscles |
| Sage | `#BFDCC8` | Workout-day stickers, success states |
| Ink | `#3A3040` | Primary text |
| Ink soft | `#857A8C` | Secondary text and hints |
| Divider | `#F0E6EA` | Lines and card borders |

Values taken from the mockups, not from the table above:

- Muscle heat scale: none `#E9DDE5`, low `#D9CCF2`, mid `#F4A7B9`, high `#E0607E`. Body base shape `#F6EDF1`.
- Accent presets in Settings: blush `#F4A7B9`, lavender `#D9CCF2`, sage `#BFDCC8`, warm yellow `#F9D9A8`.
- Dark-mode values for all tokens are not defined yet. They will be proposed and need approval before use.

## Screens and wireframe

Tab order: Today, Calendar, Trends, Explore, Me (Me is the fifth tab).

1. Welcome
2. Register
3. Log in
4. Forgot password
5. Profile setup
6. Today (tab 1)
7. Log sets
8. Body metrics (sheet)
9. Calendar (tab 2)
10. Heat map (toggle on Calendar)
11. Day detail (sheet)
12. Trends (tab 3)
13. Explore (tab 4)
14. Exercise detail
15. New exercise
16. Build workout
17. Me (tab 5)
18. Edit profile
19. Cycle log
20. Settings
21. Delete account (alert)

Flow:

```
Welcome -> Register -> Profile setup -> Today
Welcome -> Log in -> Today
Log in -> Forgot password
Today -> Log sets, Body metrics (sheet), Build workout
Calendar -> Heat map, Day detail (sheet)
Explore -> Exercise detail, New exercise
Me -> Edit profile -> Delete account (alert)
Me -> Cycle log
Me -> Settings
Me -> Sign out -> Welcome
Build workout also picks exercises from Explore
```

## Project setup decisions

- Profile text lives in Firestore at `users/{uid}`. Add the FirebaseAuth and FirebaseFirestore packages.
- The profile photo is stored on the device (camera or library). No Firebase Storage.
- Workout logs, body metrics and cycle data are stored in SwiftData on the device only.
- `GoogleService-Info.plist` comes from the Firebase console after registering the iOS app with the Xcode bundle ID. It must be added to the app target before Firebase can configure at launch.
- Remove the Xcode template files `ContentView.swift` and `Item.swift` only after the owner confirms.