@tool
class_name Hitbox extends Area2D

@export var team: Globals.Teams
@export var shape: Shape2D = RectangleShape2D.new()

@export var damage: int = 1.0

var collision: CollisionShape2D

func _ready() -> void:
  collision = CollisionShape2D.new()
  add_child(collision)

func _process(delta: float) -> void:
  collision_layer = int(pow(2, 3 + team))
  collision_mask = int(pow(2, 2 - team))

  collision.shape = shape
