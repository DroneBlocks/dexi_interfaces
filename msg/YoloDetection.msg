# Single YOLO detection result

string class_name      # Name of the detected class (e.g., "person", "car")
float32 confidence     # Detection confidence score (0.0 to 1.0)
float32[4] bbox        # Bounding box as [x1, y1, x2, y2] normalized coordinates (0.0 to 1.0)