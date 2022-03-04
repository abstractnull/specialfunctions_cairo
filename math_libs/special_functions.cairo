# 
# This lib uses small_math lib
# Start with Gamma integer/half-integers...next step general function evaluation(up to complex someday?)
# Other special functions to consider: Bessel, Airy...etc

from starkware.cairo.common.pow import pow

# TODO: Implement both forms of half integer gamma function
# sqrt(pi) ((n-2)!!/2**((n-1)/2))
# (((2n)!)/((2**2n)*n!)) sqrt(pi) DONE

from math_libs.small_math import (
    Fix_64x61,
    SmallMath_div,
    SmallMath_mul,
    SmallMath_sqrt_PI,
    SmallMath_ONE,
    SmallMath_fact
) 

# TODO: Move to independent files
# const SmallMath_INT_PART = 2 ** 64
# const SmallMath_FRACT_PART = 2 ** 61
# const SmallMath_BOUND = 2 ** 125
# const SmallMath_ONE = 1 * SmallMath_FRACT_PART

# const SmallMath_PI = 7244019458077122842
# const SmallMath_sqrt_PI = 4087000321264375119

# Double factorial: (not iterated!) 7!! = 1 * 3 * 5 * 7 ; 8!! = 2 * 4 * 6 * 8
# Argument is fixed
func Special_functions_double_fact {range_check_ptr} (x: felt) -> (res: felt):
    if x == 0:
        return (res = SmallMath_ONE)
    end
    if x == SmallMath_ONE:
        return (res = SmallMath_ONE)
    end

    let (partial_res) = Special_functions_double_fact (x - 2 * SmallMath_ONE)
    let (res) = SmallMath_mul (partial_res, x)
    return (res = res)
end

# Deprecated sqrt(pi) ((n-2)!!/2**((n-1)/2)) - Has problems with n = 1 (gamma of 1/2)
func Special_functions_gamma_half_int_deprecated {range_check_ptr}(x: felt) -> (res: felt):
    alloc_locals

    local exp = (x - 1) / 2
    let (local deno_felt) = pow (2, exp)
    let (local deno) = Fix_64x61(deno_felt)

    tempvar dfact_arg = x - 2
    let (dfact_arg_fix) = Fix_64x61(dfact_arg)

    let (local nume) = Special_functions_double_fact (dfact_arg_fix)

    let (rational_part) = SmallMath_div (nume, deno)
    let (res) = SmallMath_mul (SmallMath_sqrt_PI, rational_part)

    return (res = res)
end

# (((2n)!)/((2**2n)*n!)) sqrt(pi)
func Special_functions_gamma_half_int {range_check_ptr}(n: felt) -> (res: felt):
    alloc_locals

    # tempvar n_felt = n / SmallMath_ONE
    local x = (n - 1) / 2

    tempvar exp = 2 * x
    let (pow_deno) = pow (2, exp)
    let (fix_pow_deno) = Fix_64x61(pow_deno)
    let (fix_fact_arg) = Fix_64x61(x)

    let (fact_deno) = SmallMath_fact(fix_fact_arg)

    let (local deno) = SmallMath_mul(fix_pow_deno, fact_deno)

    tempvar nume_arg = 2 * x 
    let (fix_nume_arg) = Fix_64x61(nume_arg)
    let (nume) = SmallMath_fact(fix_nume_arg)

    let (rational) = SmallMath_div(nume, deno)

    let (res) = SmallMath_mul(rational, SmallMath_sqrt_PI)

    return (res = res)
end

#close to simple factorial
func Special_functions_gamma_int {range_check_ptr} (x: felt) -> (res: felt):
    tempvar arg = x - SmallMath_ONE
    let (res) = SmallMath_fact(arg)
    return (res = res)
end