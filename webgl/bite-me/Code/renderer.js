function Renderer(objectType, objectCount){
  if(!(this instanceof Renderer)) return new Renderer();
  this.vertices = [];
  this.canonicalVertices = [];
  this.getVertices(objectType, objectCount)

  this.vertexBuffer = gl.createBuffer();
  this.initBuffer(this.vertexBuffer, flatten(this.vertices));
}

Renderer.prototype.getVertices = function(objectType, objectCount){
  switch (objectType){
    case "pellet":
      this.canonicalVertices = initPelletData();
      break;
    case "hero":
      this.canonicalVertices = heroVertices;
      break;
    case "enemyA":
      this.canonicalVertices = enemyAVertices;
      break;
    case "enemyB":
      this.canonicalVertices = enemyBVertices;
      break;
    case "enemyC":
      this.canonicalVertices = enemyCVertices;
      break;
    case "enemyD":
      this.canonicalVertices = enemyDVertices;
      break;
  }

  for (var index = 0; index < objectCount; index++){
    Array.prototype.push.apply(this.vertices, this.canonicalVertices);
  }
}

Renderer.prototype.initBuffer = function(buffer, data){
  gl.bindBuffer(gl.ARRAY_BUFFER, buffer);
  gl.bufferData(gl.ARRAY_BUFFER, flatten(data), gl.STATIC_DRAW);
}

Renderer.prototype.draw = function(){
  gl.bindBuffer(gl.ARRAY_BUFFER, this.vertexBuffer);
  gl.vertexAttribPointer(vertexPositionAttribute, 3, gl.FLOAT, false, 0, 0);
  gl.drawArrays(gl.TRIANGLES, 0, this.vertices.length);
}

