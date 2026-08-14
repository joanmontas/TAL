module tal1.

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


lookupEnvH (consEnvH L T EnvH) L T.
lookupEnvH (consEnvH L1 T1 EnvH) L T :- lookupEnvH EnvH L T.

subsetEnvH EnvH EnvH.
subsetEnvH EnvH (consEnvH L T Rest) :- subsetEnvH EnvH Rest.

lookupMapH (consMapH L E MU) L E.
lookupMapH (consMapH L1 E1 MU) L E :- lookupMapH MU L E.

updateMapH (consMapH L E MU) L E' (consMapH L E' MU).
updateMapH (consMapH L1 E1 MU) L E' (consMapH L1 E1 MU') :- updateMapH MU L E' MU'.

addMapH (consMapH L E1 MU) E2 (consMapH (succLabelH L) E2 (consMapH L E1 MU)) (succLabelH L). 


array_get (array E1 E2 E3 E4 E5 E6) (num i0) E1.
array_get (array E1 E2 E3 E4 E5 E6) (num i1) E2.
array_get (array E1 E2 E3 E4 E5 E6) (num i2) E3.
array_get (array E1 E2 E3 E4 E5 E6) (num i3) E4.
array_get (array E1 E2 E3 E4 E5 E6) (num i4) E5.
array_get (array E1 E2 E3 E4 E5 E6) (num i5) E6.

arrayT_get (arrayT T1 T2 T3 T4 T5 T6) (num i0) T1.
arrayT_get (arrayT T1 T2 T3 T4 T5 T6) (num i1) T2.
arrayT_get (arrayT T1 T2 T3 T4 T5 T6) (num i2) T3.
arrayT_get (arrayT T1 T2 T3 T4 T5 T6) (num i3) T4.
arrayT_get (arrayT T1 T2 T3 T4 T5 T6) (num i4) T5.
arrayT_get (arrayT T1 T2 T3 T4 T5 T6) (num i5) T6.

array_set (array E1 E2 E3 E4 E5 E6) (num i0) E (array E E2 E3 E4 E5 E6).
array_set (array E1 E2 E3 E4 E5 E6) (num i1) E (array E1 E E3 E4 E5 E6).
array_set (array E1 E2 E3 E4 E5 E6) (num i2) E (array E1 E2 E E4 E5 E6).
array_set (array E1 E2 E3 E4 E5 E6) (num i3) E (array E1 E2 E3 E E5 E6).
array_set (array E1 E2 E3 E4 E5 E6) (num i4) E (array E1 E2 E3 E4 E E6).
array_set (array E1 E2 E3 E4 E5 E6) (num i5) E (array E1 E2 E3 E4 E5 E).


register_file_subtype nilEnvR EnvR2.
register_file_subtype (consEnvR L T Rest) EnvR2 :- lookupEnvR EnvR2 L T, register_file_subtype Rest EnvR2. 

typeOfHvl EnvH (array E1 E2 E3 E4 E5 E6) (arrayT T1 T2 T3 T4 T5 T6) :-
    typeOfWval EnvH E1 T1,
    typeOfWval EnvH E2 T2,
    typeOfWval EnvH E3 T3,
    typeOfWval EnvH E4 T4,
    typeOfWval EnvH E5 T5,
    typeOfWval EnvH E6 T6. 
	
