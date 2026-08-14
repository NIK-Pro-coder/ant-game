class_name Player extends CharacterBody2D

const JUMP_VELOCITY = -1000.0

@export var max_jumps: int = 2
var jumps: int = 0

@export var max_jump_buffer: float = .1
var jump_buf: float = 0.0

@export var max_coyote_time: float = .1
var coyote_time: float = 0.0

var jump_released: bool = false

var is_jumping: bool = false

var gravity_mult: float = 1.0

var is_grounded: bool = false

func handle_vertical(delta: float) -> void:
  jump_buf -= delta
  if Input.is_action_pressed("jump") and jump_released: jump_buf = max_jump_buffer

  coyote_time -= delta
  if is_on_floor():
    coyote_time = max_coyote_time
    is_jumping = false

  if coyote_time > 0:
    jumps = max_jumps
    is_grounded = true
  else:
    jumps = min(jumps, max_jumps - 1)
    is_grounded = false

  if jump_buf > 0 and jumps > 0:
    jumps -= 1
    jump_buf = 0
    coyote_time = 0
    velocity.y = JUMP_VELOCITY
    is_jumping = true

  jump_released = !Input.is_action_pressed("jump")

  if is_jumping and velocity.y < 0 and jump_released:
    gravity_mult += 1
  
  if is_jumping and velocity.y > 0:
    gravity_mult += .5

const TOP_SPEED: float = 500.0
const GROUND_ACCEL: float = 100.0
const AIR_FRICTION_MULT: float = .25

func handle_horizontal(delta: float) -> void:
  var direction := Input.get_axis("left", "right")
  var diff: float = direction * GROUND_ACCEL * delta * 60
  if direction and velocity.x * direction < TOP_SPEED:
    velocity.x += diff
    
  velocity.x = move_toward(
    velocity.x, 
    0, 
    GROUND_ACCEL * delta * 30 * (1.0 if is_on_floor() else AIR_FRICTION_MULT)
  )

const MAX_DOUBLE_TAP_TIME: float = 0.3

var dash_timer: float = 0.0
var dash_dir: float = 0.0
var released: bool = false

@export var max_air_dashes: int = 2
var dashes: int = 2

func handle_dash(delta: float) -> void:
  if is_grounded: dashes = max_air_dashes
  
  dash_timer += delta
  
  var direction := Input.get_axis("left", "right")

  if direction and released and dashes > 0:
    if direction == dash_dir and dash_timer < MAX_DOUBLE_TAP_TIME:
      velocity.x = dash_dir * TOP_SPEED * 2
      velocity.y = 0
      dash_dir = 0.0
      dashes -= 1
    else:
      dash_dir = direction
      dash_timer = 0.0
  
  released = !direction

func handle_movement(delta: float) -> void:
  handle_vertical(delta)
  handle_horizontal(delta)
  handle_dash(delta)

  if !is_on_floor():
    velocity += get_gravity() * delta * gravity_mult

func _physics_process(delta: float) -> void:
  gravity_mult = 1.0
  
  handle_movement(delta)
  
  move_and_slide()
