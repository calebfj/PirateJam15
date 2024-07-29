extends Node3D

@onready var paper: Node3D = $"../../Paper"
@onready var game_manager = $"../GameManager"

const BOTTLE_TYPE_TO_FILE_PATH = {
	bottle_type.VIAL: "res://Assets/Sprites/FormulaSprites/Tube.PNG",
	bottle_type.FLASK: "res://Assets/Sprites/FormulaSprites/Flask.PNG",
	bottle_type.JUG: "res://Assets/Sprites/FormulaSprites/Sphere.PNG"
}

const SYMBOLS_TO_FILE_PATH = {
	"ARROW": "res://Assets/Sprites/FormulaSprites/Arrow.PNG",
	"PLUS": "res://Assets/Sprites/FormulaSprites/Plus.PNG"
}

const fluid_type = preload("res://Scripts/Utilities/PotionData.gd").FluidType
const bottle_type = preload("res://Scripts/Utilities/PotionData.gd").BottleType
const fluid_to_color = preload("res://Scripts/Utilities/PotionData.gd").POTION_TYPE_TO_COLOR

var CURRENT_POINTER_POSITION: Vector3

func _ready():
	game_manager.Recipe.connect(_do_display_recipe)
	CURRENT_POINTER_POSITION = paper.position + Vector3(-6.4, -1.3, 7.85)

func _do_display_recipe(potions: Array):
	for potion in potions:
		var ingredient_count = potion.ingredients.size()
		CURRENT_POINTER_POSITION.z = paper.position.z + 7.85  # Reset Z position for each potion

		for i in range(ingredient_count):
			var ingredient = potion.ingredients[i]
			output_potion_sprite(ingredient)  # Output the potion ingredient
			CURRENT_POINTER_POSITION.z -= 0.75
			
			# Check if this is not the last ingredient to output the plus symbol
			if i < ingredient_count - 1:
				output_symbol_sprite("PLUS")
				CURRENT_POINTER_POSITION.z -= 0.75
		# After all ingredients, output the arrow and the resulting potion
		output_symbol_sprite("ARROW")
		CURRENT_POINTER_POSITION.z -= 0.75  # Adjust for the resulting potion
		output_potion_sprite(potion)  # Assuming potion.result holds the resulting potion

		CURRENT_POINTER_POSITION.x += 1  # Move to the next column for the next potion

func output_potion_sprite(potion: Object):
	var sprite: Sprite3D = Sprite3D.new()
	var texture: Texture2D = load(get_potion_sprite_image(potion))  # Load the texture resource
	sprite.modulate = fluid_to_color[potion.fluid]
	sprite.texture = texture
	sprite.scale = Vector3(0.55, 0.55, 0.55)  # Set scale directly instead of multiplying
	sprite.position = CURRENT_POINTER_POSITION  # Position the sprite
	sprite.rotation_degrees = Vector3(-90, 90, 0)  # Set rotation in one line

	paper.add_child(sprite)  # Add the sprite to the paper node

func output_symbol_sprite(symbol: String):
	var sprite: Sprite3D = Sprite3D.new()
	var texture: Texture2D = load(get_symbol_sprite_image(symbol))  # Use the symbol argument
	sprite.texture = texture
	sprite.scale = Vector3(0.55, 0.55, 0.55)  # Set scale directly
	sprite.position = CURRENT_POINTER_POSITION  # Position the sprite
	sprite.rotation_degrees = Vector3(-90, 90, 0)  # Set rotation in one line

	paper.add_child(sprite)  # Add the sprite to the paper node

func get_symbol_sprite_image(symbol: String) -> String:
	return SYMBOLS_TO_FILE_PATH[symbol]

func get_potion_sprite_image(potion: Object) -> String:
	return BOTTLE_TYPE_TO_FILE_PATH[potion.bottle]