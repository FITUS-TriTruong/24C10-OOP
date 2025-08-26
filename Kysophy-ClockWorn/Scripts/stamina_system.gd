class_name StaminaSystem
extends Node2D

@export var max_stamina: float = 500.0
@export var regen_rate: float = 0.0
@export var regen_delay: float = 1.5

var current_stamina: float
var exhausted: bool = false
var time_since_use: float = 0.0
var last_saved_stamina: float = 0.0  # Track when we last saved

func _ready():
	print("=== STAMINA SYSTEM INITIALIZING ===")
	
	# Get the current level number from Global
	var level_number = Global.current_level
	print("Current level from Global: %d" % level_number)
	
	# Set max stamina based on the level
	var level_state = Global.get_level_initial_state(level_number)
	max_stamina = level_state.max_stamina
	print("Max stamina for level %d: %.1f" % [level_number, max_stamina])
	
	# Load stamina from Global save data
	if Global:
		print("Global exists, is_fresh_level_start: %s" % str(Global.is_fresh_level_start))
		
		if Global.is_fresh_level_start:
			# Starting from level select - use carried over stamina for this level
			if Global.game_data.has("level_stamina") and Global.game_data.level_stamina.has(level_number):
				current_stamina = Global.game_data.level_stamina[level_number]
			else:
				current_stamina = level_state.stamina
				print("Warning: No level_stamina data found, using initial stamina")
			
			Global.is_fresh_level_start = false  # Mark that we've initialized
			print("Level %d - Starting with stamina: %.1f (Max: %.1f)" % [level_number, current_stamina, max_stamina])
		else:
			# Continuing or progressing - use current saved stamina
			current_stamina = Global.get_saved_stamina()
			print("Level %d - Continuing with stamina: %.1f (Max: %.1f)" % [level_number, current_stamina, max_stamina])
	else:
		print("Warning: Global not found, using max stamina")
		current_stamina = max_stamina
	
	# Ensure stamina doesn't exceed the new level's max
	current_stamina = min(current_stamina, max_stamina)
	
	last_saved_stamina = current_stamina
	print("=== STAMINA SYSTEM READY - Final stamina: %.1f ===\n" % current_stamina)

func _process(delta):
	if current_stamina < max_stamina:
		time_since_use += delta
		if time_since_use >= regen_delay:
			current_stamina += regen_rate * delta
			current_stamina = min(current_stamina, max_stamina)

	if exhausted and current_stamina >= max_stamina * 0.2:
		exhausted = false
	
	# Save stamina periodically if it has changed significantly
	_auto_save_stamina()

func _auto_save_stamina():
	# Save stamina if it has changed by more than 10 points or every few seconds
	if abs(current_stamina - last_saved_stamina) >= 10.0:
		if Global:
			Global.update_stamina(current_stamina)
			last_saved_stamina = current_stamina

func use_stamina(amount: float) -> bool:
	if exhausted:
		return false
	if current_stamina >= amount:
		current_stamina -= amount
		time_since_use = 0.0
		if current_stamina <= 0:
			current_stamina = 0
			exhausted = true
		return true
	else:
		exhausted = true
		return false

func get_stamina_percent() -> float:
	return current_stamina / max_stamina

# === PERSISTENCE FUNCTIONS ===
func save_current_stamina():
	"""Manually save the current stamina - call this when changing stages"""
	if Global:
		Global.save_stamina(current_stamina)
		last_saved_stamina = current_stamina

func set_stamina(amount: float):
	"""Set stamina to a specific amount (useful for power-ups or stage events)"""
	current_stamina = clamp(amount, 0.0, max_stamina)
	if current_stamina <= 0:
		exhausted = true
	elif current_stamina >= max_stamina * 0.2:
		exhausted = false
