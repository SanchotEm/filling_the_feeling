extends CharacterBody3D



const УСКОРЕНИЕ_ПРЫЖКА = 6
const ГРАВИТАЦИЯ = 18

@export_category("Настройки игрока")
@export_range(0, 1, 0.01) var чувствительность = .5
@export_range(1.0,10.0,0.01,"hide_slider") var СКОРОСТЬ: float 
@export_group("Настройки камер")
@export() var переключение_камеры: bool
@export_subgroup("1-ое лицо")
@export_range(0,110,1, "radians_as_degrees") var FOV = 110
@export_subgroup("3-ье лицо")
@export_range(0,110,1, "radians_as_degrees") var FOV_обычный = 70
@export_range(0,110,1, "radians_as_degrees") var FOV_движение = 70
@export_range(0, 7, 0.01) var расстояние_до_камеры: float = 5

var есть_ввод_перемещения = false

func ввод_управления():
	
	var ввод_направления = Input.get_vector("влево","вправо","назад","вперёд")
	
	var направление = (transform.basis * Vector3(ввод_направления.x, 0, -ввод_направления.y)).normalized()
	if направление:
		сведение_игрока_к_камере()
		velocity.x = направление.x * СКОРОСТЬ
		velocity.z = направление.z * СКОРОСТЬ
		$"голова/SpringArm3D".spring_length = lerpf($"голова/SpringArm3D".spring_length, расстояние_до_камеры+1, 0.1)
		$"голова/SpringArm3D/камера3лицо".fov = lerpf($"голова/SpringArm3D/камера3лицо".fov, FOV_движение, 0.1)
		есть_ввод_перемещения = true
		поворот_тела(ввод_направления)
	else :
		velocity.x = move_toward(velocity.x, 0, СКОРОСТЬ)
		velocity.z = move_toward(velocity.z, 0, СКОРОСТЬ)
		$"голова/SpringArm3D".spring_length = lerpf($"голова/SpringArm3D".spring_length, расстояние_до_камеры, 0.1)
		$"голова/SpringArm3D/камера3лицо".fov = lerpf($"голова/SpringArm3D/камера3лицо".fov, FOV_обычный, 0.1)
		есть_ввод_перемещения = false
	
	move_and_slide()
# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= ГРАВИТАЦИЯ * delta
	if Input.is_action_pressed("Прыжок") and is_on_floor():
		velocity.y = УСКОРЕНИЕ_ПРЫЖКА
	ввод_управления()
	pass

func _input(event):
	if event.is_action_pressed("Взаимодействие"):
		$"модуль_взаимодействия".взаимодействие()
	if event is InputEventMouseMotion:
		var поворот
		
		if есть_ввод_перемещения:
			
			поворот = Vector2(%"голова".rotation_degrees.x,rotation_degrees.y)
			поворот += -Vector2(event.relative.y,event.relative.x) * чувствительность
			поворот = Vector2(clamp(поворот.x, -80, 80), поворот.y)
			rotation_degrees.y = поворот.y
		else:
			поворот = Vector2(%"голова".rotation_degrees.x,%"голова".rotation_degrees.y)
			поворот += -Vector2(event.relative.y,event.relative.x) * чувствительность
			поворот = Vector2(clamp(поворот.x, -80, 80), поворот.y)
			%"голова".rotation_degrees.y = поворот.y
		%"голова".rotation_degrees.x = поворот.x
		
func сведение_игрока_к_камере():
	if %"голова".rotation.y != 0:
				rotation.y = rotate_toward(rotation.y,%"голова".global_rotation.y, move_toward(.5,.1,.25))
				%"голова".rotation.y = rotate_toward(%"голова".rotation.y, 0, move_toward(.5,.1,.25))
func поворот_тела(вектор: Vector2):
	%"тело".rotation.y = rotate_toward(%"тело".rotation.y, atan2(вектор.y, вектор.x)- PI/2,.1)
	pass
