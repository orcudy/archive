EnemyRenderer.prototype = Object.create(Renderer.prototype);
EnemyRenderer.prototype.constructor = EnemyRenderer;

function EnemyRenderer(objectType, objectCount){
  Renderer.prototype.constructor.call(this, objectType, objectCount);
  if(!(this instanceof EnemyRenderer)) return new EnemyRenderer();
	
  if(objectType == "enemyA"){
     this.enemyATexture = gl.createTexture();
     initTexture(this.enemyATexture, "eye.png");
	this.normals = enemyANormals;
	this.texCoords = enemyATexCoords;
  }
  else if(objectType == "enemyB"){
	this.normals = enemyBNormals;
	this.texCoords = [];
  }
  else if(objectType == "enemyC"){
	this.normals = enemyCNormals;
	this.texCoords = enemyCTexCoords;
	this.enemyCTexture1 = gl.createTexture();
	this.enemyCTexture2 = gl.createTexture();
	initTexture(this.enemyCTexture1, "thwompface.png");
	initTexture(this.enemyCTexture2, "thwomp.png");
  }
  else if(objectType == "enemyD"){
	this.normals = enemyDNormals;
	this.texCoords = [];
  }
  this.canonicalNormals = [];
  this.type = objectType;
  
  this.normalsBuffer = gl.createBuffer();
  this.texCoordsBuffer = gl.createBuffer();

  this.initBuffer(this.normalsBuffer, flatten(this.normals));
  this.initBuffer(this.texCoordsBuffer, flatten(this.texCoords));
}

EnemyRenderer.prototype.draw = function(){
  gl.bindBuffer(gl.ARRAY_BUFFER, this.vertexBuffer);
  gl.vertexAttribPointer(vertexPositionAttribute, 3, gl.FLOAT, false, 0, 0);
  
  gl.bindBuffer(gl.ARRAY_BUFFER, this.normalsBuffer);
  gl.vertexAttribPointer(normalsAttribute, 4, gl.FLOAT, false, 0, 0);
 

  

  
  if(this.type == "enemyA"){
    gl.activeTexture(gl.TEXTURE0);
    gl.bindTexture(gl.TEXTURE_2D, this.enemyATexture);
    gl.uniform1i(gl.getUniformLocation(enemyProgram,"texture"), 0);

  gl.bindBuffer(gl.ARRAY_BUFFER, this.texCoordsBuffer);
	gl.vertexAttribPointer(texCoordsAttribute, 2, gl.FLOAT, false, 0, 0);
	gl.uniform1f( gl.getUniformLocation(enemyProgram, "type"), 1.0 );
    for( var i=0; i<this.vertices.length; i+=3) {
        if (i == 0 || i == 42){
			enemyMaterialDiffuse = vec4(1.0,1.0,1.0,1.0);
            gl.uniform1f( gl.getUniformLocation(enemyProgram, "texturing"), 1.0 );
            enemyDiffuseProduct = mult(enemyLightDiffuse, enemyMaterialDiffuse);
            gl.uniform4fv( gl.getUniformLocation(enemyProgram, "diffuseProduct"),flatten(enemyDiffuseProduct) );
        }
        if ( i == 6 || i == 48){
            gl.uniform1f( gl.getUniformLocation(enemyProgram, "texturing"), 0.0 );
			enemyMaterialDiffuse = vec4(1.0,0.0,0.0,1.0);
            enemyDiffuseProduct = mult(enemyLightDiffuse, enemyMaterialDiffuse);
            gl.uniform4fv( gl.getUniformLocation(enemyProgram, "diffuseProduct"),flatten(enemyDiffuseProduct) );
            
        }
        gl.drawArrays( gl.TRIANGLES, i, 3 );
    }
    
  }
  
	else if(this.type == "enemyB"){
		enemyMaterialDiffuse = vec4(1.0,1.0,1.0,1.0);
		enemyDiffuseProduct = mult(enemyLightDiffuse, enemyMaterialDiffuse);
		gl.uniform4fv( gl.getUniformLocation(enemyProgram, "diffuseProduct"),flatten(enemyDiffuseProduct) );
		gl.uniform1f( gl.getUniformLocation(enemyProgram, "type"), 2.0 );
		gl.drawArrays( gl.TRIANGLES, 0, this.vertices.length );
		}
	else if(this.type == "enemyD"){
		gl.uniform1f( gl.getUniformLocation(enemyProgram, "type"), 4.0 );
		
		gl.uniform1f( gl.getUniformLocation(enemyProgram, "flag"), 0.0 );
		enemyMaterialDiffuse = vec4(1.0,1.0,1.0,1.0);
		enemyDiffuseProduct = mult(enemyLightDiffuse, enemyMaterialDiffuse);
		gl.uniform4fv( gl.getUniformLocation(enemyProgram, "diffuseProduct"),flatten(enemyDiffuseProduct) );
		gl.drawArrays( gl.TRIANGLES, 0, this.vertices.length-12 );
		
		gl.uniform1f( gl.getUniformLocation(enemyProgram, "flag"), 1.0 );
		gl.drawArrays( gl.TRIANGLES, this.vertices.length-12, 12);
	}
	else if(this.type == "enemyC"){
		gl.uniform1f( gl.getUniformLocation(enemyProgram, "type"), 3.0 );
		enemyMaterialDiffuse = vec4(1.0,1.0,1.0,1.0);
		enemyDiffuseProduct = mult(enemyLightDiffuse, enemyMaterialDiffuse);
		gl.uniform4fv( gl.getUniformLocation(enemyProgram, "diffuseProduct"),flatten(enemyDiffuseProduct) );
			// draw thwomp face
		gl.activeTexture(gl.TEXTURE0);
		gl.bindTexture(gl.TEXTURE_2D, this.enemyCTexture1);
		gl.uniform1i(gl.getUniformLocation(enemyProgram,"texture"), 0);
		
		gl.bindBuffer(gl.ARRAY_BUFFER, this.texCoordsBuffer);
		gl.vertexAttribPointer(texCoordsAttribute, 2, gl.FLOAT, false, 0, 0);
	    gl.uniform1f( gl.getUniformLocation(enemyProgram, "texturing"), 1.0 );

		gl.drawArrays( gl.TRIANGLES, 0, 6 );
			// draw thwomp sides
		//gl.activeTexture(gl.TEXTURE0);
		gl.bindTexture(gl.TEXTURE_2D, this.enemyCTexture2);
		gl.uniform1i(gl.getUniformLocation(enemyProgram,"texture"), 0);

		gl.drawArrays( gl.TRIANGLES, 6, this.vertices.length-6 );
	}
    else
        gl.drawArrays( gl.TRIANGLES, 0, this.vertices.length );
}
