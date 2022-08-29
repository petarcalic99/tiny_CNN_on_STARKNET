#This contract has the mission of returning to CL master contract the Feature Map of the first filter.
#available arguments are the filter weights and the 784 pixel vector

%lang starknet
%builtins pedersen range_check

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.alloc import alloc

# @storage_var
# func stored_addresses (idx : felt) -> (addr : felt):
# end

# @external
# func admin_store_addresses {
#         syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
#     } (idx : felt, addr : felt) -> ():
#     stored_addresses.write(idx, addr)
#     return ()
# end

############################################################################

struct FlattenedMatrix:
    member data : felt*
    member num_rows : felt
    member num_cols : felt
end


############################################################################
#Function that does a convolution operation over a 5x5 window of the picture using the Kernel given in input
#TESTED
func convSum(ker : FlattenedMatrix, snap : FlattenedMatrix, cpt : felt) -> (res : felt):
    alloc_locals
    # --- reached last element of the filter ---
    if cpt == 25:
        return(0)
    end     
    
    # --- single multiplication of the two matrix elements (im[i][j] x snap[i][j]) ---
    local filter_element = ker.data[cpt]
    local res = filter_element*snap.data[cpt]

    # --- Recurse over rest of row/vector ---
    let (rest) = convSum(ker = ker, snap = snap, cpt = cpt+1)
    
    # The result is the sum of the multiplications
    return(res + rest)
end    


#function that extracts a window 5x5 form an image
func snapShot(im : FlattenedMatrix, i : felt, j : felt) -> (res : FlattenedMatrix):
    alloc_locals
    let (im_data) = alloc()
    
    local res : FlattenedMatrix = FlattenedMatrix(data=im_data,  num_rows=5, num_cols=5)
    
    local idx = i*im.num_rows + j
    snapShotFill(im, res, idx, j, i, 0)

    return(res)
    end

func snapShotFill(im :FlattenedMatrix, res : FlattenedMatrix, idx: felt, icol : felt, irow : felt, cpt : felt):
#TESTED
    if irow == 5:
        return()
    end

    if icol == 5:
        snapShotFill(im, res, idx + 23, 0, irow + 1, cpt)
        return()
    end

    assert res.data[cpt] = im.data[idx] 
    snapShotFill(im, res, idx + 1, icol + 1, irow, cpt + 1)
    return()

end

####
####

#input image (28x28) and kernel 5x5/// output: 24x24 feature map
func cnLayer(image : FlattenedMatrix, kernel : FlattenedMatrix) -> (res : FlattenedMatrix):
    alloc_locals
    let (res_data) = alloc()
    
    local res : FlattenedMatrix = FlattenedMatrix(data=res_data,  num_rows=24, num_cols=24)
    cnLayerFill(image, kernel, res, 0, 0, 0)

    return(res)
end 

func cnLayerFill(image : FlattenedMatrix, kernel : FlattenedMatrix, res : FlattenedMatrix, icol : felt, irow : felt, cpt : felt):
    if irow == 24:
        return()
    end

    if icol == 24:
        cnLayerFill(image, kernel, res, 0, irow + 1, cpt)
        return()    
    end
    
    let snap : FlattenedMatrix = snapShot(image, irow, icol)
    let (co) = convSum(kernel, snap, 0)
    assert res.data[cpt] = co
    cnLayerFill(image, kernel, res, icol + 1, irow, cpt + 1)

    return()
end