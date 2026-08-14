@tool
class_name PlatformerPathProvider extends Node

@export var target: Vector2:
  set(value):
    if target == value: return
    
    target = value
    if target_gizmo: target_gizmo.global_position = value
    update_path()

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
  if !tilemap: return
  
  var used_rect: Rect2i = tilemap.get_used_rect()
  
  for i in pathing_gizmos:
    if is_instance_valid(i): i.queue_free()
  pathing_gizmos.clear()
  for i in get_children():
    if i.name.begins_with("path"): i.queue_free()
  
  await get_tree().process_frame
  
  for x in range(used_rect.size.x):
    for y in range(used_rect.size.y):
      var tpos := Vector2i(
        x + used_rect.position.x,
        y + used_rect.position.y,
      )
      
      @warning_ignore("narrowing_conversion")
      if (is_tile_solid(tpos) and !is_tile_solid(tpos + Vector2i(0, -1))) or Vector2i(target.x / tilemap.tile_set.tile_size.x, target.y / tilemap.tile_set.tile_size.y) == tpos:
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

func _ready() -> void:
  if Engine.is_editor_hint(): create_gizmos()
  
  await tilemap.ready
  
  tilemap.changed.connect(update_path)

func _process(_delta: float) -> void:
  if Engine.is_editor_hint(): update_gizmos()
