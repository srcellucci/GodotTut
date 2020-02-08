extends Node2D

export (PackedScene) var Mob
var score

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()

func new_game():
	score = 0
	$HUD.update_score(score)
	$Player.start($StartPosition.position)
	$HUD.show_message("Get ready!")
	$StartTimer.start()

#Delay game start breifly.
func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

#Increment player score as time goes by.
func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)

#Spawn a new mob every time the interval passes.
func _on_MobTimer_timeout():
	#Pick a random location along the path.
	$MobPath/MobSpawnLocation.set_offset(randi())
	#Instance mob.
	var mob = Mob.instance()
	add_child(mob)
	#set direction perpendicular tot he path (facing inwards).
	var direction = $MobPath/MobSpawnLocation.rotation + PI / 2
	# Set the mob's position to a random location.
	mob.position = $MobPath/MobSpawnLocation.position
	# Add some randomness to the direction.
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction
	# Set the velocity (speed & direction).
	mob.linear_velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0)
	mob.linear_velocity = mob.linear_velocity.rotated(direction)
