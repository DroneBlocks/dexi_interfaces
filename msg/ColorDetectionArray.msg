# Array of color detection results with header and timestamp

std_msgs/Header header              # Standard ROS header with timestamp and frame_id
ColorDetection[] detections         # Array of individual color detections
float64 timestamp                   # Unix timestamp when detections were made
