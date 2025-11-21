# 🍳 CookAlong TV – README
## 📺 Overview
```
CookAlong TV is a modern, gamified cooking companion designed for tvOS 16+.
It transforms cooking into an engaging living-room experience with:

XP progression

Chef ranks

Achievement badges

Per-step cooking timers

Voice narration

Category-based challenges

Beautiful, premium UI

This app is built for Apple TV, designed with an intuitive focus-driven interface and a visually polished design inspired by casual game UIs and elegant cooking apps.
```

# 🎯 Key Features
## 🧑‍🍳 1. Gamification System
```
XP earned per recipe

Difficulty multipliers

Timer accuracy bonuses

Chef Ranks: Apprentice → Legendary

Over 12 unlockable achievements

Category-based badges
```

# ⏱ 2. Smart Timers
```
Per-step timers

“Perfect Timer” bonus when advancing within 3 seconds

Visual countdown

Auto-detection when time ends
```

# 🎤 3. Voice Narration
```
Step narration using text-to-speech

“Let’s start cooking” introduction

“Next step” prompts at each stage
```

# 🍽 4. Recipe System (CoreData)
```
Saving completed recipes

Tracking repeat cooks

Category streaks

Completion badge shown in recipe list
```

# 🥗 5. Premium UI
```
Gradient backgrounds

Animated focus scaling (tvOS style)

Glass cards

Modern recipe tiles

Celebratory confetti animations
```

# 🏆 6. Achievements Page
```
Displays unlocked + locked badges

Supports 2-column responsive grid

Clean, game-like badge visuals
```

# 🎉 7. Finishing Screen
```
Confetti celebration

Narrated congratulations

Auto-return to home

Option to restart recipe
```

# 🛠 Technologies Used
```
Feature	Technology
UI	SwiftUI (tvOS)
Data Persistence	CoreData
Gamification State	UserDefaults
Narration	AVSpeechSynthesizer
Animations	SwiftUI Animations + Custom Confetti
Navigation	NavigationStack (tvOS)
Focus Engine	.focusable(...)
```

# 📁 Project Structure (heirachy)
```shell
CookAlongTV/
 ├── CookAlongTVApp.swift
 ├── PersistenceController.swift
 ├── Models/
 │     ├── Recipe.swift
 │     ├── GamificationManager.swift
 │     └── CompletedRecipe (Core Data Entity)
 ├── Views/
 │     ├── HomeView.swift
 │     ├── RecipeListView.swift
 │     ├── RecipeDetailView.swift
 │     ├── StepView.swift
 │     ├── AchievementsView.swift
 │     └── ConfettiView.swift
 ├── Data/
 │     └── SampleRecipes.swift
 └── Resources/
       └── Assets.xcassets (recipe images)
```

# 🧩 How to Build and Run the Application (tvOS 16+)

- Follow these steps exactly — this is viva-ready.

✅ 1. Install Xcode
```
Requires Xcode 14 or later

tvOS target: tvOS 16 or higher
```

## ✅ 2. Open the Xcode Project FIle
## ✅ 3. View In Xcode 
## ✅ 4. Press Play Button to run on simulator


# 🧪 Testing
```
Manual navigation tests
Timer accuracy tests
Achievement unlock scenarios
Core Data persistence tests
Gamification XP/level progress tests
```
