extends Node3D

var объекты_для_взаимодействия : Dictionary
@onready var игрок = get_parent()

func вход_в_радиус(body):
	if body.has_meta("interactable"):
		добавить_объект_взаимодействия(body)
		
			
	pass # Replace with function body.

func выход_из_радиуса(body):
	if body.has_meta("interactable"):
		удалить_объект_взаимодействия(body)
	pass # Replace with function body.

func получение_списка_объектов() -> Array[String]:
	var имена : Array[String]
	for объект in объекты_для_взаимодействия :
		имена.append(объект.name)
	return имена

func взаимодействие():
	if объекты_для_взаимодействия.size() > 0:
		var претендент_взаимодействие
		for объект in объекты_для_взаимодействия:
			if !претендент_взаимодействие:
				претендент_взаимодействие = объект
			else :
				if Vector3(объект.position-игрок.position).length() < Vector3(претендент_взаимодействие.position-игрок.position).length():
					претендент_взаимодействие = объект
				
		print(претендент_взаимодействие)
#body.get_meta("interact_script").взаимодействие(игрок)
func добавить_объект_взаимодействия(объект: Node3D):
	var новый_объект = Button.new()
	игрок.find_child("контейнер_взаимодействия").add_child(новый_объект)
	новый_объект.theme = load("res://Прочее/общая_тема.tres")
	новый_объект.text = объект.get_meta("interact_script").текст_объекта
	новый_объект.icon = load(объект.get_meta("interact_script").иконка)
	объекты_для_взаимодействия[объект] = новый_объект
	pass
func удалить_объект_взаимодействия(объект):
	объекты_для_взаимодействия[объект].queue_free()
	объекты_для_взаимодействия.erase(объект)
	
	pass
