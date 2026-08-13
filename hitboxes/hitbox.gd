@tool
class_name HitBox extends NeutralBox

@export var damage: float = 1.0
@export var hitstun: float = .1

@export var lifetime: float = -1.0

@export var iframe_group: String = ""
@export var iframe_duration: float = .1

signal on_expire
signal on_hit(what: HurtBox)

func _ready() -> void:
  super._ready()
  
  if iframe_group == "" and !Engine.is_editor_hint():
    iframe_group = str(get_instance_id())
  
  if lifetime > 0 and !Engine.is_editor_hint():
    var t := Timer.new()
    t.autostart = true
    t.wait_time = lifetime
    t.timeout.connect(queue_free)
    add_child(t)

func _process(_delta: float) -> void:
  super._process(_delta)
  
  collision.debug_color = Color(0.0, 1.0, 0.0, .42) if team == Globals.Teams.Player else Color(1.0, 0.0, 0.0, .42)
  
  collision_layer = int(pow(2, 3 + team))
  collision_mask = int(pow(2, 2 - team))

func hit(what: HurtBox) -> void:
  on_hit.emit(what)

func _exit_tree() -> void:
  on_expire.emit()
