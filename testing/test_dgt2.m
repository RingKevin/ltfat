function test_failed=test_dgt2

test_failed=0;
  
disp(' ===============  TEST_DGT2 ================');

% Run some fixed test to test the interface.
% This is not a thourough tester.

% --- first test

a=6;
M=8;

Lf=71;
L=72;
W=3;

f=rand(Lf,Lf,W);

g=pgauss(L,a*M/L);
gd=gabdual(g,a,M);

[c,Ls]=dgt2(f,g,a,M);
r=idgt2(c,gd,a,Ls);

res=f-r;
nres=norm(res(:));

failed='';
if nres>10e-10
  failed='FAILED';
  test_failed=test_failed+1;
end;

s=sprintf('DGT2 Lf:%3i L:%3i %0.5g %s',Lf,L,nres,failed);
disp(s)


% --- second test

a1=6;
M1=8;

a2=5;
M2=10;

L1=a1*M1;
L2=a2*M2;

W=1;

f=rand(L1,L2,W);

g1=pgauss(L1,a1*M1/L1);
g2=pgauss(L2,a2*M2/L2);

gd1=gabdual(g1,a1,M1);
gd2=gabdual(g2,a2,M2);

c=dgt2(f,g1,g2,[a1,a2],[M1,M2]);
c2=ref_dgt2(f,g1,g2,a1,a2,M1,M2);

rc=c-c2;
nres=norm(rc(:));

failed='';
if nres>10e-10
  failed='FAILED';
  test_failed=test_failed+1;
end;

s=sprintf('DGT2 REF L1:%3i L2:%3i %0.5g %s',L1,L2,nres,failed);
disp(s)


r=idgt2(c,gd1,gd2,[a1,a2]);

res=r-f;

nres=norm(res(:));

failed='';
if nres>10e-10
  failed='FAILED';
  test_failed=test_failed+1;
end;

s=sprintf('DGT2 INV L1:%3i L2:%3i %0.5g %s',L1,L2,nres,failed);
disp(s)
