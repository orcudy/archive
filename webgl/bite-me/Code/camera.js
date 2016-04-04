var camera = {
	FREE: 0,
	FOLLOW: 1
};

function Camera(game){
	this.game = game;
	this.cameraType = camera.FREE;
	this.z_translation = -2* this.game.map.zD_size;
	
	this.worldMatrix = mat4();
	this.pelletViewMatrix = mat4();
	this.heroModelMatrix = mat4();
	this.heroViewMatrix = mat4();	
	this.enemyModelMatrix = mat4();
	this.enemyViewMatrix = mat4();	

	this.followWorldMatrix = mat4(); 
	this.followPelletMatrix = mat4();
	this.followHeroMatrix = mat4();
	this.followEnemyMatrix = mat4();

	this.freeWorldMatrix = mat4(); 
	this.freePelletMatrix = mat4();
	this.freeHeroMatrix = mat4();
	this.freeEnemyMatrix = mat4();

	this.pelletDiameter = 2;

	this.initWorldTransform();
	this.initMapTransform();
	this.initHeroTransform();
}

Camera.prototype.initWorldTransform = function (){
	//centers world about origin 
	var offset = this.z_translation;
	var trans_x = this.translationAmount(this.game.map.xD_size);
	var trans_y = this.translationAmount(this.game.map.yD_size);
	var trans_z = this.translationAmount(this.game.map.zD_size);
	
	this.followWorldMatrix = mult( translate(0, 0, this.z_translation/2), this.followWorldMatrix );	

	this.freeWorldMatrix = mult( translate(-trans_x - 1, -trans_y - 1, trans_z + 1), this.freeWorldMatrix );	
	this.freeWorldMatrix = mult( translate(0, 0, this.z_translation), this.freeWorldMatrix );
}

Camera.prototype.initHeroTransform = function(){
	gl.useProgram(heroProgram);
	this.freeHeroMatrix = mult (translate(this.game.hero.position.x, this.game.hero.position.y, this.game.hero.position.z ), this.freeHeroMatrix);
	this.freeHeroMatrix = mult( this.freeHeroMatrix, rotate(90, [0, 1, 0]) );
	this.freeHeroMatrix = mult( this.freeHeroMatrix, rotate(-10, [0, 0, 1]) );
    this.freeHeroMatrix = mult(this.freeHeroMatrix, rotate(60, vec3(0, 1, 0)));

	this.followHeroMatrix = mult (translate(this.game.hero.position.x, this.game.hero.position.y, this.game.hero.position.z ), this.followHeroMatrix);
	this.followHeroMatrix = mult( this.followHeroMatrix, rotate(90, [0, 1, 0]) );
	this.followHeroMatrix = mult( this.followHeroMatrix, rotate(-10, [0, 0, 1]) );
    this.followHeroMatrix = mult(this.followHeroMatrix, rotate(60, vec3(0, 1, 0)));


	gl.uniformMatrix4fv(heroViewMatrixLocation, false, flatten(this.heroViewMatrix) );
  	gl.uniformMatrix4fv(heroModelMatrixLocation, false, flatten(this.heroModelMatrix) );
  	gl.uniformMatrix4fv(heroWorldMatrixLocation, false, flatten(this.worldMatrix) );
}

Camera.prototype.initMapTransform = function(){
	gl.useProgram(pelletProgram);
	gl.uniformMatrix4fv(pelletViewMatrixLocation, false, flatten(this.pelletViewMatrix) );
 	gl.uniformMatrix4fv(pelletWorldMatrixLocation, false, flatten(this.worldMatrix) );
}

Camera.prototype.update = function(){
	switch (this.cameraType){
		case camera.FOLLOW:
			this.worldMatrix = this.followWorldMatrix;
			this.heroViewMatrix = this.followHeroMatrix;
			this.enemyViewMatrix = this.followEnemyMatrix;
			break;
		case camera.FREE:
			this.worldMatrix = this.freeWorldMatrix;
			this.heroViewMatrix = this.freeHeroMatrix;
			this.enemyViewMatrix = this.freeEnemyMatrix;
			break;
	}

	gl.useProgram(pelletProgram);
	gl.uniformMatrix4fv(pelletViewMatrixLocation, false, flatten(this.pelletViewMatrix) );
 	gl.uniformMatrix4fv(pelletWorldMatrixLocation, false, flatten(this.worldMatrix) );

	gl.useProgram(heroProgram);
	gl.uniformMatrix4fv(heroViewMatrixLocation, false, flatten(this.heroViewMatrix) );
  	gl.uniformMatrix4fv(heroModelMatrixLocation, false, flatten(this.heroModelMatrix) );
  	gl.uniformMatrix4fv(heroWorldMatrixLocation, false, flatten(this.worldMatrix) );

  	gl.useProgram(enemyProgram);
	gl.uniformMatrix4fv(enemyViewMatrixLocation, false, flatten(this.enemyViewMatrix) );
  	gl.uniformMatrix4fv(enemyModelMatrixLocation, false, flatten(this.enemyModelMatrix) );
  	gl.uniformMatrix4fv(enemyWorldMatrixLocation, false, flatten(this.worldMatrix) );
}

Camera.prototype.updateHero = function(x, y, z){

	this.followHeroMatrix = mult(translate(x, y, z), this.followHeroMatrix);
	this.followWorldMatrix = mult(translate(-x, -y, -z), this.followWorldMatrix);

	this.freeHeroMatrix = mult( translate(x, y, z), this.freeHeroMatrix);
}

Camera.prototype.updateEnemy = function(enemy){
	var x = enemy.position.x;
	var y = enemy.position.y;
	var z = enemy.position.z;

	this.freeEnemyMatrix = mat4();
	this.freeEnemyMatrix = mult(translate(x, y, z), this.freeEnemyMatrix);

	this.followEnemyMatrix = mat4();
	this.followEnemyMatrix = mult(translate(x, y, z), this.followEnemyMatrix);

	this.update();

}

//triggered by event handlers
Camera.prototype.updateMap = function(x, y){
	var trans_x = this.translationAmount(this.game.map.xD_size);
	var trans_y = this.translationAmount(this.game.map.yD_size);
	var trans_z = this.translationAmount(this.game.map.zD_size);
	this.freeWorldMatrix = mult( translate(0, 0, -this.z_translation), this.freeWorldMatrix )
	this.freeWorldMatrix = mult (rotate(x, [0, -1, 0]), this.freeWorldMatrix);
	this.freeWorldMatrix = mult (rotate(y, [-1, 0, 0]), this.freeWorldMatrix);
	this.freeWorldMatrix = mult( translate(0, 0, this.z_translation), this.freeWorldMatrix )
}

Camera.prototype.translationAmount = function(size){
	var numPellets = Math.ceil(size / this.game.map.obstacleDistance);
	var farthestPelletCoord = (numPellets - 1) * this.game.map.obstacleDistance;
	var half = farthestPelletCoord / 2;
	return half - (this.pelletDiameter / 2); 
}