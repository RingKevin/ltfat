LIBLTFAT -- Backend library of LTFAT
------------------------------------

This is a standalone backend library of LTFAT.

Dependencies
------------

The library depends on FFTW, BLAS and LAPACK. On Ubuntu, just run
```
sudo apt-get install libfftw3-dev libblas-dev liblapack-dev
```
followed by
```
make
```

There are three target libraries (static and shared versions)
* build/libltfat.a(.so)   Contains double and single prec. versions of the functions
* build/libltfatd.a(.so)  Just double prec. versions of the functions
* build/libltfatf.a(.so)  Just single prec. versions of the functions

The dependency on BLAS and LAPACK can be disabled by calling
```
make NOBLASLAPACK=1
```



