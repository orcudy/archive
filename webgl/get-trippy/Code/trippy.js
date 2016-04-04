var cubeTexture;

var rotationMatrixRotation = 0;
var viewMatrixRotation = 0;
var worldMatrixRotation = 0;

var worldRotationSpeed = 1;
var rotationSpeedVLo = 0.1;
var rotationSpeedLo = 0.3;
var rotationSpeedHi = 0.2;
var rotationSpeedVHi = 0.7;
var count = 0;

var party = true;
var fadeBlack = false;
var paused = false;
var ROTATE = 5;
var TRANSLATE = 1;
var audio;

var navigationMatrix = mat4();

function start(){
  canvas = document.getElementById( "gl-canvas" );
  aspect = canvas.width/canvas.height; 
  gl = WebGLUtils.setupWebGL( canvas );
  if ( !gl ) { alert( "WebGL isn't available" ); }
  gl.viewport( 0, 0, canvas.width, canvas.height );
  gl.clearColor( 1.0, 0.1, 0.1, 1.0 );
  gl.enable(gl.DEPTH_TEST);
  program = initShaders( gl, "shader-vs", "shader-fs" );
  gl.useProgram(program);

  modelMatrixLocation = gl.getUniformLocation( program, "modelMatrix" );
  viewMatrixLocation = gl.getUniformLocation( program, "viewMatrix" );
  projectionMatrixLocation = gl.getUniformLocation( program, "projectionMatrix" );
  rotationMatrixLocation = gl.getUniformLocation(program, "rotationMatrix");
  worldMatrixLocation = gl.getUniformLocation(program, "worldMatrix");
  navigationMatrixLocation = gl.getUniformLocation(program, "navigationMatrix");


  uSamplerLocation = gl.getUniformLocation(program, "uSampler");
  
  vertexPositionAttribute = gl.getAttribLocation( program, "aVertexPosition");
  gl.enableVertexAttribArray(vertexPositionAttribute); 
  textureCoordAttribute = gl.getAttribLocation(program, "aTextureCoord");
  gl.enableVertexAttribArray(textureCoordAttribute);

  audio = document.getElementById("song");
  audio.play();

  initBuffers();
  initCamera(); 
  initTextures();
  initEventHandlers();
  drawScene();
}

function initEventHandlers(){
  window.onkeydown = function(event){
    switch (event.keyCode){
        case 37: //left
            navigationMatrix = mult(rotate(-ROTATE,  [0, 1, 0]), navigationMatrix);
            break;
        case 38: //up
            navigationMatrix = mult(rotate(-ROTATE,  [1, 0, 0]), navigationMatrix);
            break;
        case 39: //right
            navigationMatrix = mult(rotate(ROTATE,  [0, 1, 0]), navigationMatrix);
            break;
        case 40: //down
            navigationMatrix = mult(rotate(ROTATE,  [1, 0, 0]), navigationMatrix);
            break;
          case 87: //w
            navigationMatrix = mult(translate(0, 0, TRANSLATE), navigationMatrix);
            break;
        case 65: //a
            navigationMatrix = mult(translate(TRANSLATE, 0, 0), navigationMatrix);
            break;
        case 83: //s
            navigationMatrix = mult(translate(0, 0, -TRANSLATE), navigationMatrix);
            break;
        case 68: //d
            navigationMatrix = mult(translate(-TRANSLATE, 0 , 0), navigationMatrix);
            break;
        case 84: //f
          if(!paused){
            if (party){
              rotationSpeedVLo = 5.1;
              rotationSpeedLo = 5.3;
              rotationSpeedHi = 5.2;
              rotationSpeedVHi = 5.7;
              worldRotationSpeed = 5;

            } else {
              rotationSpeedVLo = 0.1;
              rotationSpeedLo = 0.3;
              rotationSpeedHi = 0.2;
              rotationSpeedVHi = 0.7;
              worldRotationSpeed = 1;
            }
            fadeBlack = !fadeBlack;
            party = !party;
          }
            
            break;
        case 32: //space
            paused = !paused;
            if (paused){
              setPaused();
            } else {
              setPlay();
            }
            toggleSong();
            break;
    };
  }
}

function setPlay(){
  rotationSpeedVLo = savedRotationSpeedVLo;
  rotationSpeedLo = savedRotationSpeedLo;
  rotationSpeedHi = savedRotationSpeedHi;
  rotationSpeedVHi = savedRotationSpeedVHi;
  worldRotationSpeed = savedWorldRotationSpeed;
}

