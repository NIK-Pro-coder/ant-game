class_name StatHolder extends Resource

@export var stat_base: float = 0.0:
  set(value):
    if value == stat_base: return
    
    stat_base = value
    stat_changed.emit()

@export var stat_flat: float = 0.0:
  set(value):
    if value == stat_flat: return
    
    stat_flat = value
    stat_changed.emit()

@export var stat_mult: float = 1.0:
  set(value):
    if value == stat_mult: return
    
    stat_mult = value
    stat_changed.emit()

var stat_value: float = 0.0:
  set(value): pass # make ts readonly
  get(): return stat_base * stat_mult + stat_flat

signal stat_changed
