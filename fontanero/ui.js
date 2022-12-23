/** @const */ var CELL_VOID = 0;
/** @const */ var CELL_FLOOR = 1;
/** @const */ var CELL_WALL = 2;
/** @const */ var CELL_ENTRANCE = 3;
/** @const */ var CELL_EXIT = 4;

/** @const */ var PICKABLE = 1;
/** @const */ var EDIBLE = 2;
/** @const */ var READABLE = 4;
/** @const */ var DRINKABLE = 8;
/** @const */ var WEARABLE = 16;
/** @const */ var FIXABLE = 32;

function in_range(x, a, b) {
	return x >= a && x < b;
}

this.map = null;
this.logText = null;
this.overlayPanel = null;
this.cellsModel = null;
this.winPanel = null;
this.hintPanel = null;
this.throwingObject = null;

this.sound = function(name) {}

this.log = function(text) {
	this.logText.text = (this.logText.text + text + "\n").split("\n").slice(-8).join("\n")
}

var actions = null;
var objects = null;
var combine = false;
var first_object = null;
var throw_obj = false;

this.run_mini_game = function(size, level_cap) {
	console.log("run_mini_game", size, level_cap);
	this.minigame.size = size;
	this.minigame.bonus = Math.floor(level_cap * (1 + Math.random()) * 1);
	this.minigame.start();
}

this.animate_throw = function(x, y, obj, actor, message) {
	var c = this.map.hero.cell, dx = x - c.x, dy = y - c.y;
	var distance = Math.max(Math.abs(dx), Math.abs(dy));
	var map = this.map;

	throwingObject.x = x * 32;
	throwingObject.y = y * 32;
	throwingObject.visible = true;

	var ui = this;
	var finalize = function() {
		throwingObject.visible = false;
		ui.log(message);
		if (obj) {
			obj.type |= PICKABLE;
			map.insert_object(obj, x, y);
		}
		if (actor) {
			map.hero.attack(actor, true);
		}
		map.tick();
	}
	throwingObjectTimer.finalize = finalize;
}.bind(this);


var gettile = function(cell) {
	if (!cell.visited)
		return -1;
	var actor = cell.actor;
	var hero = this.map.hero;
	var blinded = hero.blinded > 0;

	if (actor == hero)
		return 4;

	if (actor != null) {
		if (blinded)
			return 24;

		if (actor.boss)
			return 22;

		var name = actor.name;
		var tiles = {
			'wasp': 9, 
			'spider': 14, 
			'rat': 15,
			'bat': 16, 
			'snake': 17, 
			'poisonous bat': 16, 
			'vampire bat': 16, 
			'poisonous snake': 17,
			'rabid mole': 18,
			'mutant': 19,
			'zombie': 20,
			'ghost': 21
		}
		var tile = tiles[name];
		return tile? tile: 24;
	}
	
	var objs = cell.objects;
	var n = objs.length;
	if (n) {
		if (blinded)
			return 24;

		var mask = 0;
		for(var i = 0; i < n; ++i) {
			mask |= (objs[i].type & ~PICKABLE);
		}
		if (n == 1 || (mask & (mask - 1)) == 0) {
			var o = objs[0];
			var type = o.type;
			if (o.name.indexOf("pipes") >= 0)
				return (type&FIXABLE)? 12: 13;
			if (type & DRINKABLE)
				return 11;
			if (type & EDIBLE)
				return 7;
			if (type & READABLE)
				return 8;
			
			switch(o.name) {
			case "gold":
				return 6; 
			case "key":
				return 10;
			}
		}
		return 5;
	}
	switch(cell.type) {
	case CELL_FLOOR:
		return cell.blood? 23: 0;
	case CELL_ENTRANCE:
		return 2;
	case CELL_EXIT:
		return 3;
	case CELL_WALL:
		return 1;
	default:
		return -1;
	}
}.bind(this);

var menu = function() {
	menuPanel.text = "";
	if (objects) {
		console.log(objects);
		for(var i = 0; i < objects.length; ++i) {
			var object = objects[i][0];
			menuPanel.text += "[" + (i + 1) + "] " + object.name + "\n";
		}
	} else {
		actions.forEach(function(action) {
			var name = action.name.replace("<em>", "[").replace("</em>", "]");
			menuPanel.text += "[" + action.key + "] " + name + "\n";
		});
	}
}.bind(this);

