#!/usr/local/bin/python3

import re
from functools import reduce

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


def plan_to_match(plan_string):
	return re.match(plan_regex, plan_string)

def match_to_coord(match):
	return reduce(
		lambda acc,x: dict(acc, **{ x.get("name"): match.group(x.get("index"))}),
			[plan_id, plan_x, plan_y, plan_w, plan_h],
			{}
	)

plan_to_coord = compose(plan_to_match, match_to_coord)

with open("../../data/plans") as f:
	for line in f:
		print(line)
