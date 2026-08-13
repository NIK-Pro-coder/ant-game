class_name HealthComp extends Node

signal on_damage(amt: float)
signal on_killed
signal on_heal(amt: float)
signal on_fullheal

var health: float = 5:
  set(value):
    health = value
    update_healthbar()
@export var max_hp: float = 5:
  set(value):
    var r: float = value / max_hp
    health *= r
    max_hp = value
    update_healthbar()

@export var healthbar: Healthbar

func update_healthbar() -> void:
  if !healthbar: return
  
  healthbar.health = health
  healthbar.max_hp = max_hp

func kill() -> void: damage(max_hp)
func fullheal() -> void: damage(-max_hp)

func heal(amt: float) -> void:
  damage(-amt)

func damage(amt: float) -> void:
  if amt == 0: return
  
  health = clamp(health - amt, 0, max_hp)
  
  if amt > 0:
    on_damage.emit(amt)
    if health <= 0: on_killed.emit()
  else:
    on_heal.emit(amt)
    if health >= max_hp: on_fullheal.emit()

func _ready() -> void:
  health = max_hp

  update_healthbar()
