extends Node

var HEADS = {
	"HeadKing": "res://assets/units/components/Head/HeadKing.png",
	"HeadPawn": "res://assets/units/components/Head/HeadPawn.png"
}

var BODIES = {
	"Body": "res://assets/units/components/Body.png"
}

var LEFT_ARM = {
	"LeftArm": "res://assets/units/components/LeftArm/LeftArm.png",
	"LeftHammer": "res://assets/units/components/LeftArm/LeftHammer.png"
}

var RIGHT_ARM = {
	"RightArm": "res://assets/units/components/RightArm/RightArm.png"
}

var PALETTS = {
	"red": {
		"new_main_color": Color("#b25455"),
		"new_shadow_color": Color("#653b59"),
		"new_light_color": Color("#b65555")
	},
	"blue": {
		"new_main_color": Color("#3e8698"),
		"new_shadow_color": Color("#404e75"),
		"new_light_color": Color("#5ab3ac")
	},
	"yellow": {
		"new_main_color": Color("#bbaf45"),
		"new_shadow_color": Color("#6c5847"),
		"new_light_color": Color("#dcdf71")
	},
	"purple": {
		"new_main_color": Color("#785397"),
		"new_shadow_color": Color("#313049"),
		"new_light_color": Color("#a8719a")
	}
}

var DEFAULT_PALETTE = {
	"old_main_color": Color("#3e8698"),
	"old_shadow_color": Color("#404e75"),
	"old_light_color": Color("#5ab3ac")
}

var UNTIS = {
	"king": {
		"sprites": {
			"Head": HEADS["HeadKing"],
			"LeftArm": LEFT_ARM["LeftArm"],
			"RightArm": RIGHT_ARM["RightArm"],
			"Body": BODIES["Body"]
		},
		"move_directions": [
			Vector2i.UP,
			Vector2i.DOWN,
			Vector2i.LEFT,
			Vector2i.RIGHT,
		],
		"attack_directions": [
			Vector2i.UP,
			Vector2i.DOWN,
			Vector2i.LEFT,
			Vector2i.RIGHT,
		]
	},
	"pawn": {
		"sprites": {
			"Head": HEADS["HeadPawn"],
			"LeftArm": LEFT_ARM["LeftHammer"],
			"RightArm": RIGHT_ARM["RightArm"],
			"Body": BODIES["Body"]
		},
		"move_directions": [
			Vector2i.UP,
			Vector2i.DOWN,
			Vector2i.LEFT,
			Vector2i.RIGHT,
		],
		"attack_directions": [
			Vector2i(-1, -1),
			Vector2i(-1, 1),
			Vector2i(1, -1),
			Vector2i(1, 1),
		]
	}
}