function setPaused(){
  savedRotationSpeedVLo = rotationSpeedVLo;
  savedRotationSpeedLo = rotationSpeedLo;
  savedRotationSpeedHi = rotationSpeedHi;
  savedRotationSpeedVHi = rotationSpeedVHi;
  savedWorldRotationSpeed = worldRotationSpeed;

  rotationSpeedVLo = 0.0;
  rotationSpeedLo = 0.0;
  rotationSpeedHi = 0.0;
  rotationSpeedVHi = 0.0;
  worldRotationSpeed = 0;
}

function toggleSong(){
  if (audio.paused){
    audio.play();
  } else {
    audio.pause();
  }
}

function initBuffers() {
  
  var vertices = [
    1.0,  1.0,  0.0,
    -1.0, 1.0,  0.0,
    1.0,  -1.0, 0.0,
    -1.0, -1.0, 0.0
  ];
  
  squareVerticesBuffer = gl.createBuffer();
  gl.bindBuffer(gl.ARRAY_BUFFER, squareVerticesBuffer);
  gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(vertices), gl.STATIC_DRAW);
  
  var textureCoordinates = [
    // Front
    1.0,  1.0,
    0.0,  1.0,
    1.0,  0.0,
    0.0,  0.0,
    //Back
    0.0,  0.0,
    1.0,  0.0,
    1.0,  1.0,
    0.0,  1.0,
    // Top
    0.0,  0.0,
    1.0,  0.0,
    1.0,  1.0,
    0.0,  1.0,
    // Bottom
    0.0,  0.0,
    1.0,  0.0,
    1.0,  1.0,
    0.0,  1.0,
    // Right
    0.0,  0.0,
    1.0,  0.0,
    1.0,  1.0,
    0.0,  1.0,
    // Left
    0.0,  0.0,
    1.0,  0.0,
    1.0,  1.0,
    0.0,  1.0
  ];

  cubeVerticesTextureCoordBuffer = gl.createBuffer();
  gl.bindBuffer(gl.ARRAY_BUFFER, cubeVerticesTextureCoordBuffer);
  gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(textureCoordinates), gl.STATIC_DRAW);
}

function initCamera(){
    fov_y = 120.0; 
    near = 0.01;
    far = 350.0;
    projectionMatrix = perspective(fov_y, aspect, near, far);
    gl.uniformMatrix4fv(projectionMatrixLocation, false, flatten(projectionMatrix) );
}

function initTexture(name){
  var texture = gl.createTexture();
  var image = new Image();
  image.onload = function() { handleTextureLoaded(image, texture); }
  image.src = name;
  return texture;
}

function initTextures() {
  joseTexture = initTexture("jose.jpg");
  natalieTexture = initTexture("natalie.jpg");
  chrisTexture = initTexture("chris.jpg");
  jamieTexture = initTexture("jamie.jpg");
  omriTexture = initTexture("omri.jpg");
  rohanTexture = initTexture("rohan.jpg");
  jenTexture = initTexture("jen.jpg");
  trevorTexture = initTexture("trevor.jpg");
}

function handleTextureLoaded(image, texture) {
  gl.bindTexture(gl.TEXTURE_2D, texture);
  gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, gl.RGBA, gl.UNSIGNED_BYTE, image);
  gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.NEAREST);
  gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.NEAREST);
  gl.bindTexture(gl.TEXTURE_2D, null);
}

function setBackgroundColor(){
  if (!paused){
      if (fadeBlack){
    if(count % 6  <= 3){
      red = 1.0;
      green = 1.0;
      blue = 1.0
    } else {
      red = 0.0;
      green = 0.0;
      blue = 0.0
    }
  } else {
    if(count % 6  == 0){
      red = Math.random();
      green = Math.random();
      blue = Math.random();
    }
  }
  count++;
  gl.clearColor( red, green, blue, 1.0 );
  }
}

function setRotationMatrix(){
  rotationMatrix = mat4();
  rotationMatrix = mult( rotate(rotationMatrixRotation += 0, [0, 0, 1]), rotationMatrix);
  gl.uniformMatrix4fv(rotationMatrixLocation, false, flatten(rotationMatrix) );
}

function setWorldMatrix(){
  worldMatrix = mat4();
  worldMatrix = mult(rotate(worldMatrixRotation += worldRotationSpeed, [1, 1, 1]), worldMatrix);
  worldMatrix = mult(translate(0, 0, -8.0), worldMatrix);
  gl.uniformMatrix4fv(worldMatrixLocation, false, flatten(worldMatrix) );
}

