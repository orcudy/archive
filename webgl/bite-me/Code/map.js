function Space(hasObstacle, hasEnemy){
  if(!(this instanceof Space)) return new Space();
  this.obstacle = hasObstacle;
  this.enemy = hasEnemy;
}

function Map(xD_size, yD_size, zD_size, obstacleDistance, enemies){
  if(!(this instanceof Map)) return new Map(xD_size, yD_size, zD_size);

  this.xD_size = xD_size;
  this.yD_size = yD_size;
  this.zD_size = zD_size;

  //all valid spaces in world
  this.spaces = [];
  this.initSpaces();

  //obstacle data
  this.obstacleDistance = obstacleDistance;
  this.numObstacles_x = Math.ceil(xD_size / obstacleDistance);
  this.numObstacles_y = Math.ceil(yD_size / obstacleDistance);
  this.numObstacles_z = Math.ceil(zD_size / obstacleDistance);
  this.totalObstacles = this.numObstacles_x * this.numObstacles_y * this.numObstacles_z;

  //coordinates of all obstacles on map
  this.obstacleLocations = [];
  this.placeObstacles(obstacleDistance);

  this.renderer = new PelletRenderer("pellet", this.obstacleLocations.length, this.obstacleLocations);
}

Map.prototype.placeEnemies = function(enemies){
  for (var i = 0; i < enemies.length; i++){
    var enemy = enemies[i];
    this.spaces[enemy.position.x][enemy.position.y][-enemy.position.z].enemy = true;
  }
}

Map.prototype.initSpaces = function(){
  for (var x = 0; x < this.xD_size; x++){
    this.spaces[x] = [];
    for (var y = 0; y < this.yD_size; y++){
      this.spaces[x][y] = [];
      for (var z = 0; z < this.zD_size; z++){
        //CUSTOM: place map initialization code here
        var space = new Space(false, false);
        this.spaces[x][y].push(space);
      }
    }
  }
}

//order of loops matters! (obstaclesLocations needs to be build up
// with (x,y,z) locations as follows: (0,0,0), ..., (numObstacles_x,0,0),
// (0,1,0), (1,1,0) ..., (numObstacles_x, numObstacles_y, 0), etc.)
Map.prototype.placeObstacles = function(obstacleDistance){
  for (var z = 0; z < this.numObstacles_z; z++){
    for (var y = 0; y < this.numObstacles_y; y++){
      for (var x = 0; x < this.numObstacles_x; x++){
        var map_x = x * this.obstacleDistance;
        var map_y = y * this.obstacleDistance;
        var map_z = z * this.obstacleDistance;

        this.obstacleLocations.push( vec3(map_x, map_y, -map_z) );
        this.spaces[map_x][map_y][map_z].obstacle = true;
      }
    }
  }
}







