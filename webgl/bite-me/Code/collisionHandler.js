function CollisionHandler(game){
  if(!(this instanceof CollisionHandler)) return new CollisionHandler();

  this.game = game;
  this.offsetMap = [];

  this.initOffsetMap();
}

CollisionHandler.prototype.initOffsetMap = function(){
  for (var index = 0; index < this.game.map.totalObstacles; index++){
    this.offsetMap.push(0);
  }
}

CollisionHandler.prototype.updateOffsetMap = function(start){
  for (var index = start; index < this.game.map.totalObstacles; index++){
    this.offsetMap[index]++;
  }
}

CollisionHandler.prototype.map = function(x, y, z){
  var norm_x = x / this.game.map.obstacleDistance;
  var norm_y = y / this.game.map.obstacleDistance;
  var norm_z = -z / this.game.map.obstacleDistance;
  
  var fact_z = Math.pow(this.game.map.zD_size / this.game.map.obstacleDistance, 2) * norm_z;
  var fact_y = this.game.map.yD_size / this.game.map.obstacleDistance * norm_y;
  var fact_x = norm_x;
  
  return fact_x + fact_y + fact_z;
}

CollisionHandler.prototype.heroObstacle = function(x, y, z){  
  score++;
  scoreNode.nodeValue = score;

  var val = this.map(x, y, z);
  var offset = this.offsetMap[val];

  this.game.map.renderer.translations.splice((val - offset) * pelletVertices.length, pelletVertices.length);
  this.game.map.renderer.vertices.splice((val - offset) * pelletVertices.length, pelletVertices.length);
  this.game.map.renderer.initBuffer(this.game.map.renderer.vertexBuffer, flatten(this.game.map.renderer.vertices));
  this.game.map.renderer.initBuffer(this.game.map.renderer.translationBuffer, flatten(this.game.map.renderer.translations));
  this.game.map.spaces[x][y][-z].obstacle = false;

  this.updateOffsetMap(val);
}

CollisionHandler.prototype.heroEnemy = function(x, y, z){
  numLivesRemaining--;
  lifeNode.nodeValue = numLivesRemaining;

}
