# 5. Window, and overlap-add the data into the output stream:

5. Window, and overlap-add the data into the output stream:
kWin[] window kRow, krow*ihop
kOut setrow kWin, krow
kOla = 0
kk = 0
until kk == iolaps do
kRow getrow kOut, kk
kOla = kOla + kRow
kk += 1
od
