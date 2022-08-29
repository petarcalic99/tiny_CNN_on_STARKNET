#Code by Petar Calic (Ledger innovation lab) inspired by guiltygyoza's dnn

%lang starknet
%builtins pedersen range_check

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.alloc import alloc

#Storage variable that keeps adresses of children contracts it will have to call
@storage_var
func stored_addresses (idx : felt) -> (addr : felt):
end

@external
func admin_store_addresses {
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    } (idx : felt, addr : felt) -> ():
    stored_addresses.write(idx, addr)
    return ()
end


################################################

@contract_interface
namespace IContractCL_0:
    func compute(x_len : felt, x : felt*) -> (res : felt):
    end
end

@contract_interface
namespace IContractCL_1:
    func compute(x_len : felt, x : felt*) -> (res : felt):
    end
end

@contract_interface
namespace IContractCL_2:
    func compute(x_len : felt, x : felt*) -> (res : felt):
    end
end

@contract_interface
namespace IContractCL_3:
    func compute(x_len : felt, x : felt*) -> (res : felt):
    end
end

@contract_interface
namespace IContractCL_4:
    func compute(x_len : felt, x : felt*) -> (res : felt):
    end
end

@contract_interface
namespace IContractCL_5:
    func compute(x_len : felt, x : felt*) -> (res : felt):
    end
end

@contract_interface
namespace IContractCL_6:
    func compute(x_len : felt, x : felt*) -> (res : felt):
    end
end



@view
func compute {
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(
        x_len : felt,
        x : felt*
    ) -> (
        CL_len : felt,
        CL : felt*
    ):
    ### x  : vector 1x784 (28x28)
    ### v1 : vector 1x4032 (7x24x24)

    alloc_locals

    let (local CL) = alloc()

    let (addr_0) = stored_addresses.read(0)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    let (CL_0) = IContractCL_0.compute(addr_0, 784, x)
    assert [CL+0] = CL_0

    let (addr_1) = stored_addresses.read(1)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    let (CL_1) = IContractCL_1.compute(addr_1, 784, x)
    assert [CL+1] = CL_1

    let (addr_2) = stored_addresses.read(2)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    let (CL_2) = IContractCL_2.compute(addr_2, 784, x)
    assert [CL+2] = CL_2

    let (addr_3) = stored_addresses.read(3)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    let (CL_3) = IContractCL_3.compute(addr_3, 784, x)
    assert [CL+3] = CL_3

    let (addr_4) = stored_addresses.read(4)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    let (CL_4) = IContractCL_4.compute(addr_4, 784, x)
    assert [CL+4] = CL_4

    let (addr_5) = stored_addresses.read(5)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    let (CL_5) = IContractCL_5.compute(addr_5, 784, x)
    assert [CL+5] = CL_5

    let (addr_6) = stored_addresses.read(6)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    let (CL_6) = IContractCL_6.compute(addr_6, 784, x)
    assert [CL+6] = CL_6


    let CL_len = 7
    return (CL_len, CL)

end    
