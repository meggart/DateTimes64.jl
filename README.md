# DateTimes64

[![Build Status](https://github.com/meggart/DateTimes64.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/meggart/DateTimes64.jl/actions/workflows/CI.yml?query=branch%3Amain)

Julia Time Types binary-compatible with Numpy's `datetime64`. 

### Quick Start

Inter-operating with Python date and datetime types can be a pain. Here we implement a Julia
`TimeType` which has the same underlying memory representation as numpy's `datetime64` dtype. 
This means that array buffers or binary data on disk can directly be wrapped and will be 
represented in Julia as a valid Time type with easy conversions to types from Dates.jl. 

````julia
using PythonCall
np = pyimport("numpy")
datearray = np.array(["2007-07-13", "2006-01-13", "2010-08-13"], dtype="datetime64")
jlbytes = pyconvert(Array,parray.tobytes())
````
````
UInt8[0x8b, 0x35, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x69, 0x33, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xf2, 0x39, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]
````

We can reinterpret this byte vector as a `DateTime64` vector:

````julia
t64 = reinterpret(DateTime64{Dates.Day},jlbytes)
````
````
3-element reinterpret(DateTime64{Day}, ::Vector{UInt8}):
 DateTime64[Day]: 2007-07-13T00:00:00
 DateTime64[Day]: 2006-01-13T00:00:00
 DateTime64[Day]: 2010-08-13T00:00:00
````

and convert the result to `Date` or `DateTime`

````julia
Date.(dt64)
````
````
3-element Vector{Date}:
 2007-07-13
 2006-01-13
 2010-08-13
````