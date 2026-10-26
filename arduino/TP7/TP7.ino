// Definición de pines para la ESP32
const int pinE1 = 23; // Entrada 1 (configurada con PULLUP interno)
const int pinE2 = 22; // Entrada 2 (configurada con PULLUP interno)

const int pinL1 = 18; // Salida LED 1
const int pinL2 = 19; // Salida LED 2

// Variables para almacenar el estado anterior y reportar cambios o enviar periódico
int estadoE1 = 0;
int estadoE2 = 0;

void setup() {
  // Inicializar comunicación serial a 115200 baudios (estándar cómodo para ESP32)
  Serial.begin(115200);

  // Configurar pines de entrada con resistencia de pull-up interna
  // (Al tocar a GND con un jumper, el valor leído será LOW / 0)
  pinMode(pinE1, INPUT_PULLUP);
  pinMode(pinE2, INPUT_PULLUP);

  // Configurar pines de salida para los LEDs
  pinMode(pinL1, OUTPUT);
  pinMode(pinL2, OUTPUT);
  
  // Apagar LEDs al iniciar
  digitalWrite(pinL1, LOW);
  digitalWrite(pinL2, LOW);
}

void loop() {
  // 1. LEER ENTRADAS FÍSICAS (Invertidas porque usamos INPUT_PULLUP: sin pulsar es 1, pulsado es 0)
  // Aquí las leemos de forma directa para mandarlas a Processing
  estadoE1 = !digitalRead(pinE1);
  estadoE2 = !digitalRead(pinE2);

  // 2. ENVIAR DATOS A PROCESSING
  // Mandamos un formato simple separado por comas, ej: "E1:1,E2:0\n"
  Serial.print("E1:");
  Serial.print(estadoE1);
  Serial.print(",E2:");
  Serial.println(estadoE2);

  // 3. LEER COMANDOS DESDE LA PC (PROCESSING)
  if (Serial.available() > 0) {
    char comando = Serial.read();
    
    // Si recibimos 'A' encendemos L1, si es 'a' lo apagamos
    if (comando == 'A') {
      digitalWrite(pinL1, HIGH);
    } else if (comando == 'a') {
      digitalWrite(pinL1, LOW);
    }
    
    // Si recibimos 'B' encendemos L2, si es 'b' lo apagamos
    if (comando == 'B') {
      digitalWrite(pinL2, HIGH);
    } else if (comando == 'b') {
      digitalWrite(pinL2, LOW);
    }
  }

  // Pequeña pausa para no saturar el buffer serial
  delay(100);
}