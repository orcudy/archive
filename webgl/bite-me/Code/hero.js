Hero.prototype = Object.create(Character.prototype);
Hero.prototype.constructor = Hero;

function Hero(position, type){
  Character.prototype.constructor.call(this, position, type);
  if(!(this instanceof Hero)) return new Hero();
  this.renderer = new HeroRenderer("hero", 1);

}


