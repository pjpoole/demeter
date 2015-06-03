# Law of Demeter
Object space explorer and tracer

## Goals

I'd like to make this into a gem down the road, but for the time being I'm building on top of a bare rails project in order to start building out the core idea with a sort of established codebase.

Broadly, my goals would be to:

* Load a project and look at the objects currently in memory
* Examine the module and class relations that are going on
* Get some basic rendering on-screen: something like, a tree rooted in `BasicObject` and branching out to each of the inheriting classes
* Look at how the rendering could be adjusted to take into account LOC, module/class relations, number of methods, file location, or something else entirely (maybe have this be a view option, or a composite representation—typically this sort of visualization would allow for size, proximity, coloring, graph edges... I have a loose idea of what I'd like, but I'll have to see it in real life)
* Represent method locations: Method a is available in namespace A, and is defined in module B... something like this
* Figure out a way to visualize a selected object's dependencies in the object graph
