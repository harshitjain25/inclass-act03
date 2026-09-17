import 'package:flutter/material.dart';

// ============================================================================
// 1. MAIN ENTRY POINT
// ============================================================================
// Summary: Every Flutter app starts here. runApp() takes your root widget and
// attaches it to the screen, kicking off the framework's build-and-render pipeline.
// Reference: https://api.flutter.dev/flutter/widgets/runApp.html
void main() {
  runApp(const TactileDeckApp());
}

// ============================================================================
// 2. ROOT APPLICATION WIDGET (Manages Global Theme State)
// ============================================================================
// Summary: A StatefulWidget that owns the single source of truth for light/dark
// mode. MaterialApp reads isDarkMode to pick a theme, and onToggleTheme lets the
// child screen flip it via a callback.
// Reference: https://docs.flutter.dev/cookbook/design/themes
class TactileDeckApp extends StatefulWidget {
  const TactileDeckApp({super.key});

  @override
  State<TactileDeckApp> createState() => _TactileDeckAppState();
}

class _TactileDeckAppState extends State<TactileDeckApp> {
  // Global theme toggle variable (carried over from Activity 02!)
  bool isDarkMode = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cyber-Tactile Control Studio',
      debugShowCheckedModeBanner: false,

      // Apply Material 3 Dark or Light theme based on state
      theme: isDarkMode
          ? ThemeData.dark(useMaterial3: true)
          : ThemeData.light(useMaterial3: true),

      home: ControlDeckScreen(
        isDark: isDarkMode,

        // Callback function to toggle theme mode from child widget
        onToggleTheme: () => setState(() => isDarkMode = !isDarkMode),
      ),
    );
  }
}

// ============================================================================
// 3. MAIN DASHBOARD SCREEN (Stateful Controller)
// ============================================================================
// Summary: The screen users actually see. Its State object holds totalTaps,
// powerLevel, and systemStatus, and rebuilds the metrics card, status banner,
// buttons, and slider every time setState() runs.
// Reference: https://api.flutter.dev/flutter/material/Scaffold-class.html
class ControlDeckScreen extends StatefulWidget {
  final bool isDark;
  final VoidCallback onToggleTheme;

  const ControlDeckScreen({
    super.key,
    required this.isDark,
    required this.onToggleTheme,
  });

  @override
  State<ControlDeckScreen> createState() => _ControlDeckScreenState();
}

class _ControlDeckScreenState extends State<ControlDeckScreen> {
  // --- Mutable State Variables (Day 3 Core Concept!) ---
  int totalTaps = 0; // Increments on every button press
  double powerLevel = 65.0; // Controlled by the interactive slider
  String systemStatus = "READY"; // Displays latest activated command

  // Helper method to update dashboard state upon button press
  void _triggerAction(String actionName) {
    setState(() {
      totalTaps++;
      systemStatus = "$actionName ACTIVATED";
    });
  }

  // --------------------------------------------------------------------------
  // EXTRA CREDIT:
  // Long pressing the ALL OFF button performs a special shutdown action.
  // This demonstrates the onLongPress gesture callback.
  // --------------------------------------------------------------------------
  void _shutdownAll() {
    setState(() {
      totalTaps++;
      powerLevel = 0;
      systemStatus = "ALL SYSTEMS SHUT DOWN";
    });
  }

