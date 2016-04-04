var elt;
var framebuffer;
var seg=1;
var color = new Uint8Array(4);



var canvas;
var gl;
var program


 
var index = 0;

var picker_normalArray=[];
var picker_poingArray=[];


var axisx=1.0;
var axisy=-2.0;
var axisz=10.0;
var aDegree=0;

var near = 0.1;
var far = 50;

var theta  = 0.0;

var  aspect;
var  fovy = 45.0;

var sphereLocation=vec3(0.0, 0.0, 0.0);

var va = vec4(0.0, 0.0, -1.0,1);
var vb = vec4(0.0, 0.942809, 0.333333, 1);
var vc = vec4(-0.816497, -0.471405, 0.333333, 1);
var vd = vec4(0.816497, -0.471405, 0.333333,1);
    
var picker_lightPosition = vec4(0.0, 0.0, -30, 1.0 );
var picker_lightAmbient = vec4(0.2, 0.2, 0.2, 1.0 );
var picker_lightDiffuse = vec4( 1.0, 1.0, 1.0, 1.0 );
var picker_lightSpecular = vec4( 1.0, 1.0, 1.0, 1.0 );

var picker_materialAmbient = vec4( 1.0, 0.0, 1.0, 1.0 );
var picker_materialDiffuse = vec4( 1.0, 0.8, 0.0, 1.0 );
var picker_materialSpecular = vec4( 1.0, 1.0, 1.0, 1.0 );
var picker_materialShininess = 20.0;


var picker_ambientColor, picker_diffuseColor, picker_specularColor;
var picker_ambientProduct=vec4( 0.0, 0.0, 0.0, 0.0 );
var picker_diffuseProduct=vec4( 0.0, 0.0, 0.0, 0.0 );
var picker_specularProduct=vec4( 0.0, 0.0, 0.0, 0.0 );

var modelViewMatrix=mat4();//viewMatrix
var projectionMatrix,camera_transform;
var modelViewMatrixLoc, projectionMatrixLoc;

var normalMatrix, normalMatrixLoc;


var rotation;
var mvMatrixStack = [];


    //keep this in case we want different shading
/*function triangle(a, b, c,nArray,pArray) {

     var t1 = subtract(b, a);
     var t2 = subtract(c, a);
     var normal = normalize(cross(t2, t1));
     normal = vec4(normal);

     nArray.push(normal[0],normal[1],normal[2],0.0);
     nArray.push(normal[0],normal[1],normal[2],0.0);
     nArray.push(normal[0],normal[1],normal[2],0.0);
     
     pArray.push(a);
     pArray.push(b);
     pArray.push(c);

     index += 3;
}*/

function triangle(a, b, c) {
    
    
    
    picker_poingArray.push(a);
    picker_poingArray.push(b);
    picker_poingArray.push(c);
    
    picker_normalArray.push(a[0],a[1], a[2], 0.0);
    picker_normalArray.push(b[0],b[1], b[2], 0.0);
    picker_normalArray.push(c[0],c[1], c[2], 0.0);
    
    index += 3;
    
}

function divideTriangle(a, b, c, count) {
    if ( count > 0 ) {
                
        var ab = mix( a, b, 0.5);
        var ac = mix( a, c, 0.5);
        var bc = mix( b, c, 0.5);
                
        ab = normalize(ab, true);
        ac = normalize(ac, true);
        bc = normalize(bc, true);
                                
        divideTriangle( a, ab, ac, count - 1 );
        divideTriangle( ab, b, bc, count - 1 );
        divideTriangle( bc, c, ac, count - 1 );
        divideTriangle( ab, bc, ac, count - 1 );
    }
    else { 

           triangle( a, b, c );
     
    }
}


function tetrahedron(a, b, c, d, n) {

    
    divideTriangle(a, b, c, n);
    divideTriangle(d, c, b, n);
    divideTriangle(a, d, b, n);
    divideTriangle(a, c, d, n);
    
}

function createSphere(numOfVer){
    picker_normalArray.length=0.0;
    picker_poingArray.length=0.0
   tetrahedron(va, vb, vc, vd, numOfVer)

  
    gl.bindBuffer( gl.ARRAY_BUFFER, nBuffer);
    gl.bufferData( gl.ARRAY_BUFFER, flatten(picker_normalArray), gl.STATIC_DRAW );
    gl.vertexAttribPointer( vNormal, 4, gl.FLOAT, false, 0, 0 );


    gl.bindBuffer(gl.ARRAY_BUFFER, vBuffer);
    gl.bufferData(gl.ARRAY_BUFFER, flatten(picker_poingArray), gl.STATIC_DRAW);
    gl.vertexAttribPointer(vPosition, 4, gl.FLOAT, false, 0, 0);
    

}


