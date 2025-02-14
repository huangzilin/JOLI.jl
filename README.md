# JOLI - Julia Operators LIbrary

Julia framework for constructing matrix-free linear operators
with explicite domain/range type control
and applying them in basic algebraic matrix-vector operations.

## INSTALLATION

From julia prompt run the following if you will not need developer's write access or if you do not have GitHub account:

```
Pkg.add(PackageSpec(url="https://github.com/slimgroup/JOLI.jl.git",rev="master"))
```

or with GitHub account (and SSH keys registered) for full developer access:

```
Pkg.develop(PackageSpec(url="git@github.com:slimgroup/JOLI.jl.git"))
```

## Documentation (more to come)

For now it is just [REFERENCE guide](REFERENCE.md).

## Examples (more to come)

Check [templates](templates) for an examples of how to build your own operators or types,
or look up DCT implementation in [src/joLinearFunctionConstructors/joDCT.jl](src/joLinearFunctionConstructors/joDCT.jl).
