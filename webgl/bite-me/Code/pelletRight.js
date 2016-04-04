var pelletVertices = [];
var pelletNormals = [];

var pelletLightPosition = vec4(0.0, 0.0, 20.0, 1.0 );
var pelletLightAmbient = vec4(0.2, 0.2, 0.2, 1.0 );
var pelletLightDiffuse = vec4( 1.0, 1.0, 1.0, 1.0 );
var pelletLightSpecular = vec4( 1.0, 1.0, 1.0, 1.0 );

var pelletMaterialAmbient = vec4( 1.0, 0.0, 1.0, 1.0 );
var pelletMaterialDiffuse = vec4( 1.0, 0.8, 0.0, 1.0 );
var pelletMaterialSpecular = vec4( 1.0, 1.0, 1.0, 1.0 );
var pelletMaterialShininess = 20.0;

var pelletScale = 0.45;


// var ambientColor, diffuseColor, specularColor;
var pelletAmbientProduct = vec4( 0.0, 0.0, 0.0, 0.0 );
var pelletDiffuseProduct = vec4( 0.0, 0.0, 0.0, 0.0 );
var pelletSpecularProduct = vec4( 0.0, 0.0, 0.0, 0.0 );

var va = vec4(0.0, 0.0, -1.0,1);
var vb = vec4(0.0, 0.942809, 0.333333,1);
var vc = vec4(-0.816497, -0.471405, 0.333333,1);
var vd = vec4(0.816497, -0.471405, 0.333333,1);

var sphereResolution = 3;

function initPelletData(){
    tetrahedron(va, vb, vc, vd, sphereResolution);
    return pelletVertices;
}

function triangle(a, b, c) {

    var t1 = subtract(b, a);
    var t2 = subtract(c, a);
    var normal = normalize(cross(t2, t1));
    normal = vec4(normal);
    normal[3]  = 0.0;

    pelletNormals.push(normal);
    pelletNormals.push(normal);
    pelletNormals.push(normal);

    scaled_a = vec4(a[0] * pelletScale, a[1] * pelletScale, a[2] * pelletScale, 1.0);
    scaled_b = vec4(b[0] * pelletScale, b[1] * pelletScale, b[2] * pelletScale, 1.0);
    scaled_c = vec4(c[0] * pelletScale, c[1] * pelletScale, c[2] * pelletScale, 1.0);

    pelletVertices.push(scaled_a);
    pelletVertices.push(scaled_b);      
    pelletVertices.push(scaled_c);
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