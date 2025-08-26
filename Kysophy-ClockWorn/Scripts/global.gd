extends Node

const SAVE_PATH = "user://progress.dat"

var found_key = false
var given_key = false
var memory0 = false
var memory1 = false
var memory2 = false
var memory3 = false
var memory4 = false
var memory5 = false
var memory6 = false
var memory7 = false
var memory8 = false
var package = true
signal conversation_finished_1
signal conversation_finished_2
var ending = ""

var game_data = {
	"unlocked_level": 1,
	"current_stamina": 500.0,
	"level_stamina": {
		1: 500.0,  # Level 1 starting stamina
		2: 500.0,  # Level 2 starting stamina (will be updated when progressing from Level 1)
		3: 500.0,  # Level 3 starting stamina (will be updated when progressing from Level 2)
		4: 500.0   # Level 4 (Final Stage) starting stamina
	}
}

# Level-specific initial states
var level_initial_states = {
	1: {"stamina": 500.0, "max_stamina": 500.0},
	2: {"stamina": 500.0, "max_stamina": 500.0},
	3: {"stamina": 500.0, "max_stamina": 500.0},
	4: {"stamina": 500.0, "max_stamina": 500.0}  # Final Stage
}

var current_level: int = 1
var is_fresh_level_start: bool = true  # Flag to indicate if this is a fresh level start

func _ready():
	load_game()
	print("Save path is:", ProjectSettings.globalize_path(SAVE_PATH))
	
	# Try to detect current level from scene path on startup
	_detect_current_level_from_scene()

func _detect_current_level_from_scene():
	"""Try to extract level number from current scene path"""
	var scene_path = get_tree().current_scene.scene_file_path
	print("Detecting level from scene path: ", scene_path)
	var regex = RegEx.new()
	if regex.compile("Stage_(\\d+)\\.tscn") == OK:
		var match = regex.search(scene_path)
		if match:
			current_level = int(match.get_string(1))
			print("Detected current level from scene: %d" % current_level)
		else:
			print("No level number found in scene path, keeping current_level as: %d" % current_level)
	else:
		print("Regex compilation failed for level detection")

func unlock_level(level_number: int):
	if level_number > game_data.unlocked_level:
		game_data.unlocked_level = level_number
		print("Level %d unlocked!" % level_number)

func save_game():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(game_data))
		print("Game saved. Unlocked level: %d" % game_data.unlocked_level)

func load_game():
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		if file:
			var loaded_data = JSON.parse_string(file.get_as_text())
			if loaded_data:
				game_data = loaded_data
				
				# Ensure level_stamina exists and has all levels initialized
				if not game_data.has("level_stamina"):
					game_data.level_stamina = {
						1: 500.0,
						2: 500.0,
						3: 500.0,
						4: 500.0
					}
					print("Initialized missing level_stamina data")
				
				# Ensure all levels have stamina values
				for level in [1, 2, 3, 4]:
					if not game_data.level_stamina.has(level):
						game_data.level_stamina[level] = get_level_initial_stamina(level)
						print("Initialized missing stamina for level %d" % level)
				
				print("Game loaded. Unlocked level: %d" % game_data.unlocked_level)
				print("Level stamina states: ", game_data.level_stamina)
	else:
		print("No save file found, using default values")

func reset_progress():
	game_data.unlocked_level = 1
	game_data.current_stamina = 500.0
	game_data.level_stamina = {
		1: 500.0,
		2: 500.0,
		3: 500.0,
		4: 500.0
	}
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(game_data))
		file.close()
		print("Progress reset to Stage 1 and saved to:", SAVE_PATH)
	else:
		print("Failed to reset progress: could not open file.")

# === STAMINA PERSISTENCE FUNCTIONS ===
func save_stamina(stamina_value: float):
	game_data.current_stamina = stamina_value
	save_game()
	print("Stamina saved: %.1f" % stamina_value)

func get_saved_stamina() -> float:
	# If this is a fresh level start, return the level's carried over stamina
	if is_fresh_level_start:
		return game_data.level_stamina.get(current_level, get_level_initial_stamina(current_level))
	else:
		# Otherwise return the current saved stamina
		return game_data.get("current_stamina", 500.0)

