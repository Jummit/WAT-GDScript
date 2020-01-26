const CALLED_WITH_ARGUMENTS = preload("res://addons/WAT/assertions/called_with_arguments.gd")
const DOES_NOT_HAVE = preload("res://addons/WAT/assertions/does_not_have.gd")
const FILE_DOES_NOT_EXIST = preload("res://addons/WAT/assertions/file_does_not_exist.gd")
const FILE_EXISTS = preload("res://addons/WAT/assertions/file_exists.gd")
const HAS = preload("res://addons/WAT/assertions/has.gd")
const IS_BUILT_IN_TYPE = preload("res://addons/WAT/assertions/is_built_in_type.gd")
const IS_CLASS_INSTANCE = preload("res://addons/WAT/assertions/is_class_instance.gd")
const IS_EQUAL = preload("res://addons/WAT/assertions/is_equal.gd")
const IS_EQUAL_OR_GREATER_THAN = preload("res://addons/WAT/assertions/is_equal_or_greater_than.gd")
const IS_EQUAL_OR_LESS_THAN = preload("res://addons/WAT/assertions/is_equal_or_less_than.gd")
const IS_FALSE = preload("res://addons/WAT/assertions/is_false.gd")
const IS_FREED = preload("res://addons/WAT/assertions/is_freed.gd")
const IS_GREATER_THAN = preload("res://addons/WAT/assertions/is_greater_than.gd")
const IS_IN_RANGE = preload("res://addons/WAT/assertions/is_in_range.gd")
const IS_LESS_THAN = preload("res://addons/WAT/assertions/is_less_than.gd")
const IS_NOT_BUILT_IN_TYPE = preload("res://addons/WAT/assertions/is_not_built_in_type.gd")
const IS_NOT_CLASS_INSTANCE = preload("res://addons/WAT/assertions/is_not_class_instance.gd")
const IS_NOT_EQUAL = preload("res://addons/WAT/assertions/is_not_equal.gd")
const IS_NOT_FREED = preload("res://addons/WAT/assertions/is_not_freed.gd")
const IS_NOT_IN_RANGE = preload("res://addons/WAT/assertions/is_not_in_range.gd")
const IS_NOT_NULL = preload("res://addons/WAT/assertions/is_not_null.gd")
const IS_NULL = preload("res://addons/WAT/assertions/is_null.gd")
const IS_TRUE = preload("res://addons/WAT/assertions/is_true.gd")
const SCENE_WAS_CALLED = preload("res://addons/WAT/assertions/scene_was_called.gd")
const SCENE_WAS_NOT_CALLED = preload("res://addons/WAT/assertions/scene_was_not_called.gd")
const SCRIPT_WAS_CALLED = preload("res://addons/WAT/assertions/script_was_called.gd")
const SCRIPT_WAS_NOT_CALLED = preload("res://addons/WAT/assertions/script_was_not_called.gd")
const SIGNAL_WAS_EMITTED = preload("res://addons/WAT/assertions/signal_was_emitted.gd")
const SIGNAL_WAS_EMITTED_WITH_ARGUMENTS = preload("res://addons/WAT/assertions/signal_was_emitted_with_arguments.gd")
const SIGNAL_WAS_NOT_EMITTED = preload("res://addons/WAT/assertions/signal_was_not_emitted.gd")
const STRING_BEGINS_WITH = preload("res://addons/WAT/assertions/string_begins_with.gd")
const STRING_CONTAINS = preload("res://addons/WAT/assertions/string_contains.gd")
const STRING_DOES_NOT_BEGIN_WITH = preload("res://addons/WAT/assertions/string_does_not_begin_with.gd")
const STRING_DOES_NOT_CONTAIN = preload("res://addons/WAT/assertions/string_does_not_contain.gd")
const STRING_DOES_NOT_END_WITH = preload("res://addons/WAT/assertions/string_does_not_end_with.gd")
const STRING_ENDS_WITH = preload("res://addons/WAT/assertions/string_ends_with.gd")
const IS_BOOL = preload("res://addons/WAT/assertions/is_bool.gd")
const IS_NOT_BOOL = preload("res://addons/WAT/assertions/is_not_bool.gd")
const IS_INT = preload("res://addons/WAT/assertions/is_int.gd")
const IS_NOT_INT = preload("res://addons/WAT/assertions/is_not_int.gd")
const IS_FLOAT = preload("res://addons/WAT/assertions/is_float.gd")
const IS_NOT_FLOAT = preload("res://addons/WAT/assertions/is_not_float.gd")
const IS_STRING = preload("res://addons/WAT/assertions/is_String.gd")
const IS_NOT_STRING = preload("res://addons/WAT/assertions/is_not_String.gd")
const IS_VECTOR2 = preload("res://addons/WAT/assertions/is_Vector2.gd")
const IS_NOT_VECTOR2 = preload("res://addons/WAT/assertions/is_not_Vector2.gd")
const IS_RECT2 = preload("res://addons/WAT/assertions/is_Rect2.gd")
const IS_NOT_RECT2 = preload("res://addons/WAT/assertions/is_not_Rect2.gd")
const IS_VECTOR3 = preload("res://addons/WAT/assertions/is_Vector3.gd")
const IS_NOT_VECTOR3 = preload("res://addons/WAT/assertions/is_not_Vector3.gd")
const IS_TRANSFORM2D = preload("res://addons/WAT/assertions/is_Transform2D.gd")
const IS_NOT_TRANSFORM2D = preload("res://addons/WAT/assertions/is_not_Transform2D.gd")
const IS_PLANE = preload("res://addons/WAT/assertions/is_Plane.gd")
const IS_NOT_PLANE = preload("res://addons/WAT/assertions/is_not_Plane.gd")
const IS_QUAT = preload("res://addons/WAT/assertions/is_Quat.gd")
const IS_NOT_QUAT = preload("res://addons/WAT/assertions/is_not_Quat.gd")
const IS_AABB = preload("res://addons/WAT/assertions/is_AABB.gd")
const IS_NOT_AABB = preload("res://addons/WAT/assertions/is_not_AABB.gd")
const IS_BASIS = preload("res://addons/WAT/assertions/is_Basis.gd")
const IS_NOT_BASIS = preload("res://addons/WAT/assertions/is_not_Basis.gd")
const IS_TRANSFORM = preload("res://addons/WAT/assertions/is_Transform.gd")
const IS_NOT_TRANSFORM = preload("res://addons/WAT/assertions/is_not_Transform.gd")
const IS_COLOR = preload("res://addons/WAT/assertions/is_Color.gd")
const IS_NOT_COLOR = preload("res://addons/WAT/assertions/is_not_Color.gd")
const IS_NODEPATH = preload("res://addons/WAT/assertions/is_NodePath.gd")
const IS_NOT_NODEPATH = preload("res://addons/WAT/assertions/is_not_NodePath.gd")
const IS_RID = preload("res://addons/WAT/assertions/is_RID.gd")
const IS_NOT_RID = preload("res://addons/WAT/assertions/is_not_RID.gd")
const IS_OBJECT = preload("res://addons/WAT/assertions/is_Object.gd")
const IS_NOT_OBJECT = preload("res://addons/WAT/assertions/is_not_Object.gd")
const IS_DICTIONARY = preload("res://addons/WAT/assertions/is_Dictionary.gd")
const IS_NOT_DICTIONARY = preload("res://addons/WAT/assertions/is_not_Dictionary.gd")
const IS_ARRAY = preload("res://addons/WAT/assertions/is_Array.gd")
const IS_NOT_ARRAY = preload("res://addons/WAT/assertions/is_not_Array.gd")
const IS_POOLBYTEARRAY = preload("res://addons/WAT/assertions/is_PoolByteArray.gd")
const IS_NOT_POOLBYTEARRAY = preload("res://addons/WAT/assertions/is_not_PoolByteArray.gd")
const IS_POOLINTARRAY = preload("res://addons/WAT/assertions/is_PoolIntArray.gd")
const IS_NOT_POOLINTARRAY = preload("res://addons/WAT/assertions/is_not_PoolIntArray.gd")
const IS_POOLREALARRAY = preload("res://addons/WAT/assertions/is_PoolRealArray.gd")
const IS_NOT_POOLREALARRAY = preload("res://addons/WAT/assertions/is_not_PoolRealArray.gd")
const IS_POOLSTRINGARRAY = preload("res://addons/WAT/assertions/is_PoolStringArray.gd")
const IS_NOT_POOLSTRINGARRAY = preload("res://addons/WAT/assertions/is_not_PoolStringArray.gd")
const IS_POOLVECTOR2ARRAY = preload("res://addons/WAT/assertions/is_PoolVector2Array.gd")
const IS_NOT_POOLVECTOR2ARRAY = preload("res://addons/WAT/assertions/is_not_PoolVector2Array.gd")
const IS_POOLVECTOR3ARRAY = preload("res://addons/WAT/assertions/is_PoolVector3Array.gd")
const IS_NOT_POOLVECTOR3ARRAY = preload("res://addons/WAT/assertions/is_not_PoolVector3Array.gd")
const IS_POOLCOLORARRAY = preload("res://addons/WAT/assertions/is_PoolColorArray.gd")
const IS_NOT_POOLCOLORARRAY = preload("res://addons/WAT/assertions/is_not_PoolColorArray.gd")
