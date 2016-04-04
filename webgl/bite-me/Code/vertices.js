// -------------------------------------------------
// ----------------- Hero Data ---------------------
// -------------------------------------------------

var heroIndices = [];
var heroVertices = [];
var heroNormals = [];
var heroTextureCoords = [];

function initBuffers() {
    var scale = 0.25;
    var latitudeBands = 30;
    var longitudeBands = 30;
    var radius = 2;
    
    for (var latNumber=0; latNumber <= latitudeBands; latNumber++) {
        var theta = latNumber * Math.PI / latitudeBands;
        var sinTheta = Math.sin(theta);
        var cosTheta = Math.cos(theta);
        
        for (var longNumber=0; longNumber <= longitudeBands; longNumber++) {
            var phi = longNumber * 2 * Math.PI / longitudeBands;
            var sinPhi = Math.sin(phi);
            var cosPhi = Math.cos(phi);
            
            var x = cosPhi * sinTheta;
            var y = cosTheta;
            var z = sinPhi * sinTheta;
            var u = 1 - (longNumber / longitudeBands);
            var v = 1 - (latNumber / latitudeBands);
            
            heroNormals.push(x);
            heroNormals.push(y);
            heroNormals.push(z);
            heroTextureCoords.push(u);
            heroTextureCoords.push( v);
            heroVertices.push(radius * x * scale);
            heroVertices.push(radius * y * scale);
            heroVertices.push(radius * z * scale);
        }
    }

    for (var latNumber=0; latNumber < latitudeBands; latNumber++) {
        for (var longNumber=0; longNumber < longitudeBands; longNumber++) {
            var first = (latNumber * (longitudeBands + 1)) + longNumber;
            var second = first + longitudeBands + 1;
            heroIndices.push(first);
            heroIndices.push(second);
            heroIndices.push(first + 1);
            
            heroIndices.push(second);
            heroIndices.push(second + 1);
            heroIndices.push(first + 1);
        }
    }
}

initBuffers();


// -------------------------------------------------
// ---------------- Enemy Data ---------------------
// -------------------------------------------------

// ---------- Enemy A (Pac-man Ghost) ----------- //


var enemyAVertices = [];
var enemyANormals = [];
var enemyATexCoords = [];
var enemyATexture;
var enemyLightPosition = vec4(-5.0, 2.0, 10.0, 0.0 );
var enemyLightAmbient = vec4(1.0, 1.0, 1, 1.0);
var enemyLightDiffuse = vec4( 1.0, 1.0, 1.0, 1.0 );
var enemyLightSpecular = vec4( 1.0, 1.0, 1.0, 1.0 );

var enemyMaterialAmbient = vec4( 0.05, 0.05, 0.05, 1.0 );
var enemyMaterialDiffuse = vec4( 1.0, 0.0, 0.0, 1.0 );
var enemyMaterialSpecular = vec4( 1.0, 1.0, 1.0, 1.0 );
var enemyMaterialShininess = 20000.0;

var enemyAmbientProduct;
var enemyDiffuseProduct;
var enemySpecularProduct;

var index = 0;
function triangle(a, b, c){
    
    enemyAVertices.push(a);
    enemyAVertices.push(b);      
    enemyAVertices.push(c);

     enemyANormals.push(a[0],a[1], a[2], 0.0);
     enemyANormals.push(b[0],b[1], b[2], 0.0);
     enemyANormals.push(c[0],c[1], c[2], 0.0);
    
    if (index % 6 == 0){
        enemyATexCoords.push(texCoord[3]);
        enemyATexCoords.push(texCoord[1]);
        enemyATexCoords.push(texCoord[0]);
    }
    else {
        enemyATexCoords.push(texCoord[2]);
        enemyATexCoords.push(texCoord[1]);
        enemyATexCoords.push(texCoord[3]);
    }
    index += 3;
}

function quad(a, b, c, d){
    triangle(d,b,a);
    triangle(c,b,d);

}

// drawing the geometry
var height = 0.35;
var radius = 0.8;
var factor = radius/Math.sqrt(2);

var height2 = 0.725;
var radius2 = 0.6;
var factor2 = radius2/Math.sqrt(2);

