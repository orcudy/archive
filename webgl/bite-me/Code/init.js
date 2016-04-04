
function initCamera(projectionMatrixLocation){
    //projection 
    fov_y = 45.0; 
    near = 0.01;
    far = 350.0;
    projectionMatrix = perspective(fov_y, aspect, near, far);
    gl.uniformMatrix4fv(projectionMatrixLocation, false, flatten(projectionMatrix) );
}

function initPelletProgram(program){
  gl.useProgram(program);

  //setup matrices
  pelletProjectionMatrixLocation = gl.getUniformLocation( program, "projectionMatrix" );
  pelletWorldMatrixLocation = gl.getUniformLocation( program, "worldMatrix" );
  pelletViewMatrixLocation = gl.getUniformLocation( program, "viewMatrix" );
  initCamera(pelletProjectionMatrixLocation);  

  //setup attributes
  vertexTranslationAttribute = gl.getAttribLocation( program, "vertexTranslation");
  vertexPositionAttribute = gl.getAttribLocation( program, "vertexPosition");
  vertexNormalAttribute = gl.getAttribLocation( program, "vNormal" );
    
  //enable attributes
  gl.enableVertexAttribArray( vertexTranslationAttribute ); 
  gl.enableVertexAttribArray( vertexPositionAttribute );
  gl.enableVertexAttribArray( vertexNormalAttribute);
    
  //setup uniforms
  pelletAmbientProduct = mult(pelletLightAmbient, pelletMaterialAmbient);
  pelletDiffuseProduct = mult(pelletLightDiffuse, pelletMaterialDiffuse);
  pelletSpecularProduct = mult(pelletLightSpecular, pelletMaterialSpecular);
  
  gl.uniform4fv( gl.getUniformLocation(program, "ambientProduct"), flatten(pelletAmbientProduct) );
  gl.uniform4fv( gl.getUniformLocation(program, "diffuseProduct"), flatten(pelletDiffuseProduct) );
  gl.uniform4fv( gl.getUniformLocation(program, "specularProduct"), flatten(pelletSpecularProduct) );
  gl.uniform4fv( gl.getUniformLocation(program,"lightPosition"), flatten(pelletLightPosition) );
  gl.uniform1f( gl.getUniformLocation(program, "shininess"), pelletMaterialShininess );
}

function initHeroProgram(program){
  gl.useProgram(program);
  
  //setup matrices
  heroProjectionMatrixLocation = gl.getUniformLocation( program, "projectionMatrix" );
  heroWorldMatrixLocation = gl.getUniformLocation( program, "worldMatrix" );
  heroModelMatrixLocation = gl.getUniformLocation( program, "modelMatrix" );
  heroViewMatrixLocation = gl.getUniformLocation( program, "viewMatrix" );
  initCamera(heroProjectionMatrixLocation);
  
  heroNormalMatrixLocation = gl.getUniformLocation(program, "uNMatrix");
  heroSamplerLocation = gl.getUniformLocation(program, "uSampler");
  ambientColorUniform = gl.getUniformLocation(program, "uAmbientColor");
  lightingDirectionUniform = gl.getUniformLocation(program, "uLightingDirection");
  directionalColorUniform = gl.getUniformLocation(program, "uDirectionalColor");
  
  //setup attributes
  vertexPositionAttribute = gl.getAttribLocation( program, "vertexPosition");
  textureCoordAttribute = gl.getAttribLocation(program, "aTextureCoord");
  vertexNormalAttribute = gl.getAttribLocation(program, "aVertexNormal");

  //enable attributes
  gl.enableVertexAttribArray(vertexPositionAttribute);    
  gl.enableVertexAttribArray(textureCoordAttribute);
  gl.enableVertexAttribArray(vertexNormalAttribute);
}

