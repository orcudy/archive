var hero;

function Game(xD_size, yD_size, zD_size, obstacleDensity, numEnemies,  startPosition){
	if(!(this instanceof Game)) return new Game(xD_size, yD_size, zD_size, obstacleDensity, startPosition);
  
	this.map = new Map(xD_size, yD_size, zD_size, obstacleDensity);
  hero = new Hero(startPosition, "hero");
  this.hero = hero;

  this.enemies = this.createEnemies(1, "enemyD");
  this.enemies = this.createEnemies(1, "enemyB");
  this.enemies = this.createEnemies(1, "enemyC");
  this.enemies = this.createEnemies(1, "enemyA");
  this.map.placeEnemies(this.enemies);  this.map.placeEnemies(this.enemies);
  this.camera = new Camera(this);

  this.collisionDetector = new CollisionDetector(this);
  this.collisionHandler = new CollisionHandler(this);
  this.collisionDetector.detect();

  this.heroFrameCount = 0;
  this.enemyFrameCount = 0;
  this.updateCount = 9;
  this.moveDistance = 5; 

  this.cheat = false;
  this.chomp = document.getElementById("chomp");
}

Game.prototype.moveHero = function(x, y, z){
  this.heroFrameCount = 0
  this.hero.move(x, y, z);
  this.camera.updateHero(x, y, z);
  this.collisionDetector.detect();
}

Game.prototype.moveCamera = function(x, y){
  var rotationAmount = 3;
  this.camera.updateMap(x * rotationAmount, y * rotationAmount);
}

var enemies = [];
Game.prototype.createEnemies = function(numEnemies, type){
  for (var i = 0; i < numEnemies; i ++){
    var x = getRandom(0, this.map.xD_size - 1);
    var y = getRandom(0, this.map.yD_size - 1);
    var z = getRandom(-this.map.zD_size + 1, 0);
    var location = new Point(x, y, z);
    var enemy = new Enemy(location, type);
    enemies.push(enemy);
  }
  return enemies;
}

Game.prototype.changeEnemiesDirection = function(){
  this.enemyFrameCount = 0;
  for (var i = 0; i < this.enemies.length; i++){
    var enemy = this.enemies[i];

    var randA;
    var randB;
    do {
      randA = getRandom(0, 3);
      randB = getRandom(0, 2);
    } while (((enemy.position.x + this.moveDistance >= this.map.xD_size - 1) && (randA == 0) && (randB == 0)) ||
             ((enemy.position.x - this.moveDistance <= 0) && (randA == 0) && (randB == 1)) ||
             ((enemy.position.y + this.moveDistance >= this.map.yD_size - 1) && (randA == 1) && (randB == 0)) ||
             ((enemy.position.y - this.moveDistance <= 0) && (randA == 1) && (randB == 1)) ||
             ((enemy.position.z + this.moveDistance <= -this.map.zD_size + 1) && (randA == 2) && (randB == 1)) ||
             ((enemy.position.z - this.moveDistance >= 0) && (randA == 2) && (randB == 0)));
    
    var movement;
    (randB == 0) ? (movement = 1) : (movement = -1); 
    switch (randA){
      case 0:
        enemy.move(movement, 0, 0)
        break;
      case 1:
        enemy.move(0, movement, 0);
        break;
      case 2:
        enemy.move(0, 0, movement);
        break;
    }
  }
}

Game.prototype.moveEnemies = function(){
  for (var i = 0; i < this.enemies.length; i++){
    var enemy = this.enemies[i];
    enemy.move(enemy.heading.x, enemy.heading.y, enemy.heading.z); 
    this.collisionDetector.detect();
  }
}

Game.prototype.updateEnemies = function(){
  for (var i = 0; i < this.enemies.length; i++){
    var enemy = this.enemies[i];
    this.camera.updateEnemy(enemy);
    enemy.renderer.draw();
  }
}

Game.prototype.drawScene = function(){
  
  if (this.cheat){
    this.heroFrameCount = 1;
    this.enemyFrameCount = 1;
    this.chomp.pause();
  } else {
    this.heroFrameCount++;
    this.enemyFrameCount++;
    this.chomp.play();
  }


  //move hero forward at constant rate
  if (this.heroFrameCount % this.updateCount == 0){
    this.moveHero(this.hero.heading.x, this.hero.heading.y, this.hero.heading.z);
  }

  //move enemies at constant rate
  if (this.enemyFrameCount % this.updateCount == 0){
    this.moveEnemies();
  }

  //change direction after moving x times in one direction
  if (this.enemyFrameCount % (this.updateCount * this.moveDistance) == 0){
    this.changeEnemiesDirection();
  }

  this.camera.update();

  gl.useProgram(pelletProgram);
  this.map.renderer.draw();

  gl.useProgram(heroProgram);
  this.hero.renderer.draw();

  gl.useProgram(enemyProgram);
  this.updateEnemies();

}
