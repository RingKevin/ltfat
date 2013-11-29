#ifndef _LTFAT_MEX_FILE
#define _LTFAT_MEX_FILE

#define ISNARGINEQ 4
#define TYPEDEPARGS 0, 1
#define SINGLEARGS
#define COMPLEXINDEPENDENT

#endif // _LTFAT_MEX_FILE - INCLUDED ONCE

#define MEX_FILE __BASE_FILE__
#include "ltfat_mex_template_helper.h"

#if defined(LTFAT_SINGLE) || defined(LTFAT_DOUBLE)
#include "ltfat_types.h"

// Calling convention:
//  comp_dgt_fb(f,g,a,M);

void LTFAT_NAME(ltfatMexFnc)( int nlhs, mxArray *plhs[],int nrhs, const mxArray *prhs[] )
{
   int L  = mxGetM(prhs[0]);
   int W  = mxGetN(prhs[0]);
   int gl = mxGetNumberOfElements(prhs[1]);

   int a=(int)mxGetScalar(prhs[2]);
   int M=(int)mxGetScalar(prhs[3]);

   int N=L/a;

   mwSize ndim=3;
   if (W==1)
   {
      ndim=2;
   }

   mwSize dims[3] = {M, N, W};
   plhs[0] = ltfatCreateNdimArray(ndim,dims,LTFAT_MX_CLASSID,mxCOMPLEX);
   const LTFAT_TYPE* f_combined = (const LTFAT_TYPE*) mxGetData(prhs[0]);
   const LTFAT_TYPE* g_combined = (const LTFAT_TYPE*) mxGetData(prhs[1]);
   LTFAT_COMPLEX* out_combined = (LTFAT_COMPLEX*) mxGetData(plhs[0]);

   if(gl<L)
   {
      LTFAT_NAME(dgt_fb)(f_combined, g_combined,L,gl,W,a,M,out_combined);
   }
   else
   {
      LTFAT_NAME(dgt_long)(f_combined, g_combined,L,W,a,M,out_combined);
   }
}
#endif
