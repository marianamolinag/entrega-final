//Mariana Molina - 202222414
//Camila García Olarte - 202220777
//E08: Entrega Final

//Mariana Molina - 202222414
//Camila García Olarte - 202220777
//E08: Entrega Final

//Importar libreria
import processing.sound.*;
import processing.sound.FFT;

//Declarar la variable para la canción
SoundFile traitor;
SoundFile vampire;
SoundFile soamerican;
SoundFile cancionActual;

//Declarar la variable para el análisis de frecuencias
FFT fft;

//Número de bandas de frecuencia
int bands = 256;
//Array para guardar el espectro de nuestras frecuencias
float[] spectrum = new float [bands];

//estado actual
String estado = "PORTADA";

//Acá declaramos las imágenes de cada momento del juego
PImage cardImg;
PImage cartavaciaImg;
PImage corazonrotoImg;
PImage fondo1Img;
PImage fondo3Img;
PImage poemaImg;
PImage portadaImg;
PImage rosaImg;
PImage soamericanImg;
PImage traitorImg;
PImage corazonesImg;

// Arreglos para clases reutilizables
ElementoFlotante[] elementos;
FiguraAleatoria[] figuras;
Corazon[] corazones;
int numElementos = 18;
int numFiguras = 50;
int numCorazones = 100;
int corazonIndex = 0; //Controla cuantos corazones se han creado

//Caracteristicas de la Carta en etapa amor
int cartaX = 250;
int cartaY = 200;
int cartaW = 300;
int cartaH = 200;
boolean mostrarTexto = false;

void setup() {
  size(1000, 1000);
  background(0);
  noStroke();
  frameRate(30); //30 cuadros por segundo

  //Importar la canción
  traitor = new SoundFile(this, "traitor.MP3");
  vampire = new SoundFile(this, "vampire.mp3");
  soamerican = new SoundFile(this, "soamerican.mp3");

  //Crear el analizador de frecuencias
  fft = new FFT(this, bands);

  // Cargar imágenes
  cardImg = loadImage("card.png");
  cartavaciaImg = loadImage("cartavacia.png");
  corazonrotoImg = loadImage("corazonroto.png");
  fondo1Img = loadImage("fondo1.png");
  fondo3Img = loadImage("fondo3.png");
  poemaImg = loadImage("poema.png");
  portadaImg = loadImage("portada.png");
  rosaImg = loadImage("rosa.png");
  soamericanImg = loadImage("soamerican.png");
  traitorImg = loadImage("traitor.png");
  corazonesImg = loadImage("corazones.png");

  //Crear objetos flotantes con imágenes distintas
  elementos = new ElementoFlotante[numElementos];
  for (int i = 0; i < numElementos; i++) {
    if (i % 3 == 0) {
      elementos[i] = new ElementoFlotante(corazonrotoImg);
    } else if (i % 3 == 1) {
      elementos[i] = new ElementoFlotante(rosaImg);
    } else {
      elementos[i] = new ElementoFlotante(cardImg);
    }
  }
  //Inicializar figuras aleatorias para visualización de auido
  figuras = new FiguraAleatoria[numFiguras];
  for (int i = 0; i < numFiguras; i++) {
    figuras[i] = new FiguraAleatoria();
  }
  //Inicializar corazones invisibles que se activan al pasar el mouse
  corazones = new Corazon[numCorazones];
  for (int i = 0; i < numCorazones; i++) {
    corazones[i] = new Corazon(-100, -100); // fuera del canvas
  }
}

void draw() {
  background(0); //Reinicia fondo negro cada frame
  //Dibuja la imagen correspondiente cada etapa
  if (estado.equals("PORTADA")) {
    image(portadaImg, 0, 0, width, height);
  } else if (estado.equals("RUPTURA")) {
    image(fondo1Img, 0, 0, width, height);
    imageMode(CENTER);//Centra el texto que tenemos en la imagen
    image(traitorImg, width / 2, height / 2, traitorImg.width, traitorImg.height); // lo duplica
    imageMode(CORNER); // Regresa al modo por defecto para imágenes
    for (int i = 0; i < numElementos; i++) {
      elementos[i].mover();
      elementos[i].mostrar();  // Muestra los elementos flotantes (corazones, rosas, cartas)
    }
  } else if (estado.equals("INTROSPECCIÓN")) {
    fft.analyze(spectrum);

    // Solo actualiza las figuras cada 5 frames para que se vean más lento
    if (frameCount % 5 == 0) {
      for (int i = 0; i < numFiguras; i++) {
        figuras[i].actualizar(spectrum);
      }
    }

    // Siempre las dibuja, aunque se actualicen más lento
    for (int i = 0; i < numFiguras; i++) {
      figuras[i].dibujar();
    }
  } else if (estado.equals("AMOR")) {
    image(fondo3Img, 0, 0, width, height);

    //tamaño carta
    cartaW = 500;
    cartaH = 500;
    image(cartavaciaImg, cartaX, cartaY, cartaW, cartaH);

    // Mostrar elementos si el mouse está sobre la carta
    if (mouseX > cartaX && mouseX < cartaX + cartaW &&
      mouseY > cartaY && mouseY < cartaY + cartaH) {

      // Mostrar texto ilustrado So American (arriba del poema)
      image(soamericanImg, cartaX, 150, 500, 500);

      // Mostrar el poema encima de la carta
      image(poemaImg, cartaX, cartaY, cartaW, cartaH);

      // Mostrar ilustración de corazones (alrededor del poema)
      image(corazonesImg, 200, 150, 600, 600);
      if (mostrarTexto) {
        for (int i = 0; i < corazonIndex; i++) {
          corazones[i].mover();
          corazones[i].mostrar();
        }
      }
    }
  }
}
void mousePressed() {
  if (estado.equals("PORTADA")) {
    estado = "RUPTURA"; // Cambia de estado al hacer clic en portada
    cancionActual = traitor;
    cancionActual.play();
    fft.input(cancionActual); //Empieza el análisis de audio
  }
}