  @override
  Widget build(BuildContext context) {
    // ------------------------------------------------------------------------
    // MILESTONE 2 CUSTOMIZATION
    // When the power slider goes above 80%, the screen background changes
    // to provide immediate visual feedback that the system is in high power.
    // ------------------------------------------------------------------------
    final bool isOverload = powerLevel > 80;

    // Dynamic background color adapting to current theme and power level
    final screenBg = isOverload
        ? (widget.isDark ? const Color(0xFF3A1712) : const Color(0xFFFBE6DF))
        : (widget.isDark ? const Color(0xFF1E1F29) : const Color(0xFFE0E5EC));

    final cardBg = widget.isDark ? const Color(0xFF282A36) : Colors.white;

    return Scaffold(
      backgroundColor: screenBg,

      appBar: AppBar(
        title: const Text(
          "TACTILE CONTROL STUDIO",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,

        actions: [
          // Theme Toggle Button in the AppBar
          IconButton(
            icon: Icon(widget.isDark ? Icons.light_mode : Icons.dark_mode),
            tooltip: 'Toggle Theme',
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            // --- TOP STATUS METRICS CARD ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(20),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: widget.isDark ? 0.3 : 0.08,
                    ),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,

                children: [
                  // Total Taps Counter
                  Column(
                    children: [
                      const Text(
                        "TOTAL TAPS",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "$totalTaps",
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  // Vertical Divider Line
                  Container(
                    width: 1,
                    height: 40,
                    color: Colors.grey.withValues(alpha: 0.3),
                  ),

                  // Energy / Power Level Indicator
                  Column(
                    children: [
                      const Text(
                        "ENERGY LEVEL",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${powerLevel.toInt()}%",
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Live System Status Banner
            Text(
              "STATUS: $systemStatus",
              style: TextStyle(
                fontFamily: 'monospace',
                fontWeight: FontWeight.w600,
                color: widget.isDark ? Colors.tealAccent : Colors.teal.shade700,
              ),
            ),

            const SizedBox(height: 28),

            // --- TACTILE 3D BUTTONS ---
            //
            // MILESTONE 1 CUSTOMIZATION:
            // The original controls were changed into a Smart Room Controller.
            // Each button has its own icon, label, accent color, and action text.
            Wrap(
              spacing: 20,
              runSpacing: 20,
              alignment: WrapAlignment.center,

              children: [
                // Smart Room Control 1: Desk Lamp
                TactileButton(
                  icon: Icons.lightbulb,
                  label: "DESK LAMP",
                  accentColor: Colors.amber,
                  isDark: widget.isDark,
                  onPressed: () => _triggerAction("DESK LAMP"),
                ),

                // Smart Room Control 2: Cooling Fan
                TactileButton(
                  icon: Icons.air,
                  label: "FAN",
                  accentColor: Colors.lightBlueAccent,
                  isDark: widget.isDark,
                  onPressed: () => _triggerAction("COOLING FAN"),
                ),

                // Smart Room Control 3: Air Conditioner
                TactileButton(
                  icon: Icons.ac_unit,
                  label: "AC",
                  accentColor: Colors.cyanAccent,
                  isDark: widget.isDark,
                  onPressed: () => _triggerAction("AIR CONDITIONER"),
                ),

                // Smart Room Control 4: Ambient Lighting
                TactileButton(
                  icon: Icons.light_mode,
                  label: "AMBIENT",
                  accentColor: Colors.purpleAccent,
                  isDark: widget.isDark,
                  onPressed: () => _triggerAction("AMBIENT LIGHT"),
                ),

                // ------------------------------------------------------------
                // EXTRA CREDIT CONTROL:
                // Normal tap activates ALL OFF like a regular control.
                // Long press performs a full shutdown and sets power to 0%.
                // ------------------------------------------------------------
                TactileButton(
                  icon: Icons.power_settings_new,
                  label: "ALL OFF",
                  accentColor: Colors.redAccent,
                  isDark: widget.isDark,
                  onPressed: () => _triggerAction("ALL OFF"),
                  onLongPress: _shutdownAll,
                ),
              ],
            ),

            const SizedBox(height: 36),

            // --- INTERACTIVE CALIBRATION SLIDER ---
            Text(
              "Power Calibration: ${powerLevel.toInt()}%",
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),

            Slider(
              value: powerLevel,
              min: 0,
              max: 100,
              activeColor: Colors.blueAccent,
              inactiveColor: Colors.grey.withValues(alpha: 0.3),

              // setState updates powerLevel immediately during slider drag
              onChanged: (newVal) => setState(() => powerLevel = newVal),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// 4. REUSABLE TACTILE 3D BUTTON WIDGET
// ============================================================================
// Summary: A self-contained StatefulWidget that tracks its own isPressed flag
// and uses GestureDetector + two opposing BoxShadows to fake a physical
// push-button depress-and-release effect.
// Reference: https://api.flutter.dev/flutter/widgets/GestureDetector-class.html
class TactileButton extends StatefulWidget {
  final IconData icon; // Icon to display in center
  final String label; // Button title text
  final Color accentColor; // Active glow color
  final bool isDark; // Light or Dark theme mode
  final VoidCallback onPressed; // Action callback triggered on tap

  // Optional callback used by controls that support a long-press action.
  final VoidCallback? onLongPress;

  const TactileButton({
    super.key,
    required this.icon,
    required this.label,
    required this.accentColor,
    required this.isDark,
    required this.onPressed,
    this.onLongPress,
  });

  @override
  State<TactileButton> createState() => _TactileButtonState();
}

class _TactileButtonState extends State<TactileButton> {
  // Local boolean state tracking whether button is currently being held down
  //
  // Keeping this state local means each button can independently display
  // its pressed animation without affecting the other buttons.
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    // Determine dynamic background and shadow colors
    final baseColor = widget.isDark
        ? const Color(0xFF222430)
        : const Color(0xFFE0E5EC);

    final darkShadow = widget.isDark ? Colors.black87 : const Color(0xFFA3B1C6);

    final lightShadow = widget.isDark ? const Color(0xFF2F3244) : Colors.white;

    return GestureDetector(
      // 1. User touches button -> depress button
      onTapDown: (_) => setState(() => isPressed = true),

      // 2. User releases button -> restore position and fire callback
      onTapUp: (_) {
        setState(() => isPressed = false);
        widget.onPressed();
      },

      // 3. User cancels touch -> restore position safely
      onTapCancel: () => setState(() => isPressed = false),

      // EXTRA CREDIT:
      // If this button has a long-press action, trigger it after a long press.
      onLongPress: widget.onLongPress == null
          ? null
          : () {
              setState(() => isPressed = false);
              widget.onLongPress!();
            },

      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 100,
        ), // Smooth 100ms spring transition
        width: 140,
        height: 140,

        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(24),

          // Dual opposing BoxShadows create the 3D Neomorphic depth effect
          boxShadow: isPressed
              ? [
                  // Pressed (Sunken) Shadow Offsets
                  BoxShadow(
                    color: darkShadow.withValues(alpha: 0.5),
                    offset: const Offset(2, 2),
                    blurRadius: 4,
                  ),

                  BoxShadow(
                    color: lightShadow.withValues(alpha: 0.5),
                    offset: const Offset(-2, -2),
                    blurRadius: 4,
                  ),
                ]
              : [
                  // Unpressed (Elevated) Shadow Offsets
                  // Original shadow directions restored after Q3 experiment.
                  BoxShadow(
                    color: darkShadow.withValues(alpha: 0.7),
                    offset: const Offset(8, 8),
                    blurRadius: 16,
                  ),

                  BoxShadow(
                    color: lightShadow.withValues(alpha: 0.9),
                    offset: const Offset(-8, -8),
                    blurRadius: 16,
                  ),
                ],
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            // Dynamic Icon that changes size and glows on press
            Icon(
              widget.icon,
              size: isPressed ? 40 : 46,
              color: isPressed
                  ? widget.accentColor
                  : (widget.isDark ? Colors.white70 : Colors.black87),
            ),

            const SizedBox(height: 8),

            // Button Label
            Text(
              widget.label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                letterSpacing: 1.1,
                color: isPressed
                    ? widget.accentColor
                    : (widget.isDark ? Colors.white54 : Colors.black54),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
