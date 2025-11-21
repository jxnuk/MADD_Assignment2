# 👾 SwiftRun AI — README
- An AI-powered endless-runner game built for iOS using SwiftUI + SpriteKit + CoreML.

# 📌 Overview
```
SwiftRun AI is a mobile endless runner game where the player runs continuously, avoiding enemies, shooting obstacles, and battling a boss.
The game includes:
Real-time parallax background
Dynamic difficulty scaling
Projectile shooting
Enemies and bosses
Player life system
Coins and scoring
Core Data run history
CoreML-based player performance predictions
Beautiful modern UI using glass effects
Settings with app-wide theme + persistent preferences
Built as an assignment project for Mobile Application Development (MADD).
```

# 🎮 Features
## 🕹 Gameplay
```
Running dino hero
Jump and shoot buttons
Parallax environment (sky, mountains, ground)
Enemy, obstacle, boss AI
Player health system
Dynamic speed & spawning difficulty
```

## 🧠 AI + Data
```
Core Data stores every run
ML prediction of:
Player skill level
Predicted next run distance
Run summary screen
Performance charts using Swift Charts
```

## ⚙️ Settings
```
App theme (System / Light / Dark)
Sound toggle (future-ready)
AI difficulty toggle
Clear run history
Reset app settings
```

# 📁 Project Heirarchy
``` shell
SwiftRunAI/
│
├── SwiftRunAIApp.swift         // App entry + Settings injection
├── ContentView.swift           // Root navigation container
│
├── Gameplay/
│   ├── GameView.swift          // Game UI + HUD + pause menu
│   ├── GameScene.swift         // SpriteKit gameplay logic
│   ├── GameStats.swift         // Struct for run results
│
├── ML/
│   ├── MLManager.swift         // CoreML prediction manager
│
├── Storage/
│   ├── Persistence.swift       // Core Data stack
│   ├── RunStorage.swift        // Run saving/loading + ML integration
│
├── UI/
│   ├── MainMenuView.swift
│   ├── SettingsView.swift
│   ├── StatsView.swift
│   ├── RunChartsView.swift
│   ├── RunSummaryView.swift
│   ├── HowToPlayView.swift
│   ├── CreditsView.swift
│
└── Assets/
    ├── player.png
    ├── enemy.png
    ├── boss.png
    ├── pole.png
    ├── mountain.png
    ├── sky1.png
    ├── sky2.png
```

# 🛠 Requirements
```
Xcode 15+
iOS 16+ (minimum deployment target)
Swift 5.9+
macOS with development access
```

# 🚀 How to Set Up & Run in Xcode
- Follow these steps when opening the project for the first time.
## 1️⃣ Clone or Download the Project
- Download the source as a .zip or clone via Git:
```
git clone <your-repo-url>
```

## 2️⃣ Open the Project
```
Open Xcode → File → Open → select:
SwiftRunAI.xcodeproj
Make sure the folder contains:
.xcodeproj
Source files
Assets
ML model (if added)
```

## 3️⃣ Configure Signing
```
Required for running on a real device.
Open:
Project Navigator → SwiftRunAI (blue icon)
Under Signing & Capabilities:
Choose your Team
Set Bundle Identifier to something unique:
com.yourname.SwiftRunAI
Xcode automatically handles provisioning.
```

## 4️⃣ Add Assets to the Game
```
Go to:
Assets.xcassets
Add the following images with exact names:
Use    Asset Name
Player    player
Enemy    enemy
Boss    boss
Obstacle    pole
Mountains    mountain
Sky layer    sky1
Sky layer 2    sky2
Drag & drop each PNG into the asset catalog.
```

## 5️⃣ Add the CoreML Model
```
If using CoreML prediction:
Add your .mlmodel file to your project
Xcode auto-generates Swift bindings
Ensure the model name matches:
SwiftRunSkillPredictor
If needed, regenerate the model — I can help.
```

## 6️⃣ Build & Run
```
▶ Run on Simulator
Select a simulator (e.g., iPhone 15 Pro) → Run
```

# 📱 Run on Real Device
```
Connect your iPhone via USB
Select your device from device list
Tap “Trust this Mac” on your phone
Hit Run
If you get a “Signing error”, set the team again and Xcode will handle it.
```

