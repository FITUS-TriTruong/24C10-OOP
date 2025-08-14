class_name CharacterAnimationController
extends Node

# === NODE REFERENCES ===
var animated_sprite: AnimatedSprite2D
var movement_controller: CharacterMovement

# === SIGNALS ===
signal animation_finished()

func initialize(sprite: AnimatedSprite2D, movement: CharacterMovement) -> void:
	animated_sprite = sprite
	movement_controller = movement
	
	if animated_sprite:
		animated_sprite.connect("animation_finished", Callable(self, "_on_animation_finished"))

func update_animations() -> void:
	if not animated_sprite or not movement_controller:
		return
	
	# Update sprite direction
	var direction = movement_controller.get_direction()
	if direction > 0:
		animated_sprite.flip_h = false
		movement_controller.set_facing_right(true)
	elif direction < 0:
		animated_sprite.flip_h = true
		movement_controller.set_facing_right(false)
	
	# Update state and play animation
	movement_controller.update_state()
	var current_state = movement_controller.get_current_state()
	play_state_animation(current_state)

func play_state_animation(state: CharacterState.State) -> void:
	if not animated_sprite:
		return
		
	match state:
		CharacterState.State.IDLE:
			animated_sprite.play("Idle")
		CharacterState.State.WALKING:
			animated_sprite.play("Walk")
		CharacterState.State.RUNNING:
			animated_sprite.play("Run")
		CharacterState.State.JUMPING:
			animated_sprite.play("Jump")
		CharacterState.State.SITTING:
			animated_sprite.play("Seatted")
		CharacterState.State.ATTACKING:
			animated_sprite.play("Attack")
		CharacterState.State.KICKING:
			animated_sprite.play("Kick")
		CharacterState.State.PUSHING:
			animated_sprite.play("Push")
		CharacterState.State.PULLING:
			animated_sprite.play("Pull")
		CharacterState.State.DYING:
			animated_sprite.play("Dying")
		CharacterState.State.DEAD:
			animated_sprite.play("ded")
			

func play_idle_animation() -> void:
	if not animated_sprite:
		return
		
	if movement_controller.is_sitting():
		animated_sprite.play("Seatted")
	else:
		animated_sprite.play("Idle")

func play_sitting_animation() -> void:
	if animated_sprite:
		animated_sprite.play("Sitting")

func play_dying_animation() -> void:
	if animated_sprite:
		animated_sprite.play("Dying")

func play_dead_animation() -> void:
	if animated_sprite:
		animated_sprite.play("ded")

# === SIGNAL HANDLERS ===
func _on_animation_finished() -> void:
	if animated_sprite.animation == "Kick" or animated_sprite.animation == "Attack":
		movement_controller.set_action(false)
		play_idle_animation()
	
	animation_finished.emit()
