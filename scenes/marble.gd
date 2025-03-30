extends RigidBody3D

var vInput := 0.0;
var hInput := 0.0;
var cInput := 0.0;

var moveVector := Vector3(0.0,0.0,0.0);

const MOVE_FORCE := 8.0;
const MAX_SPEED := 3.0;
const CAM_MOVE_SPEED := 110.0;

var wallShapes: Array[ConvexPolygonShape3D];
var shapePoints: Array[Vector3];
var walls: Array[CollisionShape3D];
var rays: Array[RayCast3D];
var wallFullDepth := -1.0;
var rayDepthOffset := 0.01;

func _ready():
  walls = [
    $Body/HoleWalls/Movable/Walls/Wall1/CollisionShape3D,
    $Body/HoleWalls/Movable/Walls/Wall2/CollisionShape3D,
    $Body/HoleWalls/Movable/Walls/Wall3/CollisionShape3D,
    $Body/HoleWalls/Movable/Walls/Wall4/CollisionShape3D,
    $Body/HoleWalls/Movable/Walls/Wall5/CollisionShape3D,
    $Body/HoleWalls/Movable/Walls/Wall6/CollisionShape3D,
    $Body/HoleWalls/Movable/Walls/Wall7/CollisionShape3D,
    $Body/HoleWalls/Movable/Walls/Wall8/CollisionShape3D
  ];
  
  rays = [
    $Body/HoleWalls/Movable/Rays/RayCast3D1,
    $Body/HoleWalls/Movable/Rays/RayCast3D2,
    $Body/HoleWalls/Movable/Rays/RayCast3D3,
    $Body/HoleWalls/Movable/Rays/RayCast3D4,
    $Body/HoleWalls/Movable/Rays/RayCast3D5,
    $Body/HoleWalls/Movable/Rays/RayCast3D6,
    $Body/HoleWalls/Movable/Rays/RayCast3D7,
    $Body/HoleWalls/Movable/Rays/RayCast3D8,
    $Body/HoleWalls/Movable/Rays/RayCast3D9,
    $Body/HoleWalls/Movable/Rays/RayCast3D10,
    $Body/HoleWalls/Movable/Rays/RayCast3D11,
    $Body/HoleWalls/Movable/Rays/RayCast3D12,
    $Body/HoleWalls/Movable/Rays/RayCast3D13,
    $Body/HoleWalls/Movable/Rays/RayCast3D14,
    $Body/HoleWalls/Movable/Rays/RayCast3D15,
    $Body/HoleWalls/Movable/Rays/RayCast3D16
  ];

  shapePoints = [
    Vector3(rays[0].position.x, 0.0, rays[1].position.z),
    Vector3(rays[1].position.x, 0.0, rays[1].position.z),
    Vector3(rays[2].position.x, 0.0, rays[2].position.z),
    Vector3(rays[3].position.x, 0.0, rays[3].position.z),
    Vector3(rays[4].position.x, 0.0, rays[4].position.z),
    Vector3(rays[5].position.x, 0.0, rays[5].position.z),
    Vector3(rays[6].position.x, 0.0, rays[6].position.z),
    Vector3(rays[7].position.x, 0.0, rays[7].position.z),
    Vector3(rays[8].position.x, 0.0, rays[8].position.z),
    Vector3(rays[9].position.x, 0.0, rays[9].position.z),
    Vector3(rays[10].position.x, 0.0, rays[10].position.z),
    Vector3(rays[11].position.x, 0.0, rays[11].position.z),
    Vector3(rays[12].position.x, 0.0, rays[12].position.z),
    Vector3(rays[13].position.x, 0.0, rays[13].position.z),
    Vector3(rays[14].position.x, 0.0, rays[14].position.z),
    Vector3(rays[15].position.x, 0.0, rays[15].position.z),
    Vector3(rays[0].position.x, wallFullDepth, rays[1].position.z), # these do not change 
    Vector3(rays[1].position.x, wallFullDepth, rays[1].position.z), # these do not change 
    Vector3(rays[2].position.x, wallFullDepth, rays[2].position.z), # these do not change 
    Vector3(rays[3].position.x, wallFullDepth, rays[3].position.z), # these do not change 
    Vector3(rays[4].position.x, wallFullDepth, rays[4].position.z), # these do not change 
    Vector3(rays[5].position.x, wallFullDepth, rays[5].position.z), # these do not change 
    Vector3(rays[6].position.x, wallFullDepth, rays[6].position.z), # these do not change 
    Vector3(rays[7].position.x, wallFullDepth, rays[7].position.z), # these do not change 
    Vector3(rays[8].position.x, wallFullDepth, rays[8].position.z), # these do not change 
    Vector3(rays[9].position.x, wallFullDepth, rays[9].position.z), # these do not change 
    Vector3(rays[10].position.x, wallFullDepth, rays[10].position.z), # these do not change 
    Vector3(rays[11].position.x, wallFullDepth, rays[11].position.z), # these do not change 
    Vector3(rays[12].position.x, wallFullDepth, rays[12].position.z), # these do not change 
    Vector3(rays[13].position.x, wallFullDepth, rays[13].position.z), # these do not change 
    Vector3(rays[14].position.x, wallFullDepth, rays[14].position.z), # these do not change 
    Vector3(rays[15].position.x, wallFullDepth, rays[15].position.z), # these do not change 
  ];
  
  wallShapes = [
    ConvexPolygonShape3D.new(),
    ConvexPolygonShape3D.new(),
    ConvexPolygonShape3D.new(),
    ConvexPolygonShape3D.new(),
    ConvexPolygonShape3D.new(),
    ConvexPolygonShape3D.new(),
    ConvexPolygonShape3D.new(),
    ConvexPolygonShape3D.new()
  ];
  
  wallShapes[0].set_points([shapePoints[0], shapePoints[1], shapePoints[8], shapePoints[9],  shapePoints[16], shapePoints[17], shapePoints[24], shapePoints[25]]);
  wallShapes[1].set_points([shapePoints[1], shapePoints[2], shapePoints[9], shapePoints[10],  shapePoints[17], shapePoints[18], shapePoints[25], shapePoints[26]]);
  wallShapes[2].set_points([shapePoints[2], shapePoints[3], shapePoints[10], shapePoints[11],  shapePoints[18], shapePoints[19], shapePoints[26], shapePoints[27]]);
  wallShapes[3].set_points([shapePoints[3], shapePoints[4], shapePoints[11], shapePoints[12],  shapePoints[19], shapePoints[20], shapePoints[27], shapePoints[28]]);
  wallShapes[4].set_points([shapePoints[4], shapePoints[5], shapePoints[12], shapePoints[13],  shapePoints[20], shapePoints[21], shapePoints[28], shapePoints[29]]);
  wallShapes[5].set_points([shapePoints[5], shapePoints[6], shapePoints[13], shapePoints[14],  shapePoints[21], shapePoints[22], shapePoints[29], shapePoints[30]]);
  wallShapes[6].set_points([shapePoints[6], shapePoints[7], shapePoints[14], shapePoints[15],  shapePoints[22], shapePoints[23], shapePoints[30], shapePoints[31]]);
  wallShapes[7].set_points([shapePoints[7], shapePoints[0], shapePoints[15], shapePoints[8],  shapePoints[23], shapePoints[16], shapePoints[31], shapePoints[24]]);
  
  walls[0].shape = wallShapes[0];
  walls[1].shape = wallShapes[1];
  walls[2].shape = wallShapes[2];
  walls[3].shape = wallShapes[3];
  walls[4].shape = wallShapes[4];
  walls[5].shape = wallShapes[5];
  walls[6].shape = wallShapes[6];
  walls[7].shape = wallShapes[7];
