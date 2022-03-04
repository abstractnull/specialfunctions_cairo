# 
# This small lib/extension is based on Chris Lexmond's Math64x61 lib
# See: https://github.com/influenceth/cairo-math-64x61
#

%builtins range_check

from starkware.cairo.common.math import (
    assert_le,
    sign,
    abs_value,
    signed_div_rem
)

from starkware.cairo.common.pow import pow

# from small_math_types import Rational

# This version of Small_Math uses 64x61 Fixed point, like the Math64x61 lib
const SmallMath_INT_PART = 2 ** 64
const SmallMath_FRACT_PART = 2 ** 61
const SmallMath_BOUND = 2 ** 125
const SmallMath_ONE = 1 * SmallMath_FRACT_PART

const SmallMath_PI = 7244019458077122842
const SmallMath_sqrt_PI = 4087000321264375119


func SmallMath_assert64x61 {range_check_ptr} (x: felt):
    assert_le(x, SmallMath_BOUND)
    assert_le(-SmallMath_BOUND, x)
    return ()
end

func Fix_64x61 (x: felt) -> (fix: felt):
    return (fix = x * SmallMath_ONE)
end

# Multiples two fixed point values and checks for overflow before returning
func SmallMath_mul {range_check_ptr} (x: felt, y: felt) -> (res: felt):
    tempvar product = x * y
    let (res, _) = signed_div_rem(product, SmallMath_FRACT_PART, SmallMath_BOUND)
    SmallMath_assert64x61(res)
    return (res)
end

# Divides two fixed point values and checks for overflow before returning
# Both values may be signed (i.e. also allows for division by negative b)
func SmallMath_div {range_check_ptr} (x: felt, y: felt) -> (res: felt):
    alloc_locals
    let (div) = abs_value(y)
    let (div_sign) = sign(y)
    tempvar product = x * SmallMath_FRACT_PART
    let (res_u, _) = signed_div_rem(product, div, SmallMath_BOUND)
    SmallMath_assert64x61(res_u)
    return (res = res_u * div_sign)
end

# Gets the factorial of a fixed point integer value using simple iteration
func SmallMath_fact {range_check_ptr} (x: felt) -> (res: felt):
    if x == 0:
        return (res = SmallMath_ONE)
    end
    let (partial_fact) = SmallMath_fact (x - SmallMath_ONE)
    let (res) = SmallMath_mul(partial_fact, x)
    return (res = res)
end
