
extends Node

var found_key = false
var given_key = false

# Add this line to track the highest level unlocked.
# We initialize it to 1, so the first level is always available.
var unlocked_level: int = 1
