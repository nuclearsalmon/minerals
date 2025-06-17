# Minerals

A collection of utilities and patches that extend the functionality of crystal.

**Highly volatile, depend on a specific version!**

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     minerals:
       github: nuclearsalmon/minerals
   ```

2. Run `shards install`

## Usage

Require the relevant packages.
The base `minerals` package is required,
and it automatically patches a minimal selection
of utilities into the top level scope,
but it does not touch any types.

```cr
require "minerals"
require "minerals/lowlevel/static_array"
```

Then, either use as modules:
```cr
Minerals::StaticArray.from_s("hello", 5)
```

...or patch it into crystal:
```cr
patch Minerals::StaticArray
```
```cr
StaticArray.from_s("hello", 5)
```
