#!/usr/bin/env python3
# Requires the pyparsing package installed (can be installed from pip)
# Requires z3 installed (install z3-solver from pip)
# Handles input files in a *subset* of .dot file format
# Also, does no validation
from pyparsing import Word, alphas, nums, ZeroOrMore
from z3 import *
import sys

nodeDef = ('node' + ('[' + ('shape' + ('=' + Word(alphas) + ']' + Word(nums))))).setParseAction(lambda s, loc, toks : toks[6])
edgeDef = (Word(nums) + '--' + Word(nums) + ';').setParseAction(lambda s, loc, toks : (toks[0], toks[2]))

nodeDefs = ZeroOrMore(nodeDef).setParseAction(lambda s, loc, toks : ('nodes', toks))
edgeDefs = ZeroOrMore(edgeDef).setParseAction(lambda s, loc, toks : ('edges', toks))

graphDef = ('graph' + Word(alphas) + '{' + nodeDefs + edgeDefs + '}').setParseAction(lambda s, loc, toks : (toks[1], toks[3], toks[4]))

if __name__ == '__main__':
  if len(sys.argv) != 3:
    print(f'Usage: {sys.argv[0]} <k> <dot file>')
    print('\tTo perform k-coloring of the graph')
    sys.exit(1)
  k = int(sys.argv[1])
  graph = graphDef.parseFile(sys.argv[2])[0]
  name = graph[0]
  nodes = graph[1][1]
  edges = graph[2][1]
  
  s = Solver()
  propositions = {} # Map of propositions
  # Add the propositions
  for n in nodes:
    for c in range(k):
      propName = f'p_{n}_{c}'
      prop = Bool(propName)
      propositions[(n, c)] = prop
  # Each node can have only one color
  for n in nodes:
    clauses = []
    for posColor in range(k): # Select the color to be positive
      conjunction = []
      for c in range(k): # Output each color
        prop = propositions[n, c]
        if c == posColor:
          conjunction.append(prop)
        else:
          conjunction.append(Not(prop))
      clauses.append(And(conjunction))
    s.add(Or(clauses))
  # Ensure nodes connected by edge are distinct colors
  for (n, m) in edges:
    clauses = []
    for c in range(k):
      clauses.append(And(propositions[(n, c)], Not(propositions[(m, c)])))
    s.add(Or(clauses))
  
  if s.check() == sat:
    print(f'{k}-coloring exists for graph {name}')
    model = s.model()
    for n in nodes:
      color = 'ERROR'
      for c in range(k):
        if model.eval(propositions[(n, c)]):
          assert color == 'ERROR'
          color = c
      print(f'Node {n}: Color {color}')
  else:
    print(f'No {k}-coloring exists for graph {name}')