var panel = function() {
	if (this.map == null)
		return;
	var hero = this.map.hero, level = hero.level;

	var text = hero.name + " the Fontanero; Level: " + hero.level + " (" + hero.levels[level-1] + ") ";
	text += "HP: " + hero.hp + " (" + hero.max_hp() +  ")" + 
	(hero.poisoned? " [POISONED] ":"") + 
	(hero.blinded? " [BLINDED]":"") + 
	(hero.confused? " [CONFUSED]":"") + "\n" + 
	"Cash: $" + hero.cash + " / " + hero.level_cap() +" " + 
	"Pipes found: " + this.map.pipes + " Pipes fixed: " + this.map.fixed;
	text += "\n"
	this.hintPanel.visible = false;
	if (throw_obj) {
		this.hintPanel.text = 'Choose direction: Press up, down, left or right to throw ' + first_object.name;
		this.hintPanel.visible = true;
		overlayPanel.text = text;
		menu();
		return;
	} else if (objects) {
		overlayPanel.text = text;
		menu();
		return;
	} else {
		text += 'You are carrying: ' + hero.inv;
	}
	text += "\n"

	actions = hero.get_actions(); //MUST BE CALLED FIRST (do auto-pickup and other stuff)
	var objs = hero.cell.objects;
	var mask = 0;
	text += 'You see: ';
	if (objs.length) {
		for(var i = 0; i < objs.length; ++i) {
			var o = objs[i];
			mask |= o.type;
			text += (i? ', ': '') + o.name;
		}
	}
	else {
		text += 'nothing'
	}
	overlayPanel.text = text;

	menu();

}.bind(this);

this.panel = panel;

function on_key(key) {
	var h = this.map.hero;
	if (h.hp <= 0)
		return;

	var used = false, call_tick = true;

	switch(key) {
	case "escape":
		used = true;
		combine = false;
		throw_obj = false;
		first_object = null;
		break;
	case "left":
	case "right":
	case "up":
	case "down":
		var dx = 0, dy = 0;
		if (key == "left")
			dx = -1;
		else if (key == "right")
			dx = 1;
		else if (key == "up")
			dy = -1;
		else if (key == "down")
			dy = 1;

		if (h.confused > 0) {
			dx = -dx;
			dy = -dy;
		}
		if (throw_obj) {
			h.throw_obj(first_object, dx, dy);
			call_tick = false;
		} else
		{
			h.move(dx, dy);
			throwingObject.x = h.cell.x * 32;
			throwingObject.y = h.cell.y * 32;
		}
		used = true;
		throw_obj = false;
		first_object = null;
		objects = null;
		break;
	default:
		if (key.length != 1)
			break;
		var key_char = key.charAt(0);

		if (objects != null) {
			var i = key.charCodeAt(0) - 0x31; //ord('1');
			if (in_range(i, 0, objects.length)) {
				var o = objects[i];
				var a = o[1], obj = o[0];
				if (combine && first_object == null) {
					first_object = obj;
					objects = h.get_objects(a, DRINKABLE);
					call_tick = false;
					used = true;
					break;
				}
				if (a.need_dir) {
					first_object = obj;
					throw_obj = true;
					call_tick = false;
					used = true;
					break;
				}
				a.apply(obj, first_object);
			} 
			used = true;
			objects = null;
		} else if (actions != null) {
			for(var i = 0; i < actions.length; ++i) {
				var a = actions[i];
				if (a.key == key_char) {
					objects = h.get_objects(a);
					combine = a.combine;
					first_object = null;
					switch(objects.length) {
					case 0:
						a.apply(); //auto-action w/o object (like (s)leep)
						objects = null;
						break;
					case 1:
						var obj = objects[0][0];
						if (combine) { //choose even one object
							call_tick = false;
							break;
						}
						if (a.need_dir) {
							first_object = obj;
							throw_obj = true;
							call_tick = false;
							break;
						}
						a.apply(obj);
						objects = null;
						break;
					default:
						call_tick = false;
					}
					actions = null;
					used = true;
					break;
				}
			}
		}
	}
	if (used) {
		if (call_tick)
		{
			this.map.tick();
		}
		panel();
	}
}
this.on_key = on_key;

this.repaint = function(cell)
{
	var map = this.map;
	var idx = cell.y * map.width + cell.x;
	this.cellsModel.setProperty(idx, 'tile', gettile(cell));
}.bind(this);

this.repaint_all = function() {
	this.cellsModel.reset();
	var map = this.map;
	for(var y = 0; y < this.map.height; ++y)
		for(var x = 0; x < this.map.width; ++x) {
			this.cellsModel.append( { 'tile': gettile(map.cells[y][x]) })
		}
}.bind(this);

this.win = function() {
	var hero = this.map.hero;
	var text = hero.dead? "YOU WON!": "PURE WIN!!111";
	text += "\n\nGot $" + hero.cash + "\nBeing dead " + hero.dead + " times.\n\nProgrammed by:\nVladimir Menshakov\n&\nVladimir Zhuravlev\n\n©2010-2013"
	this.winPanel.text = text;
	this.winPanel.visible = true;
	this.winPanel.setFocus();
}.bind(this);

this.intro = function() {
	this.log("You've entered the <s>dungeon</s> cellar to fix all broken pipes and vents.");
}

