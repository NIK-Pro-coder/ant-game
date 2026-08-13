@tool
class_name Healthbar extends ProgressBar

const HEALTH_PIP_SIZE: float = 16.0

@export var max_hp: float = 5:
  set(value):
    max_hp = value
    lag_time = .5
@export var health: float = 5:
  set(value):
    health = value
    lag_time = .5

@export var always_show: bool = false

var initial_pos: Vector2 = Vector2.ZERO

var bar_behind: ProgressBar
var lag_time: float = 0.0
var going_up: bool = false

var style_fill := StyleBoxFlat.new()
var style_fill_behind := StyleBoxFlat.new()

func _ready() -> void:
  initial_pos = position
  initial_pos.x += max_hp * HEALTH_PIP_SIZE / 2.0
  show_percentage = false
  
  style_fill.bg_color = Color(1.0, 0.227, 0.258)
  style_fill.corner_radius_bottom_left = 4
  style_fill.corner_radius_bottom_right = 4
  style_fill.corner_radius_top_left = 4
  style_fill.corner_radius_top_right = 4
  
  add_theme_stylebox_override("fill", style_fill)
  
  bar_behind = ProgressBar.new()
  bar_behind.show_percentage = false
  bar_behind.z_index = -1
  add_child(bar_behind)
  
  style_fill_behind.bg_color = Color(1.0, 1.0, 1.0)
  style_fill_behind.corner_radius_bottom_left = 4
  style_fill_behind.corner_radius_bottom_right = 4
  style_fill_behind.corner_radius_top_left = 4
  style_fill_behind.corner_radius_top_right = 4
  
  bar_behind.add_theme_stylebox_override("fill", style_fill_behind)
  
  var style_bg := StyleBoxFlat.new()
  style_bg.bg_color = Color(0, 0, 0, .25)
  style_bg.corner_radius_bottom_left = 4
  style_bg.corner_radius_bottom_right = 4
  style_bg.corner_radius_top_left = 4
  style_bg.corner_radius_top_right = 4
  
  bar_behind.add_theme_stylebox_override("background", style_bg)

func _process(delta: float) -> void:
  var diff_size: float = abs(max_hp * HEALTH_PIP_SIZE - size.x)
  if diff_size < .1: size.x = max_hp * HEALTH_PIP_SIZE
  size.x = size.x * .9 + max_hp * HEALTH_PIP_SIZE * .1
  size.y = HEALTH_PIP_SIZE
  
  bar_behind.size = size
  
  if !Engine.is_editor_hint():
    position = initial_pos
    position.x -= size.x / 2.0
  
  max_value = max_hp
  bar_behind.max_value = max_hp
  
  var diff_hp: float = abs(health - value)
  if diff_hp < .06: value = health
  value = value * .9 + health * .1

  lag_time -= delta
  if lag_time < 0:
    var diff_behind: float = abs(health - bar_behind.value)
    if diff_behind < .06: bar_behind.value = health
    bar_behind.value = bar_behind.value * .9 + health * .1

  if health > bar_behind.value and !going_up:
    add_theme_stylebox_override("fill", style_fill_behind)
    bar_behind.add_theme_stylebox_override("fill", style_fill)
    bar_behind.z_index = 1
  elif health <= bar_behind.value and going_up:
    add_theme_stylebox_override("fill", style_fill)
    bar_behind.add_theme_stylebox_override("fill", style_fill_behind)
    bar_behind.z_index = -1
  
  going_up = health > bar_behind.value
  
  modulate.a = modulate.a * .9 + (0.1 if value < max_hp or bar_behind.value < max_hp or always_show or Engine.is_editor_hint() else 0.0)
