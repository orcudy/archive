HeroRenderer.prototype = Object.create(Renderer.prototype);
HeroRenderer.prototype.constructor = HeroRenderer;

var count = 0;

function HeroRenderer(objectType, objectCount){
  Renderer.prototype.constructor.call(this, objectType, objectCount);
  if(!(this instanceof HeroRenderer)) return new HeroRenderer();
    
    
    this.VertexNormalBuffer = gl.createBuffer();
    gl.bindBuffer(gl.ARRAY_BUFFER, this.VertexNormalBuffer);
    gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(heroNormals), gl.STATIC_DRAW);
    this.VertexNormalBuffer.itemSize = 3;
    this.VertexNormalBuffer.numItems = heroNormals.length / 3;
    
    this.VertexTextureCoordBuffer = gl.createBuffer();
    gl.bindBuffer(gl.ARRAY_BUFFER, this.VertexTextureCoordBuffer);
    gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(heroTextureCoords), gl.STATIC_DRAW);
    this.VertexTextureCoordBuffer.itemSize = 2;
    this.VertexTextureCoordBuffer.numItems = heroTextureCoords.length / 2;
    
    this.VertexPositionBuffer = gl.createBuffer();
    gl.bindBuffer(gl.ARRAY_BUFFER, this.VertexPositionBuffer);
    gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(heroVertices), gl.STATIC_DRAW);
    this.VertexPositionBuffer.itemSize = 3;
    this.VertexPositionBuffer.numItems = heroVertices.length / 3;
    
    this.VertexIndexBuffer = gl.createBuffer();
    gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, this.VertexIndexBuffer);
    gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, new Uint16Array(heroIndices), gl.STATIC_DRAW);
    this.VertexIndexBuffer.itemSize = 1;
    this.VertexIndexBuffer.numItems = heroIndices.length;
    this.texture = gl.createTexture();
    
    initTexture(this.texture, "pacman.png");

    out = mat4();
    var mvMatrix = mat4();
    var pMatrix = mat4();
    //var count = 0;
}

frustum=function(a,b,c,d,e,g,f){f||(f=mat4.create());var h=b-a,i=d-c,j=g-e;f[0]=e*2/h;f[1]=0;f[2]=0;f[3]=0;f[4]=0;f[5]=e*2/i;f[6]=0;f[7]=0;f[8]=(b+a)/h;f[9]=(d+c)/i;f[10]=-(g+e)/j;f[11]=-1;f[12]=0;f[13]=0;f[14]=-(g*e*2)/j;f[15]=0;return f};
perspective2=function(a,b,c,d,e)
{a=c*Math.tan(a*Math.PI/360);
    b=a*b;
    return frustum(-b,b,-a,a,c,d,e)};

multiply = function (out, a, b) {
    a00 = a[0], a01 = a[1], a02 = a[2], a03 = a[3],
    a10 = a[4], a11 = a[5], a12 = a[6], a13 = a[7],
    a20 = a[8], a21 = a[9], a22 = a[10], a23 = a[11],
    a30 = a[12], a31 = a[13], a32 = a[14], a33 = a[15];
    
    // Cache only the current line of the second matrix
    b0  = b[0], b1 = b[1], b2 = b[2], b3 = b[3];
    out[0] = b0*a00 + b1*a10 + b2*a20 + b3*a30;
    out[1] = b0*a01 + b1*a11 + b2*a21 + b3*a31;
    out[2] = b0*a02 + b1*a12 + b2*a22 + b3*a32;
    out[3] = b0*a03 + b1*a13 + b2*a23 + b3*a33;
    
    b0 = b[4]; b1 = b[5]; b2 = b[6]; b3 = b[7];
    out[4] = b0*a00 + b1*a10 + b2*a20 + b3*a30;
    out[5] = b0*a01 + b1*a11 + b2*a21 + b3*a31;
    out[6] = b0*a02 + b1*a12 + b2*a22 + b3*a32;
    out[7] = b0*a03 + b1*a13 + b2*a23 + b3*a33;
    
    b0 = b[8]; b1 = b[9]; b2 = b[10]; b3 = b[11];
    out[8] = b0*a00 + b1*a10 + b2*a20 + b3*a30;
    out[9] = b0*a01 + b1*a11 + b2*a21 + b3*a31;
    out[10] = b0*a02 + b1*a12 + b2*a22 + b3*a32;
    out[11] = b0*a03 + b1*a13 + b2*a23 + b3*a33;
    
    b0 = b[12]; b1 = b[13]; b2 = b[14]; b3 = b[15];
    out[12] = b0*a00 + b1*a10 + b2*a20 + b3*a30;
    out[13] = b0*a01 + b1*a11 + b2*a21 + b3*a31;
    out[14] = b0*a02 + b1*a12 + b2*a22 + b3*a32;
    out[15] = b0*a03 + b1*a13 + b2*a23 + b3*a33;
    return out;
};

