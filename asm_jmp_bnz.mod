module asm_jmp_bnz.

%% map H
lookupEnvH (consEnvH L T EnvH) L T.
lookupEnvH (consEnvH L1 T1 EnvH) L T :- lookupEnvH EnvH L T.

subsetEnvH EnvH EnvH.
subsetEnvH EnvH (consEnvH L T Rest) :- subsetEnvH EnvH Rest.

lookupMapH (consMapH L E MU) L E.
lookupMapH (consMapH L1 E1 MU) L E :- lookupMapH MU L E.

updateMapH (consMapH L E MU) L E' (consMapH L E' MU).
updateMapH (consMapH L1 E1 MU) L E' (consMapH L1 E1 MU') :- updateMapH MU L E' MU'.

%% addMapH nilMapH  E (consMapH zeroLabelH E nilMapH) zeroLabelH.
addMapH (consMapH L E1 MU) E2 (consMapH (succLabelH L) E2 (consMapH L E1 MU)) (succLabelH L). 


%% map R
lookupEnvR (consEnvR L T EnvR) L T.
lookupEnvR (consEnvR L1 T1 EnvR) L T :- lookupEnvR EnvR L T.

subsetEnvR EnvR EnvR.
subsetEnvR EnvR (consEnvR L T Rest) :- subsetEnvR EnvR Rest.

updateEnvR (consEnvR L E MU) L E' (consEnvR L E' MU).
updateEnvR (consEnvR L1 E1 MU) L E' (consEnvR L1 E1 MU') :- updateEnvR MU L E' MU'.

lookupMapR (consMapR L E MU) L E.
lookupMapR (consMapR L1 E1 MU) L E :- lookupMapR MU L E.

updateMapR (consMapR L E MU) L E' (consMapR L E' MU).
updateMapR (consMapR L1 E1 MU) L E' (consMapR L1 E1 MU') :- updateMapR MU L E' MU'.



typeOf Gamma EnvH EnvR (num I) (int).
typeOf Gamma EnvH EnvR (halt) (unitT).

typeOf Gamma EnvH EnvR (add Zd Zs E1 E2) (unitT) :- 
	lookupEnvR EnvR Zd SomeT, 
	lookupEnvR EnvR Zs (int), 
	typeOf Gamma EnvH EnvR E1 (int), 
	typeOf Gamma EnvH EnvR' E2 (unitT),  
	updateEnvR EnvR Zd (int) EnvR'. 

typeOf Gamma EnvH EnvR (mult Zd Zs E1 E2) (unitT) :- 
	lookupEnvR EnvR Zd SomeT, 
	lookupEnvR EnvR Zs (int), 
	typeOf Gamma EnvH EnvR E1 (int), 
	typeOf Gamma EnvH EnvR' E2 (unitT),  
	updateEnvR EnvR Zd (int) EnvR'. 


typeOf Gamma EnvH EnvR (load Zd Zs E) (unitT) :- 
	lookupEnvR EnvR Zd SomeT, 
	lookupEnvR EnvR Zs (refH T), 
	typeOf Gamma EnvH EnvR' E (unitT), 
	updateEnvR EnvR Zd T EnvR'. 

typeOf Gamma EnvH EnvR (malloc Zd E1 E2) (unitT) :- 
	lookupEnvR EnvR Zd SomeT, 
	typeOf Gamma EnvH EnvR E1 T, 
	typeOf Gamma EnvH EnvR' E2 (unitT), 
	updateEnvR EnvR Zd (refH T) EnvR'.

typeOf Gamma EnvH EnvR (move Zd E1 E2) (unitT) :- 
	lookupEnvR EnvR Zd SomeT, 
	typeOf Gamma EnvH EnvR E1 T, 
	typeOf Gamma EnvH EnvR' E2 (unitT), 
	updateEnvR EnvR Zd T EnvR'. 
	

typeOf Gamma EnvH EnvR (store Zd Zs E) (unitT) :- 
	lookupEnvR EnvR Zd (refH T), 
	lookupEnvR EnvR Zs T, 
	typeOf Gamma EnvH EnvR E (unitT). 

typeOf Gamma EnvH EnvR (jmp E) (unitT) :- 
	typeOf Gamma EnvH EnvR E (refH (codeT EnvR)). 

typeOf Gamma EnvH EnvR (bnz Zs E1 E2) (unitT) :- 
	lookupEnvR EnvR Zs (int), 
	typeOf Gamma EnvH EnvR E1 (refH (codeT EnvR)), 
	typeOf Gamma EnvH EnvR E2 (unitT). 

typeOf Gamma EnvH EnvR (code EnvR' E) (codeT EnvR') :- 
	typeOf Gamma EnvH EnvR' E (unitT). 


typeOf Gamma EnvH EnvR (labelH L) (refH T) :- lookupEnvH EnvH L T.

step (add Zd Zs V1 E) H R E H R' :- 
	lookupMapR R Zs V2, 
	addition V1 V2 V3, 
	updateMapR R Zd V3 R',
	value V3. 

step (mult Zd Zs V1 E) H R E H R' :- 
	lookupMapR R Zs V2, 
	multiplication V1 V2 V3, 
	updateMapR R Zd V3 R', 
	value V3.

step (load Zd Zs E) H R E H R' :- 
	lookupMapR R Zs (labelH L), 
	lookupMapH H L V, 
	updateMapR R Zd V R', 
	value V. 

