# Single color detection result

string color_name          # Detected color name (e.g., "red", "blue", "green")
float32 confidence         # Detection confidence based on contour area ratio (0.0 to 1.0)
float32[4] bbox            # Bounding box as [x1, y1, x2, y2] normalized coordinates (0.0 to 1.0)
float32 center_x           # Center x of detection, normalized (0.0 to 1.0)
float32 center_y           # Center y of detection, normalized (0.0 to 1.0)
uint32 pixel_count         # Number of pixels matching this color
float32 orientation_rad    # Principal-axis angle of contour in image frame, [-pi/2, pi/2]. 0 = vertical, clockwise positive
