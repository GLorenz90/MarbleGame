extends RigidBody3D

var vInput := 0.0;
var hInput := 0.0;
var cInput := 0.0;

var moveVector := Vector3(0.0,0.0,0.0);

const MOVE_FORCE := 8.0;
const MAX_SPEED := 3.0;
const CAM_MOVE_SPEED := 110.0;

func _process(delta):
  processInputs();
  moveCam(delta);
# end _process

func _physics_process(delta):
  $Body.global_rotation_degrees = Vector3(0, 0, 0);
  moveMarble(delta);
  updateHoleWalls();
# end _physics_process

func processInputs():
  vInput = Input.get_axis("move_forward", "move_backward");
  hInput = Input.get_axis("move_left", "move_right");
  cInput = -Input.get_axis("cam_left", "cam_right");
# end processInputs

func moveMarble(delta):
  if Global.main.mainCam != null && Global.main.mainCam._has_follow_spring_arm:
    moveVector = Vector3(hInput,0.0, vInput).rotated(Vector3.UP, Global.main.mainCam._follow_spring_arm.rotation.y);
  else:
    moveVector = Vector3(hInput,0.0, vInput);
  
  apply_force(moveVector * MOVE_FORCE);
  # TODO: needs grounded/slope check of some kind so we don't limit speed while falling and going down hills.
  if linear_velocity.length() > MAX_SPEED:
    linear_velocity = linear_velocity.limit_length(MAX_SPEED);
# end moveMarble

func moveCam(delta):
  if Global.main.mainCam != null && Global.main.mainCam._has_follow_spring_arm:
    Global.main.mainCam._follow_spring_arm.rotate_y(deg_to_rad(CAM_MOVE_SPEED * delta * cInput));


func _on_area_3d_body_entered(body):
  var target: PhysicsBody3D = body;
  target.set_collision_mask_value(1, false);
  pass # Replace with function body.


func _on_area_3d_body_exited(body):
  var target: PhysicsBody3D = body;
  target.set_collision_mask_value(1, true);
  pass # Replace with function body.


func _on_deleter_body_entered(body):
  body.queue_free();
  pass # Replace with function body.

func updateHoleWalls():
  var ray: RayCast3D;
  var box: StaticBody3D;
  for i in $Body/HoleWalls/Movable.get_children().size():
    ray = $Body/HoleWalls/Movable.get_child(i);
    box = ray.get_child(0);
    if ray.is_colliding():
      box.global_position = ray.get_collision_point();
    else:
      box.position = Vector3(0,-.1,0);
# end updateHoleWalls
