# 
# This lib uses small_math lib
# Start with Gamma for integers/half-integers/reals(in Cairo fixed point ),next step general function evaluation(up to complex someday?)
# Other special functions to consider: Beta, Psi, Bessel, Airy...etc

from starkware.cairo.common.pow import pow
from starkware.cairo.common.alloc import alloc

# TODO: Implement both forms of half integer gamma function
# sqrt(pi) ((n-2)!!/2**((n-1)/2))
# (((2n)!)/((2**2n)*n!)) sqrt(pi) DONE

from math_libs.small_math import (
    Double,
    Fix64x61,
    Felt_to_Fix,
    Fix_to_Felt,
    Double_to_Fix,
    Small_Math_div,
    Small_Math_mul,
    Small_Math_sqrt_PI,
    Small_Math_ONE,
    Small_Math_fact,
    Small_Math_exp2,
    Small_Math_sub,
    Small_Math_ln,
    Small_Math_pow,
    Small_Math_sinh,
    Small_Math_add,
    show_Fix
) 

# TODO: Move to independent files
# const SmallMath_INT_PART = 2 ** 64
# const SmallMath_FRACT_PART = 2 ** 61
# const SmallMath_BOUND = 2 ** 125
# const SmallMath_ONE = 1 * SmallMath_FRACT_PART

# const SmallMath_PI = 7244019458077122842
# const SmallMath_sqrt_PI = 4087000321264375119

#close to simple factorial
func Special_functions_gamma_int {range_check_ptr} (x: Fix64x61) -> (res: Fix64x61):
    let (arg) = Small_Math_sub(x, Fix64x61(Small_Math_ONE))
    let (res) = Small_Math_fact(arg)
    return (res = res)
end

# Double factorial: (not iterated!) 7!! = 1 * 3 * 5 * 7 ; 8!! = 2 * 4 * 6 * 8
# Argument is fixed
func Special_functions_double_fact {range_check_ptr} (x: Fix64x61) -> (res: Fix64x61):
    if x == 0:
        return (res = Fix64x61(Small_Math_ONE))
    end
    if x == SmallMath_ONE:
        return (res = Fix64x61(Small_Math_ONE))
    end
    let (fix_2) = Double_to_Fix(Double(2, 0))
    let (sub_1) = Small_Math_sub(x, fix_2)
    let (partial_res) = Special_functions_double_fact (sub_1)
    let (res) = Small_Math_mul (partial_res, x)
    return (res = res)
end


# (((2x)!)/((2**2x)*x!)) sqrt(pi)
func Special_functions_gamma_half_int {range_check_ptr}(n: Fix64x61) -> (res: Fix64x61):
    alloc_locals
    # n is the number of half units - here we calculate the base integer (x)
    # n - 1
    let (n_sub_1) = Small_Math_sub(n, Fix64x61(Small_Math_ONE))
    # (n - 1) / 2
    let (fix_2) = Felt_to_Fix(2)
    let (base_int) = Small_Math_div(n_sub_1, fix_2)
    # Now into the actual calculatino of the function
    # 2n
    let (mul_x_2) = Small_Math_mul(fix_2, base_int)
    # (2**2n)
    let (exp_x_2) = Small_Math_exp2(mul_x_2)
    # n!
    let (fact_deno) = Small_Math_fact(base_int)
    # ((2**2n)*n!)
    let (local deno) = Small_Math_mul(exp_x_2, fact_deno)
    # (2n)!
    let (nume) = Small_Math_fact(mul_x_2)

    let (ratio) = Small_Math_div(nume, deno)

    let (res) = Small_Math_mul(ratio, Fix64x61(Small_Math_sqrt_PI))

    return (res = res)
end

