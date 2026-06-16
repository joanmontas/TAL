sig asm_jmp_bnz.

kind term type.
kind typ type.

%% map Gamma

kind envT type.
type nilEnvT envT.
type consEnvT term -> typ -> envT -> envT.


%% map H
kind labelH type.
type zeroLabelH labelH.
type succLabelH labelH -> labelH.

kind mapH type.
type nilMapH mapH.
type consMapH labelH -> term -> mapH -> mapH.

type lookupMapH mapH -> labelH -> term -> o.
type updateMapH mapH -> labelH -> term -> mapH -> o.
type addMapH mapH -> term -> mapH -> labelH -> o.

kind envH type.
type nilEnvH envH.
type consEnvH labelH -> typ -> envH -> envH.

type lookupEnvH envH -> labelH -> typ -> o.
type subsetEnvH envH -> envH -> o.

%% map R
kind register type.

type r1 register. 
type r2 register. 

kind mapR type.
type nilMapR mapR.
type consMapR register -> term -> mapR -> mapR.

type lookupMapR mapR -> register -> term -> o.
type updateMapR mapR -> register -> term -> mapR -> o.

kind envR type.
type nilEnvR envR.
type consEnvR register -> typ -> envR -> envR.

type lookupEnvR envR -> register -> typ -> o.
type subsetEnvR envR -> envR -> o.
type updateEnvR envR -> register -> typ -> envR -> o.


type int typ.
type unitT typ.
type refH typ -> typ. 

type zero term.
type one term.
type halt term.
type labelH labelH -> term.
type add register -> register -> term -> term -> term.
type mult register -> register -> term -> term -> term.
type load register -> register -> term -> term.
type malloc register -> term -> term -> term.
type move register -> term -> term -> term.
type store register -> register -> term -> term.


type codeT envR -> typ. 
type code envR -> term -> term.

type jmp term -> term.
type bnz register -> term -> term -> term.


type value term -> o.
type step term -> mapH -> mapR -> term -> mapH -> mapR -> o.
type typeOf envT -> envH -> envR -> term -> typ -> o.

type addition term -> term -> term -> o.
type multiplication term -> term -> term -> o.
