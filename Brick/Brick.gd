extends StaticBody2D

var score = 0
var new_position = Vector2.ZERO
var dying = false
export var time_appear = 0.5
export var time_fall = 0.8
export var time_rotate = 1.0
export var time_a = 0.8
export var time_s = 1.2
export var time_v = 1.5
var duration_seconds = 0.5


var powerup_prob = 0.1


func _ready():
	position.x = new_position.x
	position.y = -100
	$Tween.interpolate_property(self, "position", position, new_position, 0.5 + randf()*2, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
	$Tween.start()
	if score >= 100:
		$TextureRect.texture = load("res://Assets/tileRed_02.png")
	elif score >= 90:
		$TextureRect.texture = load("res://Assets/tileOrange_01.png")
	elif score >= 80:
		$TextureRect.texture = load("res://Assets/tileYellow_02.png")
	elif score >= 70:
		$TextureRect.texture = load("res://Assets/tileGreen_02.png")
	elif score >= 60:
		$TextureRect.texture = load("res://Assets/tileBlue_02.png")
	elif score >= 50:
		$TextureRect.texture = load("res://Assets/tilePink_02.png")
	elif score >= 40:
		$TextureRect.texture = load("res://Assets/tileBlack_02.png")
	else:
		$TextureRect.texture = load("res://Assets/tileGrey_02.png")	

func _physics_process(_delta):
	if dying and not $Confetti.emitting and not $Tween.is_active():
		queue_free()

func hit(_ball):
	var brick_sound = get_node_or_null("/root/Game/Brick_Sound")
	if brick_sound != null:
		brick_sound.play()
	die()

func die():
	$Confetti.emitting = true
	dying = true
	collision_layer = 0
	Global.update_score(score)
	if not Global.feverish:
		Global.update_fever(score)
	get_parent().check_level()
	if randf() < powerup_prob:
		var Powerup_Container = get_node_or_null("/root/Game/Powerup_Container")
		if Powerup_Container != null:
			var Powerup = load("res://Powerups/Powerup.tscn")
			var powerup = Powerup.instance()
			powerup.position = position
			Powerup_Container.call_deferred("add_child", powerup)
	$Tween.interpolate_property(self, "position", position, Vector2(position.x, 1000), time_fall, Tween.TRANS_EXPO, Tween.EASE_IN)
	$Tween.interpolate_property(self, "rotation", rotation, -PI + randf()*2*PI, time_rotate, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property(self, "modulate", Color.white, Color.transparent, duration_seconds)
	$Tween.interpolate_property(self, "modulate", Color.white, Color.transparent, duration_seconds)
	$Tween.interpolate_property(self, "modulate", Color.white, Color.transparent, duration_seconds)
	$Tween.start()
