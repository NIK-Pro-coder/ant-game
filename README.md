# Ant Game

Ant Game is a fast-paced roguelike where you're an ant that has to go room after room defeating enemies, upgrading your wepoan, getting new mutations and finally defeating the final boss.

## TODOS (For MVP):
  - [x] Components
    - [x] Health
      - [x] Store max hp & current hp
      - [x] Signals
        - [x] On damaged
        - [x] On dead
        - [x] On heal
        - [x] On fullheal
      - [x] Healthbars
    - [x] Stats
      - [x] Hold various player & enemy stats
        - [x] Speed
        - [x] Damage
        - [x] Defence
        - [ ] (Others...)
      - [x] Emit signals when stats change
  
  - [x] Hitbox/Hurtbox system
    - [x] Base hitboxes
      - [x] Teams
      - [x] Shape
      - [x] Damage values
      - [x] Hitstun values
      - [x] Lifetimes
      - [x] Signals
        - [x] On hit
        - [x] On expire
      - [x] Iframe info
    - [x] Hurtbox
      - [x] Shape
      - [x] Iframes
      - [x] Signals
        - [x] On hit
    - [x] Projectiles
      - [x] Movement
      - [x] Piercing
      - [x] Parrying
  
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
  
  - [ ] Weapons
    - [ ] Weapons resource
      - [ ] Primary (close range)
      - [ ] Secondary (long range or something to close the distance)
      - [ ] Ultimate (not sure abt this one)
      - [ ] Rarity
    - [ ] Have player swing weapons
    - [ ] Make weapons obtainable
  
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
