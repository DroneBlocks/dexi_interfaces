# Array of YOLO detection results with header and timestamp

std_msgs/Header header              # Standard ROS header with timestamp and frame_id
YoloDetection[] detections         # Array of individual detections
float64 timestamp                  # Unix timestamp when detections were made