typeOfHvl EnvH (code EnvR' E) (codeT EnvR) :-
    typeOf EnvH EnvR E (unitT). 


typeOfWval EnvH (num I) (int).
typeOfWval EnvH (labelH L) T :- lookupEnvH EnvH L T.


typeOfV EnvH EnvR E T :- typeOfWval EnvH E T.


typeOf EnvH EnvR (halt) (unitT).

typeOf EnvH EnvR (add Zd Zs E1 E2) (unitT) :- 
    lookupEnvR EnvR Zd SomeT, 
    lookupEnvR EnvR Zs (int), 
    typeOfV EnvH EnvR E1 (int), 
    typeOf EnvH EnvR' E2 (unitT),
    updateEnvR EnvR Zd (int) EnvR'.

typeOf EnvH EnvR (mult Zd Zs E1 E2) (unitT) :- 
    lookupEnvR EnvR Zd SomeT, 
    lookupEnvR EnvR Zs (int), 
    typeOfV EnvH EnvR E1 (int), 
    typeOf EnvH EnvR' E2 (unitT),
    updateEnvR EnvR Zd (int) EnvR'.

typeOf EnvH EnvR (load Zd Zs I E) (unitT) :- 
    lookupEnvR EnvR Zd SomeT, 
    lookupEnvR EnvR Zs (arrayT T1 T2 T3 T4 T5 T6),
    arrayT_get (arrayT T1 T2 T3 T4 T5 T6) I T,
    typeOf EnvH EnvR' E (unitT),
    updateEnvR EnvR Zd T EnvR'.


typeOf EnvH EnvR (malloc Zd E1 E2 E3 E4 E5 E6 E) (unitT) :- 
    lookupEnvR EnvR Zd SomeT, 
    typeOfV EnvH EnvR E1 T1, 
    typeOfV EnvH EnvR E2 T2, 
    typeOfV EnvH EnvR E3 T3, 
    typeOfV EnvH EnvR E4 T4, 
    typeOfV EnvH EnvR E5 T5, 
    typeOfV EnvH EnvR E6 T6, 
    typeOf EnvH EnvR' E (unitT),
    updateEnvR EnvR Zd (arrayT T1 T2 T3 T4 T5 T6) EnvR'.


typeOf EnvH EnvR (move Zd E1 E2) (unitT) :- 
    lookupEnvR EnvR Zd SomeT, 
    typeOfV EnvH EnvR E1 T, 
    typeOf EnvH EnvR' E2 (unitT),
    updateEnvR EnvR Zd T EnvR'.


typeOf EnvH EnvR (store Zd Zs I E) (unitT) :- 
    lookupEnvR EnvR Zd (arrayT T1 T2 T3 T4 T5 T6),
    arrayT_get (arrayT T1 T2 T3 T4 T5 T6) I T,
    lookupEnvR EnvR Zs T,
    typeOf EnvH EnvR E (unitT). 


typeOf EnvH EnvR (jmp E) (unitT) :- 
    typeOfV EnvH EnvR E (codeT EnvR'), 
	register_file_subtype EnvR' EnvR. 


typeOf EnvH EnvR (bnz Zs E1 E2) (unitT) :- 
    lookupEnvR EnvR Zs (int), 
    typeOfV EnvH EnvR E1 (codeT EnvR'), 
    typeOf EnvH EnvR' E2 (unitT), 
	register_file_subtype EnvR' EnvR. 


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


step (load Zd Zs I E) H R E H R' :- 
    lookupMapR R Zs (labelH L), 
    lookupMapH H L V,
    array_get V I V',
    updateMapR R Zd V' R', 
    value V'. 


step (malloc Zd E1 E2 E3 E4 E5 E6 E) H R E H' R' :-
    addMapH H (array E1 E2 E3 E4 E5 E6) H' LNewH, 
    updateMapR R Zd (labelH LNewH) R', 
	value E1, value E2, value E3, value E4, value E5, value E6, 
    value (labelH LNewH). 


step (move Zd V E) H R E H R' :- 
    updateMapR R Zd V R', 
    value V. 


step (store Zd Zs I E) H R E H' R :- 
    lookupMapR R Zd (labelH L), 
    lookupMapH H L (array V1 V2 V3 V4 V5 V6), 
    lookupMapR R Zs V, 
    array_set (array V1 V2 V3 V4 V5 V6) I V Arr,
    updateMapH H L Arr H'. 


step (jmp (labelH L)) H R E H R :- 
    lookupMapH H L (code EnvR E).


step (bnz Zs (labelH L) E2) H R E1 H R :- 
    lookupMapR R Zs (num i0), 
    lookupMapH H L (code EnvR E1).


step (bnz Zs (labelH L) E) H R E H R :- 
    lookupMapR R Zs (num i1).



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