window.onload = function init() {
    canvas = document.getElementById( "gl-canvas" );
    gl = WebGLUtils.setupWebGL( canvas );
    if ( !gl ) { alert( "WebGL isn't available" ); }
    
    /////////////////////////////////////////////////////////// inbetween is display text mechanism
    var timeElement = document.getElementById("time");
    var timeNode = document.createTextNode("");
    timeElement.appendChild(timeNode);
    // timeNode.nodeValue ="";
    
    var angleElement = document.getElementById("angle");
    var angleNode = document.createTextNode("");
    angleElement.appendChild(angleNode);
   angleNode.nodeValue="Start by picking your favorite color!";
    //////////////////////////////////////////////////////////
    
    
/////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////// inbetween is picking mechanism

    
     var ctx = canvas.getContext("experimental-webgl", {preserveDrawingBuffer: true});
   
    gl.enable(gl.CULL_FACE);
    var texture = gl.createTexture();
    gl.bindTexture( gl.TEXTURE_2D, texture );
    gl.pixelStorei(gl.UNPACK_FLIP_Y_WEBGL, true);
    gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, 512, 512, 0,
                  gl.RGBA, gl.UNSIGNED_BYTE, null);
    gl.generateMipmap(gl.TEXTURE_2D);
 

    framebuffer = gl.createBuffer();
    gl.bindBuffer( gl.FRAMEBUFFER, framebuffer);
    gl.framebufferTexture2D(gl.FRAMEBUFFER, gl.COLOR_ATTACHMENT0, gl.TEXTURE_2D, texture, 0);
    gl.bindBuffer(gl.FRAMEBUFFER, null);
 
    canvas.addEventListener("mousedown", function(event){
                            
                            gl.bindBuffer(gl.FRAMEBUFFER, framebuffer);

                            gl.clear( gl.COLOR_BUFFER_BIT);
                         
                            gl.uniform1i(gl.getUniformLocation(program, "i"), 1);
                        
                            
                            drawSphere(vec3(-3,1,-20),1,1);
                            gl.uniform1i(gl.getUniformLocation(program, "i"), 2);
                            drawSphere(vec3(1.6,1,-20),1,1);
                            var x = event.clientX;
                            var y = canvas.height -event.clientY;
                            
                            gl.readPixels(x, y, 1, 1, gl.RGBA, gl.UNSIGNED_BYTE, color);
                            
                            start = document.getElementById("start");
                            if(color[0]==255) {
                                angleNode.nodeValue ="YOU PICKED THE YELLOW CUBE!!";
                                start.play();
                                setTimeout(function(){
                                    window.location.assign("gameLeft.html");
                                }, 5000);
                            }
							else if(color[1]==255) {
                                angleNode.nodeValue ="YOU PICKED THE RED CUBE!!";
                                start.play();
                                setTimeout(function(){
                                    window.location.assign("gameRight.html");
                                }, 5000);
                            }
                            else
                            angleNode.nodeValue ="Start by picking your favorite color!";
                            gl.bindFramebuffer(gl.FRAMEBUFFER, null);
                            
                            gl.uniform1i(gl.getUniformLocation(program, "i"), 0);
                            gl.clear( gl.COLOR_BUFFER_BIT );
                            
                            });
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////


    gl.viewport( 0, 0, canvas.width, canvas.height );
    gl.clearColor( 0.5, 0.5, 0.5, 1.0 );
    aspect =  canvas.width/canvas.height;
    
    camera_transform=mat4();
    
    gl.enable(gl.DEPTH_TEST);


    program = initShaders( gl, "vertex-shader", "fragment-shader" );
    gl.useProgram( program );
    
    

    nBuffer = gl.createBuffer();
    vBuffer = gl.createBuffer();
    vNormal = gl.getAttribLocation( program, "vNormal" );
 
  
    vPosition = gl.getAttribLocation( program, "vPosition");
    gl.enableVertexAttribArray( vNormal);
    gl.enableVertexAttribArray(vPosition);

    
    modelViewMatrixLoc = gl.getUniformLocation( program, "modelViewMatrix" );
    projectionMatrixLoc = gl.getUniformLocation( program, "projectionMatrix" );
    camera_transform_loc=gl.getUniformLocation( program, "camera_transform" );

    gl.uniform4fv( gl.getUniformLocation(program,
                                         "lightPosition"),flatten(picker_lightPosition) );
    gl.uniform1f( gl.getUniformLocation(program,
                                        "shininess"),picker_materialShininess );
    projectionMatrix = perspective(fovy, aspect, near, far);

      createSphere(2,1);
   

    
  
  render();
    
    
}
function mvPushMatrix() {
    var copy = mat4();
    copy=modelViewMatrix;
    mvMatrixStack.push(copy);
}

