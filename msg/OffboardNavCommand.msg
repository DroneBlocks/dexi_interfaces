string command  # Command type such as takeoff, fly_foward, fly_backward, fly_left, land, goto_ned
float32 distance_or_degrees  # Distance in m to navigate or degrees to yaw
float32 north  # North coordinate in NED frame (meters) - for goto_ned command
float32 east   # East coordinate in NED frame (meters) - for goto_ned command
float32 down   # Down coordinate in NED frame (meters, negative=up) - for goto_ned command
float32 yaw    # Yaw angle in degrees - for goto_ned command