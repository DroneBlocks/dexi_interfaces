# Single hand gesture detection result

std_msgs/Header header          # Standard ROS header with timestamp and frame_id
string gesture_name             # Name of detected gesture
float32 gesture_score           # Detection confidence score (0.0 to 1.0)
bool two_hand                   # If detected gesture involves two hands or not
float32[4] bbox                 # Bounding box as [x1, y1, x2, y2] normalized coordinates (0.0 to 1.0)
