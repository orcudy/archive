 function drawTexturedCube(fTex, lTex, bTex, rTex, tTex, bTex){
    //front
    gl.bindTexture(gl.TEXTURE_2D, fTex);
    modelMatrix = mat4();
    modelMatrix = mult(rotate(180, [0, 0, 1]), modelMatrix);
    modelMatrix = mult(translate(0, 0, 1), modelMatrix);
    gl.uniformMatrix4fv(modelMatrixLocation, false, flatten(modelMatrix) );
    gl.drawArrays(gl.TRIANGLE_STRIP, 0, 4);

    //left
    gl.bindTexture(gl.TEXTURE_2D, lTex);
    modelMatrix = mat4();
    modelMatrix = mult(rotate(180, [0, 0, 1]), modelMatrix);
    modelMatrix = mult(rotate(90, [0, 1, 0]), modelMatrix);
    modelMatrix = mult(translate(-1, 0, 0), modelMatrix);
    gl.uniformMatrix4fv(modelMatrixLocation, false, flatten(modelMatrix) );
    gl.drawArrays(gl.TRIANGLE_STRIP, 0, 4);

    //back
    gl.bindTexture(gl.TEXTURE_2D, bTex);
    modelMatrix = mat4();
    modelMatrix = mult(rotate(180, [0, 0, 1]), modelMatrix);
    modelMatrix = mult(translate(0, 0, -1), modelMatrix);
    gl.uniformMatrix4fv(modelMatrixLocation, false, flatten(modelMatrix) );
    gl.drawArrays(gl.TRIANGLE_STRIP, 0, 4);

    //right
    gl.bindTexture(gl.TEXTURE_2D, rTex);
    modelMatrix = mat4();
    modelMatrix = mult(rotate(180, [0, 0, 1]), modelMatrix);
    modelMatrix = mult(rotate(90, [0, 1, 0]), modelMatrix);
    modelMatrix = mult(translate(1, 0, 0), modelMatrix);
    gl.uniformMatrix4fv(modelMatrixLocation, false, flatten(modelMatrix) );
    gl.drawArrays(gl.TRIANGLE_STRIP, 0, 4);

    //top
    gl.bindTexture(gl.TEXTURE_2D, tTex);
    modelMatrix = mat4();
    modelMatrix = mult(rotate(180, [0, 0, 1]), modelMatrix);
    modelMatrix = mult(rotate(90, [1, 0, 0]), modelMatrix);
    modelMatrix = mult(translate(0, 1, 0), modelMatrix);
    gl.uniformMatrix4fv(modelMatrixLocation, false, flatten(modelMatrix) );
    gl.drawArrays(gl.TRIANGLE_STRIP, 0, 4);

    //bottom
    gl.bindTexture(gl.TEXTURE_2D, bTex);
    modelMatrix = mat4();
    modelMatrix = mult(rotate(180, [0, 0, 1]), modelMatrix);
    modelMatrix = mult(rotate(90, [1, 0, 0]), modelMatrix);
    modelMatrix = mult(translate(0, -1, 0), modelMatrix);
    gl.uniformMatrix4fv(modelMatrixLocation, false, flatten(modelMatrix) );
    gl.drawArrays(gl.TRIANGLE_STRIP, 0, 4);
}