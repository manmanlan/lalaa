extends Camera2D
	

func _process(delta: float) -> void:
	Global.left
	if Global.left==1:
		limit_left-=783
		limit_right-=785
		Global.left=0
	if Global.right==1:
		limit_left+=785
		limit_right+=785
		Global.right=0
	if Global.down==1:
		limit_top+=465
		limit_bottom+=465
		Global.down=0
	if Global.up==1:
		limit_top-=465
		limit_bottom-=465
		Global.up=0
