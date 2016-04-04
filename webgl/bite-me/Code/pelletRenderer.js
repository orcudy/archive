PelletRenderer.prototype = Object.create(Renderer.prototype);
PelletRenderer.prototype.constructor = PelletRenderer;

function PelletRenderer(objectType, objectCount, obstacleLocations){
  Renderer.prototype.constructor.call(this, objectType, objectCount);
  if(!(this instanceof PelletRenderer)) return new PelletRenderer();
  
  this.normals = [];
  this.getNormals(objectCount);
  
  this.translations = [];
  this.getTranslations(obstacleLocations);
  
  this.translationBuffer = gl.createBuffer();
  this.normalBuffer = gl.createBuffer();
    
  this.initBuffer(this.translationBuffer, flatten(this.translations));
  this.initBuffer(this.normalBuffer, this.normals);
}

PelletRenderer.prototype.getTranslations = function(obstacleLocations){
	for (var index = 0; index < obstacleLocations.length; index++){
		for (var i = 0; i < pelletVertices.length; i++){
			this.translations.push(obstacleLocations[index]);
		}
	}
}

PelletRenderer.prototype.getNormals = function(objectCount){
  var canonicalNormals = pelletNormals;
  for (var index = 0; index < objectCount; index++){
    Array.prototype.push.apply(this.normals, canonicalNormals);
  }
}


PelletRenderer.prototype.draw = function(){
	gl.bindBuffer(gl.ARRAY_BUFFER, this.vertexBuffer);
	gl.vertexAttribPointer(vertexPositionAttribute, 4, gl.FLOAT, false, 0, 0);

	gl.bindBuffer(gl.ARRAY_BUFFER, this.translationBuffer);
	gl.vertexAttribPointer(vertexTranslationAttribute, 3, gl.FLOAT, false, 0, 0);
    
  gl.bindBuffer(gl.ARRAY_BUFFER, this.normalBuffer);
  gl.vertexAttribPointer( vertexNormalAttribute, 4, gl.FLOAT, false, 0, 0 );

	gl.drawArrays(gl.TRIANGLES, 0, this.vertices.length);
}