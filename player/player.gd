class_name Player extends CharacterBody2D

const JUMP_VELOCITY = -750.0

@export var max_jumps: int = 2
var jumps: int = 0

@export var max_jump_buffer: float = .1
var jump_buf: float = 0.0

@export var max_coyote_time: float = .1
var coyote_time: float = 0.0

var jump_released: bool = false

var is_jumping: bool = false

var gravity_mult: float = 1.0

func handle_vertical(delta: float) -> void:
  jump_buf -= delta
  if Input.is_action_pressed("jump") and jump_released: jump_buf = max_jump_buffer

  coyote_time -= delta
  if is_on_floor():
    coyote_time = max_coyote_time
    is_jumping = false

  if coyote_time > 0: jumps = max_jumps
  else: jumps = min(jumps, max_jumps - 1)

  if jump_buf > 0 and jumps > 0:
    jumps -= 1
    jump_buf = 0
    coyote_time = 0
    velocity.y = JUMP_VELOCITY
    is_jumping = true

  jump_released = !Input.is_action_pressed("jump")

  if is_jumping and velocity.y < 0 and jump_released:
    gravity_mult += 2
  
  if is_jumping and velocity.y > 0:
    gravity_mult += 1

const TOP_SPEED: float = 750.0
const GROUND_ACCEL: float = 100.0
const AIR_FRICTION_MULT: float = .25

func handle_movement(delta: float) -> void:
  handle_vertical(delta)
  
  var direction := Input.get_axis("left", "right")
  var diff: float = direction * GROUND_ACCEL * delta * 60
  if direction and velocity.x * direction < TOP_SPEED:
    velocity.x += diff
    
  velocity.x = move_toward(
    velocity.x, 
    0, 
    GROUND_ACCEL * delta * 30 * (1.0 if is_on_floor() else AIR_FRICTION_MULT)
  )

  if !is_on_floor():
    velocity += get_gravity() * delta * gravity_mult

func _physics_process(delta: float) -> void:
  gravity_mult = 1.0
  
  handle_movement(delta)
  
  move_and_slide()
