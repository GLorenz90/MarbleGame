extends Node3D
class_name Main

var mainCam: PhantomCamera3D;

func _init():
  Global.main = self;
# end _init

func _ready():
  mainCam = $PhantomCamera3D;
# end _ready
