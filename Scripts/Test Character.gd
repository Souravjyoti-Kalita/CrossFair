extends CharacterBody2D

#platformer variable
@export var jump_height = 20.0
@export var jump_time_to_peak = 1.0
@export var jump_time_to_decend = 0.5
@export var max_jumps: int = 1
@export var hp = 20

@export var speed = 70

#programme variable calculation
@onready var jump_speed = (2.0*jump_height)/jump_time_to_peak
@onready var jump_gravity = (2.0*jump_height)/(jump_time_to_peak * jump_time_to_peak)
@onready var fall_gravity = (2.0*jump_height)/(jump_time_to_decend * jump_time_to_peak)
@onready var coyote_timer = $CoyoteTimer
@onready var jump_buffer = $JumpBuffer
@onready var jump_count:int = 0

func _physics_process(delta):
	# Add gravity every frame
	velocity.y += get_gravity() * delta

	# Input affects x axis only
	
	velocity.x = Input.get_axis("ui_left", "ui_right") * speed
	
	
	#jump count reset
	if is_on_floor():
		jump_count=0
	
	# Only allow jumping when on the ground
	if Input.is_action_just_pressed("jump"):
		if !coyote_timer.is_stopped():
			velocity.y = -jump_speed
		elif jump_count < max_jumps:
			velocity.y = -jump_speed
			jump_count +=1
		else:
			jump_buffer.start()	
	var was_on_floor = is_on_floor()
	move_and_slide()
	if was_on_floor && !is_on_floor():
		coyote_timer.start()
		print("Timer Start")
	
	if !jump_buffer.is_stopped() and is_on_floor():
		velocity.y = -jump_speed

func get_gravity():
	return jump_gravity if velocity.y < 0.0 else fall_gravity