func update_stamina(stamina_value: float):
	game_data.current_stamina = stamina_value
	# Only auto-save if we're not in a fresh level start
	if not is_fresh_level_start:
		save_game()

# === LEVEL-SPECIFIC INITIALIZATION ===
func start_level(level_number: int):
	"""Call this when starting a level from level select - use carried over stamina"""
	current_level = level_number
	is_fresh_level_start = true
	
	# Special handling for Level 1 - always start with full stamina
	if level_number == 1:
		var initial_stamina = get_level_initial_stamina(1)
		game_data.current_stamina = initial_stamina
		game_data.level_stamina[1] = initial_stamina
		print("Starting Level 1 with full stamina: %.1f" % initial_stamina)
	else:
		# Use the carried over stamina for this level, or initial if never reached
		var level_stamina = game_data.level_stamina.get(level_number, get_level_initial_stamina(level_number))
		game_data.current_stamina = level_stamina
		print("Starting Level %d with stamina: %.1f (carried over)" % [level_number, level_stamina])

func continue_level():
	"""Call this when transitioning between stages - preserve stamina"""
	is_fresh_level_start = false
	print("Continuing level progression with current stamina: %.1f" % game_data.current_stamina)

func progress_to_next_level(next_level_number: int, current_stamina_amount: float):
	"""Call this when progressing from one level to the next - carry over stamina"""
	current_level = next_level_number
	is_fresh_level_start = false  # Not a fresh start, carrying over stamina
	
	# Save the carried over stamina for the next level
	game_data.level_stamina[next_level_number] = current_stamina_amount
	game_data.current_stamina = current_stamina_amount
	
	# Save this progress immediately
	save_game()
	
	print("Progressing to Level %d with carried over stamina: %.1f" % [next_level_number, current_stamina_amount])

func reset_level_stamina(level_number: int):
	"""Reset a specific level's stamina to its initial value"""
	var initial_stamina = get_level_initial_stamina(level_number)
	game_data.level_stamina[level_number] = initial_stamina
	save_game()
	print("Reset Level %d stamina to initial: %.1f" % [level_number, initial_stamina])

func reset_all_level_stamina():
	"""Reset all levels to their initial stamina values"""
	for level in level_initial_states.keys():
		game_data.level_stamina[level] = get_level_initial_stamina(level)
	save_game()
	print("Reset all levels to initial stamina")

func get_level_initial_state(level_number: int) -> Dictionary:
	"""Get the initial state for a specific level"""
	return level_initial_states.get(level_number, {"stamina": 500.0, "max_stamina": 500.0})

func get_level_initial_stamina(level_number: int) -> float:
	"""Get just the initial stamina for a specific level"""
	var state = get_level_initial_state(level_number)
	return state.stamina

func get_level_max_stamina(level_number: int) -> float:
	"""Get the max stamina for a specific level"""
	var state = get_level_initial_state(level_number)
	return state.max_stamina

# === DEBUG FUNCTIONS ===
func debug_stamina_state():
	"""Print current stamina state for debugging"""
	print("=== STAMINA DEBUG ===")
	print("Current Level: %d" % current_level)
	print("Current Stamina: %.1f" % game_data.current_stamina)
	print("Is Fresh Level Start: %s" % str(is_fresh_level_start))
	print("Level Initial Stamina: %.1f" % get_level_initial_stamina(current_level))
	print("Level Max Stamina: %.1f" % get_level_max_stamina(current_level))
	print("Level Stamina States:")
	if game_data.has("level_stamina"):
		for level in game_data.level_stamina.keys():
			print("  Level %d: %.1f" % [level, game_data.level_stamina[level]])
	else:
		print("  No level_stamina data found!")
	print("===================")

func test_level_start(level_num: int):
	"""Test function to debug level starting"""
	print("\n=== TESTING LEVEL %d START ===" % level_num)
	debug_stamina_state()
	start_level(level_num)
	debug_stamina_state()
	print("=== END TEST ===\n")
