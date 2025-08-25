# RechargeStation.gd
extends StaticBody2D

@onready var interaction_area = $InteractionArea
var alreadyReplenished = false
@export var recharge_rate: float = 100.0   # stamina per second
@export var refill_percent: float = 0.7    # 70% refill

var target_system: StaminaSystem = null
var is_recharging: bool = false
var target_amount: float = 0.0

func _ready():
	interaction_area.interact = Callable(self, "_start_recharge")

func _process(delta):
	if is_recharging and target_system:
		var to_add = recharge_rate * delta
		target_system.set_stamina(target_system.current_stamina + to_add)

		if target_system.current_stamina >= target_amount or target_system.current_stamina >= target_system.max_stamina:
			target_system.set_stamina(min(target_system.current_stamina, target_system.max_stamina))
			is_recharging = false
			print("Recharge finished")

func _start_recharge():
	if alreadyReplenished:
		pass
	else:
		alreadyReplenished = true
		var player = get_overlapping_player()
		if player and player.has_node("StaminaSystem"):
			target_system = player.get_node("StaminaSystem")
			target_amount = min(target_system.current_stamina + target_system.max_stamina * refill_percent, target_system.max_stamina)
			is_recharging = true
			print("Started slow recharge")
		
func get_overlapping_player():
	for body in interaction_area.get_overlapping_bodies():
		if body.is_in_group("player"):
			return body
	return null
