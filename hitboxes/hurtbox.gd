@tool
class_name HurtBox extends NeutralBox

var iframes: Dictionary[String, float] = {}

signal on_hit(from: HitBox)

func _process(delta: float) -> void:
  super._process(delta)
  
  collision.debug_color = Color(0.0, 1.0, 0.0, .42) if team == Globals.Teams.Player else Color(1.0, 0.0, 0.0, .42)
  
  collision_layer = int(pow(2, 1 + team))
  collision_mask = int(pow(2, 4 - team))

  for i in iframes.keys():
    iframes[i] -= delta
    if iframes[i] <= 0: iframes.erase(i)
  
  for i: HitBox in get_overlapping_areas():
    if i.iframe_group in iframes: continue
    
    on_hit.emit(i)
    i.on_hit.emit(self)
    
    iframes[i.iframe_group] = i.iframe_duration
    
    print(i.iframe_group)
