class_name TimeManager extends Node

signal day_changed(days: int)

var freeze: bool = false
const ticks_per_second: int = 5

var day_timestamp: int = 19185:  # 2022-7-12
	get(): return 19185 + days

var daily_ticks: int = 0
var days: int = 0:
	set(value):
		days = value
		day_changed.emit(value)

var _h: int = 0
var _min: int = 0
var _s: int = 0

func _physics_process(delta: float) -> void:
	if freeze:
		return
	daily_ticks += 1

	if daily_ticks >= 86400 * ticks_per_second:
		daily_ticks = 0
		days += 1

	_h = daily_ticks / (3600 * ticks_per_second)
	_min = daily_ticks % (3600 * ticks_per_second) / (60 * ticks_per_second)
	_s = (daily_ticks % (3600 * ticks_per_second) % (60 * ticks_per_second)) / ticks_per_second


func is_leap_year(year) -> bool:
	"""判断是否为闰年"""
	if year % 400 == 0:
		return true
	if year % 100 == 0:
		return true
	if year % 4 == 0:
		return true
	return false

func days_to_date(days) -> Array[int]:
	"""将自1970-01-01起的天数转换为日期字符串 (YYYY-MM-DD)"""
	# 每月的天数（非闰年）
	var month_days: Array[int] = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

	# 初始日期
	var year = 1970
	var month = 1
	var day = 1

	# 处理天数
	var remaining_days = days

	# 逐年减去天数
	while true:
		var days_in_year = 366 if is_leap_year(year) else 365
		if remaining_days < days_in_year:
			break
		remaining_days -= days_in_year
		year += 1

	# 调整闰年二月天数
	if is_leap_year(year):
		month_days[1] = 29
	else:
		month_days[1] = 28

	# 逐月减去天数
	var i: int = 0
	for days_in_month in month_days:
		if remaining_days < days_in_month:
			month = i + 1
			day = remaining_days + 1  # 因为天数从0开始
			break
		remaining_days -= days_in_month
		i += 1

	return [year, month, day]

func format_day_time() -> String:
	return "%s-%s-%s" % days_to_date(day_timestamp)

func format_daily_time() -> String:
	return "%02d:%02d:%02d" % [_h, _min, _s]
