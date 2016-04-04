
function Character(position, type){
  if(!(this instanceof Character)) return new Character();
  this.position = position;
  this.heading = new Point(1, 0, 0);
  this.renderer = new Renderer(type, 1);
}

Character.prototype.move = function(x, y, z){
    this.position.x += x;
    this.position.y += y;
    this.position.z += z;
    
    this.heading.x = x;
    this.heading.y = y;
    this.heading.z = z;
}