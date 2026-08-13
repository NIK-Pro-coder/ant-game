class_name StatComp extends Node

var spd_holder := StatHolder.new()
var atk_holder := StatHolder.new()
var def_holder := StatHolder.new()

#region UGLY AHH CODE
@export var spd_base: float = 0.0:
  set(value):
    spd_base = value
    spd_holder.stat_base = value
var spd_mult: float = 1.0:
  set(value):
    spd_mult = value
    spd_holder.stat_mult = value
var spd_flat: float = 0.0:
  set(value):
    spd_flat = value
    spd_holder.stat_flat = value
var spd: float = 0.0:
  set(value): pass # make ts readonly
  get(): return spd_holder.stat_value

@export var atk_base: float = 0.0:
  set(value):
    atk_base = value
    atk_holder.stat_base = value
var atk_mult: float = 1.0:
  set(value):
    atk_mult = value
    atk_holder.stat_mult = value
var atk_flat: float = 0.0:
  set(value):
    atk_flat = value
    atk_holder.stat_flat = value
var atk: float = 0.0:
  set(value): pass # make ts readonly
  get(): return atk_holder.stat_value

@export var def_base: float = 0.0:
  set(value):
    def_base = value
    def_holder.stat_base = value
var def_mult: float = 1.0:
  set(value):
    def_mult = value
    def_holder.stat_mult = value
var def_flat: float = 0.0:
  set(value):
    def_flat = value
    def_holder.stat_flat = value
var def: float = 0.0:
  set(value): pass # make ts readonly
  get(): return def_holder.stat_value
#endregion

signal stats_changed

func _ready() -> void:
  spd_holder.stat_changed.connect(stats_changed.emit)
  atk_holder.stat_changed.connect(stats_changed.emit)
  def_holder.stat_changed.connect(stats_changed.emit)