step (malloc Zd V E) H R E H' R' :- 
	addMapH H V H' LNewH, 
	updateMapR R Zd (labelH LNewH) R', 
	value (labelH LNewH). 

step (move Zd V E) H R E H R' :- 
	updateMapR R Zd V R', 
	value V. 

step (store Zd Zs E) H R E H' R :- 
	lookupMapR R Zd (labelH L), 
	lookupMapR R Zs V, 
	updateMapH H L V H'. 

step (jmp (labelH L)) H R E H R :- 
	lookupMapH H L (code EnvR E).

step (bnz Zs (labelH L) E2) H R E1 H R :- 
	lookupMapR R Zs (num i0), 
	lookupMapH H L (code EnvR E1).

step (bnz Zs (labelH L) E) H R E H R :- 
	lookupMapR R Zs (num i1).


value (halt).
value (num I).
value (labelH L).

addition (num i0) (num i0) (num i0).
addition (num i0) (num i1) (num i1).
addition (num i0) (num i2) (num i2).
addition (num i0) (num i3) (num i3).
addition (num i0) (num i4) (num i4).
addition (num i0) (num i5) (num i5).
addition (num i0) (num i6) (num i6).
addition (num i1) (num i0) (num i1).
addition (num i1) (num i1) (num i2).
addition (num i1) (num i2) (num i3).
addition (num i1) (num i3) (num i4).
addition (num i1) (num i4) (num i5).
addition (num i1) (num i5) (num i6).
addition (num i1) (num i6) (num i6).
addition (num i2) (num i0) (num i2).
addition (num i2) (num i1) (num i3).
addition (num i2) (num i2) (num i4).
addition (num i2) (num i3) (num i5).
addition (num i2) (num i4) (num i6).
addition (num i2) (num i5) (num i6).
addition (num i2) (num i6) (num i6).
addition (num i3) (num i0) (num i3).
addition (num i3) (num i1) (num i4).
addition (num i3) (num i2) (num i5).
addition (num i3) (num i3) (num i6).
addition (num i3) (num i4) (num i6).
addition (num i3) (num i5) (num i6).
addition (num i3) (num i6) (num i6).
addition (num i4) (num i0) (num i4).
addition (num i4) (num i1) (num i5).
addition (num i4) (num i2) (num i6).
addition (num i4) (num i3) (num i6).
addition (num i4) (num i4) (num i6).
addition (num i4) (num i5) (num i6).
addition (num i4) (num i6) (num i6).
addition (num i5) (num i0) (num i5).
addition (num i5) (num i1) (num i6).
addition (num i5) (num i2) (num i6).
addition (num i5) (num i3) (num i6).
addition (num i5) (num i4) (num i6).
addition (num i5) (num i5) (num i6).
addition (num i5) (num i6) (num i6).
addition (num i6) (num i0) (num i6).
addition (num i6) (num i1) (num i6).
addition (num i6) (num i2) (num i6).
addition (num i6) (num i3) (num i6).
addition (num i6) (num i4) (num i6).
addition (num i6) (num i5) (num i6).
addition (num i6) (num i6) (num i6).

multiplication(num i0) (num i0) (num i0).
multiplication(num i0) (num i1) (num i0).
multiplication(num i0) (num i2) (num i0).
multiplication(num i0) (num i3) (num i0).
multiplication(num i0) (num i4) (num i0).
multiplication(num i0) (num i5) (num i0).
multiplication(num i0) (num i6) (num i0).
multiplication(num i1) (num i0) (num i0).
multiplication(num i1) (num i1) (num i1).
multiplication(num i1) (num i2) (num i2).
multiplication(num i1) (num i3) (num i3).
multiplication(num i1) (num i4) (num i4).
multiplication(num i1) (num i5) (num i5).
multiplication(num i1) (num i6) (num i6).
multiplication(num i2) (num i0) (num i0).
multiplication(num i2) (num i1) (num i2).
multiplication(num i2) (num i2) (num i4).
multiplication(num i2) (num i3) (num i6).
multiplication(num i2) (num i4) (num i6).
multiplication(num i2) (num i5) (num i6).
multiplication(num i2) (num i6) (num i6).
multiplication(num i3) (num i0) (num i0).
multiplication(num i3) (num i1) (num i3).
multiplication(num i3) (num i2) (num i6).
multiplication(num i3) (num i3) (num i6).
multiplication(num i3) (num i4) (num i6).
multiplication(num i3) (num i5) (num i6).
multiplication(num i3) (num i6) (num i6).
multiplication(num i4) (num i0) (num i0).
multiplication(num i4) (num i1) (num i4).
multiplication(num i4) (num i2) (num i6).
multiplication(num i4) (num i3) (num i6).
multiplication(num i4) (num i4) (num i6).
multiplication(num i4) (num i5) (num i6).
multiplication(num i4) (num i6) (num i6).
multiplication(num i5) (num i0) (num i0).
multiplication(num i5) (num i1) (num i5).
multiplication(num i5) (num i2) (num i6).
multiplication(num i5) (num i3) (num i6).
multiplication(num i5) (num i4) (num i6).
multiplication(num i5) (num i5) (num i6).
multiplication(num i5) (num i6) (num i6).
multiplication(num i6) (num i0) (num i0).
multiplication(num i6) (num i1) (num i6).
multiplication(num i6) (num i2) (num i6).
multiplication(num i6) (num i3) (num i6).
multiplication(num i6) (num i4) (num i6).
multiplication(num i6) (num i5) (num i6).
multiplication(num i6) (num i6) (num i6).

