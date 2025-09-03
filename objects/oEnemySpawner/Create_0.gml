
// what wave are we spawning?
waveSpawnCounter = 0;

// how many enemies to spawn per wave
nEnemiesSpawned = 0;
nEnemiesToSpawn = [4,8,8,8,8];

// used to alternative the enemy pattern
pattern = 0;

// reference positions for Guardian, Bee and Butterfly Enemies
nGuardiansSpawned = 0;
dx = 0;
dy = 0;

guardian_XPositions = [396,450,342,504];
guardian_YPositions = [120,120,120,120];

nButterfliesSpawned = 0;
butterfly_XPositions = [396,450,396,450,342,504,342,504,558,288,612,234,558,288,612,234];
butterfly_YPositions = [170,170,220,220,170,170,220,220,170,170,170,170,220,220,220,220];

nBeesSpawned = 0;
bee_XPositions = [396,450,396,450,504,342,504,342,558,288,612,234,558,288,612,234,666,180,666,180];
bee_YPositions = [270,270,320,320,270,270,320,320,270,270,270,270,320,320,320,320,270,270,320,320];

// wake up alarm to spawn an enemy
alarm[0]=20;


/*	
WAVE 1

4 Bees

[396, 270], [450, 270]
[396, 320], [450, 320]

4 Butterflies

[396, 170], [450, 170]
[396, 220], [450, 220]

WAVE 2

4 Guardians

[396, 120], [450, 120]
[342, 120], [504, 120]

4 Butterfles

[342, 170], [504, 170]
[342, 220], [504, 220]

WAVE 3

8 Butterflies

[558, 170], [288, 170]
[612, 170], [234, 170]

[558, 220], [288, 220]
[612, 220], [234, 220]

WAVE 4

8 Bees

[504, 270], [342, 270]
[504, 320], [342, 320]

[558, 270], [288, 270]
[612, 270], [234, 270]


WAVE 5 

8 Bees

[558, 270], [288, 270]
[612, 270], [234, 270]

[666, 270], [180, 270]
[666, 320], [180, 320]

*/

