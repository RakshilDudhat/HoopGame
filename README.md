# 🏀 Hoop Game

[![Swift](https://img.shields.io/badge/Swift-5.7-orange.svg)](https://swift.org)
[![iOS](https://img.shields.io/badge/iOS-16.0+-blue.svg)](https://developer.apple.com/ios/)
[![Xcode](https://img.shields.io/badge/Xcode-14.0+-lightgrey.svg)](https://developer.apple.com/xcode/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

"Shoot, Score, and Swish!" - Hoop is a fun and engaging 2D basketball free throw game built with SpriteKit and SwiftUI, featuring multiple game modes, daily challenges, and a modular architecture.

## ✨ Features

- **Multiple Game Modes**: Classic Run, Daily Challenge, Endless Run, and Continue modes
- **Physics-Based Gameplay**: Realistic ball physics powered by SpriteKit
- **Ball Customization**: Choose from multiple ball styles and colors
- **Daily Challenges**: New challenges every day to keep gameplay fresh
- **Score Tracking**: Persistent high scores and game statistics
- **Responsive Design**: Optimized for various iOS devices
- **Modular Architecture**: Clean separation of concerns with Swift Package Manager

### Game Modes

| Mode | Description | Lives |
|------|-------------|-------|
| **Classic Run** | Standard gameplay with 3 attempts per round | 3 lives |
| **Daily Challenge** | Unique challenge that resets daily | 1 life |
| **Endless Run** | Unlimited gameplay - how long can you last? | Unlimited |
| **Continue** | Resume your previous Classic Run game | 3 lives |

## 🛠️ Prerequisites

Before you begin, ensure you have the following installed:

- **macOS Monterey (12.0)** or later
- **Xcode 14.0** or later
- **iOS 16.0** or later (for running on device)
- **Swift 5.7** or later
- **Git** (for cloning the repository)

## 🚀 Installation & Setup

### 1. Clone the Repository

```bash
git clone https://github.com/RakshilDudhat/HoopGame.git
cd Hoop
```

### 2. Open in Xcode

- Open Xcode
- Select "File" → "Open" → Navigate to the cloned directory
- Select the `Hoop.xcodeproj` file

### 3. Build and Run

1. **Select Target Device**: Choose your preferred iOS Simulator or connected device from the device menu
2. **Build**: Press `⌘B` or select "Product" → "Build"
3. **Run**: Press `⌘R` or click the "Run" button in the toolbar

The app will launch and you're ready to play! 🎉

## 🏗️ Project Architecture

This project follows a modular architecture using Swift Package Manager, separating concerns into focused packages:

```
Sources/
├── App/                    # Main application entry point
├── GameCore/              # Core game logic and models
├── GameBoard/             # SpriteKit game scene and physics
├── GameLanding/           # Welcome screen and game mode selection
├── GameScore/             # Score display and statistics
├── BallPicker/            # Ball customization interface
├── CoreService/           # Data persistence and user defaults
├── DesignSystem/          # UI components and design tokens
└── RoutingImpl/           # Navigation implementation
```

### Key Components

- **GameCore**: Contains game models, utilities, and core logic
- **GameBoard**: Handles SpriteKit scene management and physics simulation
- **CoreService**: Manages data persistence using CoreData and UserDefaults
- **DesignSystem**: Provides consistent UI components and styling

## 🎮 How to Play

1. **Launch the app** and select your preferred game mode
2. **Choose your ball** from the ball picker screen
3. **Tap and drag** to aim your shot
4. **Release** to shoot the ball toward the hoop
5. **Score points** by getting the ball through the hoop
6. **Complete challenges** and beat your high scores!

### Controls

- **Tap and Drag**: Aim your shot
- **Release**: Shoot the ball
- **Ball Picker**: Swipe through different ball styles
- **Game Modes**: Select from the landing screen

## 🧪 Testing

### Running Tests

1. **From Xcode**: Press `⌘U` or select "Product" → "Test"
2. **From Terminal**: Run `swift test` in the project root

### Test Coverage

The project includes unit tests for:
- Core game logic
- Data persistence
- UI components
- Game state management

## 🛠️ Development

### Code Style

This project uses Swift's standard formatting. For consistent code style:

```bash
# Format code (if you have SwiftFormat installed)
swiftformat .
```

### Adding New Features

1. **Plan your feature** in the appropriate package
2. **Create tests first** (TDD approach recommended)
3. **Implement the feature** following the existing patterns
4. **Update documentation** if needed

### Package Dependencies

The main app depends on several local Swift packages. To add new dependencies:

1. Edit the relevant `Package.swift` file
2. Add the dependency to the `dependencies` array
3. Add the product to the target's `dependencies`

## 📦 Tech Stack

- **SpriteKit**: 2D game physics and rendering
- **SwiftUI**: Modern declarative UI framework
- **CoreData**: Data persistence and storage
- **Swift Package Manager**: Dependency management and modularization
- **Combine**: Reactive programming for state management

## 🎯 Roadmap & Backlogs

- [ ] Add haptic feedback for enhanced user experience
- [ ] Implement sound effects and background music
- [ ] Add progressive difficulty levels based on player performance
- [ ] Introduce obstacles and power-ups to increase challenge
- [ ] Expand ball customization with more textures and effects
- [ ] Implement comprehensive test coverage for the entire codebase
- [ ] Add multiplayer functionality
- [ ] Create achievements and unlockable content
- [ ] Add game statistics and analytics

## 🐛 Troubleshooting

### Common Issues

**Build Fails**
- Ensure you're using Xcode 14.0 or later
- Clean build folder: `⌘⇧K` or "Product" → "Clean Build Folder"
- Delete derived data and restart Xcode

**Simulator Issues**
- Reset Simulator: "Device" → "Erase All Content and Settings"
- Update Simulator runtime in Xcode Preferences

**Physics Not Working**
- Ensure SpriteKit framework is properly linked
- Check that physics bodies are properly configured in the scene

### Getting Help

If you encounter issues:
1. Check the existing GitHub issues
2. Create a new issue with detailed information
3. Include Xcode version, iOS version, and error messages

## 🤝 Contributing

We welcome contributions! Here's how you can help:

1. **Fork the repository**
2. **Create a feature branch**: `git checkout -b feature/amazing-feature`
3. **Make your changes** and add tests
4. **Commit your changes**: `git commit -m 'Add amazing feature'`
5. **Push to the branch**: `git push origin feature/amazing-feature`
6. **Open a Pull Request**

### Contribution Guidelines

- Follow Swift naming conventions
- Add unit tests for new functionality
- Update documentation for API changes
- Ensure code builds without warnings
- Test on multiple device sizes

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **SpriteKit Community**: For excellent documentation and examples
- **StackOverflow**: For helping overcome SpriteKit learning challenges
- **SwiftUI Community**: For modern iOS development inspiration

## ✍️ Author

**Raxil Dudhat**
https://github.com/RakshilDudhat

---

**Enjoy playing Hoop! 🏀 If you find this project helpful, please give it a ⭐️**
