@tool
class_name Projectile extends HitBox

@export var direction: Vector2:
  set(value):
    direction = value.normalized()
@export var speed: float = 100.0

var motor: CharacterBody2D

func _ready() -> void:
  super._ready()
  
  motor = CharacterBody2D.new()
  motor.motion_mode = CharacterBody2D.MOTION_MODE_FLOATING

  add_child(motor)

func _process(delta: float) -> void:
  super._process(delta)

  if !Engine.is_editor_hint():
    motor.velocity = direction * speed * delta * 60
    motor.move_and_slide()
    global_position += motor.position
    motor.position = Vector2.ZERO
