extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var player: CharacterBody3D = $"../Player"
@onready var direction_pointer: MeshInstance3D = $DirectionPointer

func _on_sight_range_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		var speed: float = 0.01 # put wanted speed here
		look_at(player.global_position)
		self.position = lerp(self.position,player.global_position,speed)


func _on_sight_range_body_exited(body: Node3D) -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("Left", "Right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


