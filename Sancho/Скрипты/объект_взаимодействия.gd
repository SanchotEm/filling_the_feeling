class_name Объект_взаимодействия extends Node
@export_file("*svg", "*.jpg", "*.jpeg","*.png") var иконка = "res://icon.svg"
@export() var текст_объекта: String ="test"
func _ready():
	get_parent().set_meta("interact_script", self)
func взаимодействие(актор):
	print(актор)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