function initEnemyProgram(program){
  gl.useProgram(program);
  
  enemyATexture = gl.createTexture();
  initTexture(enemyATexture, "eye.png");
  gl.uniform1i(gl.getUniformLocation(enemyProgram, "texture"), 0);

  //setup matrices
  enemyProjectionMatrixLocation = gl.getUniformLocation( program, "projectionMatrix" );
  enemyWorldMatrixLocation = gl.getUniformLocation( program, "worldMatrix" );
  enemyModelMatrixLocation = gl.getUniformLocation( program, "modelMatrix" );
  enemyViewMatrixLocation = gl.getUniformLocation( program, "viewMatrix" );
  initCamera(enemyProjectionMatrixLocation);  

  //setup attributes
  vertexPositionAttribute = gl.getAttribLocation( program, "vertexPosition");
  normalsAttribute = gl.getAttribLocation( program, "vNormal");
  texCoordsAttribute = gl.getAttribLocation( program, "vTexCoord");
  
  enemyAmbientProduct = mult(enemyLightAmbient, enemyMaterialAmbient);
  enemyDiffuseProduct = mult(enemyLightDiffuse, enemyMaterialDiffuse);
  enemySpecularProduct = mult(enemyLightSpecular, enemyMaterialSpecular);
  enemyTexturingLoc = gl.getUniformLocation(program, "texturing"); 
  
  //enable attributes
  gl.enableVertexAttribArray(vertexPositionAttribute); 
  gl.enableVertexAttribArray(normalsAttribute);
  gl.enableVertexAttribArray(texCoordsAttribute);
  
  gl.uniform4fv( gl.getUniformLocation(program, "ambientProduct"),flatten(enemyAmbientProduct) );
  gl.uniform4fv( gl.getUniformLocation(program, "diffuseProduct"),flatten(enemyDiffuseProduct) );
  gl.uniform4fv( gl.getUniformLocation(program, "specularProduct"),flatten(enemySpecularProduct) );
  gl.uniform4fv( gl.getUniformLocation(program,"lightPosition"),flatten(enemyLightPosition) );
  gl.uniform1f( gl.getUniformLocation(program, "shininess"), enemyMaterialShininess );
}

function initGame(){
  var worldDimension_x = 20;
  var worldDimension_y = 20;
  var worldDimension_z = 20;
  var obstacleDensity = 4; // must be a factor of worldDimensions
  var numEnemies = 5; 
  var heroStartPosition = new Point(0, 0, 0); 

  gl.useProgram(heroProgram);
  initHeroProgram(heroProgram);

  gl.useProgram(pelletProgram);
  initPelletProgram(pelletProgram);
  
  gl.useProgram(enemyProgram);
  initEnemyProgram(enemyProgram);

  initEventHandlers();

  game = new Game(worldDimension_x, worldDimension_y, worldDimension_z, obstacleDensity, numEnemies, heroStartPosition);
  drawScene();
}

var score = 0;
var numLivesRemaining = 3;

function init(){
  //get WebGL context
  canvas = document.getElementById( "gl-canvas" );
  gl = WebGLUtils.setupWebGL( canvas );
  if ( !gl ) { alert( "WebGL isn't available" ); }

  // display life and score
  lifeElement = document.getElementById("life");
  lifeNode = document.createTextNode("");
  lifeElement.appendChild(lifeNode);
  lifeNode.nodeValue = numLivesRemaining;
    
  scoreElement = document.getElementById("score");
  scoreNode = document.createTextNode("");
  scoreElement.appendChild(scoreNode);
  scoreNode.nodeValue = score;

  //setup view
  gl.viewport( 0, 0, canvas.width, canvas.height );
  gl.clearColor( 0.0, 0.0, 0.0, 1.0 );
  gl.enable(gl.DEPTH_TEST);
  aspect = canvas.width/canvas.height;
  
  //setup programs
  pelletProgram = initShaders( gl, "shader-vs-pellet", "shader-fs-pellet" );
  heroProgram = initShaders( gl, "shader-vs-hero", "shader-fs-hero" );
  enemyProgram = initShaders( gl, "shader-vs-enemy", "shader-fs-enemy" );

  initGame();
}
 
function drawScene() {
  gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
  game.drawScene();

  window.requestAnimFrame(drawScene);
}

