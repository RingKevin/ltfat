function outsig=franaadj(F,insig);
%FRANAADJ  Adjoint frame transform operator
%   Usage: f=franaadj(F,c);
%
%   `f=franaadj(F,c)` applies the adjoint operator of the frame transform
%   operator |frana|_ of *F* to the coefficients *c*. The frame object *F*
%   must have been created using |newframe|_.
%
%   The adjoint operator is often used in iterative algorithms.
%
%   See also: newframe, frana, frsyn
  
if nargin<2
  error('%s: Too few input parameters.',upper(mfilename));
end;

if ~isstruct(F)
  error('%s: First agument must be a frame definition structure.',upper(mfilename));
end;

switch(F.type)
 case 'gen'
  outsig=F.ga*insig;
  
 case 'dgt'
  [MN,W]=size(insig);
  N=MN/F.M;
  insig=reshape(insig,[F.M,N,W]);
  outsig=idgt(insig,F.ga,F.a);
  
 case 'dgtreal'
  [MN,W]=size(insig);
  M2=floor(F.M/2)+1;
  N=MN/M2;
  insig=reshape(insig,[M2,N,W]);
  outsig=idgtreal(insig,F.ga,F.a,F.M);
  
 case 'dwilt'
  [MN,W]=size(insig);
  N=MN/F.M;
  insig=reshape(insig,[2*F.M,N/2,W]);
  outsig=idwilt(insig,F.ga);
  
 case 'wmdct'
  [MN,W]=size(insig);
  N=MN/F.M;
  insig=reshape(insig,[F.M,N,W]);
  outsig=iwmdct(insig,F.ga);
  
 case {'dcti','dctiv','dsti','dstiv'}
  outsig=feval(F.type,insig);
  
 case 'ufilterbank'
  [MN,W]=size(insig);
  N=MN/F.M;
  insig=reshape(insig,[N,F.M,W]);
  outsig=ifilterbank(insig,F.ga,F.a);   

 case 'dctii'
  outsig=dctiii(insig);
 case 'dctiii'
  outsig=dctii(insig);
 case 'dstii'
  outsig=dstiii(insig);
 case 'dstiii'
  outsig=dstii(insig);
 case 'dft'
  outsig=idft(insig);
 case 'fft'
  L=size(insig,1);
  outsig=ifft(insig)*L;
 case 'fftreal'
  outsig=ifftreal(insig,F.L)*F.L;
end;

  