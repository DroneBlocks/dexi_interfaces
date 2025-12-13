# Message for challenge progress updates
string challenge_id          # Challenge being tracked
uint8 STATUS_PENDING = 0     # Challenge not yet started
uint8 STATUS_ACTIVE = 1      # Challenge in progress
uint8 STATUS_COMPLETED = 2   # Challenge completed successfully
uint8 STATUS_FAILED = 3      # Challenge failed
uint8 STATUS_TIMEOUT = 4     # Challenge timed out
uint8 status                 # Current status
string message               # Status message or hint
float32 progress             # Progress percentage (0.0 - 1.0)