var height3 = 0.85;
var radius3 = 0.3;
var factor3 = radius3/Math.sqrt(2);

var height4 = -0.65;

var zero = vec3(0.0,height3,0.0);
var zeroBottom = vec3(0.0,-height,0.0);

var texCoord = [
    vec2(0, 0),
    vec2(0, 1),
    vec2(1, 1),
    vec2(1, 0)
];


var Ghost = [
    vec3(0.0, height, radius),      //0
    vec3(factor, height, factor),   //1
    vec3(radius, height, 0),            //2
    vec3(factor, height, -factor),  //3
    vec3(0.0, height, -radius),         //4
    vec3(-factor, height, -factor),     //5
    vec3(-radius, height, 0.0),         //6
    vec3(-factor, height, factor),      //7
    
    vec3(0.0, -height, radius),         //8
    vec3(factor, -height, factor),      //9
    vec3(radius, -height, 0),           //10
    vec3(factor, -height, -factor),     //11
    vec3(0.0, -height, -radius),        //12
    vec3(-factor, -height, -factor),    //13
    vec3(-radius, -height, 0.0),        //14
    vec3(-factor, -height, factor),     //15
    
    vec3(0.0, height2, radius2),        //16
    vec3(factor2, height2, factor2),    //17
    vec3(radius2, height2, 0),      //18
    vec3(factor2, height2, -factor2),   //19
    vec3(0.0, height2, -radius2),       //20
    vec3(-factor2, height2, -factor2),  //21
    vec3(-radius2, height2, 0.0),   //22
    vec3(-factor2, height2, factor2),   //23
    
    vec3(0.0, height3, radius3),        //24
    vec3(factor3, height3, factor3),    //25
    vec3(radius3, height3, 0),      //26
    vec3(factor3, height3, -factor3),   //27
    vec3(0.0, height3, -radius3),       //28
    vec3(-factor3, height3, -factor3),  //29
    vec3(-radius3, height3, 0.0),   //30
    vec3(-factor3, height3, factor3),   //31
    
    vec3(factor/2, height4, (radius+factor)/2), //32 (8+9)
    vec3((factor+radius)/2, height4, factor/2), //33 (9+10)
    vec3((radius+factor)/2, height4, -(factor/2)),  //34 (10+11)
    vec3(factor/2, height4, (-factor-radius)/2),    //35 (11+12)
    vec3(-factor/2, height4, (-radius-factor)/2),   //36 (12+13)
    vec3((-radius-factor)/2, height4, -factor/2),   //37 (13+14)
    vec3((-radius-factor)/2, height4, factor/2),    //38 (14+15)
    vec3(-factor/2, height4, (radius+factor)/2) //39 (15+8)
    
];


//first cylinder
quad(Ghost[0], Ghost[8], Ghost[9], Ghost[1]);
quad(Ghost[1], Ghost[9], Ghost[10], Ghost[2]);
quad(Ghost[2], Ghost[10], Ghost[11], Ghost[3]);
quad(Ghost[3], Ghost[11], Ghost[12], Ghost[4]);
quad(Ghost[4], Ghost[12], Ghost[13], Ghost[5]);
quad(Ghost[5], Ghost[13], Ghost[14], Ghost[6]);
quad(Ghost[6], Ghost[14], Ghost[15], Ghost[7]);
quad(Ghost[7], Ghost[15], Ghost[8], Ghost[0]);

//second cylinder
quad(Ghost[16], Ghost[0], Ghost[1], Ghost[17]);
quad(Ghost[17], Ghost[1], Ghost[2], Ghost[18]);
quad(Ghost[18], Ghost[2], Ghost[3], Ghost[19]);
quad(Ghost[19], Ghost[3], Ghost[4], Ghost[20]);
quad(Ghost[20], Ghost[4], Ghost[5], Ghost[21]);
quad(Ghost[21], Ghost[5], Ghost[6], Ghost[22]);
quad(Ghost[22], Ghost[6], Ghost[7], Ghost[23]);
quad(Ghost[23], Ghost[7], Ghost[0], Ghost[16]);

