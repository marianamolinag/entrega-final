//Camila García Olarte-202220777
//E05: Sonido

//Importar libreria
import processing.sound.*;
import processing.sound.FFT;

//Declarar la variable para la canción
SoundFile traitor;
SoundFile vampire;
SoundFile soamerican;
//Declarar la variable para el análisis de frecuencias
FFT fft;

//Número de bandas de frecuencia
int bands = 256;
//Array para guardar el espectro de nuestras frecuencias
float[] spectrum = new float [bands];

SoundFile cancionActual;

void setup() {
  size(1000, 1000);
  background(0);
  noStroke();
  frameRate(30); //30 cuadros por segundo

  //Importar la canción
  traitor = new SoundFile(this, "traitor.mp3");
  vampire = new SoundFile(this, "vampire.mp3");
  soamerican = new SoundFile(this, "soamerican.mp3");
 
 //Iniciar primera canción
 cancionActual = traitor;
 cancionActual.play();
 
  //Crear el analizador de frecuencias
  fft = new FFT(this, bands);
  //Analice la canción
  fft.input(cancionActual);
}