function mvPopMatrix() {
    if (mvMatrixStack.length == 0) {
        throw "Invalid popMatrix!";
    }
    modelViewMatrix = mvMatrixStack.pop();
}


window.addEventListener("keydown",function(){
                        switch(event.keyCode){
                
                        case 38://up arrow
                        axisy-=0.25;
                        axisyRef-=0.25
                        break;
                        
                        case 40: //down arrow
                        axisy+=0.25;
                        axisyRef+=0.25
                        break;
                        
                        case 73://i
                        axisz+=0.25;
                        axiszRef+=0.25
                        break;
                        
                        case 77://m
                        axisz-=0.25;
                        axiszRef-=0.25
                        break;
                        
                        case 74://j
                        axisx+=0.25;
                        axisxRef+=0.25;
                        break;
                        
                        case 75://k
                        axisx-=0.25;
                        axisxRef-=0.25;
                        break;
                        
                        case 37://left arrow
                        aDegree-=1;
                        aDegreeRef-=1
                        break;
                        
                        case 39://right arrow
                        aDegree+=1;
                        aDegreeRef+=1
                        break;
     
                        
                        case 84://t
                        if(seg==1)
                        seg=2;
                        else if (seg==2)
                        seg=3;
                        else seg=1;
                        break;
                        
                        }
                   
                        
                        })

function drawSphere(sphereLocation,speed,seg){


    
       mvPushMatrix();
        modelViewMatrix=mult(modelViewMatrix,translate(sphereLocation));
    rotation=rotate(theta*speed,0,1,0);
    modelViewMatrix=mult(modelViewMatrix,rotation);
 
    
 
    gl.uniformMatrix4fv(modelViewMatrixLoc, false, flatten(modelViewMatrix) );
    gl.uniformMatrix4fv(projectionMatrixLoc, false, flatten(projectionMatrix) );
    gl.uniformMatrix4fv( camera_transform_loc, false, flatten(camera_transform) );
    
    
   picker_ambientProduct = mult(picker_lightAmbient, picker_materialAmbient);
   picker_diffuseProduct  = mult(picker_lightDiffuse, picker_materialDiffuse);
   picker_specularProduct  = mult(picker_lightSpecular, picker_materialSpecular);
    
    gl.uniform4fv( gl.getUniformLocation(program,
                                         "ambientProduct"),flatten(picker_ambientProduct) );
    gl.uniform4fv( gl.getUniformLocation(program,
                                         "diffuseProduct"),flatten(picker_diffuseProduct) );
    gl.uniform4fv( gl.getUniformLocation(program,
                                         "specularProduct"),flatten(picker_specularProduct) );
    
 switch (seg){
            
     case 1: gl.drawArrays( gl.TRIANGLES, 0, index );break;
     case 2: gl.drawArrays( gl.LINES, 0, index );break;
     case 3: gl.drawArrays( gl.POINTS, 0, index );break;
    
   
 }
            mvPopMatrix();

}

function render() {
    
    gl.clear( gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
    
 
    camera_transform=mult(camera_transform,translate(axisx,axisy,axisz));//update camera transformation matrix
    camera_transform=mult(camera_transform,rotate(aDegree,0,1,0));
    
theta+=1;

  
//------------------------------------------------------
    picker_materialAmbient = vec4( 1.0, 0.5, 0.0, 1.0 );
    picker_materialDiffuse = vec4( 1.0, 1.0, 0.0, 1.0 );
    picker_materialSpecular = vec4( 1.0, 1.0, 1.0, 1.0 );
    
    drawSphere(vec3(-3,1,-20),1,seg);
 
    picker_materialAmbient = vec4( 0.0, 1.0, 1.0, 1.0 );
    picker_materialDiffuse = vec4( 1.0, 0.0, 0.0, 1.0 );
    picker_materialSpecular = vec4( 1.0, 1.0, 1.0, 1.0 );

    drawSphere(vec3(1.5,1,-20),-1,seg);

  gl.uniform1i(gl.getUniformLocation(program, "i"),0);
   axisx=0;
    axisy=0;
    axisz=0;
    aDegree=0;
    window.requestAnimFrame(render);
}
