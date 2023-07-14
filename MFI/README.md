# Metodi Formali dell'Informatica

Repository per il corso di Metodi Formali dell'Informatica (A.A. 2022/2023) dell'Università degli Studi di Torino. In [Code](Code) c'è tutto il codice Agda che abbiamo trattato, in particolare l'esonero si può trovare in [Esonero.agda](Code/Esonero.agda) mentre la consegna in [CompilerEx.agda](Code/CompilerEx.agda)

## Domande d'Esame

- Hoare Logic
  - Loc / H-Loc: Loc ed H-Loc sono codifiche di un sistema formale tramite la struttura "data" di Agda, Loc ci dice che, per ogni **variabile x**, **espressione aritmetica a** e **stato s**, la configurazione in cui a viene assegnato ad x nello stato s porta allo stato s con un update di x secondo la valutazione dell'espressione aritmetica a in s. H-Loc raprresenta lo stesso concetto ma sfruttando le **Triple**, se l'asserzione P è vera in uno stato in cui a viene assegnato ad x allora P è vera dopo l'assegnamento.
- Verification Conditions
  - Differenza tra verification conditions and weakest preconditions: le **weakest preconditions** sono il più ampio insieme di stati che soddisfano la postcondizione, mentre le **verification conditions** sono le condizioni che devono essere soddisfatte affinchè gli invarianti I inclusi in un **comando annotato c** siano validi (formalizzati dalla regola H-While).
- Differenza tra Big-Step e Small-Step
  - Fare un esempio di comando in Big-Step ed uno in Small-Step
  - Equivalenza delle due semantiche: a parte per SKIP, essendo che non c'è nessuna configurazione che può essere ridotta da `⦅ SKIP , s ⦆` (diciamo che SKIP è un comando terminato), le due sematiche sono equivalenti. Lo dimostriamo provando il teorema di equivalenza big-small e small-big che porta a `corollary : ∀{c s t} -> ⦅ c , s ⦆ ⟶* ⦅ SKIP , t ⦆ <=> ⦅ c , s ⦆ => t`
  - La chiusura nella semantiche Small-Step è la chiusura riflessiva e transitiva di `⟶`, differisce da `=>` in quanto le due hanno diverso dominio ma esprimono lo stesso concetto.
- Weakest Pre-conditions
  - Vengono introdotte perché vogliamo ampliare il dominio degli stati in cui vale la postcondizione, in particolare vogliamo trovare il più ampio insieme di stati che soddisfano la postcondizione.
- Soundness della logica di Hoare
  - Quando una tripla è valida? Quando la postcondizione è soddisfatta in tutti gli stati in cui vale la precondizione, ovvero quando la tripla è soddisfatta in tutti gli stati in cui il comando termina.
  - Quando una tripla è derivabile? Quando la derivazione è costruita secondo le regole della logica di Hoare.
  - Teorema di correttezza: se una tripla è derivabile allora è valida. `se |- [ P ] c [ Q ] allora |= [ P ] c [ Q ]`
- H-While e correttezza di H-While
  - La precondizione è vera prima dell'esecuzione del ciclo, la postcondizione in and con la guardia è falsa dopo l'esecuzione del ciclo. È corretta perché se la precondizione è vera allora la guardia è vera e quindi il ciclo viene eseguito, se la guardia è falsa allora la postcondizione è vera e quindi il ciclo termina.
- Relative Completeness
  - 