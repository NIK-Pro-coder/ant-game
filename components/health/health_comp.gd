class_name HealthComp extends Node

signal on_damage(amt: int)
signal on_killed
signal on_heal(amt: int)
signal on_fullheal

var health: int = 5:
  set(value):
    health = value
    update_healthbar()
@export var max_hp: int = 5:
  set(value):
    var r: float = float(value) / float(max_hp)
    health = int(round(health * r))
    max_hp = value
    update_healthbar()

@export var healthbar: Healthbar

func update_healthbar() -> void:
  if !healthbar: return
  
  healthbar.health = health
  healthbar.max_hp = max_hp

func kill() -> void: damage(max_hp)
func fullheal() -> void: damage(-max_hp)

func heal(amt: int) -> void:
  damage(-amt)

func damage(amt: int) -> void:
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
