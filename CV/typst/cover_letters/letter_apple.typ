#import "@preview/brilliant-cv:2.0.2": letter
#let metadata = toml("../metadata.toml")


#show: letter.with(
  metadata,
  myAddress: "14 Rue Lebrix, Saint-Martin-d'Hères, France",
  recipientName: "Apple",
  recipientAddress: "Zurich, Switzerland",
  date: datetime.today().display(),
  subject: "Subject: Computer Programming & Machine Learning Intern",
  signature: image("../src/signature.jpeg"),
)

To whom it might concern,

I am a student currently enrolled in a double degree program between Politecnico di Torino, Italy and the ENSIMAG Grande école in Saint-Martin-d'Hères, France for, respectively, the _Master's degree in Computer Engineering (subfield Artificial Intelligence and Data Analytics)_ and the _Master of Science in Informatics at Grenoble_. I am a highly motivated student with a strong passion for artificial intelligence and computer architecture. I am currently following a couple of courses in Natural Language processing.

As I approach the end of my studies, I am looking for every opportunity to further develop my skills and knowledge and grow professionally and personally. In the internship that you propose I see a great opportunity in achieving that.

I have multiple occasions of practicing with Python and ML libraries such as TensorFlow/Keras and PyTorch, of those, I have recently presented a project that studies the various compression techniques offered by the TensorFlow Model Optimization Toolkit in the computer vision field.

I have used extensively the Numpy and Matplotlib libraries and seeing an opportunity to apply my skills on a real life problem excites me.

I am looking forward hearing from you.

Sincerely,