# end _ready

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


func _on_area_3d_body_exited(body):
  var target: PhysicsBody3D = body;
  target.set_collision_mask_value(1, true);


func _on_deleter_body_entered(body):
  body.queue_free();

func updateHoleWalls():
  for i in rays.size():
    shapePoints[i].y = rays[i].get_collision_point().y - rays[i].global_position.y - rayDepthOffset if rays[i].is_colliding() else shapePoints[i].y;
  
  wallShapes[0].set_points([shapePoints[0], shapePoints[1], shapePoints[8], shapePoints[9],  shapePoints[16], shapePoints[17], shapePoints[24], shapePoints[25]]);
  wallShapes[1].set_points([shapePoints[1], shapePoints[2], shapePoints[9], shapePoints[10],  shapePoints[17], shapePoints[18], shapePoints[25], shapePoints[26]]);
  wallShapes[2].set_points([shapePoints[2], shapePoints[3], shapePoints[10], shapePoints[11],  shapePoints[18], shapePoints[19], shapePoints[26], shapePoints[27]]);
  wallShapes[3].set_points([shapePoints[3], shapePoints[4], shapePoints[11], shapePoints[12],  shapePoints[19], shapePoints[20], shapePoints[27], shapePoints[28]]);
  wallShapes[4].set_points([shapePoints[4], shapePoints[5], shapePoints[12], shapePoints[13],  shapePoints[20], shapePoints[21], shapePoints[28], shapePoints[29]]);
  wallShapes[5].set_points([shapePoints[5], shapePoints[6], shapePoints[13], shapePoints[14],  shapePoints[21], shapePoints[22], shapePoints[29], shapePoints[30]]);
  wallShapes[6].set_points([shapePoints[6], shapePoints[7], shapePoints[14], shapePoints[15],  shapePoints[22], shapePoints[23], shapePoints[30], shapePoints[31]]);
  wallShapes[7].set_points([shapePoints[7], shapePoints[0], shapePoints[15], shapePoints[8],  shapePoints[23], shapePoints[16], shapePoints[31], shapePoints[24]]);
# end updateHoleWalls
