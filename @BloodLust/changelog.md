# BloodLust Changelog

## 2022.03.24:

- Added setting to disable BloodLust processing on dead units for performance gains.
- Swapped out usages of createVehicleLocal to createSimpleObject for spawning objects such as blood splatters when in singleplayer for improved performance.
- Disabled blood pooling by default due to flickering issue.
- Reduced blood pool size.
- Increased blood brightness.
- Improved surface detection for blood splatter placement, allowing blood to splatter on more surfaces.
- Fixed very transparent bleed droplet textures.
- Fixed large blood splatters not rendering properly from dead vaporized units.

----

## Legacy Changelog

[7-9-2017] v2.484:
Reduced blood pool flickering.

[7-9-2017] v2.483:
Fixed bug where blood was black in cloudy weather.

[7-9-2017] v2.482:
Tweaked default configuration.
Added blood spray jitter config.
Removed blood splatter emission limit from units.

[7-8-2017] v2.481:
Increased blood brightness.
Added a new blood pool animation.

[7-2-2017] v2.48:
Improved texture preloading (enable via setting "BloodLust_IsTexturePreloadingEnabled" to "true" in the BloodLust Settings Menu).
Fixed bug where blood splatters didn't spawn when a unit was hit by an explosion.
Added config entry for explosion gib force.
Adjusted blood material to fix bright blood splatters.
Updated blood textures to look more realistic.
Reduced blood droplet size for bleeding.
Reduced blood smear size.

[7-1-2017] v2.473:
Fixed object error in main menu.

[6-29-2017] v2.472:
Removed game's default blood splatters to retain consistency when using BloodLust.
Reduced vaporization gib force.

[6-27-2017] v2.471:
Hotfix for blood pool z-fighting issue.

[6-25-2017] v2.47:
Added blood pooling.

[12-11-2016] v2.46:
Added vaporization effect for multiplayer.
Added method for server owners to force certain settings on clients (check "ConfigurablesMultiplayer.sqf").
Blood splatters in multiplayer now inherit the projectile's rotation like in the singleplayer version.
Corrected usage of playSound3D command in the codebase for multiplayer environments.

[12-3-2016] v2.45:
Exposed all configurables to the BloodLust Settings Menu, expanding the usage of third-party/custom content for BloodLust.
Fixed issue where some settings wouldn't apply when imported.
Fixed splatter rotation math (blood smears now rotate correctly, following the wound path, instead of being a random rotation).
Blood splatters are now rotated to visualize the projectile path.

[11-28-2016] v2.44:
Replaced blood splatter monitoring algorithm, which removed splatters from destroyed buildings, with an event-driven system for better performance.
Vaporized gibs will now emit blood smears instead of blood droplets.

[11-28-2016] v2.43:
Added settings to limit the total number of blood sprays.
Minor optimizations applied to blood spray animation function.
The game will now pause while in the BloodLust Settings menu.

[11-26-2016] v2.42
Added the ability to import and export settings via the BloodLust Settings menu.

[7-2-2016] v2.41:
Fixed error in model configs (extra comma).
Fixed blood splatter shading (was too dark).
Fixed gib spawn position.

[6-10-2016] v2.4:
Added parameter validation on BloodLust_CreateBloodSpray to prevent possible script error.
Added vaporization effect to units which are killed from a high-speed fall.
Added blood splatters for units hit by explosions.
Added more blood splatter textures.
Fixed cleanup functionality not executing.
Added credits button to BloodLust Settings menu.
Added large blood splatter model for vaporization damage.

[6-7-2016] v2.34:
Fixed script error in multiplayer core regarding an undefined variable, "_lastEventTime".

[6-5-2016] v2.33:
Exploding vehicles will now cause its crew to vaporize.
Gib textures tweaked.
Added unit vaporized event hook.
Added camera switch to a gib upon vaporization of the player.
Possible performance improvement in multiplayer (switched remoteExecCall with remoteExec).

[6-4-2016] v2.32:
Fixed script error in multiplayer core when a unit was hit.

[6-3-2016] v2.31:
Added BloodLust Settings menu to multiplayer.
Increased amount of blood splatters emitted.
Fixed addon key and signature.

[6-1-2016] v2.3:
Remade gibs which now consist of body parts.
Fixed vaporized gib spawn bug (only one set of gibs would spawn per game).
Fixed explosion bleed bug (units were bleeding an insane amount when hit with an explosive but survived).
Fixed massive framerate drop when a large explosions goes off near blood splatters.
Expanded programability for modders by adding pre and post event handlers for BloodLust events.
Added multiplayer support (WIP).
Added sound effects for blood sprays and additional sounds for vaporization.
Temporarily removed meat chunks (will create new models in the future).

[5-24-2016] v2.2:
Improved performance on explosive handling -- now handled by dedicated Explosion event handler (also resulting in better damage accuracy).
Enhanced vaporization gib selection algorithm.
Added hand and arm gibs.
Made blood slightly transparent.
Added blood mist to vaporization effect (courtesy of BadBenson).
Added heat wave effect to vaporized objects.
Replaced the two ugly oval blood splatters with more natural shapes.
Overhauled blood splatter system (complete rewrite).
Blood splatters from vaporization now utilize new blood splatter system, resulting in blood on walls, and ceilings.
Improved blood splatter monitoring (removes blood splatters that are at invalid positions).
Bleeding wounds will now smear across surfaces (such as when a unit is shot against a wall and slumps over).
Added speed threshold for blood to emit from gibs, preventing bleed spam.
Increased variety of vaporization blood splatter textures.
Vaporization is now enabled on the player by default.
Fixed timing issues with splatter spawning.
Increased default bleed duration.
Explosion force now determines vaporized gib speed.
Modified the "Man" class to emit blood regardless if blood is disabled in the Game Settings (this is for those who want to keep blood mists but remove the pizza sauce blood pools from the base game).
Added arterial blood spray (blood will spray out during bleeding).
Added texture preloading to cache blood textures for quicker loading.

