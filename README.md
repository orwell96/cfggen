# Context-free Grammar Random Word Generator

This Lua script generates random words of a (formal) language using a context-free grammar.

Usage: `lua cfggen.lua <rules file> [count] [seed]`
(e.g. `lua cfggen.lua abc`)

Syntax of the derivation rules file:
- Each newline a separate rule
- The start nonterminal is always <init>
- Lines starting with # are comments
- Rule pattern: (spaces before/after operators optional)
```
nonterminal = terminal <nonterminal> terminal | otherterminal <othernonterminal>
or
weight * nonterminal = terminal <nonterminal> terminal''
(where weight is a positive integer)
```
`<e>` is the empty string

See the provided sample grammars for examples.

== License

Copyright (C) 2020 orwell96

This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

To review the license document, please see <http://www.gnu.org/licenses/>. 
