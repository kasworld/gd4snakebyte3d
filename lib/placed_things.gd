class_name PlacedThings

var data :Array[Array] # [y][x]node
var count :int

func _to_string() -> String:
	var rtn := ""
	for y in data:
		for x in y:
			rtn += "%s" % x
		rtn += "\n"
	return rtn

func _init( size :Vector2i) -> void:
	init(size)

func init(size :Vector2i) -> PlacedThings:
	data.clear()
	count = 0
	data.resize(size.y)
	for y in data:
		y.resize(size.x)
	return self

func get_width() -> int:
	return data[0].size()

func get_height() -> int:
	return data.size()

# include x2
func draw_hline(x1 :int, x2 :int, y :int , v) -> Dictionary:
	if x1 > x2 :
		var t = x1
		x1 = x2
		x2 = t
	var rtn := {}
	for x in range(x1,x2+1):
		var pos := Vector2i(x,y)
		var old = set_at(pos, v)
		if old != null:
			rtn[pos] = old
	return rtn

# include y2
func draw_vline(x :int, y1 :int, y2 :int , v) -> Dictionary:
	if y1 > y2 :
		var t = y1
		y1 = y2
		y2 = t
	var rtn := {}
	for y in range(y1,y2+1):
		var pos := Vector2i(x,y)
		var old = set_at(pos, v)
		if old != null:
			rtn[pos] = old
	return rtn

func get_at(pos :Vector2i) :
	return data[pos.y][pos.x]

func set_at(pos :Vector2i, v):
	var old = data[pos.y][pos.x]
	data[pos.y][pos.x] = v
	if old == null:
		count +=1
	return old

func move(from :Vector2i, to :Vector2i) :
	var from_data = del_at(from)
	assert(from_data != null, "empty move from %s -> %s" %[from, to] )
	var to_data = set_at(to, from_data)
	return to_data

func swap(pos1 :Vector2i, pos2 :Vector2i) :
	var p1data = del_at(pos1)
	assert(p1data != null, "empty swap pos1 %s -> %s" %[pos1, pos2] )
	var p2data = set_at(pos2, p1data)
	assert(p2data != null, "empty swap pos2 %s -> %s" %[pos1, pos2] )
	set_at(pos1,p2data)
	# no return

func del_at(pos :Vector2i):
	var old = data[pos.y][pos.x]
	data[pos.y][pos.x] = null
	if old != null:
		count -=1
	return old
