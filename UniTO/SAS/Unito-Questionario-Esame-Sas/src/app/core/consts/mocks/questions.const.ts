import { Question } from '../../models/question.model';

export const QUESTIONS: Question[] = [
  {
    id: 4,
    question:
      "In UP, la disciplina dei requisiti ha l'obbiettivo di produrre una lista dei requisiti, capire il contesto del sistema, catturare i requisiti funzionali e i requisiti non-funzionali",
    answer: true,
    options: ['true', 'false'],
  },
  {
    id: 5,
    question:
      'Il modello di dominio include la definizione di oggetti, associazioni e attributi di classi software',
    answer: false,
    options: ['true', 'false'],
  },

  {
    id: 7,
    question:
      'Il modello di dominio è un dizionario visuale delle classi concettuali',
    answer: true,
    options: ['true', 'false'],
  },

  {
    id: 9,
    question:
      'Il modello di dominio è una rappresentazione testuale delle classi concettuali, oggetti reali del dominio',
    answer: false,
    options: ['true', 'false'],
  },
  {
    id: 35,
    question:
      'Il modello di dominio non è parte della disciplina dei requisiti',
    answer: true,
    answer_reason: 'fa parte della disciplina di modellazione del buisness',
    options: ['true', 'false'],
  },
  {
    id: 36,
    question:
      'Nelle associazioni nel modello di dominio la direzione di lettura va sempre specificata',
    answer: false,
    options: ['true', 'false'],
  },
  {
    id: 37,
    question:
      "L'associazione nel modello di dominio è per sua natura unidirezionale",
    answer: false,
    options: ['true', 'false'],
  },
  {
    id: 38,
    question:
      "L'associazione nel modello di dominio rappresenta una relazione significativa tra classi",
    answer: true,
    options: ['true', 'false'],
  },
  {
    id: 39,
    question:
      "L'associazione nel modello di dominio rappresenta un valore logico degli oggetti di una classe",
    answer: false,
    options: ['true', 'false'],
  },
  {
    id: 40,
    question:
      "L'associazione nel modello di dominio rappresenta un’insieme di n-tuple di oggetti delle classi",
    answer: true,
    options: ['true', 'false'],
  },

  {
    id: 21,
    question:
      'Il modello di dominio è una rappresentazione testuale delle classi concettuali, oggetti reali del dominio',
    answer: false,
    options: ['true', 'false'],
  },
  {
    id: 22,
    question:
      'Il modello di dominio è un dizionario visuale delle classi concettuali',
    answer: true,
    options: ['true', 'false'],
  },
  {
    id: 64,
    question:
      'il MODELLO DI DOMINIO: Insieme di diagrammi di classi UML che includono associazioni tra classi software',
    answer: false,
    options: ['true', 'false'],
  },
  {
    id: 65,
    question:
      'il MODELLO DI DOMINIO: Rappresentazione grafica degli oggetti software',
    answer: false,
    options: ['true', 'false'],
  },
  {
    id: 66,
    question:
      'il MODELLO DI DOMINIO: Rappresentazione visuale delle classi concettuali',
    answer: true,
    options: ['true', 'false'],
  },
  {
    id: 67,
    question:
      'il MODELLO DI DOMINIO: Insieme di diagrammi di classi UML che includono associazioni tra classi concettuali',
    answer: true,
    options: ['true', 'false'],
  },
  {
    id: 68,
    question:
      'il MODELLO DI DOMINIO: Rappresentazione visuale delle classi JAVA',
    answer: false,
    options: ['true', 'false'],
  },
  {
    id: 69,
    question:
      'il MODELLO DI DOMINIO: Insieme di diagrammi di classi UML che includono le responsabilità di fare',
    answer: false,
    options: ['true', 'false'],
  },

  {
    id: 0,
    question:
      "Un caso d'uso rappresenta una maniera di utilizzare il sistema da parte di un utente per raggiungere un suo obbiettivo",
    answer: true,
    options: ['true', 'false'],
  },
  {
    id: 97,
    question:
      'La narrativa di un caso d’uso viene espressa a livello delle intenzioni dell’utente e della responsabilità del sistema',
    answer: true,
    options: ['true', 'false'],
  },
  {
    id: 98,
    question:
      'La narrativa di un caso d’uso viene espressa a livello delle azioni concrete dell’utente e delle responsabilità del sistema',
    answer: false,
    options: ['true', 'false'],
  },
  {
    id: 99,
    question:
      'Un caso d’uso è sempre completato (implementato) in una solo iterazione',
    answer: false,
    options: ['true', 'false'],
  },

  {
    id: 2,
    question:
      "Un caso d'uso rappresenta l'insieme di funzionalità di un sistema",
    answer: false,
    options: ['true', 'false'],
  },
  {
    id: 1,
    question:
      "I requisiti funzionali non catturati dai casi d'uso vengono descritti nelle specifiche supplementari",
    answer: false,
    options: ['true', 'false'],
  },
  {
    id: 6,
    question:
      "L'analisi linguistica dei casi d'uso nel formato dettagliato è una fonte di ispirazione per la costruzione del modello di dominio",
    answer: true,
    options: ['true', 'false'],
  },
  {
    id: 8,
    question:
      "Il modello di dominio riporta i concetti significativi relativi ai casi d'uso",
    answer: true,
    options: ['true', 'false'],
  },
  {
    id: 20,
    question:
      "L'analisi linguistica dei casi d'uso nel formato dettagliato è una fonte di ispirazione per la costruzione del modello di dominio",
    answer: true,
    options: ['true', 'false'],
  },
  {
    id: 3,
    question:
      "I requisiti non funzionali sono descritti completamente dai casi d'uso",
    answer: false,
    options: ['true', 'false'],
  },
  {
    id: 112,
    question:
      'I contratti sono considerati parte del modello dei casi d’uso poiché forniscono maggiori dettagli dell’analisi, sull’effetto delle operazioni di sistema implicate dai casi d’uso',
    answer: true,
    options: ['true', 'false'],
  },

  {
    id: 114,
    question:
      'I CASI D’USO Sono una collezione di soli scenari di successo che descrivono un attore che usa il sistema per raggiungere un obbiettivo specifico',
    answer: false,
    options: ['true', 'false'],
  },
  {
    id: 115,
    question:
      'I casi d’uso sono descrizioni testuali di scenari di uso interessanti del sistema software che si deve realizzare',
    answer: true,
    options: ['true', 'false'],
  },
  {
    id: 116,
    question: 'I casi d’uso servono a catturare i requisiti funzionali',
    answer: true,
    options: ['true', 'false'],
  },
  {
    id: 31,
    question:
      'In UP i casi d’uso vengono utilizzati per catturare i requisiti funzionali nella disciplina dei requisiti',
    answer: true,
    options: ['true', 'false'],
  },
  {
    id: 32,
    question: 'I casi d’uso sono caratteristiche del sistema',
    answer: false,
    options: ['true', 'false'],
  },
  {
    id: 33,
    question: 'I casi d’uso sono utilizzati per pianificare le iterazioni',
    answer: true,
    options: ['true', 'false'],
  },
  {
    id: 34,
    question: 'In UP i casi d’uso sono descritti mediante il linguaggio UML',
    answer: false,
    options: ['true', 'false'],
  },

  {
    id: 43,
    question:
      'DURANTE LA FASE DI ELABORAZIONE Si scrivono circa il 10% dei casi d’uso tra i più critici in formato dettagliato utilizzando template appositi',
    answer: false,
    options: ['true', 'false'],
  },
  {
    id: 56,
    question:
      'In percentuale sul totale di casi d’uso complessivi di un progetto, quanti sono quelli che dovrebbero essere realizzati entro la conclusione della fase di ideazione??',
    answer: '5%',
    options: ['5%', '50%', '70%', '100%'],
  },

  {
    id: 59,
    question: 'I casi d’uso mettono in risalto gli obbiettivi degli utenti',
    answer: true,
    options: ['true', 'false'],
  },
  {
    id: 60,
    question:
      'I casi d’uso sono utilizzati per la scoperta e la definizione dei requisiti non funzionali',
    answer: false,
    options: ['true', 'false'],
  },
  {
    id: 61,
    question:
      'I casi d’uso sono utilizzati per la scoperta e la definizione dei requisiti funzionali',
    answer: true,
    options: ['true', 'false'],
  },
  {
    id: 62,
    question: 'I casi d’uso mettono in risalto gli obbiettivi del sistema',
    answer: false,
    options: ['true', 'false'],
  },
  {
    id: 63,
    question:
      'I casi d’uso sono utilizzati solo nelle prime iterazioni di sviluppo',
    answer: false,
    options: ['true', 'false'],
  },

  {
    id: 109,
    question:
      'Il principale input per la redazione dei contratti sono le operazioni di sistema e il modello di dominio',
    answer: true,
    options: ['true', 'false'],
  },
  {
    id: 75,
    question:
      'Le post-condizioni descrivono i cambiamenti di stato degli oggetti nel modello di dominio dopo il completamento dell’operazione',
    answer: true,
    options: ['true', 'false'],
  },
  {
    id: 77,
    question: 'I contratti servono come input per il modello di dominio',
    answer: false,
    options: ['true', 'false'],
  },
  {
    id: 105,
    question:
      'La responsabilità sono assegnate ai concetti definiti nel modello di dominio',
    answer: false,
    options: ['true', 'false'],
  },
  {
    id: 78,
    question:
      'I contratti delle operazioni di sistema usano pre e post- condizioni per descrivere nel dettaglio i cambiamenti agli oggetti (concettuali) in un modello di dominio',
    answer: true,
    options: ['true', 'false'],
  },
  {
    id: 111,
    question: 'I contratti servono come input per il modello di dominio',
    answer: false,
    options: ['true', 'false'],
  },
  {
    id: 113,
    question:
      'Le pre-condizioni descrivono i cambiamenti di stato degli oggetti nel modello di dominio dopo il completamento dell’operazione',
    answer: false,
    options: ['true', 'false'],
  },

  {
    id: 11,
    question:
      'La composizione di oggetti è definita staticamente attraverso la specifica delle classi e delle associazioni',
    answer: false,
    options: ['true', 'false'],
  },
  {
    id: 12,
    question:
      'Il meccanismo di specializzazione per il riuso del codice è detto white-box',
    answer: true,
    options: ['true', 'false'],
  },
  {
    id: 13,
    question:
      "La modifica dell'interfaccia di una classe ha in generale un basso impatto nelle sottoclassi",
    answer: false,
    options: ['true', 'false'],
  },
  {
    id: 16,
    question:
      'I pattern GRASP sono espressi in termini di responsabilità, ruoli e collaborazioni',
    answer: true,
    options: ['true', 'false'],
  },
  {
    id: 17,
    question:
      "La decisione sull'assegnazione delle responsabilità precede sempre la codifica",
    answer: false,
    options: ['true', 'false'],
  },
  {
    id: 18,
    question:
      "L'utilizzo dei pattern GRASP è svolto all'interno della disciplina dei requisiti di UP",
    answer: false,
    options: ['true', 'false'],
  },
  {
    id: 19,
    question: 'Le responsabilità sono assegnate alle classi durante la OOD',
    answer: true,
    options: ['true', 'false'],
  },

  {
    id: 24,
    question:
      'Il meccanismo di delega è preferibile al meccanismo di specializzazione per il riuso del codice',
    answer: true,
    options: ['true', 'false'],
  },

  {
    id: 26,
    question: 'L’ereditarietà rispetta l’incapsulamento',
    answer: false,
    options: ['true', 'false'],
  },

  {
    id: 28,
    question:
      'La composizione di oggetti è un meccanismo di riuso del codice detto black-box',
    answer: true,
    options: ['true', 'false'],
  },
  {
    id: 29,
    question:
      'Un metodo di una classe software rappresenta una responsabilità “a fare” per le istanze di tale classe',
    answer: true,
    options: ['true', 'false'],
  },

  {
    id: 41,
    question:
      'DURANTE LA FASE DI ELABORAZIONE Non vengono effettuati test al codice di sviluppo',
    answer: false,
    options: ['true', 'false'],
  },
  {
    id: 42,
    question: 'DURANTE LA FASE DI ELABORAZIONE Non si sviluppa codice',
    answer: false,
    options: ['true', 'false'],
  },
  {
    id: 44,
    question:
      'DURANTE LA FASE DI ELABORAZIONE Viene scoperta e stabilizzata la maggior parte dei requisiti',
    answer: true,
    options: ['true', 'false'],
  },
  {
    id: 45,
    question:
      'DURANTE LA FASE DI ELABORAZIONE Si realizza uno studio economico per stabilire l’ordine di grandezza del progetto e dei costi',
    answer: false,
    options: ['true', 'false'],
  },
  {
    id: 46,
    question:
      'DURANTE LA FASE DI ELABORAZIONE Viene programmato il nucleo, rischioso, dell’architettura',
    answer: true,
    options: ['true', 'false'],
  },
  {
    id: 47,
    question:
      'In UML per responsabilità si intende la specifica di un metodo associato ad una classe Java',
    answer: false,
    options: ['true', 'false'],
  },
  {
    id: 48,
    question:
      'In UML per responsabilità si intende la specifica di una variabile di istanza di una classe Java',
    answer: false,
    options: ['true', 'false'],
  },
  {
    id: 49,
    question:
      'In UML per responsabilità si intende un contratto o un obbligo di un classificatore',
    answer: true,
    options: ['true', 'false'],
  },
  {
    id: 50,
    question:
      'In UML per responsabilità si intende la specifica di una variabile di istanza o di un metodo associato ad una classe Java',
    answer: false,
    options: ['true', 'false'],
  },
  {
    id: 51,
    question:
      'Gli SSD Sono espressi attraverso i diagrammi di comunicazione di UML',
    answer: false,
    options: ['true', 'false'],
  },
  {
    id: 52,
    question:
      'Gli SSD Mostrano l’ordine degli eventi generati dagli attori esterni al sistema',
    answer: true,
    options: ['true', 'false'],
  },
  {
    id: 53,
    question:
      'I contratti costituiscono un input per gli SSD delle operazioni e per la progettazione degli oggetti',
    answer: false,
    options: ['true', 'false'],
  },
  {
    id: 54,
    question: 'Un evento di sistema è un evento interno al sistema',
    answer: false,
    options: ['true', 'false'],
  },
  {
    id: 55,
    question:
      'Gli SSD mostrano gli eventi generati dagli attori esterni al sistema',
    answer: true,
    options: ['true', 'false'],
  },

  {
    id: 57,
    question:
      'In percentuale sul totale dei requisiti funzionali di un progetto, quanti sono quelli che dovrebbero essere identificati entro la conclusione della fase di ideazione?? 50%',
    answer: '70%',
    options: ['5%', '50%', '70%', '100%'],
  },
  {
    id: 58,
    question:
      'In percentuale sul totale dei requisiti funzionali di un progetto, quanti sono quelli che dovrebbero essere identificati entro la conclusione della fase di elaborazione?? Quasi',
    answer: '100%',
    options: ['5%', '50%', '70%', '100%'],
  },

  {
    id: 70,
    question: 'Il riuso white-box è preferibile al riuso black-box',
    answer: false,
    options: ['true', 'false'],
  },
  {
    id: 71,
    question:
      'Il meccanismo di ereditarietà non è preferibile al meccanismo di delega per ottenere il riuso del software',
    answer: true,
    options: ['true', 'false'],
  },
  {
    id: 72,
    question: 'L’ereditarietà si avvale del meccanismo di delega',
    answer: false,
    options: ['true', 'false'],
  },
  {
    id: 73,
    question: 'Il meccanismo di composizione non rispetta l’incapsulamento',
    answer: false,
    options: ['true', 'false'],
  },
  {
    id: 74,
    question:
      'Le operazioni di sistema possono essere identificate mentre si abbozzano gli DSD',
    answer: false,
    options: ['true', 'false'],
  },

  {
    id: 76,
    question:
      'I contratti descrivono in modo dettagliato i cambiamenti richiesti dall’esecuzione di una operazione di sistema, descrivono come devono essere ottenuti questi risultati',
    answer: false,
    options: ['true', 'false'],
  },
  {
    id: 27,
    question:
      'I pattern GoF incentivano l’uso dell’ereditarietà come meccanismo di riuso del codice, in particolare attraverso il pattern composite',
    answer: false,
    options: ['true', 'false'],
  },

  {
    id: 14,
    question:
      "I pattern GoF prediligono l'utilizzo del meccanismo di ereditarietà per ottenere la specializzazione",
    answer: false,
    options: ['true', 'false'],
  },
  {
    id: 10,
    question:
      'I pattern GoF incentivano i meccanismi di riuso del software attraverso la definizione di gerarchie di classi',
    answer: false,
    options: ['true', 'false'],
  },
  {
    id: 25,
    question:
      "I pattern GoF prediligono l'utilizzo del meccanismo di ereditarietà per ottenere il polimorfismo",
    answer: true,
    options: ['true', 'false'],
  },
  {
    id: 79,
    question:
      'I pattern GoF composite fornisce caratteristiche addizionali ad elementi atomici (foglie), mantenendo una interfaccia comune',
    answer: false,
    options: ['true', 'false'],
  },
  {
    id: 80,
    question:
      'Il pattern GoF composite permette di costruire tassonomie di classi',
    answer: false,
    options: ['true', 'false'],
  },
  {
    id: 81,
    question:
      'Il pattern GoF composite utilizza il meccanismo di specializzazione per rendere l’interfaccia delle entità atomiche esattamente come l’interfaccia delle entità composte',
    answer: false,
    options: ['true', 'false'],
  },
  {
    id: 82,
    question:
      'Il pattern GoF composite permette di evitare l’esplosione delle sottoclassi per supportare un ampio numero di estensioni e combinazioni di esse',
    answer: false,
    options: ['true', 'false'],
  },
  {
    id: 83,
    question:
      'Il pattern GoF composite permette di costruire strutture ricorsive in modo che ad un cliente l’intera struttura sia vista come una singola entità',
    answer: true,
    options: ['true', 'false'],
  },
  {
    id: 84,
    question: 'L’extreme programming promuove lo sviluppo seguito dai test',
    answer: false,
    options: ['true', 'false'],
  },
  {
    id: 85,
    question:
      'I test unitari hanno lo scopo di verificare la comunicazione tra specifiche parti del sistema',
    answer: false,
    options: ['true', 'false'],
  },
  {
    id: 86,
    question:
      'Preparazione, esecuzione, verifica e rilascio sono le parti del test unitario',
    answer: true,
    options: ['true', 'false'],
  },
  {
    id: 87,
    question:
      'Il refactoring prevede di applicare piccole trasformazioni che preservano il comportamento',
    answer: true,
    options: ['true', 'false'],
  },
  {
    id: 88,
    question:
      'I test unitari sono utilizzati per dimostrare che il refactoring non abbia causato una regressione',
    answer: true,
    options: ['true', 'false'],
  },
  {
    id: 89,
    question:
      'La progettazione object-oriented in UP ha il fine di identificare le responsabilità e assegnarle ad un opportuno oggetto o classe',
    answer: true,
    options: ['true', 'false'],
  },
  {
    id: 90,
    question:
      'La coesione è la misura di quanto fortemente un elemento è connesso ad altri elementi, ha conoscenza di altri elementi e dipende da altri elementi',
    answer: false,
    options: ['true', 'false'],
  },
  {
    id: 91,
    question:
      'Il pattern GRASP Information Expert e High Cohesion sono pattern valutativi',
    answer: false,
    options: ['true', 'false'],
  },
  {
    id: 92,
    question:
      'La creazione di un oggetto è di responsabilità di un oggetto che aggrega, contiene un’istanza dell’oggetto da creare',
    answer: true,
    options: ['true', 'false'],
  },
  {
    id: 93,
    question:
      'Una classe con accoppiamento alto fa molte cose non correlate tra loro e svolte troppo lavoro',
    answer: false,
    options: ['true', 'false'],
  },
  {
    id: 94,
    question:
      'Il refactoring è una pratica promossa dal metodo iterativo e agile xp',
    answer: true,
    options: ['true', 'false'],
  },
  {
    id: 95,
    question:
      'Il refactoring prevede lo sviluppo guidato dai test, ovvero uno sviluppo preceduto dai test',
    answer: false,
    options: ['true', 'false'],
  },
  {
    id: 96,
    question:
      'Il refactorin è un metodo strutturato e disciplinato per scrivere o ristrutturare del codice esistente',
    answer: true,
    options: ['true', 'false'],
  },

  {
    id: 100,
    question:
      'DURANTE LA FASE DI ELABORAZIONE: I requisiti e le iterazioni sono organizzati in base alla richiesta dell’utente finale',
    answer: false,
    options: ['true', 'false'],
  },
  {
    id: 101,
    question:
      'DURANTE LA FASE DI ELABORAZIONE: I requisiti e le iterazioni sono organizzati in base al rischio, copertura (devono coprire tutto il sistema) e criticità',
    answer: true,
    options: ['true', 'false'],
  },
  {
    id: 102,
    question:
      'DURANTE LA FASE DI ELABORAZIONE: Si effettua attività di programmazione di qualità-produzione e test',
    answer: true,
    options: ['true', 'false'],
  },
  {
    id: 103,
    question:
      'DURANTE LA FASE DI ELABORAZIONE: Vengono realizzati prototipi “usa e getta” per ottenere i rischi maggiori',
    answer: false,
    options: ['true', 'false'],
  },
  {
    id: 104,
    question:
      'La responsabilità è un’astrazione di ciò che ha o rappresenta un oggetto o un componente software',
    answer: true,
    options: ['true', 'false'],
  },

  {
    id: 106,
    question:
      'Nel reponsibility-Drive Developement gli oggetti software sono considerati come dotati di responsabilità',
    answer: true,
    options: ['true', 'false'],
  },
  {
    id: 107,
    question:
      'La disciplina dei requisiti è il processo per scoprire cosa deve essere costruito',
    answer: true,
    options: ['true', 'false'],
  },
  {
    id: 108,
    question:
      'La disciplina dei requisiti deve orientare lo sviluppo verso il sistema corretto',
    answer: true,
    options: ['true', 'false'],
  },
  {
    id: 110,
    question:
      'I contratti usano precondizioni e post-condizioni per descrivere nel dettaglio i cambiamenti agli oggetti in un modello di progetto (software)',
    answer: false,
    options: ['true', 'false'],
  },

  {
    id: 117,
    question: 'Si consideri la seguente associazione R tra a e B:',
    subQuestion:
      'se A = {a1,a2,a3} e B = {b1,b2}, R può essere {(a1,b1),(a2,b2)}',
    imgName: 'question_117_118_119_120.png',

    answer: false,
    options: ['true', 'false'],
  },
  {
    id: 118,
    question: 'Si consideri la seguente associazione R tra a e B: ',
    subQuestion:
      'se A = {a1,a2} e B = {b1,b2,b3}, R può essere {(a1,b1),(a2,b2),(a1,b2),(a2,b3)}',
    imgName: 'question_117_118_119_120.png',
    answer: false,
    options: ['true', 'false'],
  },
  {
    id: 119,
    question: 'Si consideri la seguente associazione R tra a e B: ',
    subQuestion:
      'se A = {a1,a2} e B = {b1,b2,b3}, R può essere {(a1,b1),(a1,b2),(a2,b3)}',
    imgName: 'question_117_118_119_120.png',

    answer: true,
    options: ['true', 'false'],
  },
  {
    id: 120,
    question: 'Si consideri la seguente associazione R tra a e B: ',
    subQuestion: 'se A = {a1,a2} e B = {b1,b2}, R può essere {(a1,b1),(a1,b2)}',
    imgName: 'question_117_118_119_120.png',

    answer: false,
    options: ['true', 'false'],
  },
  {
    id: 121,
    question:
      'Si consideri l’associazione “Contained-in” nel seguente Modello di Dominio: ',
    subQuestion:
      'Una istanza di Sale deve essere distrutta prima di un’istanza di SalesLineItem',
    imgName: 'question_121_to_126.png',
    answer_reason:
      'l’istanza Sale è l’intero ( il contenitore) e la parte è SalesLineItem. Dato che siamo in una composizione, la parte (SalesLineItem) non può esistere senza l’intero e quindi non posso distruggere l’istanza intero (Sale) prima di un’istanza parte. ',
    answer: false,
    options: ['true', 'false'],
  },

  {
    id: 122,
    question:
      'Si consideri l’associazione “Contained-in” nel seguente Modello di Dominio: ',
    subQuestion:
      'Una istanza di SalesLineItem deve essere distrutta prima di un’istanza di Sale.',
    imgName: 'question_121_to_126.png',
    answer: true,
    answer_reason: 'è il contrario di quanto detto prima (domanda 122)',
    options: ['true', 'false'],
  },

  {
    id: 123,
    question:
      'Si consideri l’associazione “Contained-in” nel seguente Modello di Dominio: ',
    subQuestion:
      'Le istanze di SalesLineItem appartengono ad una sola istanza di Sale alla volta.',
    imgName: 'question_121_to_126.png',
    answer: true,
    answer_reason: 'data dalla cardinalità dell’associazione “contained-in” ',
    options: ['true', 'false'],
  },

  {
    id: 124,
    question:
      'Si consideri l’associazione “Contained-in” nel seguente Modello di Dominio: ',
    subQuestion:
      'Le istanze di Sale appartengono ad una sola istanza di SalesLineItem alla volta.',
    imgName: 'question_121_to_126.png',
    answer_reason:
      'perché la cardinalità dell’associazione “contained-in” è 1..* ',
    answer: false,
    options: ['true', 'false'],
  },
  {
    id: 125,
    question:
      'Si consideri l’associazione “Contained-in” nel seguente Modello di Dominio: ',
    subQuestion:
      'Una istanza di SalesLineItem pu`o essere creata dopo un’istanza di Sale.',
    imgName: 'question_121_to_126.png',
    answer: true,
    answer_reason:
      'per quanto detto in precedenza sulla composizione (domanda 122)',

    options: ['true', 'false'],
  },
  {
    id: 126,
    question:
      'Si consideri l’associazione “Contained-in” nel seguente Modello di Dominio: ',
    subQuestion:
      'Una istanza di Sale pu`o essere creata dopo un’istanza di SalesLineItem.',
    imgName: 'question_121_to_126.png',
    answer_reason:
      'per quanto detto in precedenza sulla composizione (domanda 122)',
    answer: false,
    options: ['true', 'false'],
  },
  {
    id: 127,
    question:
      'Si consideri il seguente Modello di Dominio: Si supponga Product Catalog = {c1, c2} e Product Description = {d1, d2, d3, d4}. ',
    subQuestion:
      'Contains pu`o essere {(c1, d1), (c1, d2), (c2, d2), (c2, d3), (c2, d4)}.',
    imgName: 'question_127_to_130.png',
    answer_reason:
      'd2 è associato a 2 elementi di c (c1 e c2) e questo non va bene perché dev’essere associato solo ad un elemento di c per la cardinalità dell’associazione (1 --- 1..*)',
    answer: false,
    options: ['true', 'false'],
  },
  {
    id: 128,
    question:
      'Si consideri il seguente Modello di Dominio: Si supponga Product Catalog = {c1, c2} e Product Description = {d1, d2, d3, d4}. ',
    subQuestion:
      'Contains pu`o essere {(c1, d1), (c1, d2), (c1, d3), (c2, d4)}.',
    imgName: 'question_127_to_130.png',
    answer_reason: 'vengono rispettate le cardinalità',
    answer: true,
    options: ['true', 'false'],
  },
  {
    id: 129,
    question:
      'Si consideri il seguente Modello di Dominio: Si supponga Product Catalog = {c1, c2} e Product Description = {d1, d2, d3, d4}. ',
    subQuestion: 'Contains pu`o essere {(c1, d1), (c1, d2), (c2, d3)}.',
    imgName: 'question_127_to_130.png',
    answer_reason: 'perché d3 non è associato a nessun elemento di c',
    answer: false,
    options: ['true', 'false'],
  },
  {
    id: 130,
    question: 'Si consideri il seguente Modello di Dominio: ',
    subQuestion:
      'Contains pu`o essere {(c1, d1), (c1, d2), (c1, d3), (c1, d4)}.',
    imgName: 'question_127_to_130.png',
    answer_reason: 'perché c2 non è associato a nessun elemento di d',
    answer: false,
    options: ['true', 'false'],
  },
  {
    id: 131,
    question:
      'Si consideri il diagramma seguente e Si supponga A = {a1, a2, a3, a4} e B = {b1, b2}.',
    subQuestion: 'R pu`o essere {(b1, a1), (b1, a2), (b2, a1)}.',
    imgName: 'question_131_to_134.png',
    answer_reason:
      'perché a1 è associato a 2 elementi di b, quando invece la cardinalità è (0..1). ',
    answer: false,
    options: ['true', 'false'],
  },
  {
    id: 132,
    question:
      'Si consideri il diagramma seguente e Si supponga A = {a1, a2, a3, a4} e B = {b1, b2}.',
    subQuestion: 'R pu`o essere {(b1, a1), (b1, a2), (b1, a3)}.',
    imgName: 'question_131_to_134.png',
    answer_reason:
      'perché b2 non è associato a nessun elemento di a, quando invece la cardinalità è (1..3)',
    answer: false,
    options: ['true', 'false'],
  },
  {
    id: 133,
    question:
      'Si consideri il diagramma seguente e Si supponga A = {a1, a2, a3, a4} e B = {b1, b2}.',
    subQuestion:
      'R pu`o essere {(b1, a1), (b1, a2), (b1, a3), (b1, a4), (b2, a3)}.',
    imgName: 'question_131_to_134.png',
    answer_reason:
      'perché a3 è associato a 2 elementi di b, quando invece la cardinalità è (0..1)',
    answer: false,
    options: ['true', 'false'],
  },
  {
    id: 134,
    question:
      'Si consideri il diagramma seguente e Si supponga A = {a1, a2, a3, a4} e B = {b1, b2}.',
    subQuestion: 'R pu`o essere {(b1, a1), (b1, a2), (b2, a3), (b2, a4)}.',
    imgName: 'question_131_to_134.png',
    answer_reason: 'tutto ok, le cardinalità sono rispettate',
    answer: true,
    options: ['true', 'false'],
  },
];
