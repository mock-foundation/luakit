# ``LuaKit/Lua``

@Metadata {
    @DocumentationExtension(mergeBehavior: append)
}

## Overview

For documentation on usage of this class, refer to <doc:Meet-LuaKit>.

## Topics

### Initializers

- ``init()``
- ``init(libs:)``
- ``init(includeStd:)``

### Library management

- ``openStdLib(_:)``
- ``openStdLibs(_:)``

### Stack manipulation

- ``pushToStack()``
- ``pushToStack(bool:)``
- ``pushToStack(double:)``
- ``pushToStack(string:)``

### Function import/export

- ``register(function:name:)``
- ``getArgAsDouble(args:index:)``
- ``getArgAsString(args:index:)``

### Code running

- ``run(code:name:)``
- ``loadCode(_:name:)``
