Enemy.prototype = Object.create(Character.prototype);
Enemy.prototype.constructor = Enemy;

function Enemy(position, type){
  Character.prototype.constructor.call(this, position, type);
  if(!(this instanceof Enemy)) return new Enemy();
  this.renderer = new EnemyRenderer(type, 1);
}


