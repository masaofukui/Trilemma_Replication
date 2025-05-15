using Parameters, Setfield

function process_inputs(allinputs,set_functions,leng)
    # Inputs:
    #   allinputs: string of equilibrium variables (e.g., "lC,lPrice,...")
    #   set_functions: array of functions corresponding to each model equations
    #   leng: array specifying the dimension of inputs, outputs, functions, etc.
    # Outputs:
    #   references: array of the number of functions. 
    #               Each element gives nn * 2 matrix, first column specifying the index of the variable, second column specifying the timing relative to t.

    n = Int(length(set_functions));

    @assert (sum(leng["output"].*leng["function"]) == sum(leng["input"])); # of equations = # of unknowns
    references = Any[]

    for i = 1:n
        #println("i=",i)
        # count the number of arguments
        nspec = first(methods(set_functions[i])).nargs-2;

        specinputs = split(arg_name(set_functions[i]),',');

        @assert (length(specinputs) == nspec); # inputs string should include # of function inputs except P
        
        refarray = zeros(Int64,nspec,2);
        
        for j = 1:nspec
            #("i= ",i,", j=",j)
            input = specinputs[j];
            pos = 0;
            inputname = input;
            if length(input) >= 3
                if cmp(input[(end-2):end],"_m1") == 0
                    pos = -1;
                    inputname = input[1:(end-3)];
                elseif cmp(input[(end-2):end],"_p1") == 0
                    pos = 1;
                    inputname = input[1:(end-3)];
                end
            end
            inputplace = findall(cmp.(inputname,allinputs) .== 0);
            @assert (length(inputplace) == 1); # should be exactly one match of input name in master list of inputs
            refarray[j,1] = inputplace[1];
            refarray[j,2] = pos;
        end
        push!(references,refarray);
    end
    
    return references
end



