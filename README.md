BeamAnalyzer
============

Analyze the contents of an Erlang BEAM file.

Currently, this library implements the following functions:
* functions/1 - lists public and private functions in a module.
* exports/1 - lists public functions in a module.
* private_functions/1 - lists private functions in a module.
* function/3 - returns the clauses of any function as an abstract syntax tree.
