@tool
class_name NeutralBox extends Area2D

@export var team: Globals.Teams
@export var shape: Shape2D = RectangleShape2D.new()

var collision: CollisionShape2D

func _ready() -> void:
  collision = CollisionShape2D.new()
  add_child(collision)

func _process(_delta: float) -> void:
  collision.shape = shape
