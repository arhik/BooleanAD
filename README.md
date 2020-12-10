# BooleanAD.jl

- Defined Automatic Differentiation rules for Boolean types.
- Meant to be used with Flux.jl

This repo makes a point that adjoints can be defined for Boolean Type
These ruleset will help learning F$\_2$ boolean functions with help of oracle.

Warning: Extremely experimental and needs verification from experts.

Example potential application:
- HTM networks.
- Mask learning.
- Wide networks with top-k.
- Graph learning.