#Windschitl type LogGamma
func Special_functions_windschitl {range_check_ptr}(x: Fix64x61) -> (res: Fix64x61):
    alloc_locals
    # fix_ONE
    local fix_ONE: Fix64x61 = Fix64x61(Small_Math_ONE)

    # const 1 = 0.918938533204673
    local c_1_double : Double = Double (918938533204673, 15)
    let (local t_1: Fix64x61) = Double_to_Fix (c_1_double)

    # const 2 = 0.5
    let c_2_double : Double = Double (5, 1)
    let (local c_2_fix: Fix64x61) = Double_to_Fix(c_2_double)
    # (x-0.5) 
    let (local t_2_sub : Fix64x61) =  Small_Math_sub(x, c_2_fix)
    # log(x)
    let (local t_2_log : Fix64x61) =  Small_Math_ln(x)
    # (x-0.5)*log(x)
    let (t_2: Fix64x61) = Small_Math_mul(t_2_sub, t_2_log)

    # t_3 = -x
    local t_3: Fix64x61 = Fix64x61(-x.val) 

    # t_4: 6.0
    let (local c_3: Fix64x61) = Felt_to_Fix(6)
    # t_4 pow(x,6.0)
    let (local t_4_pow: Fix64x61) = Small_Math_pow(x, c_3)
    # t_4: 810.0
    let (local c_4: Fix64x61) = Felt_to_Fix(810)
    # t_4: 810.0*pow(x,6.0)
    let (local t_4_log_pro_2: Fix64x61) = Small_Math_mul(c_4, t_4_pow)
    # t_4: 1/(810.0*pow(x,6.0))
    let (local t_4_div_2: Fix64x61) = Small_Math_div(fix_ONE, t_4_log_pro_2)
    # t_4: 1/x
    let (local t_4_div_1: Fix64x61) = Small_Math_div(fix_ONE, x)
    # t_4: sinh(1/x) : 0.52109530549
    let (local t_4_sinh: Fix64x61) = Small_Math_sinh(t_4_div_1)
    # t_4: x*sinh(1/x)
    let (local t_4_log_pro_1: Fix64x61) = Small_Math_mul(x, t_4_sinh)
    # t_4: x*sinh(1/x) + 1/(810.0*pow(x,6.0))
    let (local t_4_sum: Fix64x61) = Small_Math_add(t_4_log_pro_1, t_4_div_2)
    # t_4: log( x*sinh(1/x) + 1/(810.0*pow(x,6.0)) )
    let (local t_4_log: Fix64x61) = Small_Math_ln(t_4_sum)
    # t_4: 0.5*x
    let (local t_4_pro: Fix64x61) = Small_Math_mul(c_2_fix, x)
    # t_4: 0.5*x*log( x*sinh(1/x) + 1/(810.0*pow(x,6.0)) )
    let (local t_4: Fix64x61) = Small_Math_mul(t_4_pro, t_4_log)
    
    # t_1 + t_2
    let (local t_1_2: Fix64x61) = Small_Math_add(t_1, t_2)
    # t_1 + t_2 + t_3
    let (local t_1_2_3: Fix64x61) = Small_Math_add(t_1_2, t_3)
    # t_1 + t_2 + t_3 + t_4
    let (local res_windschitl: Fix64x61) = Small_Math_add(t_1_2_3, t_4)

    #let (windschitl_gamma: Fix64x61) = Small_Math_exp(windschitl)

    return(res = res_windschitl)
end

#Lanczos method for LogGamma
func Special_functions_lanczos {range_check_ptr}(x: Fix64x61) -> (res: Fix64x61):
    alloc_locals
    let (q_vector: Fix64x61*) = alloc()
    let (q_0) = Double_to_Fix(Double(751226331530, 7))
    let (q_1) = Double_to_Fix(Double(809166278952, 7))
    let (q_2) = Double_to_Fix(Double(363082951477, 7))
    let (q_3) = Double_to_Fix(Double(868724529705, 8))
    let (q_4) = Double_to_Fix(Double(116892649479, 8))
    let (q_5) = Double_to_Fix(Double(838676043424, 10))
    let (q_6) = Double_to_Fix(Double(250662827511, 11))

    assert([q_vector]) = q_0
    assert([q_vector + 1]) = q_1
    assert([q_vector + 2]) = q_2
    assert([q_vector + 3]) = q_3
    assert([q_vector + 4]) = q_4
    assert([q_vector + 5]) = q_5
    assert([q_vector + 6]) = q_6

    # 0.5
    let (c_1) = Double_to_Fix(Double(5, 1))
    # 5.5
    let (c_2) = Double_to_Fix(Double(55, 1))
    # (x + 0.5)
    let (a_t_1_sum) = Small_Math_add(x, c_1)
    # (x + 5.5)
    let (a_t_2) = Small_Math_add(x, c_2)
    # log(x + 5.5)
    let (a_t_1_log) = Small_Math_ln(a_t_2)
    # (x + 0.5) * log(x + 5.5)
    let (a_t_1) = Small_Math_mul(a_t_1_sum, a_t_1_log)
    # a = (x + 0.5) * log(x + 5.5) - (x + 5.5)
    let (a_0) = Small_Math_sub(a_t_1, a_t_2)
    let (a_final, b_final) = lanczos_inner(q_vector, 7, 0, x, a_0)

    # log(b)
    let(log_b) = Small_Math_ln(b_final)
    # a + log(b)
    let(res_lanczos) = Small_Math_add (a_final, log_b)

    return(res = res_lanczos)
end

func lanczos_inner {range_check_ptr}(q_vector: Fix64x61*, q_vector_size: felt, index: felt, x: Fix64x61, a_0: Fix64x61) -> (a: Fix64x61, b: Fix64x61):
    alloc_locals
    if q_vector_size == 0:
        let (b_0) = Felt_to_Fix(0)
        return(a = a_0, b = b_0)
    end
    let (acc_a, acc_b) = lanczos_inner(q_vector + Fix64x61.SIZE, q_vector_size - 1, index + 1, x, a_0)
    # (double)n
    let (local n_fix) = Felt_to_Fix(index)
    # x + (double)n
    let (log_arg) = Small_Math_add(n_fix, x)
    # log(x + (double)n)
    let (a_log) = Small_Math_ln(log_arg)
    # pow(x, (double)n)
    let (pow_b) = Small_Math_pow(x, n_fix)
    # q[n]
    let q_n: Fix64x61 = cast([q_vector], Fix64x61)
    # q[n] * pow(x, (double)n)
    let (b_mul) = Small_Math_mul(q_n, pow_b) 

    let (sum_a) = Small_Math_sub(acc_a, a_log) 
    let (sum_b) = Small_Math_add(acc_b, b_mul)

    return (a = sum_a, b = sum_b)
end