//third cylinder
quad(Ghost[24], Ghost[16], Ghost[17], Ghost[25]);
quad(Ghost[25], Ghost[17], Ghost[18], Ghost[26]);
quad(Ghost[26], Ghost[18], Ghost[19], Ghost[27]);
quad(Ghost[27], Ghost[19], Ghost[20], Ghost[28]);
quad(Ghost[28], Ghost[20], Ghost[21], Ghost[29]);
quad(Ghost[29], Ghost[21], Ghost[22], Ghost[30]);
quad(Ghost[30], Ghost[22], Ghost[23], Ghost[31]);
quad(Ghost[31], Ghost[23], Ghost[16], Ghost[24]);

//cap
triangle(zero, Ghost[25], Ghost[24]);
triangle(zero, Ghost[26], Ghost[25]);
triangle(zero, Ghost[27], Ghost[26]);
triangle(zero, Ghost[28], Ghost[27]);
triangle(zero, Ghost[29], Ghost[28]);
triangle(zero, Ghost[30], Ghost[29]);
triangle(zero, Ghost[31], Ghost[30]);   
triangle(zero, Ghost[24], Ghost[31]);   

//bottom
triangle(Ghost[8], Ghost[9], Ghost[32]);
triangle(Ghost[9], Ghost[10], Ghost[33]);
triangle(Ghost[10], Ghost[11], Ghost[34]);
triangle(Ghost[11], Ghost[12], Ghost[35]);
triangle(Ghost[12], Ghost[13], Ghost[36]);
triangle(Ghost[13], Ghost[14], Ghost[37]);
triangle(Ghost[14], Ghost[15], Ghost[38]);  
triangle(Ghost[15], Ghost[8], Ghost[39]);


// -------------- Enemy B (Space Invader) ----------- //

var enemyBVertices = [];
var enemyBNormals = [];

function triangleB(a, b, c){
    
    enemyBVertices.push(a);
    enemyBVertices.push(b);      
    enemyBVertices.push(c);

    var t1 = subtract(b, a);
    var t2 = subtract(c, a);
    var normal = normalize(cross(t2, t1));
    normal = vec4(normal);

    enemyBNormals.push(normal);
    enemyBNormals.push(normal);
    enemyBNormals.push(normal);

     
}

function quadB(a, b, c, d){
    triangleB(a,b,c);
    triangleB(a,c,d);
}

var Invader = [
    vec3(-0.6, 0.8, 0.0),
    vec3(-0.4, 0.8, 0.0),
    vec3(-0.4, 0.6, 0.0),
    vec3(-0.6, 0.6, 0.0),
    
    vec3(-0.4, 0.6, 0.0),
    vec3(-0.2, 0.6, 0.0),
    vec3(-0.2, 0.2, 0.0),
    vec3(-0.4, 0.2, 0.0),
    
    vec3(-0.6, 0.4, 0.0),
    vec3(-0.4, 0.4, 0.0),
    vec3(-0.4, -0.6, 0.0),
    vec3(-0.6, -0.6, 0.0),
    
    vec3(-0.8, 0.2, 0.0),
    vec3(-0.6, 0.2, 0.0),
    vec3(-0.6, -0.2, 0.0),
    vec3(-0.8, -0.2, 0.0),
        
    vec3(-1.0, 0.0, 0.0),
    vec3(-0.8, 0.0, 0.0),
    vec3(-0.8, -0.6, 0.0),
    vec3(-1.0, -0.6, 0.0),
        
    vec3(-0.4, 0.0, 0.0),
    vec3(-0.2, 0.0, 0.0),
    vec3(-0.2, -0.4, 0.0),
    vec3(-0.4, -0.4, 0.0),
        
    vec3(-0.2, 0.4, 0.0),
    vec3(0.0, 0.4, 0.0),
    vec3(0.0, -0.4, 0.0),
    vec3(-0.2, -0.4, 0.0),
        
    vec3(-0.4, -0.6, 0.0),
    vec3(-0.12, -0.6, 0.0),
    vec3(-0.12, -0.8, 0.0),
    vec3(-0.4, -0.8, 0.0),
    
    //mirrored side
    
    vec3(0.6, 0.8, 0.0),
    vec3(0.4, 0.8, 0.0),
    vec3(0.4, 0.6, 0.0),
    vec3(0.6, 0.6, 0.0),
    
    vec3(0.4, 0.6, 0.0),
    vec3(0.2, 0.6, 0.0),
    vec3(0.2, 0.2, 0.0),
    vec3(0.4, 0.2, 0.0),
    
    vec3(0.6, 0.4, 0.0),
    vec3(0.4, 0.4, 0.0),
    vec3(0.4, -0.6, 0.0),
    vec3(0.6, -0.6, 0.0),
    
    vec3(0.8, 0.2, 0.0),
    vec3(0.6, 0.2, 0.0),
    vec3(0.6, -0.2, 0.0),
    vec3(0.8, -0.2, 0.0),
        
    vec3(1.0, 0.0, 0.0),
    vec3(0.8, 0.0, 0.0),
    vec3(0.8, -0.6, 0.0),
    vec3(1.0, -0.6, 0.0),
        
    vec3(0.4, 0.0, 0.0),
    vec3(0.2, 0.0, 0.0),
    vec3(0.2, -0.4, 0.0),
    vec3(0.4, -0.4, 0.0),
        
    vec3(0.2, 0.4, 0.0),
    vec3(0.0, 0.4, 0.0),
    vec3(0.0, -0.4, 0.0),
    vec3(0.2, -0.4, 0.0),
        
    vec3(0.4, -0.6, 0.0),
    vec3(0.12, -0.6, 0.0),
    vec3(0.12, -0.8, 0.0),
    vec3(0.4, -0.8, 0.0),
        
];
        

