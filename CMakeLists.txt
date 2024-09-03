cmake_minimum_required(VERSION 3.8)
project(dexi_interfaces)

if(CMAKE_COMPILER_IS_GNUCXX OR CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  add_compile_options(-Wall -Wextra -Wpedantic)
endif()

find_package(ament_cmake REQUIRED)
find_package(rosidl_default_generators REQUIRED)
rosidl_generate_interfaces(${PROJECT_NAME}
  "msg/LEDState.msg"
  "msg/LEDStateArray.msg"
  "srv/GetTelemetry.srv"
  "srv/GPIOSend.srv"
  "srv/GPIOSetup.srv"
  "srv/LEDPixelColor.srv"
  "srv/LEDRingColor.srv"
  "srv/Load.srv"
  "srv/Navigate.srv"
  "srv/Run.srv"
  "srv/SetAltitude.srv"
  "srv/SetLedEffect.srv"
  "srv/SetPosition.srv"
  "srv/SetYaw.srv"
  "srv/Store.srv"
 )

 ament_export_dependencies(rosidl_default_runtime)

if(BUILD_TESTING)
  find_package(ament_lint_auto REQUIRED)
  set(ament_cmake_copyright_FOUND TRUE)
  set(ament_cmake_cpplint_FOUND TRUE)
  ament_lint_auto_find_test_dependencies()
endif()

ament_package()
