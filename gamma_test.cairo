#simple test of Gamma,integers & half-integers
#TODO migrate to real comprehensive test

from math_libs.special_functions import Special_functions_gamma_half_int

from math_libs.small_math import SmallMath_ONE
from math_libs.small_math import SmallMath_fact
from math_libs.small_math import Fix_64x61

# Testing odd arguments for x. x=3 -> gamma of (3/2) ; x=5 -> gamma of (5/2)
func test_gamma_int {range_check_ptr} (x: felt):
    alloc_locals
    if x == 1:
        return()
    end
    if x == 0:
        return()
    end
    test_gamma_int (x - 2)
    let (local res_half_int) = Special_functions_gamma_half_int(x)
    %{
        txt = ' Gamma of '+ (str) (ids.x) + '/2 = ' + (str) (ids.res_half_int/ids.SmallMath_ONE)
        print (txt)
    %}
    return()
end

func main {range_check_ptr}():
    
    %{
        print (f' -------------------------------------')
        print (f' TEST: Gamma function of half integers')
    %}
    test_gamma_int(19)
    %{
        print (f' -------------------------------------')
    %}
    return ()
end