quadB(Invader[0], Invader[1], Invader[2], Invader[3]);
quadB(Invader[4], Invader[5], Invader[6], Invader[7]);
quadB(Invader[8], Invader[9], Invader[10], Invader[11]);
quadB(Invader[12], Invader[13], Invader[14], Invader[15]);
quadB(Invader[16], Invader[17], Invader[18], Invader[19]);
quadB(Invader[20], Invader[21], Invader[22], Invader[23]);
quadB(Invader[24], Invader[25], Invader[26], Invader[27]);
quadB(Invader[28], Invader[29], Invader[30], Invader[31]);

//mirrored side
quadB(Invader[32], Invader[33], Invader[34], Invader[35]);
quadB(Invader[36], Invader[37], Invader[38], Invader[39]);
quadB(Invader[40], Invader[41], Invader[42], Invader[43]);
quadB(Invader[44], Invader[45], Invader[46], Invader[47]);  
quadB(Invader[48], Invader[49], Invader[50], Invader[51]);
quadB(Invader[52], Invader[53], Invader[54], Invader[55]);
quadB(Invader[56], Invader[57], Invader[58], Invader[59]);
quadB(Invader[60], Invader[61], Invader[62], Invader[63]);  


// ----------------- Enemy C (Thwomp) ---------------------- //
var enemyCVertices = [];
var enemyCNormals = [];
var enemyCTexCoords = [];

var index = 0;

function triangleC(a, b, c){
    
    enemyCVertices.push(a);
    enemyCVertices.push(b);      
    enemyCVertices.push(c);

    var t1 = subtract(b, a);
    var t2 = subtract(c, a);
    var normal = normalize(cross(t2, t1));
    normal = vec4(normal);

    enemyCNormals.push(normal);
    enemyCNormals.push(normal);
    enemyCNormals.push(normal);
    if (index%6 == 0){
    enemyCTexCoords.push(texCoord[0]);
    enemyCTexCoords.push(texCoord[1]);
    enemyCTexCoords.push(texCoord[3]);
    }
    else{
    enemyCTexCoords.push(texCoord[3]);
    enemyCTexCoords.push(texCoord[1]);
    enemyCTexCoords.push(texCoord[2]);
    }
     index += 3;
     
}

function quadC(a, b, c, d)
{
    triangleC(a,b,d);
    triangleC(d,b,c);

}

var Thwomp = [
    vec3(-1.0, 1.0, 1.0),
    vec3(1.0, 1.0, 1.0),
    vec3(1.0, -1.0, 1.0),
    vec3(-1.0, -1.0, 1.0),
    
    vec3(-1.0, 1.0, -1.0),
    vec3(1.0, 1.0, -1.0),
    vec3(1.0, -1.0, -1.0),
    vec3(-1.0, -1.0, -1.0),
];

