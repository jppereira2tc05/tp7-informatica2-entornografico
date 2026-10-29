import processing.serial.*;

Serial myPort;        
String inString = ""; 

// Variables lógicas para el estado visual en la interfaz
int estadoE1 = 0;
int estadoE2 = 0;
boolean ledL1 = false;
boolean ledL2 = false;

void setup() {
  size(600, 400);
  
  printArray(Serial.list()); 
  
  // Poné acá el puerto exacto de tu Arduino Nano (ej: "COM3", "COM4", etc.)
  String portName = "COM3"; 
  myPort = new Serial(this, portName, 115200);
  
  delay(1500); // Pausa breve de estabilización
  myPort.clear();
  myPort.bufferUntil('\n');
}

void draw() {
  background(240);
  
  // --- SECTOR DE ENTRADAS ---
  fill(100, 150, 200);
  rect(50, 50, 200, 80, 10);
  fill(255);
  textSize(20);
  text("Entradas", 110, 95);
  
  // Indicador E1
  if (estadoE1 == 1) fill(0, 255, 0); else fill(200);
  rect(70, 150, 70, 50, 5);
  fill(0);
  text("E1", 95, 182);
  
  // Indicador E2
  if (estadoE2 == 1) fill(0, 255, 0); else fill(200);
  rect(160, 150, 70, 50, 5);
  fill(0);
  text("E2", 185, 182);
  
  // --- SECTOR DE SALIDAS ---
  fill(230, 180, 140);
  rect(350, 50, 200, 80, 10);
  fill(255);
  text("Salidas", 415, 95);
  
  // Círculo L1 (Interactivo)
  if (ledL1) fill(255, 0, 0); else fill(200);
  ellipse(395, 175, 60, 60);
  fill(0);
  text("L1", 387, 182);
  
  // Círculo L2 (Interactivo)
  if (ledL2) fill(255, 0, 0); else fill(200);
  ellipse(485, 175, 60, 60);
  fill(0);
  text("L2", 477, 182);
  
  textSize(14);
  fill(50);
  text("Hacé clic en los círculos L1 o L2 para conmutar las salidas físicas.", 50, 320);
}

// Función automática que lee los datos que manda el Nano
void serialEvent(Serial p) {
  inString = p.readStringUntil('\n');
  if (inString != null) {
    inString = trim(inString); 
    
    // Esperamos formato: E1:0,E2:0,L1:0,L2:0
    if (inString.startsWith("E1:")) {
      String[] partes = split(inString, ',');
      if (partes.length >= 4) {
        String valE1 = split(partes[0], ':')[1];
        String valE2 = split(partes[1], ':')[1];
        String valL1 = split(partes[2], ':')[1];
        String valL2 = split(partes[3], ':')[1];
        
        estadoE1 = int(valE1);
        estadoE2 = int(valE2);
        
        // Sincronizamos los LEDs visuales con el estado real devuelto por la placa
        ledL1 = (int(valL1) == 1);
        ledL2 = (int(valL2) == 1);
      }
    }
  }
}

// Interacción por Mouse en la interfaz
void mousePressed() {
  if (dist(mouseX, mouseY, 395, 175) < 30) {
    if (!ledL1) {
      myPort.write('A'); 
      println("Enviado desde Processing: A");
    } else {
      myPort.write('a'); 
      println("Enviado desde Processing: a");
    }
  }
  
  if (dist(mouseX, mouseY, 485, 175) < 30) {
    if (!ledL2) {
      myPort.write('B'); 
      println("Enviado desde Processing: B");
    } else {
      myPort.write('b'); 
      println("Enviado desde Processing: b");
    }
  }
}
