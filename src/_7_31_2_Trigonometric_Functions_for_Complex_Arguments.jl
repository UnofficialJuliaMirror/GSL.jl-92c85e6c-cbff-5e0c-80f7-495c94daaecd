#!/usr/bin/env julia
#GSL Julia wrapper
#(c) 2013 Jiahao Chen <jiahao@mit.edu>
########################################################
# 7.31.2 Trigonometric Functions for Complex Arguments #
########################################################
export sf_complex_sin_e, sf_complex_cos_e, sf_complex_logsin_e


# This function computes the complex sine, \sin(z_r + i z_i) storing the real
# and imaginary parts in szr, szi.
# 
#   Returns: Cint
function sf_complex_sin_e(zr::Real, zi::Real)
    szr = Ptr{gsl_sf_result}()
    szi = Ptr{gsl_sf_result}()
    errno = ccall( (:gsl_sf_complex_sin_e, libgsl), Cint, (Cdouble,
        Cdouble, Ptr{gsl_sf_result}, Ptr{gsl_sf_result}), zr, zi, szr, szi )
    if errno!= 0 throw(GSL_ERROR(errno)) end
    return unsafe_load(szr), unsafe_load(szi)
end
@vectorize_2arg Number sf_complex_sin_e


# This function computes the complex cosine, \cos(z_r + i z_i) storing the real
# and imaginary parts in czr, czi.
# 
#   Returns: Cint
function sf_complex_cos_e(zr::Real, zi::Real)
    czr = Ptr{gsl_sf_result}()
    czi = Ptr{gsl_sf_result}()
    errno = ccall( (:gsl_sf_complex_cos_e, libgsl), Cint, (Cdouble,
        Cdouble, Ptr{gsl_sf_result}, Ptr{gsl_sf_result}), zr, zi, czr, czi )
    if errno!= 0 throw(GSL_ERROR(errno)) end
    return unsafe_load(czr), unsafe_load(czi)
end
@vectorize_2arg Number sf_complex_cos_e


# This function computes the logarithm of the complex sine, \log(\sin(z_r + i
# z_i)) storing the real and imaginary parts in lszr, lszi.
# 
#   Returns: Cint
function sf_complex_logsin_e(zr::Real, zi::Real)
    lszr = Ptr{gsl_sf_result}()
    lszi = Ptr{gsl_sf_result}()
    errno = ccall( (:gsl_sf_complex_logsin_e, libgsl), Cint, (Cdouble,
        Cdouble, Ptr{gsl_sf_result}, Ptr{gsl_sf_result}), zr, zi, lszr, lszi )
    if errno!= 0 throw(GSL_ERROR(errno)) end
    return unsafe_load(lszr), unsafe_load(lszi)
end
@vectorize_2arg Number sf_complex_logsin_e
