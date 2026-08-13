extends Node

enum Teams {
  Player,
  Enemy,
}

func _ready() -> void:
  process_mode = Node.PROCESS_MODE_ALWAYS
