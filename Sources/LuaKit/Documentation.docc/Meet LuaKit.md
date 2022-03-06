# Meet LuaKit

LuaKit is a Swift framework for loading, running, and managing Lua code right from Swift.
Let's see how you can do just that.

## Something to know

So, let's get familiar with LuaKit's structure. You have a base class ``Lua``,
which contains an instance of Lua, and functions to interact with it. The
underlying instance is closed for interaction from outside, just to be safe.
``Lua`` mainly exposes functions that are safe to use, that are wrapped in
additional code to make it safe, like ``Lua/run(code:name:)``. Functions that
are not safe are kept private.

By the way, LuaKit also exposes a `liblua` module, which contains functions
from the actual C API of Lua, so you can use that if you want full control over
Lua.

Passed that topic. So, yea, let's start actually running some Lua code!

## Running Lua code

For running Lua code there is a ``Lua/run(code:name:)`` function. `code`
argument is code that you actually want to run, and `name` is a label that
you want to assign to that exact piece of code.

Let's imagine for an example this piece of Lua code:

```lua
function fact(n)
    if n == 0 then
        return 1
    else
        return n * fact(n-1)
    end
end

print("Using number 5:")
print(fact(5))
```

This piece of code is loaded in ``LuaKit`` like this:

```swift
// Initializing Lua with a default set
// of libraries (we gonna talk about that later)
let l = Lua()
// Loading and executing Lua code
l.run(code: """
function fact(n)
    if n == 0 then
        return 1
    else
        return n * fact(n-1)
    end
end

print("Using number 5:")
print(fact(5))
""", name: "codeLabel")
```

Let's imagine you just did that and ran that. If you did everything like above, it
should print out in `stdout` _Hey!_. If not, then, something had gone totally
wrong.
