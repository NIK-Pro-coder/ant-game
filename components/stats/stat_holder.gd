class_name StatHolder extends Resource

@export var stat_base: float = 125.0
@export var stat_flat: float = 0.0
@export var stat_mult: float = 1.0

var stat_value: float = 0.0:
  set(value): pass # make ts readonly
  get(): return stat_base * stat_mult + stat_flat
