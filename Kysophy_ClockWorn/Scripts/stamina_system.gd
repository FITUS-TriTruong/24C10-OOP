#class_name StaminaSystem
extends Node2D

@export var max_stamina: float = 500.0
@export var regen_rate: float = 0.0
@export var regen_delay: float = 1.5

var current_stamina: float
var exhausted: bool = false
var time_since_use: float = 0.0

func _ready():
	current_stamina = max_stamina

func _process(delta):
	if current_stamina < max_stamina:
		time_since_use += delta
		if time_since_use >= regen_delay:
			current_stamina += regen_rate * delta
			current_stamina = min(current_stamina, max_stamina)

	if exhausted and current_stamina >= max_stamina * 0.2:
		exhausted = false

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
