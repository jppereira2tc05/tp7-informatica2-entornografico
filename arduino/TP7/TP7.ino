// Definición de pines utilizando los números de GPIO directos para el módulo genérico
const int pinE1 = 14; // Equivalente a D5 (Pulsador conectado a GND)
const int pinE2 = 12; // Equivalente a D6 (Pulsador conectado a GND)

const int pinL1 = 5;  // Equivalente a D1 (Salida LED 1 con resistencia de 39 ohms)
const int pinL2 = 4;  // Equivalente a D2 (Salida LED 2 con resistencia de 39 ohms)

// Variables para almacenar el estado
int estadoE1 = 0;
int estadoE2 = 0;

void setup() {
  // Inicializar comunicación serial a 115200 baudios
  Serial.begin(115200);

  // Configurar pines de entrada con resistencia de pull-up interna
  pinMode(pinE1, INPUT_PULLUP);
  pinMode(pinE2, INPUT_PULLUP);

  // Configurar pines de salida para los LEDs
  pinMode(pinL1, OUTPUT);
  pinMode(pinL2, OUTPUT);
  
  // Asegurar que arranquen apagados
  digitalWrite(pinL1, LOW);
  digitalWrite(pinL2, LOW);
}

void loop() {
  // 1. LEER ENTRADAS FÍSICAS (Invertidas con '!')
  estadoE1 = !digitalRead(pinE1);
  estadoE2 = !digitalRead(pinE2);

  // 2. ACCIONAR LOS LEDS LOCALMENTE SEGÚN EL PULSADOR
  // Si apretás el pulsador 1, prende el LED 1 automáticamente
  if (estadoE1 == HIGH) {
    digitalWrite(pinL1, HIGH);
  } else {
    digitalWrite(pinL1, LOW);
  }

  // Si apretás el pulsador 2, prende el LED 2 automáticamente
  if (estadoE2 == HIGH) {
    digitalWrite(pinL2, HIGH);
  } else {
    digitalWrite(pinL2, LOW);
  }

  // 3. ENVIAR DATOS A PROCESSING (O al Monitor Serie)
  Serial.print("E1:");
  Serial.print(estadoE1);
  Serial.print(",E2:");
  Serial.println(estadoE2);

  // 4. LEER COMANDOS DESDE LA PC (POR SI USÁS PROCESSING DESPUÉS)
  if (Serial.available() > 0) {
    char comando = Serial.read();
    
    if (comando == 'A') {
      digitalWrite(pinL1, HIGH);
    } else if (comando == 'a') {
      digitalWrite(pinL1, LOW);
    }
    
    if (comando == 'B') {
      digitalWrite(pinL2, HIGH);
    } else if (comando == 'b') {
      digitalWrite(pinL2, LOW);
    }
  }

  // Pequeña pausa para estabilidad
  delay(50);
}
