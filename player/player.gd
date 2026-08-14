class_name Player extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -600.0

@export var max_jumps: int = 2
var jumps: int = 0

@export var max_jump_buffer: float = .1
var jump_buf: float = 0.0

@export var max_coyote_time: float = .1
var coyote_time: float = 0.0

@export var max_jump_cooldown: float = .25
var jump_cool: float = 0.0

func handle_vertical(delta: float) -> void:
  jump_buf -= delta
  if Input.is_action_pressed("jump"): jump_buf = max_jump_buffer

  coyote_time -= delta
  if is_on_floor(): coyote_time = max_coyote_time

  if coyote_time > 0: jumps = max_jumps
  else: jumps = min(jumps, max_jumps - 1)

  jump_cool -= delta
  if jump_buf > 0 and jumps > 0 and jump_cool <= 0:
    jumps -= 1
    jump_buf = 0
    coyote_time = 0
    jump_cool = max_jump_cooldown
    velocity.y = JUMP_VELOCITY

func handle_movement(delta: float) -> void:
  if not is_on_floor():
    velocity += get_gravity() * delta
  
  handle_vertical(delta)
  
  # Get the input direction and handle the movement/deceleration.
  # As good practice, you should replace UI actions with custom gameplay actions.
  var direction := Input.get_axis("left", "right")
  if direction:
    velocity.x = direction * SPEED
  else:
    velocity.x = move_toward(velocity.x, 0, SPEED)


func _physics_process(delta: float) -> void:
  handle_movement(delta)
  
  move_and_slide()