normalize2 = function(out, a) {
    var x = a[0],
    y = a[1],
    z = a[2];
    var len = x*x + y*y + z*z;
    if (len > 0) {
        len = 1 / Math.sqrt(len);
        out[0] = a[0] * len;
        out[1] = a[1] * len;
        out[2] = a[2] * len;
    }
    return out;
};

toInverseMat3 = function(mat, dest) {
    // Cache the matrix values (makes for huge speed increases!)
    var a00 = mat[0], a01 = mat[1], a02 = mat[2];
    var a10 = mat[4], a11 = mat[5], a12 = mat[6];
    var a20 = mat[8], a21 = mat[9], a22 = mat[10];
    
    var b01 = a22*a11-a12*a21;
    var b11 = -a22*a10+a12*a20;
    var b21 = a21*a10-a11*a20;
    
    var d = a00*b01 + a01*b11 + a02*b21;
    if (!d) { return null; }
    var id = 1/d;
    
    if(!dest) { dest = mat3.create(); }
    
    dest[0] = b01*id;
    dest[1] = (-a22*a01 + a02*a21)*id;
    dest[2] = (a12*a01 - a02*a11)*id;
    dest[3] = b11*id;
    dest[4] = (a22*a00 - a02*a20)*id;
    dest[5] = (-a12*a00 + a02*a10)*id;
    dest[6] = b21*id;
    dest[7] = (-a21*a00 + a01*a20)*id;
    dest[8] = (a11*a00 - a01*a10)*id;
    
    return dest;
};

transpose3 = function(out, a) {
    // If we are transposing ourselves we can skip a few steps but have to cache some values
    if (out === a) {
        var a01 = a[1], a02 = a[2], a12 = a[5];
        out[1] = a[3];
        out[2] = a[6];
        out[3] = a01;
        out[5] = a[7];
        out[6] = a02;
        out[7] = a12;
    } else {
        out[0] = a[0];
        out[1] = a[3];
        out[2] = a[6];
        out[3] = a[1];
        out[4] = a[4];
        out[5] = a[7];
        out[6] = a[2];
        out[7] = a[5];
        out[8] = a[8];
    }
    
    return out;
};



HeroRenderer.prototype.draw = function(){
    
    ambient = vec3(0.2, 0.2, 0.2);
    gl.uniform3f(ambientColorUniform, 0.2, 0.2, 0.2);
    
    var lightingDirection = [0, 0, -20];
    var adjustedLD = []
    adjustedLD.push(1);
    adjustedLD.push(1);
    adjustedLD.push(1);
    //output = vec3();
    normalize2(adjustedLD, lightingDirection);
    adjustedLD[0] *= -1;
    adjustedLD[1] *= -1;
    adjustedLD[2] *= -1;
    gl.uniform3fv(lightingDirectionUniform, adjustedLD);
    
    gl.uniform3f(directionalColorUniform, 0.8, 0.8, 0.8);
    
    gl.activeTexture(gl.TEXTURE0);
    gl.bindTexture(gl.TEXTURE_2D, this.texture);
    gl.uniform1i(heroSamplerLocation, 0);
    
    gl.bindBuffer(gl.ARRAY_BUFFER, this.VertexPositionBuffer);
    gl.vertexAttribPointer(vertexPositionAttribute, this.VertexPositionBuffer.itemSize, gl.FLOAT, false, 0, 0);
    
    gl.bindBuffer(gl.ARRAY_BUFFER, this.VertexTextureCoordBuffer);
    gl.vertexAttribPointer(textureCoordAttribute, this.VertexTextureCoordBuffer.itemSize, gl.FLOAT, false, 0, 0);
    
    gl.bindBuffer(gl.ARRAY_BUFFER, this.VertexNormalBuffer);
    gl.vertexAttribPointer(vertexNormalAttribute, this.VertexNormalBuffer.itemSize, gl.FLOAT, false, 0, 0);
    
    gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, this.VertexIndexBuffer);
    
    mvMatrix = mat4();
    mvMatrix = mult(mvMatrix,translate(hero.position.x, hero.position.y, hero.position.z));

    out = mat4();

    //mvMatrix = multiply( flatten(out), mvMatrix, flatten(rotate(90, [0, 1, 0])) );
    //mvMatrix = multiply( flatten(out), mvMatrix, flatten(rotate(-10, [0, 0, 1])) );
    mvMatrix = flatten(game.camera.heroViewMatrix);
    
    var normalMatrix = flatten(mat3());
    toInverseMat3(mvMatrix, normalMatrix);
    transpose3(normalMatrix, normalMatrix);
    gl.uniformMatrix3fv(heroNormalMatrixLocation, false, normalMatrix);
    
    gl.drawElements(gl.TRIANGLES, this.VertexIndexBuffer.numItems, gl.UNSIGNED_SHORT, 0);
    count = (count+1)%100;
    if (count < 50)
    {
        this.texture.image.src = "pacman.png";
    }
    else
    {
        this.texture.image.src = "pacmanclose.png";
    }
}