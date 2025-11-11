extends Sprite2D

# 定义精灵在纹理中的区域
@export var element_region: Rect2 = Rect2(0, 0, 100, 100)

func _ready():
	_initialize_region()
	_set_scale()

# 当在编辑器中更改属性时更新显示
func _validate_property(property):
	if property.name == "element_region":
		_initialize_region()

# 初始化区域设置
func _initialize_region():
	if texture:
		region_enabled = true
		region_rect = element_region
	else:
		push_warning("Element sprite is missing a texture!")

# 设置缩放比例
func _set_scale():
	scale = Vector2(0.5, 0.5)