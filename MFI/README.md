# Metodi Formali dell'Informatica

Repository per il corso di Metodi Formali dell'Informatica (A.A. 2022/2023) dell'Università degli Studi di Torino. In [Code](Code) c'è tutto il codice Agda che abbiamo trattato, in particolare l'esonero si può trovare in [Esonero.agda](Code/Esonero.agda) mentre la consegna in [CompilerEx.agda](Code/CompilerEx.agda)

## Domande d'Esame

- Hoare Logic
  - Loc / H-Loc: Loc ed H-Loc sono codifiche di un sistema formale tramite la struttura "data" di Agda, Loc ci dice che, per ogni **variabile x**, **espressione aritmetica a** e **stato s**, la configurazione in cui a viene assegnato ad x nello stato s porta allo stato s con un update di x secondo la valutazione dell'espressione aritmetica a in s. H-Loc raprresenta lo stesso concetto ma sfruttando le **Triple**, se l'asserzione P è vera in uno stato in cui a viene assegnato ad x allora P è vera dopo l'assegnamento.
  - Composizione: per dimostrare bisogna chiamare ricorsivamente la dimostrazione dividendola secondo uno stato intermedio tra i due programmi.
- Verification Conditions
  - Differenza tra verification conditions and weakest preconditions: le **weakest preconditions** sono il più ampio insieme di stati che soddisfano la postcondizione, mentre le **verification conditions** sono le condizioni che devono essere soddisfatte affinchè gli invarianti I inclusi in un **comando annotato c** siano validi (formalizzati dalla regola H-While).
  - Cosa comporta l'aggiunta dell'invariante di ciclo e come dobbiamo modificare le weakest pre-conditions in pre e vc e pre del WHILE: in pre l'unica cosa che cambia è che nel caso del WHILE abbiamo già la pre-condizione I, nel vc del WHILE I deve essere valida quando la guardia è vera mentre è irrilevante quando la guardia è falsa, se la guardia è falsa allora il ciclo termina e la post-condizione è vera nello stato in cui la guardia è falsa, se la guardia è vera allora il ciclo viene eseguito e deve essere vera la pre-condizione C I s, in tutto ciò deve sempre essere vero vc C I.
- Differenza tra Big-Step e Small-Step
  - Fare un esempio di comando in Big-Step ed uno in Small-Step
  - Equivalenza delle due semantiche: a parte per SKIP, essendo che non c'è nessuna configurazione che può essere ridotta da `⦅ SKIP , s ⦆` (diciamo che SKIP è un comando terminato), le due sematiche sono equivalenti. Lo dimostriamo provando il teorema di equivalenza big-small e small-big che porta a `corollary : ∀{c s t} -> ⦅ c , s ⦆ ⟶* ⦅ SKIP , t ⦆ <=> ⦅ c , s ⦆ => t`
  - La chiusura nella semantiche Small-Step è la chiusura riflessiva e transitiva di `⟶`, differisce da `=>` in quanto le due hanno diverso dominio ma esprimono lo stesso concetto.
- Weakest Pre-conditions
  - Vengono introdotte perché vogliamo ampliare il dominio degli stati in cui vale la postcondizione, in particolare vogliamo trovare il più ampio insieme di stati che soddisfano la postcondizione.
  - Nel caso dell'assegnamento e WHILE: per l'assegnamento bisogna dimostrare che si può ridurre la pre-condizione a Q con l'assegnamento di a ad x valutato in s: `wp-lemma (x := a) {Q} = H-Str S-prem H-Loc | where S-prem : wp (x := a) Q ==> (λ s → Q (s [ x ::= aval a s ]))` mentre per il WHILE usiamo H-Weak per dimostrare che il ciclo termina.
- Soundness della logica di Hoare
  - Quando una tripla è valida? Quando la postcondizione è soddisfatta in tutti gli stati in cui vale la precondizione, ovvero quando la tripla è soddisfatta in tutti gli stati in cui il comando termina.
  - Quando una tripla è derivabile? Quando la derivazione è costruita secondo le regole della logica di Hoare.
  - Teorema di correttezza: se una tripla è derivabile allora è valida. `se |- [ P ] c [ Q ] allora |= [ P ] c [ Q ]`
- H-While e correttezza di H-While
  - La precondizione è vera prima dell'esecuzione del ciclo, la postcondizione in and con la guardia è falsa dopo l'esecuzione del ciclo. È corretta perché se la precondizione è vera allora la guardia è vera e quindi il ciclo viene eseguito, se la guardia è falsa allora la postcondizione è vera e quindi il ciclo termina.
- Relative Completeness
  - Perché è relativa e dove Agda limita l'espressività con che regola di Hoare?: è relativa perché non è completa per tutti i comandi, in particolare non è completa per i comandi che non terminano. Agda limita l'espressività con la regola H-While perché non è possibile dimostrare la correttezza di un ciclo infinito.
  - Dove entrano in gioco le weakest pre-conditions per dimostrare la completezza?: Nella dimostrazione di completezza, dobbiamo dimostrare che, data una tripla {P} c {Q}, P ==> wp c Q, ci avvaliamo della regola derivata H-Str, caso particolare di H-Conseq dove ci focalizziamo sull'indebolimento della precondizione.
  - Come riscrivo `wp (c1 ; c2) Q`?: `wp (c1 ; c2) Q = wp c1 (wp c2 Q)` e lo dimostriamo avvalendoci della regola Comp.
- Come si definisce il WHILE con la Small-Step sematics?: `While : ∀{b c s} -> ⦅ WHILE b DO c , s ⦆ ⟶ ⦅ IF b THEN (c :: (WHILE b DO c)) ELSE SKIP , s ⦆`, facciamo un passo alla volta richiamando ricorsivamente la regola a differenza della Big-Step dove quindi dobbiamo dividere in WhileFalse e WhileTrue.
- Equivalenza tra programmi, definizione: `c ∼ c' = ∀{s t} -> ( ⦅ c , s ⦆ => t <=> ⦅ c' , s ⦆ => t )` vale a dire, dati due programmi c e c', se e solo se per ogni stato s, c e c' terminano nello stesso stato t, allora c e c' sono equivalenti.
- WHILE in BigStep, sembra circolare, perché non lo è? Perché ci avvaliamo delle regole WhileFalse e WhileTrue, lo stato viene aggiornato man mano.