quadC(Thwomp[3], Thwomp[0], Thwomp[1], Thwomp[2]);
quadC(Thwomp[1], Thwomp[5], Thwomp[6], Thwomp[2]);
quadC(Thwomp[2], Thwomp[6], Thwomp[7], Thwomp[3]);
quadC(Thwomp[4], Thwomp[0], Thwomp[3], Thwomp[7]);
quadC(Thwomp[5], Thwomp[1], Thwomp[0], Thwomp[4]);
quadC(Thwomp[5], Thwomp[4], Thwomp[7], Thwomp[6]);

// ----------------- Enemy D (Andross) -------------------- //
var enemyDVertices = [];
var enemyDNormals = [];

function triangleD(a, b, c){
    
    enemyDVertices.push(a);
    enemyDVertices.push(b);      
    enemyDVertices.push(c);

    var t1 = subtract(b, a);
    var t2 = subtract(c, a);
    var normal = normalize(cross(t2, t1));
    normal = vec4(normal);

    enemyDNormals.push(normal);
    enemyDNormals.push(normal);
    enemyDNormals.push(normal);

}
var scaling = 2.0;
var Andross = [
    vec3(0*scaling, 0.9*scaling, 0), // 1
    vec3(-0.08*scaling, 0.35*scaling, 0), // 2
    vec3(0.08*scaling, 0.35*scaling, 0), // 3
    vec3(0.4*scaling, 0.51*scaling, 0.1), // 4
    vec3(0.35*scaling, 0.85*scaling, 0), // 5
    vec3(0.625*scaling, 0.5*scaling, 0), // 6
    vec3(0.625*scaling, 0.25*scaling, 0), // 7
    vec3(0.4*scaling, 0.4*scaling, 0.1), // 8
    vec3(0.165*scaling, 0.28*scaling, 0), // 9
    vec3(0.4*scaling, 0.25*scaling, 0.1), // 10
    vec3(0.4*scaling, 0.08*scaling, 0.1), // 11
    vec3(0.625*scaling, -0.05*scaling, 0), // 12
    vec3(0.2*scaling, -0.18*scaling, 0), // 13
    vec3(0.57*scaling, -0.52*scaling, 0), // 14
    vec3(0.4*scaling, -0.5*scaling, 0.05), // 15
    vec3(0.3*scaling, -0.9*scaling, 0), // 16
    vec3(0*scaling, -0.9*scaling, 0), // 17
    vec3(0*scaling, -0.68*scaling, 0.1), // 18
    vec3(0*scaling, -0.62*scaling, 0.1), // 19
    vec3(0*scaling, -0.4*scaling, 0.1), // 20
    vec3(-0.4*scaling, -0.5*scaling, 0.05), // 21
    vec3(-0.57*scaling, -0.52*scaling, 0), // 22
    vec3(-0.3*scaling, -0.9*scaling, 0), // 23
    vec3(-0.625*scaling, -0.05*scaling, 0), // 24
    vec3(-0.2*scaling, -0.18*scaling, 0), // 25
    vec3(0*scaling, -0.25*scaling, 0.075), // 26
    vec3(-0.1*scaling, -0.1*scaling, 0.3), // 27
    vec3(0.1*scaling, -0.1*scaling, 0.3), // 28
    vec3(-0.165*scaling, 0.28*scaling, 0), // 29
    vec3(-0.4*scaling, 0.08*scaling, 0.1), // 30
    vec3(-0.625*scaling, 0.25*scaling, 0), // 31
    vec3(-0.4*scaling, 0.25*scaling, 0.1), // 32
    vec3(-0.4*scaling, 0.4*scaling, 0.1), // 33
    vec3(-0.625*scaling, 0.5*scaling, 0), // 34
    vec3(-0.4*scaling, 0.51*scaling, 0.1), // 35
    vec3(-0.35*scaling, 0.85*scaling, 0), // 36
    vec3(0.0*scaling, 0.0*scaling, -0.5),   // 37

];

    triangleD( Andross[2], Andross[1], Andross[0]);
    triangleD( Andross[0], Andross[3], Andross[2]);
    triangleD( Andross[4], Andross[3], Andross[0]);
    triangleD( Andross[5], Andross[3], Andross[4]);
    triangleD( Andross[6], Andross[3], Andross[5]);
    triangleD( Andross[6], Andross[7], Andross[3]);
    triangleD( Andross[11], Andross[9], Andross[6]);
    triangleD( Andross[11], Andross[10], Andross[9]);
    triangleD( Andross[11], Andross[12], Andross[10]);
    triangleD( Andross[3], Andross[8], Andross[2]);
    
    triangleD( Andross[8], Andross[27], Andross[2]);
    triangleD( Andross[7], Andross[8], Andross[3]);
    triangleD( Andross[9], Andross[10], Andross[8]);
    triangleD( Andross[10], Andross[12], Andross[8]);
    triangleD( Andross[12], Andross[27], Andross[8]);
    triangleD( Andross[8], Andross[27], Andross[2]);
    triangleD( Andross[13], Andross[12], Andross[11]);
    triangleD( Andross[13], Andross[14], Andross[12]);
    triangleD( Andross[13], Andross[15], Andross[14]);
    triangleD( Andross[14], Andross[25], Andross[12]);
    
    triangleD( Andross[14], Andross[19], Andross[25]);
    triangleD( Andross[26], Andross[12], Andross[27]);
    triangleD( Andross[26], Andross[24], Andross[12]);
    triangleD( Andross[12], Andross[25], Andross[24]);
    triangleD( Andross[15], Andross[17], Andross[14]);
    triangleD( Andross[15], Andross[22], Andross[17]);
    triangleD( Andross[17], Andross[18], Andross[14]);
    triangleD( Andross[18], Andross[17], Andross[20]);
    triangleD( Andross[17], Andross[22], Andross[20]);
    triangleD( Andross[22], Andross[21], Andross[20]);
    
    triangleD( Andross[2], Andross[27], Andross[1]);
    triangleD( Andross[27], Andross[26], Andross[1]);
    triangleD( Andross[0], Andross[1], Andross[34]);
    triangleD( Andross[34], Andross[35], Andross[0]);
    triangleD( Andross[34], Andross[33], Andross[35]);
    triangleD( Andross[35], Andross[32], Andross[33]);
    triangleD( Andross[32], Andross[30], Andross[33]);
    triangleD( Andross[31], Andross[29], Andross[30]);
    triangleD( Andross[29], Andross[23], Andross[30]);
    triangleD( Andross[28], Andross[32], Andross[34]);
    
    triangleD( Andross[1], Andross[28], Andross[34]);
    triangleD( Andross[26], Andross[28], Andross[1]);
    triangleD( Andross[26], Andross[24], Andross[28]);
    triangleD( Andross[28], Andross[29], Andross[31]);
    triangleD( Andross[24], Andross[29], Andross[28]);
    triangleD( Andross[24], Andross[23], Andross[29]);
    triangleD( Andross[24], Andross[20], Andross[23]);
    triangleD( Andross[20], Andross[21], Andross[23]);
    triangleD( Andross[25], Andross[20], Andross[24]);
    triangleD( Andross[19], Andross[20], Andross[25]);

    triangleD( Andross[36], Andross[4], Andross[0]);
    triangleD( Andross[36], Andross[5], Andross[4]);
    triangleD( Andross[36], Andross[6], Andross[5]);
    triangleD( Andross[36], Andross[11], Andross[6]);
    triangleD( Andross[36], Andross[13], Andross[11]);
    triangleD( Andross[36], Andross[15], Andross[13]);
    triangleD( Andross[36], Andross[22], Andross[15]);
    triangleD( Andross[36], Andross[21], Andross[22]);
    triangleD( Andross[36], Andross[23], Andross[21]);
    triangleD( Andross[36], Andross[30], Andross[23]);
    triangleD( Andross[36], Andross[33], Andross[30]);
    triangleD( Andross[36], Andross[35], Andross[33]);
    triangleD( Andross[36], Andross[0], Andross[35]);
    
    //eyes
    triangleD( Andross[32], Andross[31], Andross[30]);
    triangleD( Andross[28], Andross[31], Andross[32]);
    
    triangleD( Andross[7], Andross[6], Andross[9]);
    triangleD( Andross[7], Andross[9], Andross[8]);