function undo() {
    if (hero.heading.x != 0)
    {
        if (hero.heading.x > 0)
        {
            game.camera.freeHeroMatrix = mult(game.camera.freeHeroMatrix, rotate(-60, vec3(0, 1, 0)));
            game.camera.followHeroMatrix = mult(game.camera.followHeroMatrix, rotate(-60, vec3(0, 1, 0)));
        }
        else
        {
            game.camera.freeHeroMatrix = mult(game.camera.freeHeroMatrix, rotate(60, vec3(0, 1, 0)));
            game.camera.followHeroMatrix = mult(game.camera.followHeroMatrix, rotate(60, vec3(0, 1, 0)));
        }
        
    }
    else if (hero.heading.y != 0)
    {
        if (hero.heading.y > 0)
        {
            game.camera.freeHeroMatrix = mult(game.camera.freeHeroMatrix, rotate(-290, vec3(0, 0, 1)));
            game.camera.followHeroMatrix = mult(game.camera.followHeroMatrix, rotate(-290, vec3(0, 0, 1)));
            
        }
        else
        {
            game.camera.freeHeroMatrix = mult(game.camera.freeHeroMatrix, rotate(290, vec3(0, 0, 1)));
            game.camera.followHeroMatrix = mult(game.camera.followHeroMatrix, rotate(290, vec3(0, 0, 1)));
        }
    }
    else if (hero.heading.z < 0)
    {
        game.camera.freeHeroMatrix = mult(game.camera.freeHeroMatrix, rotate(-180, vec3(0, 1, 0)));
        game.camera.followHeroMatrix = mult(game.camera.followHeroMatrix, rotate(-180, vec3(0, 1, 0)));
    }
}
function initEventHandlers(){
  window.onkeydown = function(event){
      
    switch (event.keyCode){
        case 37: //left arrow
            undo();
            game.camera.freeHeroMatrix = mult(game.camera.freeHeroMatrix, rotate(-60, vec3(0, 1, 0)));
            game.camera.followHeroMatrix = mult(game.camera.followHeroMatrix, rotate(-60, vec3(0, 1, 0)));
          game.moveHero(-1, 0, 0);
          break;
        case 38: //up arrow
            undo();
            game.camera.freeHeroMatrix = mult(game.camera.freeHeroMatrix, rotate(290, vec3(0, 0, 1)));
            game.camera.followHeroMatrix = mult(game.camera.followHeroMatrix, rotate(290, vec3(0, 0, 1)));
          game.moveHero(0, 1, 0);
          break;
        case 39: //right arrow
            undo();
            game.camera.freeHeroMatrix = mult(game.camera.freeHeroMatrix, rotate(60, vec3(0, 1, 0)));
            game.camera.followHeroMatrix = mult(game.camera.followHeroMatrix, rotate(60, vec3(0, 1, 0)));
          game.moveHero(1, 0, 0);
          break;
        case 40: //down arrow
            undo();
            game.camera.freeHeroMatrix = mult(game.camera.freeHeroMatrix, rotate(-290, vec3(0, 0, 1)));
            game.camera.followHeroMatrix = mult(game.camera.followHeroMatrix, rotate(-290, vec3(0, 0, 1)));
          game.moveHero(0, -1, 0);
          break;
        case 87: //w
          if (game.camera.cameraType == camera.FREE){
            game.moveCamera(0, 1);
          }
          break;
        case 65: //a
          if (game.camera.cameraType == camera.FREE){
            game.moveCamera(1, 0);
          }          break;
        case 83: //s
          if (game.camera.cameraType == camera.FREE){
            game.moveCamera(0, -1);
          }          break;
        case 68: //d
          if (game.camera.cameraType == camera.FREE){
            game.moveCamera(-1, 0);
          }          break;
        case 69: //e
          break;
        case 81: //q
          break;
        case 49: //1
          game.camera.cameraType = camera.FREE;
          break;
        case 50: //2
          game.camera.cameraType = camera.FOLLOW;
          break;
        case 13: //enter
            undo();
            game.camera.freeHeroMatrix = mult(game.camera.freeHeroMatrix, rotate(180, vec3(0, 1, 0)));
            game.camera.followHeroMatrix = mult(game.camera.followHeroMatrix, rotate(180, vec3(0, 1, 0)));

          game.moveHero(0, 0, -1);
          break;
        case 16: //shift
            undo();
          game.moveHero(0, 0, 1);
          break;
        case 32: //space
          game.cheat = !game.cheat;
          break;
    };
  }
}









