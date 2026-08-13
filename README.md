# Ant Game

Ant Game is a fast-paced roguelike where you're an ant that has to go room after room defeating enemies, upgrading your wepoan, getting new mutations and finally defeating the final boss.

## TODOS (For MVP):
  - [ ] Components
    - [ ] Health
      - [ ] Store max hp & current hp
      - [ ] Signals
        - [ ] On damaged
        - [ ] On dead
        - [ ] On heal
        - [ ] On fullheal
      - [ ] Healthbars
    - [ ] Stats
      - [ ] Hold various player & enemy stats
        - [ ] Speed
        - [ ] Damage
        - [ ] Defence
        - [ ] (Others...)
      - [ ] Emit signals when stats change
  
  - [ ] Hitbox/Hurtbox system
    - [ ] Base hitboxes
      - [ ] Shape
      - [ ] Damage values
      - [ ] Hitstun values
      - [ ] Lifetimes
      - [ ] Iframe info
    - [ ] Projectiles
      - [ ] Movement
      - [ ] Piercing
      - [ ] Parrying
    - [ ] Hurtbox
      - [ ] Shape
      - [ ] Iframes
  
  - [ ] Player
    - [ ] Velocity-based horizontal movement
      - [ ] Acceleration
      - [ ] Air & ground friction
    - [ ] Jumping
      - [ ] Coyote time
      - [ ] Jump buffering
      - [ ] Multiple jumps
    - [ ] Dash
      - [ ] Dash buffering
      - [ ] Multiple dashes
  
  - [ ] Enemies
    - [ ] Enemy spawner
    - [ ] Enemy AI
      - [ ] Base pathfinding
      - [ ] Base auto-retarget
  
  - [ ] Level generator
    - [ ] Graph generation
      - [ ] Make branching structure
      - [ ] Special rooms (item rooms, shops, etc.)
      - [ ] Ensure special room spawns
    - [ ] Room generation
    - [ ] Actual generation
      - [ ] Layout generated rooms
      - [ ] Add corridors
  
  - [ ] Mutation system
    - [ ] Mutation resource
      - [ ] Icon
      - [ ] Name
      - [ ] Description
      - [ ] Rarity (or weight idk)
      - [ ] Methods to apply effects
        - [ ] Passive
        - [ ] On player hit enemy
        - [ ] On enemy hit player
        - [ ] On player jump
        - [ ] On player land
        - [ ] On player dash
        - [ ] On player kill enemy
        - [ ] On parry
    - [ ] Mutation orb