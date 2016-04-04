
function CollisionDetector(game){
	if(!(this instanceof CollisionDetector)) return new CollisionDetector();
	this.game = game;
}

CollisionDetector.prototype.detect = function(){
	var map = this.game.map;
	var x = this.game.hero.position.x;
	var y = this.game.hero.position.y;
	var z = this.game.hero.position.z;
	
	if ((x < this.game.map.xD_size) && (x >= 0) &&
		(y < this.game.map.yD_size) && (y >= 0) &&
		(z > -this.game.map.zD_size) && (z <= 0)) {
		if (this.game.map.spaces[x][y][-z].obstacle){
			this.game.collisionHandler.heroObstacle(x, y, z);
		}

		if ((map.spaces[x][y][-z]).enemy){
			this.game.collisionHandler.heroEnemy(x, y, z);
		}
	}
}
