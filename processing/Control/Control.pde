import processing.serial.*;

Serial myPort;        // Objeto para la comunicación serial
String inString = ""; // Para almacenar los datos que llegan de la ESP32

// Variables lógicas para el estado visual en la interfaz
int estadoE1 = 0;
int estadoE2 = 0;
boolean ledL1 = false;
boolean ledL2 = false;

void setup() {
  size(600, 400);
  
  // ¡Atento acá! Verificá en el monitor serial de Arduino IDE qué puerto USB usa tu ESP32 
  // (por ejemplo, "COM3" en Windows o "/dev/ttyUSB0" en Linux) y cambialo en el índice [0] si hace falta.
  printArray(Serial.list()); // Esto te imprime los puertos disponibles en la consola de Processing
  String portName = Serial.list()[0]; 
  myPort = new Serial(this, portName, 115200);
  
  // Limpiar el buffer serial inicial
  myPort.bufferUntil('\n');
}

void draw() {
  background(240);
  
  // --- DIBUJAR SECTOR DE ENTRADAS ---
  fill(100, 150, 200);
  rect(50, 50, 200, 80, 10);
  fill(255);
  textSize(20);
  text("Entradas", 110, 95);
  
  // Indicador E1 (Cambia de color según el estado que manda la ESP32)
  if (estadoE1 == 1) fill(0, 255, 0); else fill(200);
  rect(70, 150, 70, 50, 5);
  fill(0);
  text("E1", 95, 182);
  
  // Indicador E2
  if (estadoE2 == 1) fill(0, 255, 0); else fill(200);
  rect(160, 150, 70, 50, 5);
  fill(0);
  text("E2", 185, 182);
  
  // --- DIBUJAR SECTOR DE SALIDAS ---
  fill(230, 180, 140);
  rect(350, 50, 200, 80, 10);
  fill(255);
  text("Salidas", 415, 95);
  
  // Círculo L1 (Interactivo: si hacés clic acá, mandas la orden de prender/apagar)
  if (ledL1) fill(255, 0, 0); else fill(200);
  ellipse(395, 175, 60, 60);
  fill(0);
  text("L1", 387, 182);
  
  // Círculo L2 (Interactivo)
  if (ledL2) fill(255, 0, 0); else fill(200);
  ellipse(485, 175, 60, 60);
  fill(0);
  text("L2", 477, 182);
  
  // Texto instructivo inferior
  textSize(14);
  fill(50);
  text("Hacé clic en los círculos L1 o L2 para conmutar las salidas físicas.", 80, 320);
}

// Función automática que lee cuando llega un salto de línea (\n) desde la ESP32
void serialEvent(Serial p) {
  inString = p.readStringUntil('\n');
  if (inString != null) {
    inString = trim(inString); // Limpiar espacios o retornos de carro
    
    // Parseo básico de la cadena recibida ej: "E1:1,E2:0"
    // Buscamos los valores o cortamos las posiciones
    // Para simplificar, asumimos que llega ordenado:
    if (inString.startsWith("E1:")) {
      // Ejemplo rápido de split por comas
      String[] partes = split(inString, ',');
      if (partes.length >= 2) {
        String valE1 = split(partes[0], ':')[1];
        String valE2 = split(partes[1], ':')[1];
        
        estadoE1 = int(valE1);
        estadoE2 = int(valE2);
      }
    }
  }
}

// Interacción por Mouse (Punto 2 del TP: pinchar en el casillero de las salidas)[cite: 1]
void mousePressed() {
  // Coordenadas del círculo L1 (Centro en x=395, y=175, radio 30)
  if (dist(mouseX, mouseY, 395, 175) < 30) {
    ledL1 = !ledL1; // Invertir estado local
    if (ledL1) {
      myPort.write('A'); // Enviar comando a Arduino para prender
    } else {
      myPort.write('a'); // Enviar comando a Arduino para apagar
    }
  }
  
  // Coordenadas del círculo L2 (Centro en x=485, y=175, radio 30)
  if (dist(mouseX, mouseY, 485, 175) < 30) {
    ledL2 = !ledL2; // Invertir estado local
    if (ledL2) {
      myPort.write('B'); // Enviar comando a Arduino para prender
    } else {
      myPort.write('b'); // Enviar comando a Arduino para apagar
    }
  }
}