[5-19-2016] v2.1:
Overhauled vaporization conditions.
Added body exploding sound effects to vaporization.
Added two new gibs (skull fragment and bone shard).
Added collision sounds when a unit is hit by a vehicle.
Added probability that a unit can be vaporized when hit by a high-speed vehicle.
Fixed intestine gib (was frozen in place).
Reduced gib bounciness.
Added version number to BloodLust Settings menu.
Added distance-based clean-up of BloodLust (removes splatters, gibs, etc, once the player leaves the area; can be toggled via Settings Menu).
Moved all scheduled code into PFHs.
Refactored code base, prefixing all global variables with "BloodLust_" to prevent naming collision.

[5-16-2016] v2.05:
Made gibbing dependent upon ammo caliber.
Fixed vaporization (was not triggering).
Added new brain gib model.

[5-16-2016] v2.04:
Fixed configuration file which caused BloodLust to have compatibility issues with others addons.

[5-14-2016] v2.03:
Added property descriptions to BloodLust Settings menu.

[5-12-2016] v2.02:
Added settings regarding blood sprays and blood splatter probability.
Fixed bug where player could be vaporized, regardless if the setting was toggled off.
Added mod image.

[5-10-2016] v2.01:
Fixed UI sizing.
Moved "BloodLust Settings" button to top-right of Escape menu.
Added "Reset" button to Settings Manager (resets everything to default values).

[5-10-2016] v2.0:
Added ingame settings menu, accessible from the escape menu.
Swapped low health blood splatters with high health blood splatters for a more realistic effect.
Blood splatters on surfaces now have a random direction.

[5-9-2016] v1.9:
Bullet caliber now affects amount of blood splatter emitted.
Added more blood splatter textures.
Tweaked values.

[5-7-2016] v1.8:
Expanded upon vaporization with a new gib model and more blood splatters.
Added blood spray animations for exit wounds.
Added weight to gibs, reducing bounciness.
Bug fixes (such as floating bleed splatters) and code refactoring.

[5-5-2016] v1.71:
Fixed script error on bleed.

[5-5-2016] v1.7:
Remade blood splatter textures.
Overhauled blood splatter system to use units' hitpoint health, resulting in large, medium, and small blood splatters.
Dead units will now continue to bleed out, leaving puddles of blood where they were hit.
Performance improvements.

[5-4-2016] v1.7b:
Meat chunks now shoot out towards the path of the projectile.
Meat chunks are now less bouncy.
Tweaked values for more blood and increased splatter limits.
Increased gib bleed rate.

[5-3-2016] v1.7a:
Meat chunks now emit blood when it hits surfaces.
Reduced meat chunk spawns.
Added leg gibs for vaporization (very WIP).
Modified blood splatters to be darker and not glow indoors.

[5-1-2016] v1.6:
Added meat chunks and brain matter when a unit is hit (WIP).
Added blood drip sounds on bleeding.

[4-24-2016] v1.5:
Added bleeding (units will drip blood).

[4-24-2016] v1.41:
Changed vaporization implementation to make unit invisible instead of deleting them (to prevent issues with missions and various scripts).
Added configurables to toggle vaporization.

[4-24-2016] v1.4:
Added jitter to blood splatter placement, causing them to look more messy.
Randomized amount of blood splatters emitted per hit (still limited to BloodSplatterIterations).
Added more configurables.
Updated surface intersection blacklist, allowing objects baked into a map to receive splatters.
Explosives will "vaporize" a unit (such as an explosive charge) -- Will be expanded upon in the future.
Optimized parts of code, resulting in improved performance.

[4-23-2016] v1.31:
Increased blood splatter iterations (more blood emitted).
Added code to allow for configuration (still WIP; will include a mission in the future to configure values).

[4-22-2016] v1.3:
Splatters will now be removed if they are no longer at a valid position (such as a building that was just destroyed) -- reduces floating splatters.
Added limit to amount of hits which occur per unit per HitPart event (should improve performance on large explosions or splash damage).

[4-20-2016] v1.2:
Improved surface blacklisting logic.
Improved exit-wound normal (adding a bit more dynamic-ness to the splatter positions).
Increased blood iterations (more blood emitted).
Reduced chance of blood splatters sticking out of corners and small surfaces.

[4-18-2016] v1.1:
Splatters' position offset from surfaces to prevent Z-Fighting.
Revamped splatter texture selection based on where a unit is hit.
Remade splatter textures -- now at a whopping 48 splatters!

[4-17-2016] v1.01:
Fixed some issues with surface intersections;
Fixed bug with splatters glitching out vehicles (splatters are now attached to vehicles);

[4-17-2016] v1.0:
More blood textures;
Blood splatters now align to surfaces (such as walls);

[4-17-2016] v0.11:
Refactored configuration (should fix related issues);
Reduced blood splatter iterations (was too exaggerated);
Reduced max blood splatter limit;

[4-16-2016] v0.1:
Initial Release -- Expect issues
