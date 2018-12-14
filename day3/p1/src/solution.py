#!/usr/local/bin/python3

import re
from functools import reduce
from itertools import chain
from operator import itemgetter

plan_regex = r"#(.*) @ (.*),(.*): (.*)x(.*)"
plan_id = { "name": "id", "index": 1 }
plan_x = { "index": 2, "name": "x" }
plan_y = { "index": 3, "name": "y" }
plan_w = { "index": 4, "name": "w" }
plan_h = { "index": 5, "name": "h" }

def compose(*functions):
	def inner(x):
		return reduce(lambda res, fn: fn(res), functions, x)
	
	return inner


def string_to_match(plan_string):
	return re.match(plan_regex, plan_string)

def match_to_plan(match):
	def reduce_fn(acc, x):
		key = x.get("name")
		val = match.group(x.get("index"))
		if not key == "id":
			val = int(val)

		return dict(acc, **{ key: val})

	return reduce(
		reduce_fn,
		[plan_id, plan_x, plan_y, plan_w, plan_h],
		{}
	)

string_to_plan = compose(string_to_match, match_to_plan)

def plan_to_coords(plan):
	def map_fn(i):
		dx = i % plan["w"]
		dy = i // plan["w"]
		return (plan["x"] + dx, plan["y"] + dy)

	total_squares = range(0, plan["w"] * plan["h"])
	return map(map_fn, total_squares)

string_to_coords = compose(string_to_plan, plan_to_coords)

def sort_coord_gen(*args):
	return sorted(
		chain(*args),
		key=itemgetter(1,0),
	)



#########
# Tests #
#########


def test_single_string():
	test_string = "#123 @ 3,2: 5x4"
	coords_gen = plan_to_coords(string_to_plan(test_string))

	for coord in coords_gen:
		print(coord)

def test_solution():
	with open("../../data/plans") as f:
		plans = map(string_to_plan, f)
		coords = map(plan_to_coords, plans)
		for coord in coords:
			for c in coord:
				print(c)

def test_overlap():
	string1 = "#1 @ 1,3: 4x4"
	string2 = "#2 @ 3,1: 4x4"
	string3 = "#1 @ 5,5: 2x2"
	coords = sort_coord_gen(
		string_to_coords(string1),
		string_to_coords(string2),
		string_to_coords(string3),
	)

	for c in coords:
		print(c)

test_overlap()
