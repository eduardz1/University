4. Un sistema embedded riceve su due porte seriali sequenze di dati provenienti da due diversi
   sensori. Ciascun sensore genera i dati con cadenze variabili nel tempo e non predicibili, in quanto il
   processo di digitalizzazione al suo interno può richiedere più o meno tempo in funzione del dato
   letto. Ogni volta che il sistema riceve un nuovo valore su una delle due porte seriali, deve
   accoppiarlo con il dato più recente ricevuto sull'altra (se già presente) e inviarlo ad una fase
   successiva di computazione. Il sistema al proprio interno utilizza due thread differenti per leggere
   dalle due porte seriali e richiede l'uso di un oggetto di sincronizzazione in grado di
   implementare la logica descritta sopra. Tale oggetto offre la seguente interfaccia pubblica:

class Synchronizer {
public:
Synchronizer(std::function<void(float d1, float d2)> process);
void dataFromFirstPort(float d1);
void dataFromSecondPort(float d2);
}

All'atto della costruzione, viene fornita la funzione process(...) che rappresenta la fase successiva
della computazione. Quando vengono invocati i metodi dataFromFirstPort(...) o
dataFromSecondPort(...), se non è ancora presente il dato dalla porta opposta, questi si bloccano al
proprio interno senza consumare CPU, in attesa del valore corrispondente. Al suo arrivo, viene
invocata una sola volta la funzione process(...). Si implementi tale classe utilizzando le funzionalità
offerte dallo standard C++.
