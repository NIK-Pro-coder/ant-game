@tool
class_name Projectile extends HitBox

@export var direction: Vector2:
  set(value):
    direction = value.normalized()
@export var speed: float = 100.0

@export var max_piercing: int = -1
var pierced: Array[HurtBox] = []

var motor: CharacterBody2D

func _ready() -> void:
  super._ready()
  
  motor = CharacterBody2D.new()
  motor.motion_mode = CharacterBody2D.MOTION_MODE_FLOATING

  add_child(motor)

func _process(delta: float) -> void:
  super._process(delta)
  
  if team == Globals.Teams.Enemy:
    collision_mask |= 8
    if len(get_overlapping_areas()) > 0:
      team = Globals.Teams.Player
      direction = -direction
      speed = speed * 1.2

  if !Engine.is_editor_hint():
    motor.velocity = direction * speed * delta * 60
    motor.move_and_slide()
    global_position += motor.position
    motor.position = Vector2.ZERO

func hit(what: HurtBox) -> void:
  super.hit(what)
  
  if !what in pierced: pierced.append(what)
  
  if len(pierced) > max_piercing and max_piercing >= 0:
    queue_free()
