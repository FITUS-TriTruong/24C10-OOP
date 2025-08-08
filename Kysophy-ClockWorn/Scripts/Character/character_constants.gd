class_name CharacterConstants
extends RefCounted

# === MOVEMENT CONSTANTS ===
const WALK_SPEED: float = 90.0
const RUN_SPEED: float = 120.0
const JUMP_VELOCITY: float = -200.0
const TILE_SIZE: int = 16
const FALL_DAMAGE_THRESHOLD: float = 3 * TILE_SIZE
const PUSH_COOLDOWN: float = 0.6

# === STAMINA CONSTANTS ===
const STAMINA_RUN_COST: float = 2.0
const STAMINA_JUMP_COST: float = 5.0
const STAMINA_KICK_COST: float = 15.0
const STAMINA_ATTACK_COST: float = 10.0