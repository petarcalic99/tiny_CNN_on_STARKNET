%lang starknet

from src.CL_0 import convSum
from src.CL_0 import snapShot
from src.CL_0 import FlattenedMatrix
from src.CL_0 import cnLayer
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.alloc import alloc

#Function that fills up a Matrix
func fill(n : felt, cpt : felt, i : felt, tab : FlattenedMatrix):
    if cpt == n:
        return()
    end

    assert tab.data[cpt] = i
    fill(n, cpt+1, i+1 , tab)
    return()
    end

@external
func test_convSum():
    alloc_locals
    let (ptr) = alloc()
    let (ptr2) = alloc()

    local image : FlattenedMatrix = FlattenedMatrix(data = ptr, num_rows = 5, num_cols = 5)
    fill(25,0,1,image)

    local kernel : FlattenedMatrix = FlattenedMatrix(data = ptr2, num_rows = 5, num_cols = 5)
    fill(25,0,1,kernel)
    #######################
    let r = image.num_rows
    assert 5 = r

    let d = image.data  
    let k = kernel.data
    assert 1 = d[0]
    assert 25 = d[24]
    assert 4 = k[3]

    ##################### 
    let (test_convSum) = convSum(kernel, image, 0)
    assert 5525 = test_convSum  #sum(i**2) for i 0-25

    return ()
end


@external
func test_snapShot():           
    alloc_locals

    let (ptr) = alloc()
    local wholeImage : FlattenedMatrix = FlattenedMatrix(data = ptr, num_rows = 28, num_cols = 28)
    fill(748,0,1,wholeImage)

    let a = wholeImage.data[0]
    assert 1 = a
    let b = wholeImage.data[500]
    assert 501 = b
    let c = wholeImage.data[743]
    assert 744 = c

    #######################################
    let snap : FlattenedMatrix = snapShot(wholeImage, 0, 0)
    assert 29 = snap.data[5]   #6th square   
    assert 33 = snap.data[9]   #10th square  
    assert 57 = snap.data[10]   #11th square  
    assert 117 = snap.data[24]   #25th square
    #assert 0 = snap.data[25]   #26th square    Should be out of bound!

    return()
end


@external
func test_cn_Layer():
    alloc_locals

    let (ptr) = alloc()
    let (ptr2) = alloc()

    local wholeImage : FlattenedMatrix = FlattenedMatrix(data = ptr, num_rows = 28, num_cols = 28)
    fill(748,0,1,wholeImage)

    local kernel : FlattenedMatrix = FlattenedMatrix(data = ptr2, num_rows = 5, num_cols = 5)
    fill(25,0,1,kernel)

    let cnl : FlattenedMatrix = cnLayer(wholeImage, kernel)

    #assert 25 = cnl.data[0]
    
    return()
end