module tal.

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

typeOfW Gamma EnvH EnvR (zero) (int) (one).
typeOfW Gamma EnvH EnvR (one) (int) (one).
typeOfW Gamma EnvH EnvR (junk T) T (zero).     -- (uninit)
typeOfW Gamma EnvH EnvR (labelH L) (refH T) :- lookupEnvH EnvH L T. -- EnvH is phi


typeOfH Gamma EnvH EnvR (array E1 E2) (arrayT T1 FL1 T2 FL2):-  -- tuple
	typeOfW Gamma EnvH EnvR E1 T1 FL1,
	typeOfW Gamma EnvH EnvR E2 T2 FL2.


typeOfH Gamma EnvH EnvR (code EnvR' E) (codeT EnvR') :-    -- code Gamma is EnvR'
	typeOf Gamma EnvH EnvR' E (unitT). 

typeOfV Gamma EnvH EnvR Z T :- 
	lookupEnvR EnvR Z T.

typeOfV Gamma EnvH EnvR E T :- 
	typeOfW Gamma EnvH EnvR E T FL.



typeOf Gamma EnvH EnvR (halt) (unitT).

typeOf Gamma EnvH EnvR (add Zd Zs E1 E2) (unitT) :- 
	lookupEnvR EnvR Zd SomeT, 
	lookupEnvR EnvR Zs (int), 
	typeOfV Gamma EnvH EnvR E1 (int), 
	typeOf Gamma EnvH EnvR' E2 (unitT),  
	updateEnvR EnvR Zd (int) EnvR'. 

typeOf Gamma EnvH EnvR (mult Zd Zs E1 E2) (unitT) :- 
	lookupEnvR EnvR Zd SomeT, 
	lookupEnvR EnvR Zs (int), 
	typeOfV Gamma EnvH EnvR E1 (int), 
	typeOf Gamma EnvH EnvR' E2 (unitT),  
	updateEnvR EnvR Zd (int) EnvR'. 


typeOf Gamma EnvH EnvR (load Zd Zs I E) (unitT) :- 
	lookupEnvR EnvR Zd SomeT, 
	lookupEnvR EnvR Zs (arrayT T1 FL1 T2 FL2), 
	arrayT_get (arrayT T1 FL1 T2 FL2) I T,
	typeOf Gamma EnvH EnvR' E (unitT), 
	updateEnvR EnvR Zd T EnvR'.

typeOf Gamma EnvH EnvR (malloc Zd T1 T2 E) (unitT) :- 
	lookupEnvR EnvR Zd SomeT, 
	typeOf Gamma EnvH EnvR' E (unitT),
	updateEnvR EnvR Zd (arrayT T1 (zero) T2 (zero)) EnvR'.

typeOf Gamma EnvH EnvR (move Zd E1 E2) (unitT) :- 
	lookupEnvR EnvR Zd SomeT, 
	typeOfV Gamma EnvH EnvR E1 T, 
	typeOf Gamma EnvH EnvR' E2 (unitT), 
	updateEnvR EnvR Zd T EnvR'. 
	

typeOf Gamma EnvH EnvR (store Zd Zs I E) (unitT) :- 
	lookupEnvR EnvR Zd (arrayT T1 FL1 T2 FL2), 
	arrayT_get (arrayT T1 FL1 T2 FL2) I T,
	lookupEnvR EnvR Zs T,
	typeOf Gamma EnvH EnvR' E (unitT), 
	set_flag (arrayT T1 FL1 T2 FL2) I AR,      -- gives a new array AR, with I changed the flag set to one
	updateEnvR EnvR Zd AR EnvR'.


typeOf Gamma EnvH EnvR (jmp E) (unitT) :- 
	typeOfV Gamma EnvH EnvR E (refH (codeT EnvR)). 

typeOf Gamma EnvH EnvR (bnz Zs E1 E2) (unitT) :- 
	lookupEnvR EnvR Zs (int), 
	typeOfV Gamma EnvH EnvR E1 (refH (codeT EnvR)), 
	typeOf Gamma EnvH EnvR E2 (unitT). 






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
	array_get V I V'
	updateMapR R Zd V' R', 
	value V'. 

step (malloc T1 T2 Zd E) H R E H' R' :- 
	addMapH H (array (junk T1) (junk T2)) H' LNewH, 
	updateMapR R Zd (labelH LNewH) R', 
	value (labelH LNewH). 

step (move Zd V E) H R E H R' :- 
	updateMapR R Zd V R', 
	value V. 

step (store Zd Zs I E) H R E H' R :- 
	lookupMapR R Zd (labelH L), 
	lookupMapR R Zs V, 
	array_get V I V'
	updateMapH H L V' H'. 

step (jmp (labelH L)) H R E H R :- 
	lookupMapH H L (code EnvR E).

step (bnz Zs (labelH L) E2) H R E1 H R :- 
	lookupMapR R Zs (zero), 
	lookupMapH H L (code EnvR E1).

step (bnz Zs (labelH L) E) H R E H R :- 
	lookupMapR R Zs (one).


value (halt).
value (zero).
value (one).
value (labelH L).

addition zero zero zero. 
multiplication zero zero zero. 

