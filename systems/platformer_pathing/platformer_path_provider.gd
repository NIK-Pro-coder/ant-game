@tool
class_name PlatformerPathProvider extends Node

@export var target: Vector2:
  set(value):
    if target == value: return
    
    target = value
    if target_gizmo: target_gizmo.global_position = value
    update_path()
@export var target_node: Node2D

@export var tilemap: TileMapLayer

var target_gizmo: Sprite2D

var pathing_gizmos: Array[Sprite2D] = []

func destroy_gizmos() -> void:
  target_gizmo = null
  pathing_gizmos.clear()
  
  for i in get_children():
    i.queue_free()

func create_gizmos() -> void:
  destroy_gizmos()
  
  target_gizmo = create_gizmo("Target")
  target_gizmo.global_position = target
  
  add_child(target_gizmo)
  
  target_gizmo.owner = owner

func create_gizmo(gizmo_name: String, gizmo_scale: Vector2 = Vector2.ONE, gizmo_color: Color = Color.WHITE) -> Sprite2D:
  if has_node(gizmo_name): get_node(gizmo_name).queue_free()
  
  var gizmo := Sprite2D.new()
  gizmo.texture = preload("uid://cfjl56656abr8")
  gizmo.name = gizmo_name
  gizmo.scale = gizmo_scale
  gizmo.modulate = gizmo_color
  
  return gizmo

func update_gizmos() -> void:
  target_gizmo.scale = Vector2(.25, .25)
  target_gizmo.modulate = Color.BLUE
  target = target_gizmo.global_position

func is_tile_solid(coords: Vector2i) -> bool:
  var self_data := tilemap.get_cell_tile_data(coords)
  
  if !self_data: return false
  
  return self_data.get_collision_polygons_count(0) > 0

func update_path() -> void:
  if !tilemap or !tilemap.tile_set: return
  
  @warning_ignore("narrowing_conversion")
  var target_pos := Vector2i(target.x / tilemap.tile_set.tile_size.x, target.y / tilemap.tile_set.tile_size.y + 1)
  
  var used_rect: Rect2i = tilemap.get_used_rect()
  
  for i in pathing_gizmos:
    if is_instance_valid(i): i.queue_free()
  pathing_gizmos.clear()
  for i in get_children():
    if i.name.begins_with("path"): i.free()
  
  for x in range(used_rect.size.x):
    for y in range(used_rect.size.y):
      var tpos := Vector2i(
        x + used_rect.position.x,
        y + used_rect.position.y,
      )
      
      if (is_tile_solid(tpos) and !is_tile_solid(tpos + Vector2i(0, -1))) or target_pos == tpos:
        if !has_node("path%s%s" % [tpos.x, tpos.y]):
          var gizmo := create_gizmo("path%s%s" % [tpos.x, tpos.y], Vector2(.1, .1), Color.GREEN)
          gizmo.global_position = Vector2(
            (tpos.x + .5) * tilemap.tile_set.tile_size.x,
            (tpos.y - .5) * tilemap.tile_set.tile_size.y,
          )
          
          add_child(gizmo)
          pathing_gizmos.append(gizmo)
        
        for ox in [-1, 1]:
          if !is_tile_solid(tpos + Vector2i(ox, 0)):
            if !has_node("path%s%s" % [tpos.x + ox, tpos.y]):
              var gizmo_side := create_gizmo("path%s%s" % [tpos.x + ox, tpos.y], Vector2(.1, .1), Color.ORANGE)
              gizmo_side.global_position = Vector2(
                (tpos.x + .5 + ox) * tilemap.tile_set.tile_size.x,
                (tpos.y - .5) * tilemap.tile_set.tile_size.y,
              )
              
              add_child(gizmo_side)
              pathing_gizmos.append(gizmo_side)
            
            for i in range(1, 100):
              if !is_tile_solid(tpos + Vector2i(ox, i-1)):
                var gizmo_down := create_gizmo("path%s%s" % [tpos.x + ox, tpos.y + i], Vector2(.1, .1), Color.RED)
                gizmo_down.global_position = Vector2(
                  (tpos.x + .5 + ox) * tilemap.tile_set.tile_size.x,
                  (tpos.y - .5 + i) * tilemap.tile_set.tile_size.y,
                )
                
                add_child(gizmo_down)
                pathing_gizmos.append(gizmo_down)
              else: break

  var visited: Array[Vector2i] = []
  var previous: Array[Vector2i] = [target_pos]
  var frontier: Array[Vector2i] = [target_pos]
  
  while len(frontier) > 0:
    var prev := previous[0]
    var pos := frontier[0]
    frontier.pop_front()
    previous.pop_front()
    
    visited.append(pos)
    
    var dir: float = 0.0
    
    if prev.x < pos.x: dir = PI * 1.5
    if prev.x > pos.x: dir = PI * 0.5
    if prev.y < pos.y: dir = PI * 0.0
    if prev.y > pos.y: dir = PI * 1.0
    
    var g: Sprite2D = get_node("path%s%s" % [pos.x, pos.y])

    g.rotation = dir
    
    for o in [
      Vector2i(-1, 0),
      Vector2i(1, 0),
      Vector2i(0, -1),
      Vector2i(0, 1),
    ] :
      var n := "path%s%s" % [pos.x + o.x, pos.y + o.y]
      
      if has_node(n) and !(pos + o) in visited:
        frontier.append(pos + o)
        previous.append(pos)

func _ready() -> void:
  if Engine.is_editor_hint(): create_gizmos()
  
  await tilemap.ready
  
  tilemap.changed.connect(update_path)

func _process(_delta: float) -> void:
  if Engine.is_editor_hint(): update_gizmos()
  elif target_node and target.distance_squared_to(target_node.global_position) > 32: target = target_node.global_position

func get_next_direction(pos: Vector2) -> Vector2:
  var min_dist: float = -1
  var min_rot: float = 0
  var min_pos: Vector2 = Vector2.ZERO
  for i in get_children():
    if i.name.begins_with("path"):
      var d := (i as Sprite2D).global_position.distance_squared_to(pos)
      
      if d < min_dist or min_dist < 0:
        min_dist = d
        min_rot = (i as Sprite2D).rotation
        min_pos = (i as Sprite2D).global_position
  
  return (
    (min_pos - pos).normalized() * .5 + \
    Vector2.from_angle(min_rot - PI / 2.0)
  ).normalized()