void keyPressed() {
  //Permite avanzar de un estado a otro con la tecla derecha
  if (keyCode == RIGHT) {
    if (estado.equals("RUPTURA")) {
      cancionActual.stop();
      estado = "INTROSPECCIÓN";
      cancionActual = vampire;
      fft.input(cancionActual);
      cancionActual.play();
    } else if (estado.equals("INTROSPECCIÓN")) {
      cancionActual.stop();
      estado = "AMOR";
      cancionActual = soamerican;
      fft.input(cancionActual);
      cancionActual.play();
    } else if (estado.equals("AMOR")) {
      cancionActual.stop();
      estado = "PORTADA"; // Vuelve al inicio del ciclo
    }
  }
}

void mouseMoved() {
  //En el estado AMOR, si el mouse está sobre la carta, activa los corazones
  if (estado.equals("AMOR")) {
    if (mouseX > cartaX && mouseX < cartaX + cartaW &&
      mouseY > cartaY && mouseY < cartaY + cartaH) {
      mostrarTexto = true;

      if (corazonIndex < numCorazones) {
        corazones[corazonIndex] = new Corazon(mouseX, mouseY);
        corazonIndex++;
      }
    } else {
      mostrarTexto = false;
      for (int i = 0; i < numCorazones; i++) {
        corazones[i] = new Corazon(-100, -100); //Oculta los corazones otra vez
      }
      corazonIndex = 0;
    }
  }
}
class ElementoFlotante {
  PImage img;
  float x, y;
  float xSpeed, ySpeed;
  int xDir, yDir;

  // Constructor que recibe una imagen y le asigna una posición y velocidad aleatoria
  ElementoFlotante(PImage _img) {
    img = _img;
    x = random(width); //Posición aleatoria en el eje X
    y = random(height); //Posición aleatoria en el eje Y
    xSpeed = random(1, 3); //Velocidad aleatoria
    ySpeed = random(1, 3);

    xDir = random(1) < 0.5 ? -1 : 1;  // Dirección aleatoria: izquierda o derecha
    yDir = random(1) < 0.5 ? -1 : 1;
  }

  // Hace que el elemento se mueva y rebote en los bordes
  void mover() {
    x += xSpeed * xDir;
    y += ySpeed * yDir;
    // Rebote en los bordes
    if (x < 0 || x > width-250) {
      xDir *= -1;
    }
    if (y < 0 || y > height-250) {
      yDir *= -1;
    }
  }
  //Dibuja la imagen en la pantalla con un cierto tamaño
  void mostrar() {
    image(img, x, y, 250, 250);
  }
}

class FiguraAleatoria {

  float x, y;
  float tam;
  color c;
  int tipo; // 0: línea, 1: círculo, 2: triángulo

  // Constructor: posición, color y tipo de figura aleatoria
  FiguraAleatoria() {
    x = random(width);
    y = random(height);
    tam = random(10, 50);
    tipo = int(random(3)); // Se ajustará luego según la frecuencia
    c = color(random(100, 255), 0, random(100, 255)); // Tonos rojo y morado
  }

  //Actualiza la forma y el tamaño en función del análisis de audio
  void actualizar(float[] spectrum) {
    int i = int(random(bands)); //Escoge una frecuencia aleatoria
    float val = spectrum[i] * 1000;//Aumenta el valor para usarlo gráficamente

    // Elegir forma según nivel de frecuencia
    if (val > 400) {
      tipo = 2; // triángulo
    } else if (val > 100) {
      tipo = 1; // círculo
    } else {
      tipo = 0; // línea
    }

    x += random(-1, 1);  // Movimiento más suave
    y += random(-1, 1);
    tam = val / 2;

    // Color dinámico en gama rojo/morado
    c = color(random(150, 255), 0, random(100, 255));
  }

  //Dibuja la figura con el tipo correspondiente
  void dibujar() {
    fill(c, 180);
    noStroke();

    switch (tipo) {
    case 0: // línea
      stroke(c);
      strokeWeight(2);
      line(x, y, x + tam, y + tam);
      noStroke();
      break;

    case 1: // círculo
      ellipse(x, y, tam, tam);
      break;

    case 2: // triángulo
      float h = tam * sqrt(3) / 2;
      triangle(x, y - h / 2, x - tam / 2, y + h / 2, x + tam / 2, y + h / 2);
      break;
    }
  }
}


  class Corazon {
    float x, y;
    float dy;
    //Constructor que define la posición y velocidad del corazón flotante
    Corazon(float _x, float _y) {
      x = _x;
      y = _y;
      dy = random(-2, -0.5);
    }

    //Mueve el corazón hacia arriba
    void mover() {
      y += dy;
    }

    //Dibuja una figura de corazón usando curvas
    void mostrar() {
      fill(255, 0, 0, 150); //Rojo con transparencia
      noStroke();
      beginShape();
      vertex(x, y);
      //bezierVertex(cx1, cy1, cx2, cy2, x, y);
//cx1, cy1: Primer punto de control (influye en el inicio de la curva)
//cx2, cy2: Segundo punto de control (influye en el final de la curva)
//x, y: Punto final de la curva
      bezierVertex(x - 10, y - 10, x - 15, y + 10, x, y + 20);
      bezierVertex(x + 15, y + 10, x + 10, y - 10, x, y);
      endShape(CLOSE);
    }
  }
