@tool
class_name Hitbox extends Area2D

@export var team: Globals.Teams

var shape: CollisionShape2D

func _ready() -> void:
  shape = CollisionShape2D.new()

func _process(delta: float) -> void:
  collision_layer = int(pow(2, 3 + team))
  collision_mask = int(pow(2, 2 - team))
