const int pinE1 = 2; // Pin digital para la entrada 1
const int pinE2 = 3; // Pin digital para la entrada 2
const int pinL1 = 4; // Pin digital para el LED 1
const int pinL2 = 5; // Pin digital para el LED 2

int estadoE1 = 0;
int estadoE2 = 0;
int estadoL1 = 0;
int estadoL2 = 0;

void setup() {
  Serial.begin(115200);
  delay(1000);

  pinMode(pinE1, INPUT_PULLUP);
  pinMode(pinE2, INPUT_PULLUP);
  pinMode(pinL1, OUTPUT);
  pinMode(pinL2, OUTPUT);
  
  digitalWrite(pinL1, LOW);
  digitalWrite(pinL2, LOW);
}

void loop() {
  // Leemos el estado de los botones (con Pullup, presionado es LOW, lo invertimos con '!')
  estadoE1 = !digitalRead(pinE1);
  estadoE2 = !digitalRead(pinE2);

  // Ver si llegó algo de Processing
  if (Serial.available() > 0) {
    char comando = (char)Serial.read();
    
    if (comando == 'A') {
      digitalWrite(pinL1, HIGH);
      estadoL1 = 1;
    } else if (comando == 'a') {
      digitalWrite(pinL1, LOW);
      estadoL1 = 0;
    } else if (comando == 'B') {
      digitalWrite(pinL2, HIGH);
      estadoL2 = 1;
    } else if (comando == 'b') {
      digitalWrite(pinL2, LOW);
      estadoL2 = 0;
    }
  }

  // Mandar el estado completo a Processing
  Serial.print("E1:");
  Serial.print(estadoE1);
  Serial.print(",E2:");
  Serial.print(estadoE2);
  Serial.print(",L1:");
  Serial.print(estadoL1);
  Serial.print(",L2:");
  Serial.println(estadoL2);

  delay(50);
}