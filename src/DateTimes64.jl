module DateTimes64
export DateTime64
using Dates: Period, TimeType, Date, DateTime, Dates

"""
    DateTime64{PeriodType} <: Dates.TimeType

This type encodes a 64-bit DateType (stored internally as an Int64) as some number of the given `PeriodType` 
(any subtype of `Dates.TimePeriod`, like `Dates.Nanosecond` `Dates.Hour`, `Dates.Minute`, etc).

!!! tip
    This structure mimics the Python `datetime64` or `M8[\$timeperiod]` exactly, and can be used to reinterpret
    such values.  For example, `M8[ns]` in Python translates to `DateTime64{Dates.Nanosecond}` in Julia.
"""
struct DateTime64{P} <: TimeType
    i::Int64
end
DateTime64{P}(d::TimeType) where P = convert(DateTime64{P},d)
DateTime64(d::TimeType) = convert(DateTime64{Dates.Nanosecond},d)
Base.convert(::Type{Date},t::DateTime64{P}) where P = Date(1970)+P(t.i)
Base.convert(::Type{DateTime},t::DateTime64{P}) where P = DateTime(1970)+P(t.i)
Base.show(io::IO,t::DateTime64{P}) where P = print(io,"DateTime64[",P,"]: ",string(DateTime(t)))
Base.isless(x::DateTime64{P}, y::DateTime64{P}) where P = isless(x.i, y.i)
import Base: ==
==(x::DateTime64{P}, y::DateTime64{P}) where P = x.i == y.i
const strpairs = (Dates.Year => "Y", Dates.Month => "M", Dates.Week => "W", Dates.Day=>"D", 
    Dates.Hour => "h", Dates.Minute => "m", Dates.Second=>"s", Dates.Millisecond =>"ms",
    Dates.Microsecond => "us", Dates.Nanosecond => "ns")

for (jlt,s) in strpairs
    @eval pydatetime_string(d::Type{<:DateTime64{$jlt}}) = string("<M8[",$s,"]")
end
pydatetime_string(x::DateTime64{P}) where P = pydatetime_string(DateTime64{P}) 

function datetime_from_pystring(s)
    m = match(r"<M8\[(\w+)\]",s)
    if m === nothing
        throw(ArgumentError("Could not parse datetime description"))
    else
        ms = only(m.captures)
        i = findfirst(i->isequal(last(i),ms),strpairs)
        i === nothing && throw(ArgumentError("Could not parse datetime description"))
        DateTime64{first(strpairs[i])}
    end
end

Base.convert(::Type{DateTime64{P}}, t::Date) where P = DateTime64{P}(Dates.value(P(t-Date(1970))))
Base.convert(::Type{DateTime64{P}}, t::DateTime) where P = DateTime64{P}(Dates.value(P(t-DateTime(1970))))
Base.convert(::Type{DateTime64{P}}, t::DateTime64{Q}) where {P,Q} = DateTime64{P}(Dates.value(P(Q(t.i))))
Base.zero(t::Union{DateTime64, Type{<:DateTime64}}) = t(0)


end
