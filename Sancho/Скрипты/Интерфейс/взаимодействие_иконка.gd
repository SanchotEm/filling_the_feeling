extends Control
@onready var текст: Label = $"HBoxContainer/текст"
@onready var текстура: TextureRect = $"HBoxContainer/текстура"
# Called when the node enters the scene tree for the first time.
func установка(путь_до_картинки: String = "res://icon.svg", название : String = "ТЕСТ"):
	текст.text = название
	текстура.texture = load(путь_до_картинки)

