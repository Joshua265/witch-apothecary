class_name CharacterData

var name: String
var age: int
var occupation: String
var image_path: String
var sitting_sprite: String

func _init(
  _name: String = "",
  _age: int = 0,
  _occupation: String = "",
  _image_path: String = "",
  _sitting_sprite: String = ""
):
  self.name = _name
  self.age = _age
  self.occupation = _occupation
  self.image_path = _image_path
  self.sitting_sprite = _sitting_sprite

static var characters: Dictionary[String, CharacterData] = {
  "Helena": CharacterData.new(
	"Helena",
	29,
	"Seamstress",
	"res://sprites/characters/seamstress.png",
		"res://sprites/characters/seamstress_sitting.png",
  ),
  "Husband": CharacterData.new(
	"Husband",
	32,
	"Carpenter",
	"res://sprites/characters/husband.png",
	"res://sprites/characters/husband_sitting.png",
  ),
}
