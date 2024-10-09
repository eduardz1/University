#import "@preview/brilliant-cv:2.0.2": letter
#let metadata = toml("../metadata.toml")


#show: letter.with(
  metadata,
  myAddress: "14 Rue Lebrix, Saint-Martin-d'Hères, France",
  recipientName: "ARM",
  recipientAddress: "Sophia Antipolis, France",
  date: datetime.today().display(),
  subject: "Subject: CPU Microarchitecture and Design Intern",
  signature: image("../src/signature.jpeg"), 
)

To whom it might concern,

I am a student currently enrolled in a double degree program between Politecnico di Torino, Italy and the ENSIMAG Grande école in Saint-Martin-d'Hères, France for, respectively, the _Master's degree in Computer Engineering (subfield Artificial Intelligence and Data Analytics)_ and the _Master of Science in Informatics at Grenoble_. I am a highly motivated student with a strong passion for artificial intelligence and computer architecture.

As I approach the end of my studies, I am looking for every opportunity to further develop my skills and knowledge and grow professionally and personally. In the internship that you propose I see a great opportunity in achieving that.

I have always been interested by this field and have always tried being up do date on the latest developments in computer architecture, looking at the latest announcement from Intel, AMD, Apple, NVIDIA or the latest updates to the ARM spec in ARMv9.

I am a fast learner, I have a lot of experience in programming with C and the usage of UNIX systems. I have had the opportunity to explore the ARM assembly language multiple times over my academic career and have even started developing a Game Boy Advanced emulator with a friend (which meant starting with the virtualization of its ARMv7 CPU).

I am looking forward hearing from you.

Sincerely,