#include "config.h"
#include "ltfat.h"
#include "ltfat_types.h"

#define CH(name) LTFAT_COMPLEXH_NAME(name)

#define PREPROC_REAL \
  for (int n=0;n<N*W;n+=2) \
  { \
     pcoef2[0]=pcoef[0]; \
\
     for (int m=1;m<M;m+=2) \
     { \
        pcoef2[m] = -I*scalconst*(pcoef[m]); \
        pcoef2[m+coef2_ld] = scalconst*(pcoef[m+M]); \
     } \
 \
     for (int m=2;m<M;m+=2) \
     { \
        pcoef2[m] = scalconst*(pcoef[m]); \
        pcoef2[m+coef2_ld] = -I*scalconst*(pcoef[m+M]); \
     } \
 \
     pcoef2[M+nyquestadd] = pcoef[M]; \
     pcoef+=2*M; \
     pcoef2+=2*coef2_ld; \
  }

#define PREPROC_COMPLEX \
  for (int n=0;n<N*W;n+=2) \
  { \
     pcoef2[0] = pcoef[0]; \
 \
     for (int m=1;m<M;m+=2) \
     { \
        pcoef2[m] = -I*scalconst*pcoef[m]; \
        pcoef2[M2-m] = I*scalconst*pcoef[m]; \
        pcoef2[M2+m] =  scalconst*pcoef[m+M]; \
        pcoef2[M4-m] = scalconst*pcoef[m+M]; \
     } \
 \
     for (int m=2;m<M;m+=2) \
     { \
        pcoef2[m] = scalconst*pcoef[m]; \
        pcoef2[M2-m] = scalconst*pcoef[m]; \
        pcoef2[M2+m] =  -I*scalconst*pcoef[m+M]; \
        pcoef2[M4-m] = I*scalconst*pcoef[m+M]; \
     } \
 \
     pcoef2[M+nyquestadd] = pcoef[M]; \
     pcoef+=M2; \
     pcoef2+=M4; \
  }


LTFAT_EXTERN void
LTFAT_NAME_COMPLEX(idwilt_long)(const LTFAT_COMPLEX *c, const LTFAT_COMPLEX *g,
			   const int L, const int W, const int M,
			   LTFAT_COMPLEX *f)
{
   const int N=L/M;
   const int M2=2*M;
   const int M4=4*M;
   const LTFAT_REAL scalconst = 1.0/sqrt(2.0);

   LTFAT_COMPLEX *coef2 = (LTFAT_COMPLEX*)ltfat_calloc(2*M*N*W,sizeof(LTFAT_COMPLEX));

  const int nyquestadd = (M%2)*M2;

  LTFAT_COMPLEX *pcoef  = c;
  LTFAT_COMPLEX *pcoef2 = coef2;

  PREPROC_COMPLEX

  LTFAT_NAME(idgt_long)(coef2, g, L, W, M, 2*M, f);

  ltfat_free(coef2);

}

LTFAT_EXTERN void
LTFAT_NAME_REAL(idwilt_long)(const LTFAT_REAL *c, const LTFAT_REAL *g,
			   const int L, const int W, const int M,
			   LTFAT_REAL *f)
{
   const int N=L/M;
   const int coef2_ld = M+1;
   const LTFAT_REAL scalconst = 1.0/sqrt(2.0);
   const int nyquestadd = (M%2)*coef2_ld;

   LTFAT_COMPLEX *coef2 = (LTFAT_COMPLEX*)ltfat_calloc((M+1)*N*W,sizeof(LTFAT_COMPLEX));

  LTFAT_REAL *pcoef  = c;
  LTFAT_COMPLEX *pcoef2 = coef2;

  PREPROC_REAL

  LTFAT_NAME(idgtreal_long)(coef2, g, L, W, M, 2*M, f);

  ltfat_free(coef2);

}

LTFAT_EXTERN void
LTFAT_NAME_COMPLEX(idwilt_fb)(const LTFAT_COMPLEX *c, const LTFAT_COMPLEX *g,
			    const Lint L, const Lint gl, const Lint W, const Lint M,
			   LTFAT_COMPLEX *f)
{
   const int N=L/M;
   const int M2=2*M;
   const int M4=4*M;
   const LTFAT_REAL scalconst = 1.0/sqrt(2.0);

   LTFAT_COMPLEX *coef2 = (LTFAT_COMPLEX*)ltfat_calloc(2*M*N*W,sizeof(LTFAT_COMPLEX));

  const int nyquestadd = (M%2)*M2;

  LTFAT_COMPLEX *pcoef  = c;
  LTFAT_COMPLEX *pcoef2 = coef2;

  PREPROC_COMPLEX

  LTFAT_NAME(idgt_fb)(coef2, g, L, gl, W, M, 2*M, f);

  ltfat_free(coef2);

}

LTFAT_EXTERN void
LTFAT_NAME_REAL(idwilt_fb)(const LTFAT_REAL *c, const LTFAT_REAL *g,
			   const Lint L, const Lint gl, const Lint W, const Lint M,
			   LTFAT_REAL *f)
{
   const Lint N = L/M;
   const Lint coef2_ld = M + 1;
   const Lint nyquestadd = (M%2)*coef2_ld;
   const LTFAT_REAL scalconst = (LTFAT_REAL) 1.0/sqrt(2.0);

   LTFAT_COMPLEX *coef2 = (LTFAT_COMPLEX*)ltfat_calloc((M+1)*N*W,sizeof(LTFAT_COMPLEX));

   LTFAT_REAL* pcoef  = c;
   LTFAT_COMPLEX* pcoef2 = coef2;

   PREPROC_REAL

   LTFAT_NAME(idgtreal_fb)(coef2, g, L, gl, W, M, 2*M, f);

   ltfat_free(coef2);
}

#undef CH
#undef PREPROC_REAL
#undef PREPROC_COMPLEX

