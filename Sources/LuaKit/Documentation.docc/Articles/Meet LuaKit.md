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

## Running Swift code

Yea, you have heard that right - we are going to run some Swift code. But we will be
doing that **in Lua** 😎

There is a function called ``Lua/register(function:name:)``, which does just that.
But there is a catch. It expects a function that looks something like this:

```swift
@_cdecl("hello_lua_kit") // snake case is just a convention in C world
func helloLuaKit(pointer: OpaquePointer?) -> Int32 {
    print("Hello from Swift!")
    return 0
}
```

Yea, you need to create a function that actually is a C function. But don't be scared!
It is not as scary as it seems. LuaKit provides some nice API for you to make this
easier!

The first one is for preparing arguments.
