# 1. Convert frequencies in Hz back into phase differences:

1. Convert frequencies in Hz back into phase differences:
while kk < isize/2 do
kFr[kk] = (kFr[kk] - kk*iscal)*ifac
kk += 1
od
