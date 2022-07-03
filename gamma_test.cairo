%builtins range_check
#simple test of LogGamma,Gamma integers & half-integers
#TODO migrate to real comprehensive test
#Test ok Jul 22

from math_libs.special_functions import (
    Special_functions_gamma_half_int,
    Special_functions_windschitl,
    Special_functions_lanczos
)

from math_libs.small_math import (
    Double,
    Fix64x61,
    Felt_to_Fix,
    Double_to_Fix,
    Small_Math_div,
    Small_Math_mul,
    Small_Math_sqrt_PI,
    Small_Math_ONE,
    Small_Math_fact,
    Small_Math_sub,
    Small_Math_ln,
    Small_Math_pow,
    Small_Math_sinh,
    Small_Math_add,
    show_Fix
) 


# Testing odd arguments for x. x=3 -> gamma of (3/2) ; x=5 -> gamma of (5/2)
func test_gamma_int {range_check_ptr} (x: felt):
    alloc_locals
    if x == 1:
        return()
    end
    if x == 0:
        return()
    end
    let (x_fix) = Double_to_Fix(Double(x, 0))
    test_gamma_int (x - 2)
    let (local res_half_int) = Special_functions_gamma_half_int(x_fix)
    tempvar res_half_int_val = res_half_int.val
    %{
        txt = ' Gamma of '+ (str) (ids.x) + '/2 = ' + (str) (ids.res_half_int_val/ids.Small_Math_ONE)
        print (txt)
    %}
    return()
end

# Use only odd numbers for test
func test_1_half_int {range_check_ptr}(test: felt):
    return()
end


func main {range_check_ptr}():
    %{
        import time
        ts_0 = time.time()
        print('\n TESTING GAMMA FUNCTION LIB')
        print (f' -------------------------------------')
    %}
    # Uncomment one of the following test:
    
    # # -----------------------------------------------------------------------
    # # TEST 1: half integer function - use only odd numbers for calling
    # %{
    #     print (f' TEST Gamma function of half integers')
    # %}
    # test_gamma_int(5)
    # # -----------------------------------------------------------------------
    
    # # -----------------------------------------------------------------------
    # # TEST 2: set the value for the arg of the windschitl function
    # let (windschitl_arg) = Double_to_Fix(Double (15, 0))
    # %{
    #     print (' Windschitl arg:')
    # %}
    # show_Fix(windschitl_arg)
    # let (windschitl_res) = Special_functions_windschitl (windschitl_arg)
    # %{
    #     print ('TEST LogGamma Windschitl result:')
    # %}
    # show_Fix(windschitl_res)
    # # -----------------------------------------------------------------------

    # -----------------------------------------------------------------------    
    # TEST 3: set the value for the arg of the lanczos function
    let (lanczos_arg) = Double_to_Fix(Double (15, 0))
    %{
        print (' Lanczos arg:')
    %}
    show_Fix(lanczos_arg)
    let (lanczos_res) = Special_functions_lanczos (lanczos_arg)
    %{
        print ('TEST LogGamma Lanczos result:')
    %}
    show_Fix(lanczos_res)
    # -----------------------------------------------------------------------
    %{
        import time
        ts_f = time.time() - ts_0
        print (f' -------------------------------------')
        print(' CLOSING TIME FOR TEST:', ts_f, 'seconds\n')
    %}   
    return ()
end
