module tal2.


lookupEnvH (consEnvH L T EnvH) L T.


lookupEnvH (consEnvH L1 T1 EnvH) L T :- lookupEnvH EnvH L T.

  
subsetEnvH EnvH EnvH.

subsetEnvH EnvH (consEnvH L T Rest) :- subsetEnvH EnvH Rest.


lookupMapH (consMapH L E MU) L E.

lookupMapH (consMapH L1 E1 MU) L E :- lookupMapH MU L E.

updateMapH (consMapH L E MU) L E' (consMapH L E' MU).

updateMapH (consMapH L1 E1 MU) L E' (consMapH L1 E1 MU') :- updateMapH MU L E' MU'.

addMapH (consMapH L E1 MU) E2 (consMapH (succLabelH L) E2 (consMapH L E1 MU)) (succLabelH L). 

array_get (array E1 E2) (num i0) E1.

array_get (array E1 E2) (num i1) E2.

arrayT_get (arrayT T1 FL1 T2 FL2) (num i0) T1.

arrayT_get (arrayT T1 FL1 T2 FL2) (num i1) T2.

set_flag (arrayT T1 FL1 T2 FL2) (num i0) (arrayT T1 (i1) T2 FL2).

set_flag (arrayT T1 FL1 T2 FL2) (num i1) (arrayT T1 FL1 T2 (i1)).

lookupEnvR (consEnvR L T EnvR) L T.

lookupEnvR (consEnvR L1 T1 EnvR) L T :- lookupEnvR EnvR L T.


subsetEnvR EnvR EnvR.

subsetEnvR EnvR (consEnvR L T Rest) :- subsetEnvR EnvR Rest.


%%subsetEnvR nilEnvR nilEnvR.

%%subsetEnvR (consEnvR L T Rest1) (consEnvR L T Rest2) :- subsetEnvR Rest1 Rest2.

%%subsetEnvR EnvR (consEnvR L T Rest2) :- subsetEnvR EnvR Rest2.


updateEnvR (consEnvR L E MU) L E' (consEnvR L E' MU).

updateEnvR (consEnvR L1 E1 MU) L E' (consEnvR L1 E1 MU') :- updateEnvR MU L E' MU'.

lookupMapR (consMapR L E MU) L E.

lookupMapR (consMapR L1 E1 MU) L E :- lookupMapR MU L E.

updateMapR (consMapR L E MU) L E' (consMapR L E' MU).

updateMapR (consMapR L1 E1 MU) L E' (consMapR L1 E1 MU') :- updateMapR MU L E' MU'.



typeOfW Gamma EnvH EnvR (num I) (int) (i1).

typeOfW Gamma EnvH EnvR (junk T) T (i0).

typeOfW Gamma EnvH EnvR (labelH L) (refH T) (i1) :- lookupEnvH EnvH L T.


typeOfH Gamma EnvH EnvR (array E1 E2) (arrayT T1 FL1 T2 FL2):-
    typeOfW Gamma EnvH EnvR E1 T1 FL1,
    typeOfW Gamma EnvH EnvR E2 T2 FL2.

typeOfH Gamma EnvH EnvR (code EnvR' E) (codeT EnvR') :-
    typeOf Gamma EnvH EnvR' E (unitT). 


typeOfV Gamma EnvH EnvR E T :- 
    typeOfW Gamma EnvH EnvR E T FL.


typeOf Gamma EnvH EnvR (halt) (unitT).

typeOf Gamma EnvH EnvR (add Zd Zs E1 E2) (unitT) :- 
    lookupEnvR EnvR Zd SomeT, 
    lookupEnvR EnvR Zs (int), 
    typeOfV Gamma EnvH EnvR E1 (int), 
    updateEnvR EnvR Zd (int) EnvR',
    typeOf Gamma EnvH EnvR' E2 (unitT).

