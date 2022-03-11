# Function import and export

In this article we will understand how to import/export Swift functions
to Lua, to be used there as normal Lua functions. So yea, let's get
started!

## Export

Well, to be able to export a Swift function to Lua, you should provided
some kind of a wrapper. Sorry, but this is a required thing, firstly
because how C API of Lua works, and secondly because Lua is a
dynamically-typed language.

So, let's get an example of this. Imagine we have a Swift function like
this:

```swift
func operateOnData(_ data: String) {
    // let's just imagine it does something fabulous
}
```

...and we have a task to export it to Lua. We have a function to do so,
namely ``Lua/registerFunction(_:name:)``, but it expects some kind of
`lua_CFunction` 🤨.

This looks strange, but in reality everything is pretty easy. Basically,
it expects a function that looks like this:

```swift
@_cdecl("to_be_exported")
func toBeExported(args: OpaquePointer?) -> Int32 {
    // does something (wow)
}
```

_Woah woah woah, what is that mess?_ - you would say. And on a first look,
it does look strange, but, again, in reality, it is easy. Let's dive into
how this works:

- `@_cdecl("to_be_exported")` is an attribute (or annotation as everyone
else calls it) builtin to Swift, that exports the function to C. That
is required by the C API of Lua, because, well, the API is written in
C 🤷. This annotation puts restrictions on how we can declare a function,
we shoud not care about that, as it is just a wrapper around a Swift
function.

- `args: OpaquePointer?` are (judging by the name) arguments passed to
to the function from Lua. This thing is not used directly, but in helper
functions of LuaKit. You pass the `OpaquePointer` instance to functions
like ``Lua/getArgAsString(args:index:)`` or
``Lua/getArgAsDouble(args:index:)``, which will use the provided
`OpaquePointer` instance to return you an argument you requested. Please
note that index count **starts from 1**. Ples don't bully me, this is the
Lua developer that made me to do this 💀

- The return value is Int32, and is not returning a status code or something,
no, it is actually **a number of return values**. You can use it
non-directly though, by just using a helper function 

