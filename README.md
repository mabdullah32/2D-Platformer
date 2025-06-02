## NeXTCS Final Project
## Teammate Wah: BRIAN OO
## Teammate Hoo: MUSTAFA ABDULLAH
---

### Project Description

Our project will be a metroidvania, with some roguelike aspects.

Plays similarly to hit game "20 Minutes Till Dawn," either top-down or underwater with low gravity and lots of drag, with enemies surrounding the player. However, enemies will be fewer but stronger and firing multiple projectiles for the player to dodge.

Point and click to shoot, WASD to mave, etc etc.

Likely a leveling system that scales the player's damage, hp, unlocks abilities(?)

Possibly a resource management system to use abilities...


### Skill Usage, in no particular order

Basic Drawing - rectangles, squares, and various other shapes used for the background, ground, and platforms

Using Colors/Controlling Color State - different colored tiles to represent different types of blocks. Different colors to easily differentiate between different aspects of the game

Primitive Variables and Types - floats: movement (calculating gravity or drag, depending on how we choose to format the game). integers: size of platforms, size of the game, representing different power-ups/materials using integers. 

Boolean Values - tell whether the game is lost, still going, or won, test for collisions with enemies and ground

setup and draw - setup: create the background and space. draw: update player position, enemy position, coins collected, etc. with each iteration

Readable Code - comments

Debugging Practices - using println() within functions to tell if they're working (in the debugging phase)

Conditional Statements - velocity change calculations, collision processing, and many more

Loops - to fill out the block grid array

ArrayLists: NKey, to keep track of keys currently pressed

2D Arrays: grid for walls, collectibles (pwr ups), traps, etc.

Objects and Classes: Enemy, Player, Projectile, Boss

LinkedLists: Segments of a centipede-like boss, with each node after the head following the node before it


### Libraries (optional)
Iff you plan to use any auxiliary libraries, for each library... 
* Provide a clickable link.
* Explain necessity/applicability.
* Fill out this form: <https://forms.gle/TMH9CYeS8QE3kTq56>
* *Nota bene: Auxiliary library use subject to instructor approval. Have a backup plan, should library usage request be denied.*
* As soon as possible, and time-permitting, build a proof-of-principle prototype to demonstrate to yourself and team that you can utilize this library.
