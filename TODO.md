# TODO List for Second Scenario (Escenario 2) Implementation

- [x] Create new scene res://scenes/escenario2.tscn with background using escenario2.jpg
- [x] Create NPC script res://npcs/amante.gd extending npc.gd with custom dialogue
- [x] Create NPC scene res://npcs/amante.tscn using amante.png sprite
- [x] Add scene transition logic in player.gd to switch to escenario2 when moving right past x=4000
- [x] Integrate dialogue system: when player interacts with NPC, show dialogue via dialogue_ui
- [x] Add AudioStreamPlayer to main scene for background music (baloncesto16_retro_loop.ogg)
- [x] Update camera bounds to accommodate both scenes (extend right_bound)
- [x] Fix scene file syntax issues (camera_path NodePaths)
- [x] Fix dialogue_ui.tscn connection syntax
- [ ] Test scene transitions by moving player right
- [ ] Test NPC interaction and dialogue display
- [ ] Verify background music plays continuously
- [ ] Adjust camera bounds and scene positioning as needed
