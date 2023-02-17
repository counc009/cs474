#!/usr/bin/env python3
# Usage: python3 <script> <k> <dot file>
#   where <k> is an integer
#     and <dot file> is a path to the desired .dot file

# Requires the pyparsing package installed (can be installed from pip)
# Requires z3 installed (install z3-solver from pip)

# Handles input files in a *subset* of .dot file format (use graph_g.dot and
# graph_h.dot as templates)

# Note that this script does very little validation, so incorrectly formatted
# command line arguments or .dot files may result in unexpected errors or
# results

from pyparsing import Word, alphas, nums, ZeroOrMore
from z3 import *
import sys

# Define the grammar of the .dot files that we're going to recognize
# - A nodeDef recognizes a line declaring a node
#   + Form "node [shape=<shape>] <number>"
# - An edgeDef recognizes a line declaring an edge
#   + Form "<number> -- <number>;"
# Parse actions are used to extract the things we care about into tuples
nodeDef = ('node' + ('[' + ('shape' + ('=' + Word(alphas) + ']' + Word(nums))))).setParseAction(lambda s, loc, toks : toks[6])
edgeDef = (Word(nums) + '--' + Word(nums) + ';').setParseAction(lambda s, loc, toks : (toks[0], toks[2]))

# Define lists of nodes and edges, using parse actions to get lists of tuples
nodeDefs = ZeroOrMore(nodeDef).setParseAction(lambda s, loc, toks : ('nodes', toks))
edgeDefs = ZeroOrMore(edgeDef).setParseAction(lambda s, loc, toks : ('edges', toks))

# Define the entire .dot file structure
# - Form "graph <name> { <nodeDefs> <edgeDefs> }"
# Again using parse actions to collect the components we care about
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
  
  # Initialize the z3 solver
  s = Solver()
  # Keep a map from node names and colors to the z3 proposition
  propositions = {}

  # Add the propositions
  for n in nodes:
    for c in range(k):
      propName = f'p_{n}_{c}'
      prop = Bool(propName) # Create z3 proposition (as boolean type)
      propositions[(n, c)] = prop
  
  # Add formula to ensure each node has exactly one color
  for n in nodes:
    clauses = [] # Used to collect the different possible colors
    # Loop over each color that the node can have
    for posColor in range(k):
      conjunction = [] # Used to collect the atomic formula for each color
      for c in range(k):
        prop = propositions[n, c] # Find proposition for this node and color
        if c == posColor: # For the positive color, add the proposition
          conjunction.append(prop)
        else: # For other colors add the negation (so it is not that color)
          conjunction.append(Not(prop))
      # And together the atomic formula. The resulting formula is satisfied if
      # the node is assigned the color posColor and no other color
      clauses.append(And(conjunction))
    # Or together the formula for each positive color, resulting in a single
    # formula that is true iff the node is assigned a single color
    s.add(Or(clauses))

  # Add formula to ensure nodes connected by an edge are distinct colors
  for (n, m) in edges:
    clauses = []
    # For each color we insert a formula that is satisfied when the first node
    # (node n) has that color and the second node (node m) does not have that
    # color
    for c in range(k):
      clauses.append(And(propositions[(n, c)], Not(propositions[(m, c)])))
    # And we or together one of these formula for each color, resulting in a
    # formula that is true if node n has some color c and node m is not that
    # color
    s.add(Or(clauses))
  
  # We check if the formulae are satisfiable
  if s.check() == sat:
    print(f'{k}-coloring exists for graph {name}')
    # If so, get the model
    model = s.model()
    # And check each node and each color until we find the proposition that is
    # set to True (meaning the node has that color)
    for n in nodes:
      color = 'ERROR'
      for c in range(k):
        if model.eval(propositions[(n, c)]):
          assert color == 'ERROR'
          color = c
      print(f'Node {n}: Color {color}')
  else:
    print(f'No {k}-coloring exists for graph {name}')
