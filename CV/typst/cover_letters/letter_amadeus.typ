#import "@preview/brilliant-cv:2.0.2": letter
#let metadata = toml("../metadata.toml")


#show: letter.with(
  metadata,
  myAddress: "14 Rue Lebrix, Saint-Martin-d'Hères, France",
  recipientName: "Amadeus",
  recipientAddress: "Nice",
  date: datetime.today().display(),
  subject: "Subject: INTERN - Data Engineer (Rust, Kafka, 3A, 6M)",
  signature: image("../src/signature.jpeg"), 
)

To whom it might concern,

I am a student currently enrolled in a double degree program between Politecnico di Torino, Italy and the ENSIMAG Grande école in Saint-Martin-d'Hères, France for, respectively, the _Master's degree in Computer Engineering (subfield Artificial Intelligence and Data Analytics)_ and the _Master of Science in Informatics at Grenoble_. I am a highly motivated student with a strong passion for artificial intelligence and computer architecture.

As I approach the end of my studies, I am looking for every opportunity to further develop my skills and knowledge and grow professionally and personally. In the internship that you propose I see a great opportunity in achieving that.

I have had the opportunity to program in Rust for the first time this year and was very pleased with the language. I have developed, with a group of friends, a system of program hardening through variable duplication and a system of fault injection all using procedural macros. I have been so pleased with the language that I am currently in talks with the professor to continue working at the project outside of university.

I have good familiarity with the concept of Agile programming and extensive experience with Python programming. I am also familiar with Spark, having seen it in the Big Data course in Turin.

I am looking forward hearing from you.

Sincerely,