typeOf Gamma EnvH EnvR (mult Zd Zs E1 E2) (unitT) :- 
    lookupEnvR EnvR Zd SomeT, 
    lookupEnvR EnvR Zs (int), 
    typeOfV Gamma EnvH EnvR E1 (int), 
    updateEnvR EnvR Zd (int) EnvR',
    typeOf Gamma EnvH EnvR' E2 (unitT).

typeOf Gamma EnvH EnvR (load Zd Zs I E) (unitT) :- 
    lookupEnvR EnvR Zd SomeT, 
    %% lookupEnvR EnvR Zs (arrayT T1 FL1 T2 FL2),
    lookupEnvR EnvR Zs (refH (arrayT T1 FL1 T2 FL2)),
    arrayT_get (arrayT T1 FL1 T2 FL2) I T,
    updateEnvR EnvR Zd T EnvR',
    typeOf Gamma EnvH EnvR' E (unitT).


typeOf Gamma EnvH EnvR (malloc Zd T1 T2 E) (unitT) :- 
    lookupEnvR EnvR Zd SomeT, 
    %% updateEnvR EnvR Zd (arrayT T1 (i0) T2 (i0)) EnvR',
    updateEnvR EnvR Zd (refH (arrayT T1 (i0) T2 (i0))) EnvR',
    typeOf Gamma EnvH EnvR' E (unitT).


typeOf Gamma EnvH EnvR (move Zd E1 E2) (unitT) :- 
    lookupEnvR EnvR Zd SomeT, 
    typeOfV Gamma EnvH EnvR E1 T, 
    updateEnvR EnvR Zd T EnvR',
    typeOf Gamma EnvH EnvR' E2 (unitT).


typeOf Gamma EnvH EnvR (store Zd Zs I E) (unitT) :- 
    %% lookupEnvR EnvR Zd (arrayT T1 FL1 T2 FL2), 
    lookupEnvR EnvR Zd (refH (arrayT T1 FL1 T2 FL2)),
    arrayT_get (arrayT T1 FL1 T2 FL2) I T,
    lookupEnvR EnvR Zs T,
    set_flag (arrayT T1 FL1 T2 FL2) I AR,
    %% updateEnvR EnvR Zd AR EnvR',
    updateEnvR EnvR Zd (refH AR) EnvR',
    typeOf Gamma EnvH EnvR' E (unitT).


typeOf Gamma EnvH EnvR (jmp E) (unitT) :- 
    typeOfV Gamma EnvH EnvR E (refH (codeT EnvR')), 
	register_file_subtype EnvR' EnvR. 


typeOf Gamma EnvH EnvR (bnz Zs E1 E2) (unitT) :- 
    lookupEnvR EnvR Zs (int), 
    typeOfV Gamma EnvH EnvR E1 (refH (codeT EnvR')), 
    typeOf Gamma EnvH EnvR' E2 (unitT), 
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


step (malloc Zd T1 T2 E) H R E H' R' :-
    addMapH H (array (junk T1) (junk T2)) H' LNewH, 
    updateMapR R Zd (labelH LNewH) R', 
    value (labelH LNewH). 


step (move Zd V E) H R E H R' :- 
    updateMapR R Zd V R', 
    value V. 


step (store Zd Zs I E) H R E H' R :- 
    lookupMapR R Zd (labelH L), 
    lookupMapR R Zs V, 
    array_get V I V',
    updateMapH H L V' H'. 


step (jmp (labelH L)) H R E H R :- 
    lookupMapH H L (code EnvR E).


step (bnz Zs (labelH L) E2) H R E1 H R :- 
    lookupMapR R Zs (num i0), 
    lookupMapH H L (code EnvR E1).


step (bnz Zs (labelH L) E) H R E H R :- 
    lookupMapR R Zs (num i1).


value (num I).
value (labelH L).
value (junk T).


register_file_subtype nilEnvR EnvR2.

register_file_subtype (consEnvR L T Rest) EnvR2 :- lookupEnvR EnvR2 L T, register_file_subtype Rest EnvR2. 



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
