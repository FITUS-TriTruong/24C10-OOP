extends CharacterBody2D

# === Constants & Settings ===
const SPEED := 90.0
const RUN_SPEED := 120.0
const JUMP_VELOCITY := -200.0
const PUSH_COOLDOWN := 0.6
var gravity: float = float(ProjectSettings.get_setting("physics/2d/default_gravity"))
const STAMINA_RUN_COST = 8.0
const STAMINA_JUMP_COST = 12.0
const STAMINA_KICK_COST = 15.0

# === States ===
var facing_right := true
var is_sitting := false
var is_action := false
var is_pushing := false
var push_cooldown_timer := 0.0
var sitting_status := 0
var on_ladder: bool = false

@onready var stamina_system: Node2D = $StaminaSystem
@onready var progress_bar: ProgressBar = $CanvasLayer/ProgressBar
@onready var Anim = $AnimatedSprite2D

func _ready() -> void:
	add_to_group("player")
	Anim.connect("animation_finished", Callable(self, "_on_animation_finished"))
	
#func _process(delta: float) -> void:
	#progress_bar.value = stamina_system.get_stamina_percent() * 100
	## Handle stamina exhaustion effects
	#if stamina_system.exhausted:
		## You might want to slow down or prevent running when exhausted
		#pass

func can_perform_action(stamina_cost: float) -> bool:
	return stamina_system.use_stamina(stamina_cost)

func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		if not on_ladder:
			velocity.y += gravity * delta
		else:
			velocity += get_gravity() * delta

	# Push cooldown countdown
	if push_cooldown_timer > 0:
		push_cooldown_timer -= delta
		if push_cooldown_timer <= 0:
			push_cooldown_timer = 0
			is_pushing = false

	# Sit toggle
	if Input.is_action_just_pressed("Sit"):
		is_sitting = not is_sitting
		sitting_status = 1 if is_sitting else 0
		if is_sitting:
			Anim.play("Sitting")
		else:
			play_idle()
		velocity.x = 0
		return

	# Sitting lock
	if is_sitting or sitting_status == 1:
		if not Input.is_anything_pressed():
			return
		else:
			is_sitting = false
			sitting_status = 0

	# Action lock (attack/kick)
	if is_action:
		velocity.x = 0
		return

	if Input.is_action_just_pressed("Kick"):
		is_action = true
		Anim.play("Kick")
		return

	if Input.is_action_just_pressed("Attack"):
		is_action = true
		Anim.play("Attack")
		return

	# Jump
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		#if can_perform_action(STAMINA_JUMP_COST):
			velocity.y = JUMP_VELOCITY
			Anim.play("Jump")
		#else:
			## Play some exhausted animation or sound
			#pass

	# Modified Movement section to use stamina for running
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction == 0:
		direction = Input.get_axis("Move_left", "Move_right")  # Fallback support

	if direction != 0:
		if is_pushing:
			velocity.x = direction * (SPEED * 0.1)
			Anim.play("Push" if direction > 0 else "Pull")
		else:
			if Input.is_action_pressed("Shift"):
				if not stamina_system.exhausted:
					velocity.x = direction * RUN_SPEED
					Anim.play("Run")
					# Continuous stamina drain while running
					stamina_system.use_stamina(STAMINA_RUN_COST * delta)
				else:
					# Fall back to walking if exhausted
					velocity.x = direction * SPEED
					Anim.play("Walk")
			else:
				velocity.x = direction * SPEED
				Anim.play("Walk")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_on_floor() and not is_action and not is_sitting:
			play_idle()

	# Flip sprite
	if direction > 0:
		Anim.flip_h = false
		facing_right = true
	elif direction < 0:
		Anim.flip_h = true
		facing_right = false

	move_and_slide()

func play_idle() -> void:
	if is_sitting or sitting_status == 1:
		Anim.play("Seatted")
	else:
		Anim.play("Idle")

func _on_animation_finished() -> void:
	if Anim.animation == "Kick" or Anim.animation == "Attack":
		is_action = false
		play_idle()

# === Ladder triggers ===
func _on_ladd_er_body_entered(body: CharacterBody2D) -> void:
	if "animated_sprite" in body.name:
		on_ladder = true

func _on_ladd_er_body_exited(body: CharacterBody2D) -> void:
	if "animated_sprite" in body.name:
		on_ladder = false

# === Push system triggers ===
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("RigidBody"):
		var delta_y = global_position.y - body.global_position.y
		if abs(delta_y) < 10:
			is_pushing = true
			push_cooldown_timer = 0.0
		else:
			is_pushing = false
			body.collision_layer = 1
			body.collision_mask = 1

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("RigidBody"):
		push_cooldown_timer = PUSH_COOLDOWN
		body.collision_layer = 2
		body.collision_mask = 2
