#!/usr/bin/env julia
#GSL Julia wrapper
#(c) 2013 Jiahao Chen <jiahao@mit.edu>
####################################
# 6.5 General Polynomial Equations #
####################################

export roots

function roots{T<:Real}(c::Vector{T}, realOnly::Bool)
    n = length(c)
    a = convert(Vector{Cdouble}, c)
    if n==0
        return nothing #No solution
    elseif n==1
        gsl_poly_solve_quadratic(0.0, a[2], a[1])
    elseif n==2
        if realOnly
            gsl_poly_solve_quadratic(a[3], a[2], a[1])
        else
            gsl_poly_complex_solve_quadratic(a[3], a[2], a[1])
        end
    elseif n==3
        if realOnly
            gsl_poly_solve_cubic(a[3]/a[4], a[2]/a[4], a[1]/a[4])
        else
            gsl_poly_complex_solve_cubic(a[3]/a[4], a[2]/a[4], a[1]/a[4])
        end
    else #Use general solver
        w = gsl_poly_complex_workspace_alloc(n)
        z = gsl_poly_complex_solve(a, n, w)
        gsl_poly_complex_workspace_free(w)
        gsl_complex_packed_ptr(z)
    end
end

roots{T<:Real}(c::Vector{T}) = roots{T}(c, false) #By default, all complex roots


export gsl_poly_complex_workspace_alloc, gsl_poly_complex_workspace_free,
       gsl_poly_complex_solve


# This function allocates space for a gsl_poly_complex_workspace struct and a
# workspace suitable for solving a polynomial with n coefficients using the
# routine gsl_poly_complex_solve.          The function returns a pointer to
# the newly allocated gsl_poly_complex_workspace if no errors were detected,
# and a null pointer in the case of error.
# 
#   Returns: Ptr{Void}
function gsl_poly_complex_workspace_alloc(n::Integer)
    ccall( (:gsl_poly_complex_workspace_alloc, "libgsl"), Ptr{Void},
        (Csize_t, ), n )
end


# This function frees all the memory associated with the workspace w.
# 
#   Returns: Void
function gsl_poly_complex_workspace_free (w::Ptr{Void})
    ccall( (:gsl_poly_complex_workspace_free, "libgsl"), Void, (Ptr{Void},
        ), w )
end


# This function computes the roots of the general polynomial  P(x) = a_0 + a_1
# x + a_2 x^2 + ... + a_{n-1} x^{n-1} using balanced-QR reduction of the
# companion matrix.  The parameter n specifies the length of the coefficient
# array.  The coefficient of the highest order term must be non-zero.  The
# function requires a workspace w of the appropriate size.  The n-1 roots are
# returned in the packed complex array z of length 2(n-1), alternating real and
# imaginary parts.          The function returns GSL_SUCCESS if all the roots
# are found. If the QR reduction does not converge, the error handler is
# invoked with an error code of GSL_EFAILED.  Note that due to finite
# precision, roots of higher multiplicity are returned as a cluster of simple
# roots with reduced accuracy.  The solution of polynomials with higher-order
# roots requires specialized algorithms that take the multiplicity structure
# into account (see e.g. Z. Zeng, Algorithm 835, ACM Transactions on
# Mathematical Software, Volume 30, Issue 2 (2004), pp 218–236).
# 
#   Returns: Cint
function gsl_poly_complex_solve{T<:Real}(a::Vector{T}, n::Integer, w::Ptr{Void})
    z=zeros(2n-2)
    a=convert(Array{Cdouble}, a)
    ccall( (:gsl_poly_complex_solve, "libgsl"), Cint, (Ptr{Cdouble},
        Csize_t, Ptr{Void}, Ptr{Void}), a, n, w, z )
    return z    
end
