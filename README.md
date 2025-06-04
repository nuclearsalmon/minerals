# Minerals

A collection of utilities and patches that extend the functionality of crystal

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     minerals:
       github: nuclearsalmon/minerals
   ```

2. Run `shards install`

## Usage

### As a module

```crystal
require "minerals"
```

### With full featureset
```crystal
ENV["MINERALS_TOPLEVEL"] ||= "true"
ENV["MINERALS_PATCH"] ||= "true"
require "minerals"
```

### With methods in top-level scope

```crystal
ENV["MINERALS_TOPLEVEL"] ||= "true"
require "minerals"
```

### With patches to objects

```crystal
ENV["MINERALS_PATCH"] ||= "true"
require "minerals"
```
