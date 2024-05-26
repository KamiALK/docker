
import redis
import time
import random

# Conexión a Redis
# r = redis.Redis(host='localhost', port=6379, db=0)
r = redis.Redis(host='172.17.0.2', port=6379, db=0)

def productor():
    while True:
        # Generar un mensaje aleatorio
        mensaje = f"Mensaje-{random.randint(1, 100)}"
        # Publicar el mensaje en la cola
        r.lpush('cola', mensaje)
        print(f"Productor: Enviado mensaje: {mensaje}")
        time.sleep(random.uniform(0.5, 2))  # Esperar un tiempo aleatorio

def consumidor():
    while True:
        # Esperar a que haya mensajes en la cola
        mensaje = r.brpop('cola', timeout=0)
        print(f"Consumidor: Recibido mensaje: {mensaje}")
        # Procesar el mensaje (en este caso, simplemente imprimirlo)
        time.sleep(random.uniform(1, 3))  # Simular un procesamiento
        

if __name__ == "__main__":
    # Crear y ejecutar hilos para el productor y el consumidor
    import threading
    productor_thread = threading.Thread(target=productor)
    consumidor_thread = threading.Thread(target=consumidor)
    productor_thread.start()
    consumidor_thread.start()