function drawScene() {
  gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
  gl.uniformMatrix4fv(navigationMatrixLocation, false, flatten(navigationMatrix) );

  setBackgroundColor();
  setRotationMatrix();
  setWorldMatrix();

  gl.bindBuffer(gl.ARRAY_BUFFER, squareVerticesBuffer);
  gl.vertexAttribPointer(vertexPositionAttribute, 3, gl.FLOAT, false, 0, 0);

  gl.bindBuffer(gl.ARRAY_BUFFER, cubeVerticesTextureCoordBuffer);
  gl.vertexAttribPointer(textureCoordAttribute, 2, gl.FLOAT, false, 0, 0);

  gl.activeTexture(gl.TEXTURE0);
  gl.uniform1i(uSamplerLocation, 0);

  viewMatrix = mat4();
  viewMatrix = mult(rotate(viewMatrixRotation += rotationSpeedHi, [1, 1, 0]), viewMatrix);
  viewMatrix = mult(translate(4, 0, -4.0), viewMatrix);
  gl.uniformMatrix4fv(viewMatrixLocation, false, flatten(viewMatrix) );
  drawTexturedCube(natalieTexture, natalieTexture, natalieTexture, natalieTexture, natalieTexture, natalieTexture);

  viewMatrix = mat4();
  viewMatrix = mult(rotate(viewMatrixRotation += rotationSpeedHi, [0, 1, 0]), viewMatrix);
  viewMatrix = mult(translate(-4, 0, -4.0), viewMatrix);
  gl.uniformMatrix4fv(viewMatrixLocation, false, flatten(viewMatrix) );
  drawTexturedCube(jamieTexture, jamieTexture, jamieTexture, jamieTexture, jamieTexture, jamieTexture);

  viewMatrix = mat4();
  viewMatrix = mult(rotate(viewMatrixRotation += rotationSpeedHi, [1, 1, 0]), viewMatrix);
  viewMatrix = mult(translate(0, 4, -4.0), viewMatrix);
  gl.uniformMatrix4fv(viewMatrixLocation, false, flatten(viewMatrix) );
  drawTexturedCube(chrisTexture, chrisTexture, chrisTexture, chrisTexture, chrisTexture, chrisTexture);

  viewMatrix = mat4();
  viewMatrix = mult(rotate(viewMatrixRotation += rotationSpeedHi, [0, 1, 1]), viewMatrix);
  viewMatrix = mult(translate(0, -4, -4.0), viewMatrix);
  gl.uniformMatrix4fv(viewMatrixLocation, false, flatten(viewMatrix) );
  drawTexturedCube(omriTexture, omriTexture, omriTexture, omriTexture, omriTexture, omriTexture);

  viewMatrix = mat4();
  viewMatrix = mult(rotate(viewMatrixRotation += rotationSpeedHi, [1, 1, 0]), viewMatrix);
  viewMatrix = mult(translate(4, 0, 4.0), viewMatrix);
  gl.uniformMatrix4fv(viewMatrixLocation, false, flatten(viewMatrix) );
  drawTexturedCube(rohanTexture, rohanTexture, rohanTexture, rohanTexture, rohanTexture, rohanTexture);

  viewMatrix = mat4();
  viewMatrix = mult(rotate(viewMatrixRotation += rotationSpeedHi, [0, 1, 1]), viewMatrix);
  viewMatrix = mult(translate(-4, 0, 4.0), viewMatrix);
  gl.uniformMatrix4fv(viewMatrixLocation, false, flatten(viewMatrix) );
  drawTexturedCube(joseTexture, joseTexture, joseTexture, joseTexture, joseTexture, joseTexture);

  viewMatrix = mat4();
  viewMatrix = mult(rotate(viewMatrixRotation += rotationSpeedHi, [1, 1, 0]), viewMatrix);
  viewMatrix = mult(translate(0, 4, 4.0), viewMatrix);
  gl.uniformMatrix4fv(viewMatrixLocation, false, flatten(viewMatrix) );
  drawTexturedCube(jenTexture, jenTexture, jenTexture, jenTexture, jenTexture, jenTexture);

  viewMatrix = mat4();
  viewMatrix = mult(rotate(viewMatrixRotation += rotationSpeedHi, [0, 1, 0]), viewMatrix);
  viewMatrix = mult(translate(0, -4, 4.0), viewMatrix);
  gl.uniformMatrix4fv(viewMatrixLocation, false, flatten(viewMatrix) );
  drawTexturedCube(trevorTexture, trevorTexture, trevorTexture, trevorTexture, trevorTexture, trevorTexture);

  window.requestAnimFrame(drawScene);
}