# 📉 If Gameplay Screen is Black
```
Usually means:
Scene images missing or misnamed
Scene size not filling view
GameView not creating scene on .onAppear
Check asset names first.
```

# 🤖 ML Setup Guide (Short Version)
```
To enable ML predictions:
Collect run data (distance, duration, coins, etc.)
Save to Core Data
Export as CSV (if training model)
Train CoreML model via CreateML
Add .mlmodel to Xcode
Update MLManager.swift to match your model outputs
Your app already handles:
averaging previous runs
sending features to ML
saving predictions into Core Data
displaying predictions on summary screen
```

# 🚀 Technologies Used in SwiftRun AI
- Below is a complete list of every major technology, framework, and system used in your iOS game — grouped clearly.

## 🎨 1. SwiftUI
```
SwiftUI is used for all the app’s UI screens, including:

Main menu

Game HUD

Settings

Stats & charts

Summary screen

Pause overlay

SwiftUI handles:

Navigation (NavigationStack)

Modern UI layouts

System-wide themes (dark/light/system)

Button interactions

Glass-style visual effects (.ultraThinMaterial)
```

## 🎮 2. SpriteKit
```
SpriteKit powers the actual gameplay:

Game loop (update())

Player physics

Enemies, boss, obstacles

Projectile shooting

Parallax backgrounds

Collision detection

Physics categories & bit masks

Smooth animations & movements

This is the engine that draws and updates the game world every frame.
```

## 🧠 3. CoreML
```
CoreML is used for machine learning predictions:

Predict player skill level

Predict next run distance

Uses your trained .mlmodel file

Automatically generates Swift classes like
SwiftRunSkillPredictor

MLManager handles:

Preparing inputs

Running predictions

Returning predictions for summary display
```

## 🗄️ 4. Core Data
```
Core Data stores all gameplay history:

Distance

Duration

Coins collected

Obstacles hit

Predicted skill

Predicted next distance

Core Data files:

PersistenceController.swift

RunStorage.swift

Entity: Run

Used for:

Saving every run

Fetching stats

Clearing history

Feeding ML training features
```

## 📊 5. Swift Charts
```
Swift Charts is used in your Performance Charts screen:

Line charts for distance over time

Bar charts for score per run

Clean visualization for panel demonstration

This is the modern iOS charting framework introduced in iOS 16.
```

## ⚙️ 6. UserDefaults
```
UserDefaults stores persistent settings, including:

AI difficulty toggle

Sound toggle

Theme preference

Reset-to-default options

Stored through your AppSettings class.
```

## 📱 7. UIKit (indirectly)
```
Used for:

Haptics (UINotificationFeedbackGenerator)

Some system UI behaviors behind‐the‐scenes

Your app remains SwiftUI-based, but relies on UIKit for device feedback.
```

## 🌁 8. Asset Catalog
```
Xcode’s asset system stores:

Player sprite

Boss sprite

Enemy sprite

Obstacle sprite

Background sky

Mountain layer

Any UI icons

All sprites are loaded by name through:

SKSpriteNode(imageNamed: "player")
```

## 🌈 9. Gameplay Logic & Physics
```
Powered by SpriteKit:

Gravity

Impulse-based jumping

Non-dynamic rigid bodies

Collision masks

Spawn timers

Difficulty scaling

Parallax movement
```

## 🔧 10. Xcode 15 Toolchain
```
Your project uses:

Swift 5.9

iOS 16+ deployment target

Asset catalogs

Swift Package Manager (built-in)

Auto-generated ML model code

Real-device debugging
```

# 🎁 Summary Table
```
Technology	Purpose
SwiftUI	UI, menus, HUD, layouts
SpriteKit	Gameplay engine, physics, animations
CoreML	Predicting skill & next distance
Core Data	Saving gameplay runs
Swift Charts	Performance analytics
UserDefaults	Settings persistence
UIKit (Haptics)	Tactile feedback
Xcode Asset Catalog	Storing game sprites
Swift / iOS SDK	Core language & platform APIs
```

# 🧪 Testing Checklist
```
Before submission, check:
All menus navigate correctly
GameScene resets correctly after death
Pause menu works
Theme toggle changes entire app
Clear History actually clears StatsView
ML predictions appear in summary (if model is added)
All sprites load correctly
```
