function test_failed=test_dgt_fb
%TEST_DGT_FB  Test the filter bank algorithms in DGT
%
%  This script runs a throrough test of the DGT routine,
%  testing it on a range of input parameters.
%
%  The script test the filter bank algorithms in DGT, IDGT, GABDUAL and
%  GABTIGHT by comparing with the full window case.
%
%  The computational backend is tested this way, but the
%  interfaces is not.
      
Lr  = [24, 35, 35, 24,144,108,144,135,77,77];
ar  = [ 6,  5,  5,  4,  9,  9, 12,  9, 7, 7];
Mr  = [ 8,  7,  7,  6, 16, 12, 24,  9,11,11];
glr = [16, 14, 21, 12, 48, 12, 24, 18,22,11];

test_failed=0;

disp(' ===============  TEST_DGT_FB ================');

disp('--- Used subroutines ---');

which comp_dgt_fb
which comp_idgt_fb


for ii=1:length(Lr);

  L=Lr(ii);
  
  M=Mr(ii);
  a=ar(ii);
  gl=glr(ii);

  b=L/M;
  N=L/a;
  

  for rtype=1:2
          
    if rtype==1
      rname='REAL ';	
      g=rand(gl,1);
    else
      rname='CMPLX';	
      g=crand(gl,1);
    end;
    
    % Test following test only makes sense if the dual is also
    % FIR. Otherwise the code will fail because of a missing parameter.
    if gl<=M
      gd = gabdual(g,a,M);
      gd_long = gabdual(fir2long(g,L),a,M,L);
      res = norm(fir2long(gd,L)-gd_long);
      [test_failed,fail]=ltfatdiditfail(res,test_failed);
      s=sprintf('DUAL  %s L:%3i a:%3i M:%3i gl:%3i %0.5g %s',rname,L,a,M,gl,res,fail);
      disp(s)
      
      gt = gabtight(g,a,M);    
      gt_long = gabtight(fir2long(g,L),a,M,L);
            
      res = norm(fir2long(gt,L)-gt_long);
      [test_failed,fail]=ltfatdiditfail(res,test_failed);
      s=sprintf('TIGHT %s L:%3i a:%3i M:%3i gl:%3i %0.5g %s',rname,L,a,M,gl,res,fail);
      disp(s)
    end;

    for W=1:3
                
      if rtype==1
	rname='REAL ';	
	f=rand(L,W);
      else
	rname='CMPLX';	
	f=crand(L,W);
      end;
      
      cc  = dgt(f,g,a,M);  
      cc2 = dgt(f,fir2long(g,L),a,M);
      
      cdiff=cc-cc2;
      res=norm(cdiff(:));      
      [test_failed,fail]=ltfatdiditfail(res,test_failed);
      s=sprintf('REF  %s L:%3i W:%2i a:%3i M:%3i gl:%3i %0.5g %s',rname,L,W,a,M,gl,res,fail);
      disp(s)


      f1   = idgt(cc2,g,a);  
      f2   = idgt(cc2,fir2long(g,L),a);
      
      cdiff=f1-f2;
      res=norm(cdiff(:));      
      [test_failed,fail]=ltfatdiditfail(res,test_failed);
      s=sprintf('IREF %s L:%3i W:%2i a:%3i M:%3i gl:%3i %0.5g %s',rname,L,W,a,M,gl,res,fail);
      disp(s)

      % Test the real valued transform
      if rtype==1
        
        % --- Reference test ---
        ccreal=dgtreal(f,g,a,M);
        M2=floor(M/2)+1;
        
        cdiff=cc(1:M2,:,:)-ccreal;
        res=norm(cdiff(:));
        [test_failed,fail]=ltfatdiditfail(res,test_failed);
        s=sprintf('REFREAL    L:%3i W:%2i a:%3i M:%3i gl:%3i %0.5g %s',...
                   L,W,a,M,gl,res,fail);
        disp(s);
        
        % --- Reconstruction test ---
        % Test following test only makes sense if the dual is also FIR.
        if gl<=M
          
          rreal=idgtreal(ccreal,gd,a,M);
       
          res=norm(f-rreal,'fro');
          [test_failed,fail]=ltfatdiditfail(res,test_failed);
          s=sprintf('RECREAL    L:%3i W:%2i a:%3i M:%3i gl:%3i %0.5g %s',...
                    L,W,a,M,gl,res,fail);
          disp(s)
        end;
      end;

      
    end;  
    
  end;

end;