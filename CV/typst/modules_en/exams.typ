#import "@preview/brilliant-cv:2.0.2": cvSection, cvHonor, cvEntry, hBar
#let metadata = toml("../metadata.toml")
#let cvSection = cvSection.with(metadata: metadata)
#let cvEntry = cvEntry.with(metadata: metadata)

#pagebreak()

#cvSection("Exams")

#show table.cell.where(y: 0): strong
#set table(
  stroke: (x, y) => if y == 0 {
    (bottom: 0.7pt + black)
  },
  align: (x, y) => (
    if x > 0 {
      center
    } else {
      left
    }
  ),
)

= University of Turin + University of Oslo

/ Mean grade: 28.6/30

#table(
  columns: 6,
  table.header(
    [Code],
    [Description],
    [Grade],
    [Date],
    [CFU/ECTS],
    [SSD (Italian acronym for Scientific-Disciplinary Sector)],
  ),
  table.cell(colspan: 6, inset: 1.5em, align: center + horizon)[ == FIRST YEAR],
  [MFN0570], [Mathematical Analysis], [28/30], [09/08/2021], [9], [MAT/05],
  [MFN0586], [Computer Architectures], [26/30], [12/07/2021], [9], [INF/01],
  [MFN0588], [Matrix Calculus and Operational Research], [27/30], [22/01/2021], [6], [MAT/09],
  [MFN0590], [English 1], [passed], [25/01/2021], [3], [L-LIN/12],
  [MFN0582], [Programming 1], [30/30], [15/02/2021], [9], [INF/01],
  [MFN0585], [Programming 2], [30L/30], [09/06/2021], [9], [INF/01],
  [MFN0578], [Discrete Mathematics and Logic], [29/30], [18/02/2021], [12], [MAT/02 + MAT/01],
  table.cell(colspan: 6, inset: 1.5em, align: center + horizon)[ == SECOND YEAR],
  [MFN0597], [Algorithms and Data Structures], [30L/30], [21/06/2022], [9], [INF/01],
  [MFN0602], [Database], [29/30], [14/09/2022], [9], [INF/01],
  [MFN0604], [Management, business administration and computer law], [29/30], [29/07/2022], [9], [SECS-P/08 + IUS/02],
  [MFN0600], [ Foundations of Probability and Statistics], [30L/30], [28/01/2022], [6], [MAT/06],
  [MFN0598], [Psychs], [30/30], [21/12/2022], [6], [FIS/01],
  [MFN0603], [Formal Languages and Compilers], [28/30], [21/02/2022], [9], [INF/01],
  [MFN0601], [Operating Systems], [25/30], [25/02/2022], [12], [INF/01],
  table.cell(colspan: 6, inset: 1.5em, align: center + horizon)[ == THIRD YEAR],
  [MFN0610], [Languages and Programming Paradigms], [30L/30], [17/01/2023], [9], [INF/01],
  [MFN0633], [Formal Methods], [27/30], [25/07/2023], [9], [INF/01],
  [MFN0605], [Programming 3], [30/30], [27/06/2023], [6], [INF/01],
  [MFN1362], [Computer Networks], [30L/30], [02/02/2023], [6], [INF/01],
  [MFN0606], [Software Engineering], [28/30], [27/06/2023], [9], [INF/01],
  [IN3050], [Introduction to Artificial Intelligence and Machine Learning], [30/30], [09/08/2023], [12], [INF/01],
  [INF0073], [Internship], [-], [-], [9], [\*\*\* N/A \*\*\*],
  [INF0074], [Bachelor Thesis], [-], [-], [3], [\*\*\* N/A \*\*\*],
)

= Polytechnic University of Turin + Grenoble INP - Ensimag

/ Mean grade: 29.4/30

#table(
  columns: 6,
  table.header(
    [Code],
    [Description],
    [Grade],
    [Date],
    [CFU/ECTS],
    [SSD (Italian acronym for Scientific-Disciplinary Sector)],
  ),
  table.cell(colspan: 6, inset: 1.5em, align: center + horizon)[ == FIRST YEAR],
  [01DSHOV], [Big data processing and analytics], [29/30], [19/02/2024],[6], [ING-INF/05],
  [01OTWOV], [Computer network technologies and services], [-], [-],[6], [ING-INF/05],
  [01SQJOV], [Data Science and Database Technology], [28/30], [22/02/2024],[8], [ING-INF/05],
  [01TXASM], [Data management and visualization], [-], [-],[8], [ING-INF/05],
  [01TXYOV], [Web Applications I], [30L/30], [28/06/2024],[6], [ING-INF/05],
  [01URTOV], [Machine learning and pattern recognition], [-], [-],[6], [ING-INF/05],
  [02GOLOV], [Computer architectures], [30L/30], [04/09/2024],[10], [ING-INF/05],
  [02GRSOV], [System and Device Programming], [-], [-],[10], [ING-INF/05],
  [04GSPOV], [Software engineering],[30/30], [01/07/2024], [8], [ING-INF/05],
  table.cell(colspan: 6, inset: 1.5em, align: center + horizon)[ == SECOND YEAR],
  [01HZNOV], [Large Language Models], [-], [-],[6], [ING-INF/05],
  [01TYMOV], [Information systems security], [-], [-],[6], [ING-INF/05],
  [01URVOV], [GPU programming], [-], [-],[6], [ING-INF/05],
  [01URWOV], [Advanced Machine Learning], [-], [-],[6], [ING-INF/05],
  [08MBROV], [Thesis], [-], [-],[30], [\*\*\* N/A \*\*\*],
)

