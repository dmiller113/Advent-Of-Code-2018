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
string1 = "#1 @ 1,3: 4x4"
string2 = "#2 @ 3,1: 4x4"
string3 = "#3 @ 5,5: 2x2"


def compose(*functions):
	def inner(x):
		return reduce(lambda res, fn: fn(res), functions, x)
	
	return inner


def split_while(fn, iter):
	def inner(fn, xs, acc):
		if len(xs) == 0:
			return (acc, [])

		h, *tail = xs

		if(fn(h)):
			acc.append(h)
			return inner(fn, tail, acc)

		return (acc, xs)

	return inner(fn, iter, [])


def overlap(iter):
	processed = set()
	acc = set()

	for h in iter:
		if h in processed:
			acc.add(h)
			continue

		processed.add(h)

	return acc


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


def find_nonoverlapping_plans(plans):
	plan_dict = {
		plan["id"]: [coord for coord in plan_to_coords(plan)] for plan in plans
	}

	plan_ids = list(plan_dict.keys())

	overlap_coords = overlap(chain(*plan_dict.values()))

	overlapped_ids = []
	for coord in overlap_coords:
		for plan_id in plan_ids:
			if coord in plan_dict[plan_id]:
				overlapped_ids.append(plan_id)

		plan_ids = [x for x in plan_ids if x not in overlapped_ids]
		overlapped_ids = []
	
	return plan_ids
		


#########
# Tests #
#########


def test_single_string():
	test_string = "#123 @ 3,2: 5x4"
	coords_gen = plan_to_coords(string_to_plan(test_string))

	for coord in coords_gen:
		print(coord)

def test_solution1():
	with open("../../data/plans") as f:
		coords = map(string_to_coords, f)
		print('done mapping')
		coords = chain(*coords)
		print('start overlap')
		overlapped_coords = overlap(coords)
		print(len(overlapped_coords))


		
def test_overlap():
	coords = chain(
		string_to_coords(string1),
		string_to_coords(string2),
		string_to_coords(string3),
	)

	overlapped_coords = overlap(coords)

	print(len(overlapped_coords))


def test_solo():
	plans = [string_to_plan(s) for s in [string1, string2, string3]]

	plan_ids = find_nonoverlapping_plans(plans)

	print(list(plan_ids))

def test_solution2():
	with open("../../data/plans") as f:
		plans = [string_to_plan(l) for l in f]
		plan_ids = find_nonoverlapping_plans(plans)
		print(list(plan_ids))

# test_overlap()
# test_solution1()
# test_solo()
test_solution2()
