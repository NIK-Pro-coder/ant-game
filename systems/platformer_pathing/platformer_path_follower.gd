class_name PlatformerPathFollower extends Node2D

@export var provider: PlatformerPathProvider

func get_next_dir() -> Vector2:
  return provider.get_next_direction(global_position)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  var dir := get_next_dir()
  
  print(dir)
  
  global_position += dir
