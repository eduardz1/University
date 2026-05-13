#import "@preview/brilliant-cv:2.0.2": letter
#let metadata = toml("../metadata.toml")


#show: letter.with(
  metadata,
  myAddress: "14 Rue Lebrix, Saint-Martin-d'Hères, France",
  recipientName: "Centre Inria de l'Université de Bordeaux",
  recipientAddress: "200 avenue de la vieille Tour, 33405 Talence Cedex",
  date: datetime.today().display(),
  subject: "Subject: Master Internship for GPU Kernel Development",
  signature: image("../src/signature.jpeg"),
)

To whom it might concern,

I am a student currently enrolled in a double degree program between Politecnico di Torino, Italy and the ENSIMAG Grande école in Saint-Martin-d'Hères, France for, respectively, the _Master's degree in Computer Engineering (subfield Artificial Intelligence and Data Analytics)_ and the _Master of Science in Informatics at Grenoble_. I am a highly motivated student with a strong passion for lower level computing and GPU architecture.

As I approach the end of my studies, I am looking for every opportunity to further develop my skills and knowledge and grow professionally and personally. In the internship that you propose I see a great opportunity in achieving that.

I have been following recently a course in GP-GPU computing and CUDA programming and I am eager to apply my knowledge in a real life project. I have been having fun optimizing algorithms for parallel execution and I have always been passionate about optimizing code for performance as much as possible.

During my five years of studies, I have been exposed to a variety of programming languages and paradigms, I am curious about working in Fortran.

I am looking forward hearing from you.

Sincerely,