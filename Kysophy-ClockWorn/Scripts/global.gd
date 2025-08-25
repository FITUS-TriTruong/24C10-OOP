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

var game_data = {
	"unlocked_level": 1,
	"current_stamina": 500.0
}

func _ready():
	load_game()
	print("Save path is:", ProjectSettings.globalize_path(SAVE_PATH))

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
				print("Game loaded. Unlocked level: %d" % game_data.unlocked_level)

func reset_progress():
	game_data.unlocked_level = 1
	game_data.current_stamina = 500.0
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
	return game_data.get("current_stamina", 500.0)

func update_stamina(stamina_value: float):
	game_data.current_stamina = stamina_value
	# Auto-save stamina every time it's updated
	save_game()
