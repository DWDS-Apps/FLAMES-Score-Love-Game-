# FLAMES Love Score Game 🔥

A fun Flutter app that calculates the **FLAMES** compatibility score between two names.

## What is FLAMES?

FLAMES is a classic name-based compatibility game. The acronym stands for:

| Letter | Meaning     | Emoji |
| ------ | ----------- | ----- |
| **F**  | Friends     | 🤝   |
| **L**  | Lovers      | 💕   |
| **A**  | Affection   | 🥰   |
| **M**  | Marriage    | 💍   |
| **E**  | Enemy       | ⚔️   |
| **S**  | Siblings    | 👫   |

## How It Works

### Step 1 — Enter Two Names
Type in two names (e.g., "Alchie" and "Tagudin").

### Step 2 — Cancel Matching Letters
Each common letter cancels out between the two names. Only the **uncancelled** letters remain.

**Example:**
- Name 1: `ALCHIE` → letter counts: A:1, L:1, C:1, H:1, I:1, E:1
- Name 2: `TAGUDIN` → letter counts: T:1, A:1, G:1, U:1, D:1, I:1, N:1
- Cancelled: A cancels with A, I cancels with I
- Remaining: `LCHE` + `TGUDN` = **9 letters**

### Step 3 — Count & Eliminate
Take the total remaining letter count (e.g., **9**) and use it to eliminate letters from `FLAMES` one by one.

```
FLAMES  → 6 letters, count = 9
(9 - 1) % 6 = 2 → remove 'A' → FLMES

FLMES   → 5 letters, count = 9
(9 - 1) % 5 = 3 → remove 'E' → FLMS

FLMS    → 4 letters, count = 9
(9 - 1) % 4 = 0 → remove 'F' → LMS

LMS     → 3 letters, count = 9
(9 - 1) % 3 = 2 → remove 'S' → LM

LM      → 2 letters, count = 9
(9 - 1) % 2 = 0 → remove 'L' → M

Result: M → Marriage 💍
```

### Step 4 — Read the Result
The last remaining letter is your FLAMES score:

| Result    | Meaning                                      |
| --------- | -------------------------------------------- |
| **F** 🤝  | **Friends** — strong friendship bond         |
| **L** 💕  | **Lovers** — romantic connection             |
| **A** 🥰  | **Affection** — care and sweet feelings      |
| **M** 💍  | **Marriage** — long-term soulmate match      |
| **E** ⚔️  | **Enemy** — conflict and arguments           |
| **S** 👫  | **Siblings** — platonic brother-sister bond  |

## App Features

- 🎨 Clean, modern Material 3 UI
- ❤️ Romantic pink-themed design
- 📱 Responsive form with validation
- 🎯 Real-time FLAMES calculation
- 💬 Result card with emoji, meaning, and description
- 🔄 Try again with new names

## Tech Stack

- **Framework:** Flutter (Dart)
- **UI:** Material 3 Design
- **Platforms:** Android, iOS, Web, Linux, macOS, Windows

## Project Structure

```
lib/
├── main.dart                  # App entry point & theme
├── models/
│   └── flames_game.dart       # FLAMES calculation logic
├── screens/
│   └── home_screen.dart       # Main game UI
└── widgets/
    └── result_card.dart       # Result display widget
```

## Getting Started

### Prerequisites
- Flutter SDK 3.6+
- Dart SDK 3.6+

### Run the App

```bash
cd flames_love_game
flutter pub get
flutter run
```

### Build for Android

```bash
flutter build apk --release
```

### Build for Web

```bash
flutter build web
```

## Algorithm

The FLAMES algorithm is implemented in `lib/models/flames_game.dart`:

1. **Letter frequency counting** — counts each letter's occurrences in both names (case-insensitive, a-z only)
2. **Cancellation** — for each letter, takes the absolute difference of counts (cancels matching letters)
3. **Summation** — adds all differences to get total remaining letter count
4. **Elimination** — iteratively removes letters from `[F, L, A, M, E, S]` using `(count - 1) % length` as the index
5. **Result** — the last remaining letter is the score

---

*Made with ❤️ using Flutter*
