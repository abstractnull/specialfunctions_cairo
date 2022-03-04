#
# ---------------- TESTS ---------------- 
# 

# TODO: Generalized Test Frame
func test_iterate_factorial {range_check_ptr} (x: felt):
    alloc_locals
    if x == 0:
        return ()
    end
    test_iterate_factorial (x - 1)
    let (fix_x) = Fix_64x61 (x)
    let (local fact_x) = SmallMath_fact (fix_x)
    %{
        print(f' Factorial of', ids.x, '=', ids.fact_x/ids.SmallMath_ONE) 
    %}
    return ()
end

func test_iterate_sqrt_PI {range_check_ptr}(x: felt, index: felt):
    alloc_locals
    if index == x:
        return()
    end
    test_iterate_sqrt_PI(x, index + 1)
    tempvar factor = index
    tempvar test_value = SmallMath_sqrt_PI - factor
    let (local sq_test) = SmallMath_mul(test_value, test_value)
    %{
        print (f' ............................................', ids.test_value)
        print (f' SmallMath_PI:', ids.SmallMath_PI)
        print (f' SM_sqrt_PI^2:', ids.sq_test)
        print (f' Difference  :', ids.sq_test - ids.SmallMath_PI)
    %}    
    return()
end