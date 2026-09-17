# 🎛️ Cyber-Tactile Control Studio (Flutter)

A sleek, interactive 3D Neomorphic smart room control deck built with Flutter & Dart, demonstrating micro-interactions and state management.

## ✨ Features

- **Smart Room Tactile Controls**: Five interactive controls for Desk Lamp, Fan, AC, Ambient Lighting, and All Off using `GestureDetector` and dual `BoxShadow` effects.
- **Live State Management**: Tracks total button presses, current system status, and power calibration in real time.
- **Power Overload Feedback**: The background changes when the power level crosses 80%.
- **Adaptive Theme System**: Supports both dark and light modes.
- **Modular Component Design**: Uses a reusable `TactileButton` widget for all smart room controls.
- **Long-Press Control**: Long pressing the All Off button shuts down all systems and changes the power level to 0%.

## 🛠️ Tech Stack

- **Framework**: Flutter (Material 3)
- **Language**: Dart
- **Key Widgets**: `StatefulWidget`, `GestureDetector`, `AnimatedContainer`, `Slider`, `Wrap`

## 🎨 Design Decisions

I chose a Smart Room Controller because the tactile button design feels similar to using physical switches and controls in a room.

I used different colors for each control so they are easy to recognize. The Desk Lamp uses amber, the Fan uses light blue, the AC uses cyan, and Ambient Lighting uses purple. I also added an All Off control in red because it represents a more important shutdown action.

For interactive feedback, the background changes when the power level goes above 80%, making the high-power state easy to notice.

As an extra interaction, I added a long-press action to the All Off button. A normal tap activates the control, while a long press shuts down all systems and changes the power level to 0%.