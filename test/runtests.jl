using DateTimes64
using Test
using Dates

@testset "DateTimes64.jl" begin

#Create some datetime64s in Python
#Originally the byte vector was created like this. Here we simply paste the result to avoid the
#Python and numpy test dependency
# np = pyimport("numpy")
# parray = np.array(["2007-07-13", "2006-01-13", "2010-08-13"], dtype="datetime64")
# jlbytes = pyconvert(Array,parray.tobytes())

jlbytes = UInt8[0x8b, 0x35, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x69, 0x33, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xf2, 0x39, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]
dt64 = reinterpret(DateTime64{Dates.Day},jlbytes)
@test Date.(dt64) == [Date(2007,07,13),Date(2006,1,13),Date(2010,8,13)]
@test DateTime.(dt64) == [DateTime(2007,07,13),DateTime(2006,1,13),DateTime(2010,8,13)]
@test dt64[1] > dt64[2]
@test dt64[1] == dt64[1]
@test DateTimes64.pydatetime_string(DateTime64{Dates.Year}) == "<M8[Y]"
@test DateTimes64.pydatetime_string(DateTime64{Dates.Month}) == "<M8[M]"
@test DateTimes64.pydatetime_string(DateTime64{Dates.Week}) == "<M8[W]"
@test DateTimes64.pydatetime_string(DateTime64{Dates.Day}) == "<M8[D]"
@test DateTimes64.pydatetime_string(DateTime64{Dates.Hour}) == "<M8[h]"
@test DateTimes64.pydatetime_string(DateTime64{Dates.Minute}) == "<M8[m]"
@test DateTimes64.pydatetime_string(DateTime64{Dates.Second}) == "<M8[s]"
@test DateTimes64.pydatetime_string(DateTime64{Dates.Millisecond}) == "<M8[ms]"
@test DateTimes64.pydatetime_string(DateTime64{Dates.Microsecond}) == "<M8[us]"
@test DateTimes64.pydatetime_string(DateTime64{Dates.Nanosecond}) == "<M8[ns]"
@test DateTimes64.pydatetime_string(dt64[1]) == "<M8[D]"
@test DateTimes64.datetime_from_pystring("<M8[Y]") == DateTime64{Dates.Year}
@test DateTimes64.datetime_from_pystring("<M8[M]") == DateTime64{Dates.Month}
@test DateTimes64.datetime_from_pystring("<M8[W]") == DateTime64{Dates.Week}
@test DateTimes64.datetime_from_pystring("<M8[D]") == DateTime64{Dates.Day}
@test DateTimes64.datetime_from_pystring("<M8[h]") == DateTime64{Dates.Hour}
@test DateTimes64.datetime_from_pystring("<M8[m]") == DateTime64{Dates.Minute}
@test DateTimes64.datetime_from_pystring("<M8[s]") == DateTime64{Dates.Second}
@test DateTimes64.datetime_from_pystring("<M8[ms]") == DateTime64{Dates.Millisecond}
@test DateTimes64.datetime_from_pystring("<M8[us]") == DateTime64{Dates.Microsecond}
@test DateTimes64.datetime_from_pystring("<M8[ns]") == DateTime64{Dates.Nanosecond}
@test Date(zero(DateTime64{Dates.Day})) == Date(1970)
@test DateTime64{Dates.Day}(Date(1970,1,5)) == DateTime64{Day}(4)
@test DateTime64(Date(1970,1,5)) == DateTime64{Nanosecond}(345600000000000)
@test DateTime64{Dates.Day}(DateTime(1970,1,5)) == DateTime64{Day}(4)
@test DateTime64(DateTime(1970,1,5)) == DateTime64{Nanosecond}(345600000000000)
@test DateTime64{Dates.Day}(DateTime64{Dates.Hour}(48)) == DateTime64{Day}(2)
buf = IOBuffer()
show(buf,dt64[1])
@test String(take!(buf)) == "DateTime64[Day]: 2007-07-13T00:00:00"
end
