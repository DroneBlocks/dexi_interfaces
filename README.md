# dexi_interfaces

ROS 2 message and service definitions shared across the DEXI drone stack.

This package is the single source of truth for every custom `.msg` and `.srv`
type used by the other DEXI packages — vision detections, LED state, offboard
control commands, flight actions, the Blockly execution surface, and so on.
It contains no executables; it exists only so the runtime packages can build
against and import typed interfaces.

## What lives here

Messages and services are grouped below by subsystem for quick orientation.
All definitions are in `msg/` or `srv/` at the package root.

### Messages — `msg/`

| Subsystem | Message | Published by (typical) | Notes |
|---|---|---|---|
| Vision — YOLO | `YoloDetection` | `dexi_yolo` | Single class/bbox/confidence entry |
| Vision — YOLO | `YoloDetectionArray` | `dexi_yolo` | Header-stamped batch on `/yolo_detections` |
| Vision — color | `ColorDetection` | `dexi_color_detection` | One HSV-matched color blob |
| Vision — color | `ColorDetectionArray` | `dexi_color_detection` | Header-stamped batch on `/color_detections` |
| LED | `LEDState` | `dexi_led` | Single pixel: index + RGB + brightness |
| LED | `LEDStateArray` | `dexi_led` | Whole-strip update |
| Flight control | `State` | `dexi_offboard` / examples | Full offboard setpoint envelope (position/velocity/attitude/rates, with mode enums) |
| Flight control | `OffboardNavCommand` | user scripts → `dexi_offboard` | High-level commands (`takeoff`, `fly_forward`, `land`, `goto_ned`, etc.) |
| NLP | `Prompt` | `dexi_llm` clients | Natural-language prompt envelope |
| Challenge | `ChallengeStart` | challenge runner | Marks start of a scored run |
| Challenge | `ChallengeStatus` | challenge runner | Periodic status during a run |
| Challenge | `ChallengeResult` | challenge runner | Final scored outcome |

### Services — `srv/`

| Subsystem | Service | Server (typical) | Purpose |
|---|---|---|---|
| Flight actions | `Navigate` | `dexi_offboard` | Navigate to an NED target |
| Flight actions | `SetPosition` | `dexi_offboard` | Position setpoint |
| Flight actions | `SetAltitude` | `dexi_offboard` | Altitude-only setpoint |
| Flight actions | `SetYaw` | `dexi_offboard` | Yaw-only setpoint |
| Flight telemetry | `GetTelemetry` | `dexi_offboard` | One-shot telemetry snapshot |
| LED | `LEDEffect` | `dexi_led` | Trigger a named animation |
| LED | `SetLedEffect` | `dexi_led` | Alternate trigger API used by Blockly |
| LED | `LEDPixelColor` | `dexi_led` | Set a single pixel |
| LED | `LEDRingColor` | `dexi_led` | Set the whole ring |
| GPIO | `GPIOSetup` | `dexi_gpio` / `dexi_cpp` | Configure a pin as input/output |
| GPIO | `GPIOSend` | `dexi_gpio` / `dexi_cpp` | Write a value to an output pin |
| GPIO | `SetGpio` | `dexi_gpio` / `dexi_cpp` | Alternate write API used by Blockly |
| GPIO | `ReadGpio` | `dexi_gpio` / `dexi_cpp` | Read an input pin |
| Servo | `ServoControl` | `dexi_cpp` servo controller | Drive a servo via PCA9685 |
| Code execution | `ExecuteBlocklyCommand` | Blockly runtime | Execute a Blockly-generated command |
| Code execution | `Run` | Blockly runtime | Start a stored program |
| Code execution | `Load` | Blockly runtime | Load a program by id/name |
| Code execution | `Store` | Blockly runtime | Save a program |
| NLP | `LLMChat` | `dexi_llm` | One-shot chat turn against the local LLM |
| Firmware | `FlashFirmware` | dexi-os / bringup scripts | Trigger a firmware flash from the companion computer |

If you add a new interface, update this table in the same PR so the
subsystem grouping stays current.

## Building

This is a standard `ament_cmake` + `rosidl` interface package. It gets built
alongside the rest of `dexi_ws` by the normal colcon invocation:

```bash
cd ~/dexi_ws
colcon build --packages-select dexi_interfaces
source install/setup.bash
```

Packages that consume these interfaces should list `dexi_interfaces` in
their `package.xml`:

```xml
<depend>dexi_interfaces</depend>
```

…and declare the same dependency in their `CMakeLists.txt` (`find_package`)
or `setup.py` (`install_requires` is not needed — `rosidl` generated Python
modules are discovered via the ament index at runtime).

## Using from Python (rclpy)

```python
from dexi_interfaces.msg import YoloDetectionArray, OffboardNavCommand
from dexi_interfaces.srv import Navigate, SetAltitude

# Subscribe to YOLO detections
self.create_subscription(
    YoloDetectionArray,
    "/yolo_detections",
    self.on_detections,
    10,
)

# Send a high-level offboard command
msg = OffboardNavCommand()
msg.command = "fly_forward"
msg.distance_or_degrees = 1.5  # meters
self.offboard_pub.publish(msg)

# Call a flight-action service
client = self.create_client(Navigate, "/dexi/navigate")
```

## Using from C++ (rclcpp)

```cpp
#include <dexi_interfaces/msg/yolo_detection_array.hpp>
#include <dexi_interfaces/msg/offboard_nav_command.hpp>
#include <dexi_interfaces/srv/navigate.hpp>

auto sub = node->create_subscription<dexi_interfaces::msg::YoloDetectionArray>(
    "/yolo_detections", 10, callback);
```

## Compatibility

- **ROS 2 distribution:** developed on Jazzy, should build on Humble too
  since no Jazzy-specific interface features are used.
- **Language bindings:** Python (rclpy) and C++ (rclcpp) are generated
  automatically by `rosidl_default_generators`.
- **Stability:** message fields are treated as stable — downstream packages
  on drones in the field depend on the exact field names and types.
  Additive changes (new fields, new enum values, new messages) are safe;
  renaming or reordering existing fields is a breaking change and should
  be avoided without a coordinated update of every consumer.

## Related packages

- [`dexi_bringup`](https://github.com/DroneBlocks/dexi_bringup) — top-level
  launch files and per-platform config
- [`dexi_offboard`](https://github.com/DroneBlocks/dexi_offboard) — PX4
  offboard control manager (primary consumer of `State`,
  `OffboardNavCommand`, flight-action services)
- [`dexi_yolo`](https://github.com/DroneBlocks/dexi_yolo) — YOLO object
  detection (publishes `YoloDetectionArray`)
- [`dexi_color_detection`](https://github.com/DroneBlocks/dexi_color_detection)
  — HSV color detection (publishes `ColorDetectionArray`)
- [`dexi_led`](https://github.com/DroneBlocks/dexi_led) — LED control
  (`LEDState`, `LEDEffect`, etc.)
- [`dexi_llm`](https://github.com/DroneBlocks/dexi_llm) — local LLM for
  natural-language drone commands (`LLMChat`, `Prompt`)
- [`dexi_apriltag`](https://github.com/DroneBlocks/dexi_apriltag) — AprilTag
  detection and odometry (consumes upstream `apriltag_msgs`, does not
  currently publish `dexi_interfaces` types)

## License

MIT — see `LICENSE`.
