extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -350.0
const JUMP_FLOAT_TIME = 0.1
static var last_on_floor_timer := 0.0
static var mails_collected := 0
static var win := false

func _ready():
	$Camera2D.zoom = Vector2(3, 3)

func check_mail():
	var mails = get_node("../mail:")
	var tile_pos = mails.local_to_map(mails.to_local(global_position))
	if mails.get_cell_source_id(tile_pos) != -1 && !win:
		mails.erase_cell(tile_pos)
		mails_collected += 1
		%Label.text = "Mail collected: " + str(mails_collected)

func check_mailbox():
	var mailbox = get_node("../mailbox:")
	var tile_pos = mailbox.local_to_map(mailbox.to_local(global_position))
	if mailbox.get_cell_source_id(tile_pos) != -1 && !win:
		%Label.hide()
		%win.text = "You have delivered your night mail!\nTotal mail delivered: " + str(mails_collected) + "/40"
		%win.show()
		win = true

func _process(_delta):
	if (get_viewport().get_visible_rect().size.x <= 854 || get_viewport().get_visible_rect().size.y <= 480):
		$Camera2D.zoom = Vector2(1, 1)
	elif (get_viewport().get_visible_rect().size.x <= 1280 || get_viewport().get_visible_rect().size.y <= 720):
		$Camera2D.zoom = Vector2(2, 2)
	elif (get_viewport().get_visible_rect().size.x <= 2560 || get_viewport().get_visible_rect().size.y <= 1440):
		$Camera2D.zoom = Vector2(3, 3)
	else:
		$Camera2D.zoom = Vector2(4, 4)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if is_on_floor():
		last_on_floor_timer = JUMP_FLOAT_TIME
	else:
		last_on_floor_timer -= delta
		velocity += get_gravity() * delta
	# Handle jump.
	if Input.is_action_just_pressed("jump") and last_on_floor_timer > 0:
		velocity.y = JUMP_VELOCITY
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
	check_mail()
	check_mailbox()