function system_solve(ss0,ss1,references,P,set_functions,T,leng; trate = 0.06, xguess = 0)
    
    n = sum(leng["input"]);
    @assert (n == length(ss0));
    
    # start by assuming convergence from ss0 to ss1 within first Tconv
    mixes = ((1+trate).^(-(1:T)));
    if xguess != 0
        xfull = copy(xguess)
    else
        xfull = mixes*ss0'+(1 .-mixes)*ss1';
    end
    
    count = 0;
    maxcount = 100;
    
    Jdims = (T*n,T*n);


    
    while count < maxcount
        count = count+1
        J = zeros(T*n,T*n);
        
        # construct input matrix from xfull
        xfull_lag  = [ss0'; xfull[1:end-1,:]];
        #xfull_lead = [xfull[2:end,:]; ss1'];
        if P["solve_terminal"] == 1
            xfull_lead = [xfull[2:end,:];xfull[end,:]'];
        else
            xfull_lead = [xfull[2:end,:];ss1'];
        end

        input_mat = zeros(T,n,3);
        input_mat[:,:,1] = xfull_lag;
        input_mat[:,:,2] = xfull;
        input_mat[:,:,3] = xfull_lead;
        
        outputs,ders = all_computations(input_mat,references,P,set_functions,leng);
        
        
        sum(ders,dims = 4)
        
        
        
        errors = maximum(abs.(outputs))
        error = maximum(errors)
        println("Error = ", error)

        if error < 1E-10 || (P["first_order"]==1 && count==2);
            break;
        end

        
        # assemble Jacobian piece by piece!
        # 'i' is index of condition, 'j' is index of variable
        for i = 1:n
            for j = 1:n
                indices_lag = Base._sub2ind(Jdims,(((i-1)*T+2):(i*T)),(((j-1)*T+1):(j*T-1)));
                indices = Base._sub2ind(Jdims,(((i-1)*T+1):(i*T)),(((j-1)*T+1):(j*T)));
                indices_lead = Base._sub2ind(Jdims,(((i-1)*T+1):(i*T-1)),(((j-1)*T+2):(j*T)));
                
                J[indices_lag] = J[indices_lag] + ders[2:T,i,j,1];
                J[indices] = J[indices]+ ders[1:T,i,j,2];
                J[indices_lead] = J[indices_lead] + ders[1:(T-1),i,j,3];

                #J[indices[end]] =  J[indices[end]] + ders[(T-1),i,j,3] ;
            end
        end

        
        

        yvec = outputs[:];

        J = sparse(J)

        xupdate = - J \ yvec;

        xupdate = reshape(xupdate,T,n);
        xfull = xfull + xupdate;
    end
    @assert count < maxcount

    return xfull
end



function myeval(P,curfunc,allinputs_t)
    output = curfunc(P,allinputs_t...);
    return output
end

 
function myeval_vec(P,curfunc,leng,refarray,x)
    allinputs_t_tuple = tuple()
    start_index = 0;
    for j = axes(refarray,1)
        ll = leng["input"][refarray[j,1]]
        extract_index = start_index .+ (1:ll)
        allinputs_t_temp = x[extract_index]
        allinputs_t_tuple = tuple(allinputs_t_tuple...,allinputs_t_temp)
        start_index += ll;
    end
    temp_eval = curfunc(P,allinputs_t_tuple...);
    return temp_eval
end


function all_computations(input_mat,references,P,set_functions,leng;ss=0)
    # Input:
    #   input_mat: 
    #           1st dim: time
    #           2nd dim: dimension of input vairables, has to be the same as the number of output
    #           3rd dim: time index relative to t (_m1, 0, _p1)
    # Output:
    #   ders: evaluation of Jacobians.
    #           1st dim: time
    #           2nd dim: number of output (number of model equations * output of each equation)
    #           3rd dim: dimension of input vairables, has to be the same as the number of output
    #           4th dim: time index relative to t (_m1, 0, _p1)
    #   outputs: evaluation of model equations given input_mat
    #           1st dim: time
    #           2nd dim: number of output (number of model equations * output of each equation)
    
    allfunctions = set_functions;
    
    h = 1e-5;
    T = size(input_mat,1);      # number of time periods doing this for
    n = length(allfunctions);

    noutput = sum(leng["function"].*leng["output"])

    # should have full list of functions, matching size of "references" AND
    # matching second dimension of input matrix (# of eqs = # of unknowns)
    @assert (noutput == size(input_mat,2))
    @assert (length(references) == sum(leng["function"]))
    @assert (size(input_mat,3) == 3) # should have one lag and one lead
    
    outputs = zeros(T,noutput);
    ders = zeros(T,noutput,noutput,3);
    
    # go through each function and find the derivative at these inputs!
    for i = 1:n
        #println(i)
        curfunc = allfunctions[i];
        refarray = references[i];


        all_index,all_pos =  convert_index(refarray,leng)

        linearindices = Base._sub2ind((noutput, 3),all_index,all_pos);
        ninputs = size(refarray,1)
        for t = 1:T
            temp = input_mat[t,:,:];
            temp = temp[:]
            
            allinputs_t = temp[linearindices]

           #=
            allinputs_t_tuple = tuple()
            start_index = 0;
            for j = 1:ninputs
                ll = leng["input"][refarray[j,1]]
                extract_index = start_index .+ (1:ll)
                allinputs_t_temp = allinputs_t[extract_index]
                allinputs_t_tuple = tuple(allinputs_t_tuple...,allinputs_t_temp)
                start_index += ll;
            end
            =#
           
           


            # shock!
            #P[Shock_Var] = Shock_Path[t];
            # in the final period, set Q =0
            if ss == 1
                P["ss"] = 1;
                P["t"] = 0;
            else
                P["ss"] = 0;
                P["t"] = t;
            end
            
            #println(i)
            #temp_eval = myeval(P,curfunc,allinputs_t_tuple)
            temp_eval = myeval_vec(P,curfunc,leng,refarray,allinputs_t)
            @assert length(temp_eval) == leng["out_func"][i]
            if i == 1
                output_index = 1:leng["out_func"][i]
            else
                start_index = sum(leng["out_func"][1:(i-1)])
                output_index = start_index .+ (1:leng["out_func"][i])
            end
            outputs[t,output_index] .= temp_eval

            #println(i,t)
            if P["autodiff"] == 1
                Derivative_mat = ForwardDiff.jacobian(x-> myeval_vec(P,curfunc,leng,refarray,x),allinputs_t)

                for ipos = 1:3
                    # ipos = 1 for _m1; ipos = 2 for 0; ipos = 3 for _p1
                    derivative_indices = all_index[all_pos .== ipos]
                    set_pos = (all_pos .==ipos)
                    if abs(sum(set_pos)) > 0
                        all_indices = 1:length(all_pos)
                        subset_indices = all_indices[set_pos]
                        ders[t,output_index,derivative_indices,ipos] .= Derivative_mat[:,subset_indices]
                    end
                end

            elseif  P["autodiff"] == 0
                allinputs_idx = 0;
                # obtain gradient by going through each input and taking partial
                for j = 1:ninputs
                    for ic = 1:leng["input"][refarray[j,1]]
                        allinputs_idx +=1
                        
                        #allinputs_high = deepcopy(allinputs_t_tuple)
                        #allinputs_low  = deepcopy(allinputs_t_tuple)
                        #allinputs_high[j][ic] = allinputs_high[j][ic] + h;
                        #allinputs_low[j][ic] = allinputs_low[j][ic] - h;
                        
                        #derivatives = (myeval(P,curfunc,allinputs_high) .- myeval(P,curfunc,allinputs_low))/(2*h);
                        #derivatives = (myeval(P,curfunc,allinputs_high) .- temp_eval )/(h);
                        allinputs_t_high = copy(allinputs_t)
                        allinputs_t_high[allinputs_idx] = allinputs_t[allinputs_idx] + h
                        derivatives = (myeval_vec(P,curfunc,leng,refarray,allinputs_t_high) .- temp_eval )/(h);
                    

                        if refarray[j,1] == 1
                            start_c = 0;
                        else
                            start_c = sum(leng["input"][1:(refarray[j,1]-1)])
                        end
                        cindex = Int64( start_c .+ ic );
                        cpos = Int64( refarray[j,2] + 2 );

                        ders[t,output_index,cindex,cpos] .= copy(derivatives);
                        #end
                    end
                end
            end
        end
        
        
       
    end

    return outputs,ders
end


function convert_index(refarray,leng)
    # Input:
    #   refarray: nn * 2 matrix as input of each model equation;
    #             first column specifies the variable, second column specifies the time relative to t
    # Output:
    #   all_index: vector of all inputs 
    #   all_pos: 
    
    leng_input = leng["input"]
    all_index = zeros(sum(leng_input[refarray[:,1]]))
    all_pos = zeros(sum(leng_input[refarray[:,1]]))
    nn = size(refarray[:,1],1)
    startindex = 0;
    for j = 1:nn
        if refarray[j,1] == 1
            start_c = 0;
        else
            start_c = sum(leng_input[1:(refarray[j,1]-1)])
        end
        cindex =  start_c .+ (1:leng_input[refarray[j,1]]);
        lindex = startindex .+ (1:leng_input[refarray[j,1]])
        all_index[lindex] .= cindex
        all_pos[lindex] .= refarray[j,2] + 2
        startindex += leng_input[refarray[j,1]]
    end
    all_index = Int64.(all_index)
    all_pos = Int64.(all_pos)

    return all_index, all_pos
end


    
function method_argnames(m::Method)
    argnames =           ccall(:jl_uncompress_argnames, Vector{Symbol}, (Any,), m.slot_syms)
    isempty(argnames) && return argnames
    return argnames[1:m.nargs]
end

function arg_name(f)
    ms = collect(methods(f))
    argname_temp = method_argnames(last(ms))[2:end]
    argname_temp = string(argname_temp)
    argname = replace(argname_temp,"[:P," => "" )
    argname = replace(argname," :" => "" )
    argname = replace(argname,"]" => "" )
    return argname
end
